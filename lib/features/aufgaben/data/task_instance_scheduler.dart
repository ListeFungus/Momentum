import 'package:drift/drift.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/habit_recurrence.dart';
import 'package:momentum/features/aufgaben/data/missed_policy.dart';
import 'package:momentum/features/aufgaben/data/post_buffer_behavior.dart';
import 'package:momentum/features/aufgaben/data/task_capture_mode.dart';
import 'package:momentum/features/aufgaben/data/task_definition_version_writer.dart';
import 'package:momentum/features/aufgaben/data/task_definition_resolver.dart';
import 'package:momentum/features/aufgaben/data/task_entry_status.dart';
import 'package:momentum/features/aufgaben/data/task_entries_tabelle.dart';
import 'package:momentum/features/aufgaben/data/task_lifecycle_service.dart';
import 'package:momentum/features/aufgaben/data/task_types.dart';
import 'package:momentum/features/aufgaben/data/task_value_commitment.dart';
import 'package:uuid/uuid.dart';

class TaskInstanceScheduler {
  TaskInstanceScheduler(this._database, {DateTime Function()? now})
    : _definitionVersionWriter = TaskDefinitionVersionWriter(_database),
      _definitionResolver = TaskDefinitionResolver(_database),
      _lifecycleService = TaskLifecycleService(_database, now: now),
      _now = now ?? DateTime.now;

  final AppDatabase _database;
  final TaskDefinitionVersionWriter _definitionVersionWriter;
  final TaskDefinitionResolver _definitionResolver;
  final TaskLifecycleService _lifecycleService;
  final DateTime Function() _now;
  final Uuid _uuid = const Uuid();

  Future<int> ensureEntriesForDate({
    required DateTime date,
    String? taskType,
  }) async {
    final selectedDate = _dateOnly(date);
    final rangeStart = await _earliestRelevantDate(
      selectedDate: selectedDate,
      taskType: taskType,
    );

    return ensureEntriesInRange(
      from: rangeStart,
      to: selectedDate,
      taskType: taskType,
    );
  }

  Future<int> ensureEntriesInRange({
    required DateTime from,
    required DateTime to,
    String? taskType,
  }) async {
    final start = _dateOnly(from);
    final end = _dateOnly(to);
    final rangeStart = start.isAfter(end) ? end : start;
    final rangeEnd = start.isAfter(end) ? start : end;
    var createdCount = 0;

    await _database.transaction(() async {
      await _definitionResolver.applyDueChanges(rangeEnd);
      var date = rangeStart;
      while (!date.isAfter(rangeEnd)) {
        await _applyDirectMissedConsequences(
          referenceDate: date,
          taskType: taskType,
        );
        await _applyBufferMissedConsequences(
          referenceDate: date,
          taskType: taskType,
        );
        createdCount += await _ensureEntriesForSingleDate(
          date: date,
          taskType: taskType,
        );
        await _applyCarryoverLimits(referenceDate: date, taskType: taskType);
        date = _addLocalDays(date, 1);
      }
    });

    return createdCount;
  }

  Future<DateTime> _earliestRelevantDate({
    required DateTime selectedDate,
    required String? taskType,
  }) async {
    final taskQuery = _database.select(_database.aufgaben)
      ..where((task) => task.isActive.equals(true) & task.trashedAt.isNull());

    if (taskType != null) {
      taskQuery.where((task) => task.taskType.equals(taskType));
    }

    final activeTasks = await taskQuery.get();
    DateTime? earliestDate;

    for (final task in activeTasks) {
      final relevantDate =
          task.taskType == TaskTypes.task &&
                  task.recurrence == HabitRecurrence.none
              ? task.dueDate
              : task.startDate;

      if (relevantDate == null) {
        continue;
      }

      final normalizedDate = _dateOnly(relevantDate);
      if (normalizedDate.isAfter(selectedDate)) {
        continue;
      }

      if (earliestDate == null || normalizedDate.isBefore(earliestDate)) {
        earliestDate = normalizedDate;
      }
    }

    return earliestDate ?? selectedDate;
  }

  Future<int> _applyDirectMissedConsequences({
    required DateTime referenceDate,
    required String? taskType,
  }) async {
    final cutoffDate = _dateOnly(referenceDate);
    final query = _database.select(_database.taskEntries).join([
      innerJoin(
        _database.aufgaben,
        _database.aufgaben.id.equalsExp(_database.taskEntries.taskId),
      ),
    ])..where(
      _database.aufgaben.isActive.equals(true) &
          _database.aufgaben.trashedAt.isNull() &
          _database.taskEntries.status.equals(TaskEntryStatus.pending) &
          _database.taskEntries.scheduledDate.isSmallerThanValue(cutoffDate),
    );

    if (taskType != null) {
      query.where(_database.aufgaben.taskType.equals(taskType));
    }

    final rows = await query.get();
    if (rows.isEmpty) {
      return 0;
    }

    final now = _now();
    var updatedCount = 0;

    for (final row in rows) {
      final currentTask = row.readTable(_database.aufgaben);
      final entry = row.readTable(_database.taskEntries);
      final task = await _definitionResolver.taskForEntry(currentTask, entry);
      if (task.missedPolicy != MissedPolicy.direct) {
        continue;
      }
      final status =
          task.missedConsequence == MissedConsequence.keepNeutral
              ? TaskEntryStatus.noEntry
              : TaskEntryStatus.failure;
      final effectiveAt = _addLocalDays(entry.scheduledDate, 1);

      await (_database.update(_database.taskEntries)
        ..where((candidate) => candidate.id.equals(entry.id))).write(
        TaskEntriesCompanion(
          status: Value(status),
          updatedAt: Value(now),
          respondedAt: const Value(null),
          finalizedAt: Value(now),
          effectiveAt: Value(effectiveAt),
          resolutionOrigin: const Value(TaskEntryResolutionOrigin.automatic),
          appliedMissedPolicy: const Value(MissedPolicy.direct),
          appliedMissedConsequence: Value(task.missedConsequence),
          checkboxValue: const Value(null),
          revision: Value(entry.revision + 1),
        ),
      );
      updatedCount++;
    }

    return updatedCount;
  }

  Future<int> _applyBufferMissedConsequences({
    required DateTime referenceDate,
    required String? taskType,
  }) async {
    final cutoffDate = _dateOnly(referenceDate);
    final query = _database.select(_database.taskEntries).join([
      innerJoin(
        _database.aufgaben,
        _database.aufgaben.id.equalsExp(_database.taskEntries.taskId),
      ),
    ])..where(
      _database.aufgaben.isActive.equals(true) &
          _database.aufgaben.trashedAt.isNull() &
          _database.taskEntries.status.equals(TaskEntryStatus.pending) &
          _database.taskEntries.scheduledDate.isSmallerThanValue(cutoffDate),
    );

    if (taskType != null) {
      query.where(_database.aufgaben.taskType.equals(taskType));
    }

    final rows = await query.get();
    if (rows.isEmpty) {
      return 0;
    }

    final now = _now();
    var updatedCount = 0;

    for (final row in rows) {
      final currentTask = row.readTable(_database.aufgaben);
      final entry = row.readTable(_database.taskEntries);
      final task = await _definitionResolver.taskForEntry(currentTask, entry);
      if (task.missedPolicy != MissedPolicy.buffer) {
        continue;
      }
      final postBufferStatus = _statusForPostBufferBehavior(
        task.postBufferBehavior,
      );

      if (postBufferStatus == null) {
        continue;
      }

      final effectiveAt = _addLocalDays(
        entry.scheduledDate,
        task.missedBufferDays + 1,
      );

      if (effectiveAt.isAfter(cutoffDate)) {
        continue;
      }

      await (_database.update(_database.taskEntries)
        ..where((candidate) => candidate.id.equals(entry.id))).write(
        TaskEntriesCompanion(
          status: Value(postBufferStatus),
          updatedAt: Value(now),
          respondedAt: const Value(null),
          finalizedAt: Value(now),
          effectiveAt: Value(effectiveAt),
          resolutionOrigin: const Value(TaskEntryResolutionOrigin.automatic),
          appliedMissedPolicy: const Value(MissedPolicy.buffer),
          appliedMissedConsequence: Value(task.postBufferBehavior),
          checkboxValue: const Value(null),
          revision: Value(entry.revision + 1),
        ),
      );
      updatedCount++;
    }

    return updatedCount;
  }

  Future<int> _applyCarryoverLimits({
    required DateTime referenceDate,
    required String? taskType,
  }) async {
    final cutoffDate = _dateOnly(referenceDate);
    final taskQuery = _database.select(_database.aufgaben)
      ..where((task) => task.isActive.equals(true) & task.trashedAt.isNull());

    if (taskType != null) {
      taskQuery.where((task) => task.taskType.equals(taskType));
    }

    final tasks = await taskQuery.get();
    var updatedCount = 0;

    for (final task in tasks) {
      final pendingEntries =
          await (_database.select(_database.taskEntries)
                ..where(
                  (entry) =>
                      entry.taskId.equals(task.id) &
                      entry.status.equals(TaskEntryStatus.pending) &
                      entry.planningOrigin.equals(
                        TaskEntryPlanningOrigin.planned,
                      ) &
                      entry.scheduledDate.isSmallerOrEqualValue(cutoffDate),
                )
                ..orderBy([(entry) => OrderingTerm.asc(entry.scheduledDate)]))
              .get();

      final groups = <String, List<(TaskEntry, Aufgabe)>>{};
      for (final entry in pendingEntries) {
        final historicalTask = await _definitionResolver.taskForEntry(
          task,
          entry,
        );
        if (historicalTask.missedPolicy != MissedPolicy.carryover) {
          continue;
        }
        final key =
            '${historicalTask.maxCarryoverCount}:'
            '${historicalTask.missedConsequence}';
        groups.putIfAbsent(key, () => <(TaskEntry, Aufgabe)>[]).add((
          entry,
          historicalTask,
        ));
      }

      for (final group in groups.values) {
        final rule = group.first.$2;
        final overflowCount = group.length - rule.maxCarryoverCount;
        if (overflowCount <= 0) {
          continue;
        }
        final now = _now();
        final status =
            rule.missedConsequence == MissedConsequence.keepNeutral
                ? TaskEntryStatus.noEntry
                : TaskEntryStatus.failure;

        for (final pair in group.take(overflowCount)) {
          final entry = pair.$1;
          await (_database.update(_database.taskEntries)
            ..where((candidate) => candidate.id.equals(entry.id))).write(
            TaskEntriesCompanion(
              status: Value(status),
              updatedAt: Value(now),
              respondedAt: const Value(null),
              finalizedAt: Value(now),
              effectiveAt: Value(cutoffDate),
              resolutionOrigin: const Value(
                TaskEntryResolutionOrigin.automatic,
              ),
              appliedMissedPolicy: const Value(MissedPolicy.carryover),
              appliedMissedConsequence: Value(rule.missedConsequence),
              checkboxValue: const Value(null),
              revision: Value(entry.revision + 1),
            ),
          );
          updatedCount++;
        }
      }
    }

    return updatedCount;
  }

  Future<bool> isDueOnDate(Aufgabe task, DateTime date) async {
    final selectedDate = _dateOnly(date);
    if (task.trashedAt != null ||
        await _lifecycleService.isTaskExcludedOnDay(task.id, selectedDate)) {
      return false;
    }
    final effectiveTask = await _definitionResolver.taskForDate(
      task,
      selectedDate,
    );
    task = effectiveTask;

    if (task.taskType == TaskTypes.task &&
        task.recurrence == HabitRecurrence.none) {
      final dueDate = task.dueDate;

      if (dueDate == null) {
        return false;
      }

      return _dateOnly(dueDate) == selectedDate;
    }

    if (task.startDate.isAfter(selectedDate)) {
      return false;
    }

    final endDate = task.endDate;
    if (endDate != null && endDate.isBefore(selectedDate)) {
      return false;
    }

    if (task.recurrence == HabitRecurrence.weeklyAfterCompletion) {
      return _isAfterCompletionDue(task, selectedDate, 7);
    }

    if (HabitRecurrence.isCustomAfterCompletion(task.recurrence)) {
      return _isAfterCompletionDue(
        task,
        selectedDate,
        HabitRecurrence.customAfterCompletionDays(task.recurrence),
      );
    }

    if (task.recurrence == HabitRecurrence.weeklyFixedDays) {
      return _isActiveOnWeekday(task, selectedDate.weekday);
    }

    if (task.recurrence == HabitRecurrence.monthlyFixedDays) {
      return _isActiveOnMonthDay(task, selectedDate);
    }

    if (task.recurrence == HabitRecurrence.none) {
      return false;
    }

    return true;
  }

  Future<int> _ensureEntriesForSingleDate({
    required DateTime date,
    required String? taskType,
  }) async {
    final taskQuery = _database.select(_database.aufgaben)
      ..where((task) => task.isActive.equals(true) & task.trashedAt.isNull());

    if (taskType != null) {
      taskQuery.where((task) => task.taskType.equals(taskType));
    }

    final activeTasks = await taskQuery.get();
    final dueTasks = <Aufgabe>[];

    for (final task in activeTasks) {
      final effectiveTask = await _definitionResolver.taskForDate(task, date);
      if (await isDueOnDate(effectiveTask, date)) {
        dueTasks.add(effectiveTask);
      }
    }

    var createdCount = 0;
    final now = _now();

    for (final task in dueTasks) {
      if (_isPureTrackingTask(task)) {
        continue;
      }

      final existingEntry =
          await (_database.select(_database.taskEntries)..where(
            (entry) =>
                entry.taskId.equals(task.id) & entry.scheduledDate.equals(date),
          )).getSingleOrNull();

      if (existingEntry != null) {
        continue;
      }

      await _database
          .into(_database.taskEntries)
          .insert(
            TaskEntriesCompanion.insert(
              id: _uuid.v4(),
              taskId: task.id,
              taskDefinitionVersionId: Value(
                await _definitionVersionWriter.versionIdForScheduledDate(
                  task.id,
                  date,
                ),
              ),
              scheduledDate: date,
              createdAt: Value(now),
              updatedAt: now,
            ),
            mode: InsertMode.insertOrIgnore,
          );
      createdCount++;
    }

    return createdCount;
  }

  Future<bool> _isAfterCompletionDue(
    Aufgabe task,
    DateTime date,
    int intervalDays,
  ) async {
    final openEntry =
        await (_database.select(_database.taskEntries)
              ..where(
                (entry) =>
                    entry.taskId.equals(task.id) &
                    entry.status.isIn({
                      TaskEntryStatus.pending,
                      TaskEntryStatus.noEntry,
                    }) &
                    entry.scheduledDate.isSmallerOrEqualValue(date),
              )
              ..orderBy([(entry) => OrderingTerm.asc(entry.scheduledDate)])
              ..limit(1))
            .getSingleOrNull();

    if (openEntry != null) {
      return _dateOnly(openEntry.scheduledDate) == date;
    }

    final lastFinalEntry =
        await (_database.select(_database.taskEntries)
              ..where(
                (entry) =>
                    entry.taskId.equals(task.id) &
                    entry.status.isIn(TaskEntryStatus.finalValues) &
                    entry.scheduledDate.isSmallerThanValue(date),
              )
              ..orderBy([
                (entry) => OrderingTerm.desc(entry.effectiveAt),
                (entry) => OrderingTerm.desc(entry.scheduledDate),
              ])
              ..limit(1))
            .getSingleOrNull();

    final lastEffectiveDate =
        lastFinalEntry?.effectiveAt ?? lastFinalEntry?.finalizedAt;

    if (lastEffectiveDate == null) {
      return true;
    }

    return !date.isBefore(_addLocalDays(lastEffectiveDate, intervalDays));
  }
}

bool _isPureTrackingTask(Aufgabe task) {
  return task.erfassungsmodus == TaskCaptureMode.value &&
      task.valueCommitment == TaskValueCommitment.pureTracking;
}

bool _isActiveOnWeekday(Aufgabe task, int weekday) {
  return task.activeWeekdays
      .split(',')
      .map(int.tryParse)
      .whereType<int>()
      .contains(weekday);
}

bool _isActiveOnMonthDay(Aufgabe task, DateTime date) {
  final selectedDays =
      task.activeWeekdays.split(',').map(int.tryParse).whereType<int>().toSet();

  return selectedDays.contains(date.day) ||
      (selectedDays.contains(_lastDayOfMonthValue) && _isLastDayOfMonth(date));
}

bool _isLastDayOfMonth(DateTime date) {
  final nextDay = _addLocalDays(date, 1);
  return nextDay.day == 1;
}

String? _statusForPostBufferBehavior(String behavior) {
  if (behavior == PostBufferBehavior.markAsFailure) {
    return TaskEntryStatus.failure;
  }
  if (behavior == PostBufferBehavior.markAsNoEntry) {
    return TaskEntryStatus.noEntry;
  }
  return null;
}

const _lastDayOfMonthValue = 32;

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

DateTime _addLocalDays(DateTime date, int days) =>
    DateTime(date.year, date.month, date.day + days);
