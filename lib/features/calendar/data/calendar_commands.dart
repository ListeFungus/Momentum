import 'package:drift/drift.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/task_definition_version_writer.dart';
import 'package:momentum/features/aufgaben/data/task_entry_status.dart';
import 'package:uuid/uuid.dart';

import 'calendar_clock.dart';
import 'calendar_planning.dart';

/// Atomic command shared by drag, resize and accessible scheduling dialogs.
class CalendarCommands {
  CalendarCommands(this.database, {CalendarClock? clock})
    : clock = clock ?? CalendarClock();
  final AppDatabase database;
  final CalendarClock clock;

  Future<void> change({
    required Aufgabe expectedTask,
    required TaskEntry? expectedEntry,
    required DateTime? day,
    required CalendarPlanning planning,
  }) async {
    planning.validate();
    final today = calendarDay(clock.now());
    final target = day == null ? null : calendarDay(day);
    await database.transaction(() async {
      final task =
          await (database.select(database.aufgaben)
            ..where((t) => t.id.equals(expectedTask.id))).getSingle();
      final entries =
          await (database.select(database.taskEntries)
            ..where((e) => e.taskId.equals(task.id))).get();
      final entry = entries.firstOrNull;
      if (task.toJson().toString() != expectedTask.toJson().toString() ||
          entry?.id != expectedEntry?.id ||
          entry?.revision != expectedEntry?.revision ||
          entry?.updatedAt != expectedEntry?.updatedAt) {
        throw StateError(
          'Der Eintrag wurde inzwischen geändert. Bitte Kalender neu laden.',
        );
      }
      if (task.trashedAt != null ||
          !task.isActive ||
          task.recurrence != 'none' ||
          entries.length > 1 ||
          (entry != null && entry.status != TaskEntryStatus.pending)) {
        throw StateError(
          'Nur offene, unabhängige einmalige Termine können direkt geändert werden. Serien bitte regulär bearbeiten.',
        );
      }
      final pending =
          await (database.select(database.taskPendingDefinitionChanges)..where(
            (p) => p.taskId.equals(task.id) & p.state.equals('pending'),
          )).get();
      final assignments =
          await (database.select(database.taskProjectAssignmentChanges)..where(
            (p) => p.taskId.equals(task.id) & p.state.equals('pending'),
          )).get();
      final bundles =
          await (database.select(database.taskValueBundleVersions)..where(
            (b) =>
                (b.firstTaskId.equals(task.id) |
                    b.secondTaskId.equals(task.id)) &
                b.cancelledAt.isNull() &
                (b.validTo.isNull() | b.validTo.isBiggerThanValue(today)),
          )).get();
      final interruptions =
          await (database.select(database.taskPlanningInterruptions)
            ..where((p) => p.taskId.equals(task.id))).get();
      bool interrupted(DateTime value) => interruptions.any(
        (p) =>
            !value.isBefore(DateTime.parse(p.fromDay)) &&
            (p.untilDayExclusive == null ||
                value.isBefore(DateTime.parse(p.untilDayExclusive!))),
      );
      if (pending.isNotEmpty ||
          assignments.isNotEmpty ||
          bundles.isNotEmpty ||
          interrupted(today) ||
          (target != null && interrupted(target))) {
        throw StateError(
          'Der Termin ist durch Bündel, Pause oder eine vorgemerkte Änderung gesperrt. Bitte regulär bearbeiten.',
        );
      }
      if (target != null &&
          (target.isBefore(today) ||
              target.isBefore(calendarDay(task.startDate)) ||
              (task.endDate != null &&
                  target.isAfter(calendarDay(task.endDate!))))) {
        throw StateError(
          'Der Termin muss ab heute innerhalb des Start-/Endzeitraums liegen.',
        );
      }
      clock.validate(target ?? today, planning);
      if (task.dueDate == target &&
          task.plannedStartMinute == planning.startMinute &&
          task.plannedDurationMinutes == planning.durationMinutes) {
        return;
      }
      final now = clock.now().toUtc();
      final updated = task.copyWith(
        dueDate: Value(target),
        plannedStartMinute: Value(planning.startMinute),
        plannedDurationMinutes: Value(planning.durationMinutes),
        updatedAt: Value(now),
      );
      await (database.update(database.aufgaben)
        ..where((t) => t.id.equals(task.id))).write(
        AufgabenCompanion(
          dueDate: Value(target),
          plannedStartMinute: Value(planning.startMinute),
          plannedDurationMinutes: Value(planning.durationMinutes),
          updatedAt: Value(now),
        ),
      );
      final version = await TaskDefinitionVersionWriter(
        database,
      ).createVersion(updated, validFrom: today, createdAt: now);
      if (entry != null) {
        await (database.update(database.taskEntries)
          ..where((e) => e.id.equals(entry.id))).write(
          TaskEntriesCompanion(
            scheduledDate:
                target == null ? const Value.absent() : Value(target),
            originalScheduledDate: Value(
              entry.originalScheduledDate ?? entry.scheduledDate,
            ),
            plannedStartMinute: Value(planning.startMinute),
            plannedDurationMinutes: Value(planning.durationMinutes),
            taskDefinitionVersionId: Value(version),
            revision: Value(entry.revision + 1),
            updatedAt: Value(now),
          ),
        );
      } else if (target != null) {
        await database
            .into(database.taskEntries)
            .insert(
              TaskEntriesCompanion.insert(
                id: const Uuid().v4(),
                taskId: task.id,
                scheduledDate: target,
                taskDefinitionVersionId: Value(version),
                plannedStartMinute: Value(planning.startMinute),
                plannedDurationMinutes: Value(planning.durationMinutes),
                createdAt: Value(now),
                updatedAt: now,
              ),
            );
      }
    });
  }
}
