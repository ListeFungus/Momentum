import 'package:drift/drift.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/habit_recurrence.dart';
import 'package:momentum/features/aufgaben/data/task_definition_change.dart';
import 'package:momentum/features/aufgaben/data/task_entry_status.dart';
import 'calendar_clock.dart';
import 'calendar_planning.dart';
import 'package:momentum/features/aufgaben/data/tracking_start_policy.dart';

class CalendarFilter {
  const CalendarFilter({
    this.tasks = true,
    this.habits = false,
    this.trackers = false,
  });
  final bool tasks, habits, trackers;
  bool accepts(Aufgabe task) =>
      task.erfassungsmodus == 'value' && task.valueCommitment == 'pure_tracking'
          ? trackers
          : task.taskType == 'habit'
          ? habits
          : tasks;
}

class CalendarOccurrence {
  const CalendarOccurrence({
    required this.task,
    required this.currentTask,
    required this.day,
    required this.entry,
    required this.planning,
    this.project,
    this.bundleName,
    this.lockReason,
    this.warning,
  });
  final Aufgabe task, currentTask;
  final DateTime? day;
  final TaskEntry? entry;
  final CalendarPlanning planning;
  final Project? project;
  final String? bundleName, lockReason, warning;
  bool get isVirtual => entry == null;
  bool get canMove => lockReason == null;
  int? get visibleStart => warning == null ? planning.startMinute : null;
}

class CalendarUnknown {
  const CalendarUnknown(this.task, this.earliest);
  final Aufgabe task;
  final DateTime? earliest;
}

class CalendarRange {
  const CalendarRange({
    required this.occurrences,
    required this.overdue,
    required this.undated,
    required this.unknown,
  });
  final List<CalendarOccurrence> occurrences, overdue, undated;
  final List<CalendarUnknown> unknown;
  List<CalendarOccurrence> onDay(DateTime day) =>
      occurrences.where((e) => e.day == calendarDay(day)).toList();
}

/// Pure projection over one coherent database snapshot; never generates entries.
class CalendarProjection {
  CalendarProjection({
    required this.tasks,
    required this.entries,
    required this.versions,
    required this.pending,
    required this.interruptions,
    required this.assignments,
    required this.bundleVersions,
    required this.projects,
    required this.applyVersion,
    required this.clock,
  });
  final List<Aufgabe> tasks;
  final List<TaskEntry> entries;
  final List<TaskDefinitionVersion> versions;
  final List<TaskPendingDefinitionChange> pending;
  final List<TaskPlanningInterruption> interruptions;
  final List<TaskProjectAssignmentChange> assignments;
  final List<TaskValueBundleVersion> bundleVersions;
  final List<Project> projects;
  final Aufgabe Function(Aufgabe, TaskDefinitionVersion) applyVersion;
  final CalendarClock clock;

  CalendarRange project(DateTime from, DateTime to, CalendarFilter filter) {
    final today = calendarDay(clock.now());
    final result = <CalendarOccurrence>[],
        overdue = <CalendarOccurrence>[],
        undated = <CalendarOccurrence>[];
    final unknown = <CalendarUnknown>[];
    for (final current in tasks.where((t) => t.trashedAt == null)) {
      final history =
          entries.where((e) => e.taskId == current.id).toList()
            ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
      final definitions =
          versions
              .where((v) => v.taskId == current.id && v.supersededAt == null)
              .toList()
            ..sort((a, b) {
              final date = a.validFrom.compareTo(b.validFrom);
              return date == 0
                  ? a.versionNumber.compareTo(b.versionNumber)
                  : date;
            });
      final changes =
          pending
              .where((p) => p.taskId == current.id && p.state == 'pending')
              .toList()
            ..sort((a, b) => a.effectiveDate.compareTo(b.effectiveDate));
      Aufgabe effective(DateTime day) {
        final valid =
            definitions
                .where((v) => v.validFrom.isBefore(calendarAddDays(day, 1)))
                .lastOrNull ??
            (TrackingStartPolicy.isPure(current)
                ? definitions.firstOrNull
                : null);
        var task = valid == null ? current : applyVersion(current, valid);
        for (final p in changes.where(
          (p) => !calendarDay(p.effectiveDate).isAfter(day),
        )) {
          if (p.groupKey == 'calendar') {
            final value = CalendarPlanning.decode(p.payloadJson);
            task = task.copyWith(
              plannedStartMinute: Value(value.startMinute),
              plannedDurationMinutes: Value(value.durationMinutes),
            );
          } else if (p.groupKey == 'schedule') {
            final value = TaskScheduleChangePayload.decode(p.payloadJson);
            task = task.copyWith(
              recurrence: value.recurrence,
              activeWeekdays: value.activeWeekdays,
              missedPolicy: value.missedPolicy,
              missedConsequence: value.missedConsequence,
              missedBufferDays: value.missedBufferDays,
              postBufferBehavior: value.postBufferBehavior,
              maxCarryoverCount: value.maxCarryoverCount,
            );
          } else if (p.groupKey == 'goal') {
            final value = TaskGoalChangePayload.decode(p.payloadJson);
            task = task.copyWith(
              goalType: value.goalType,
              goalValue: value.goalValue,
              goalWindowDays: Value(value.goalWindowDays),
              goalPeriod: value.goalPeriod,
              goalPeriodAlignment: value.goalPeriodAlignment,
            );
          }
        }
        return task;
      }

      bool paused(DateTime day) => interruptions.any(
        (p) =>
            p.taskId == current.id &&
            !day.isBefore(DateTime.parse(p.fromDay)) &&
            (p.untilDayExclusive == null ||
                day.isBefore(DateTime.parse(p.untilDayExclusive!))),
      );
      bool allowed(Aufgabe task, DateTime day) =>
          current.isActive &&
          !day.isBefore(
            calendarDay(
              TrackingStartPolicy.isPure(task)
                  ? current.startDate
                  : task.startDate,
            ),
          ) &&
          (task.endDate == null || !day.isAfter(calendarDay(task.endDate!))) &&
          !paused(day);
      CalendarOccurrence occurrence(DateTime? day, TaskEntry? entry) {
        var task = effective(day ?? today);
        final version =
            versions
                .where((v) => v.id == entry?.taskDefinitionVersionId)
                .firstOrNull;
        if (entry != null && version != null) {
          task = applyVersion(current, version);
        }
        var planning = CalendarPlanning(
          startMinute:
              entry == null
                  ? task.plannedStartMinute
                  : entry.plannedStartMinute,
          durationMinutes:
              entry == null
                  ? task.plannedDurationMinutes
                  : entry.plannedDurationMinutes,
        );
        if (entry != null &&
            entry.status == 'pending' &&
            day != null &&
            !day.isBefore(today) &&
            changes.any(
              (p) =>
                  p.groupKey == 'calendar' &&
                  !calendarDay(p.effectiveDate).isAfter(day),
            )) {
          final preview = effective(day);
          planning = CalendarPlanning(
            startMinute: preview.plannedStartMinute,
            durationMinutes: preview.plannedDurationMinutes,
          );
        }
        final ref = day ?? today;
        final bundle =
            bundleVersions
                .where(
                  (b) =>
                      (b.firstTaskId == current.id ||
                          b.secondTaskId == current.id) &&
                      b.cancelledAt == null &&
                      !calendarDay(b.validFrom).isAfter(ref) &&
                      (b.validTo == null ||
                          calendarDay(b.validTo!).isAfter(ref)),
                )
                .lastOrNull;
        final projectChanges =
            assignments
                .where(
                  (a) =>
                      a.taskId == current.id &&
                      (a.state == 'applied' || a.state == 'pending') &&
                      (a.scope == 'all_history' ||
                          !calendarDay(a.effectiveDate).isAfter(ref)),
                )
                .toList()
              ..sort((a, b) => a.sequence.compareTo(b.sequence));
        final projectId =
            projectChanges.isEmpty
                ? task.projectId
                : projectChanges.last.targetProjectId;
        final project =
            projects
                .where((p) => p.id == projectId && p.trashedAt == null)
                .firstOrNull;
        final lock =
            current.recurrence != 'none'
                ? 'Serie – bitte regulär bearbeiten.'
                : entry != null && entry.status != 'pending'
                ? 'Abgeschlossene Einträge bleiben erhalten.'
                : history.length > 1
                ? 'Mehrere historische Einträge – direktes Verschieben gesperrt.'
                : !current.isActive || paused(today) || paused(ref)
                ? 'Pausierter Eintrag.'
                : bundle != null ||
                    bundleVersions.any(
                      (b) =>
                          (b.firstTaskId == current.id ||
                              b.secondTaskId == current.id) &&
                          b.cancelledAt == null &&
                          (b.validTo == null || b.validTo!.isAfter(today)),
                    )
                ? 'Bündelquelle – bitte regulär bearbeiten.'
                : changes.isNotEmpty ||
                    assignments.any(
                      (a) => a.taskId == current.id && a.state == 'pending',
                    )
                ? 'Vorgemerkte Änderung – direktes Verschieben gesperrt.'
                : null;
        return CalendarOccurrence(
          task: task,
          currentTask: current,
          day: day,
          entry: entry,
          planning: planning,
          project: project,
          bundleName: bundle?.name,
          lockReason: lock,
          warning:
              day != null && !clock.accepts(day, planning)
                  ? 'Zeitumstellung: Uhrzeit nicht eindeutig. Ohne Zeitblock angezeigt.'
                  : null,
        );
      }

      if (current.recurrence == 'none' && current.dueDate == null) {
        final item = occurrence(null, history.firstOrNull);
        if (filter.accepts(item.task)) undated.add(item);
        continue;
      }
      for (final entry in history) {
        final day = calendarDay(entry.scheduledDate);
        final item = occurrence(day, entry);
        if (!filter.accepts(item.task)) continue;
        if (!day.isBefore(from) && !day.isAfter(to)) result.add(item);
        if (day.isBefore(today) && entry.status == 'pending') overdue.add(item);
      }
      final dependent =
          current.recurrence == HabitRecurrence.weeklyAfterCompletion ||
          HabitRecurrence.isCustomAfterCompletion(current.recurrence);
      if (!dependent &&
          current.isActive &&
          filter.accepts(current) &&
          changes.any(
            (p) =>
                p.groupKey == 'schedule' &&
                TaskScheduleChangePayload.decode(
                  p.payloadJson,
                ).recurrence.contains('after_completion'),
          )) {
        // A pending change into a completion-based series has no safely known
        // predecessor yet. Keep it visible as unknown, without inventing a date.
        unknown.add(CalendarUnknown(current, null));
      }
      DateTime? next;
      if (dependent) {
        final interval =
            current.recurrence == HabitRecurrence.weeklyAfterCompletion
                ? 7
                : HabitRecurrence.customAfterCompletionDays(current.recurrence);
        final blocking =
            history
                .where((e) => e.status == 'pending' || e.status == 'no_entry')
                .firstOrNull;
        final finals =
            history
                .where(
                  (e) =>
                      TaskEntryStatus.isFinal(e.status) &&
                      (e.effectiveAt ?? e.finalizedAt) != null,
                )
                .toList()
              ..sort(
                (a, b) => (a.effectiveAt ?? a.finalizedAt!).compareTo(
                  b.effectiveAt ?? b.finalizedAt!,
                ),
              );
        final stable =
            changes.every((p) => p.groupKey != 'schedule') &&
            definitions.every((v) => v.recurrence == current.recurrence);
        if (blocking == null && stable) {
          next =
              finals.isEmpty
                  ? calendarDay(current.startDate)
                  : calendarAddDays(
                    finals.last.effectiveAt ?? finals.last.finalizedAt!,
                    interval,
                  );
          if (next.isBefore(calendarDay(current.startDate))) {
            next = calendarDay(current.startDate);
          }
        }
        final base =
            blocking == null ? next : calendarDay(blocking.scheduledDate);
        final earliest =
            stable && base != null
                ? calendarAddDays(base.isAfter(today) ? base : today, interval)
                : null;
        if (current.isActive &&
            filter.accepts(current) &&
            (current.endDate == null ||
                !calendarDay(current.endDate!).isBefore(today))) {
          unknown.add(
            CalendarUnknown(
              current,
              earliest != null && allowed(effective(earliest), earliest)
                  ? earliest
                  : null,
            ),
          );
        }
      }
      final dates = <DateTime>[];
      if (dependent) {
        if (next != null) dates.add(next);
      } else if (current.recurrence == 'none') {
        if (current.dueDate != null) dates.add(calendarDay(current.dueDate!));
      }
      {
        for (var day = from; !day.isAfter(to); day = calendarAddDays(day, 1)) {
          final task = effective(day);
          final days =
              task.activeWeekdays
                  .split(',')
                  .map(int.tryParse)
                  .whereType<int>()
                  .toSet();
          if (task.recurrence == 'daily' ||
              (task.recurrence == 'weekly_fixed_days' &&
                  days.contains(day.weekday)) ||
              (task.recurrence == 'monthly_fixed_days' &&
                  (days.contains(day.day) ||
                      (days.contains(32) &&
                          calendarAddDays(day, 1).day == 1)))) {
            dates.add(day);
          }
        }
      }
      for (final day in dates) {
        if (history.any((e) => calendarDay(e.scheduledDate) == day)) continue;
        final task = effective(day);
        if (!allowed(task, day) || !filter.accepts(task)) continue;
        final item = occurrence(day, null);
        if (!day.isBefore(from) && !day.isAfter(to)) result.add(item);
        if (day.isBefore(today) && current.recurrence == 'none') {
          overdue.add(item);
        }
      }
    }
    int compare(CalendarOccurrence a, CalendarOccurrence b) {
      final day = (a.day ?? from).compareTo(b.day ?? from);
      if (day != 0) return day;
      final time = (a.visibleStart ?? 1441).compareTo(b.visibleStart ?? 1441);
      return time == 0 ? a.task.name.compareTo(b.task.name) : time;
    }

    result.sort(compare);
    overdue.sort(compare);
    undated.sort(compare);
    return CalendarRange(
      occurrences: result,
      overdue: overdue,
      undated: undated,
      unknown: unknown,
    );
  }
}
