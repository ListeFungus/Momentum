import 'package:drift/drift.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/task_definition_change.dart';
import 'package:momentum/features/aufgaben/data/task_definition_version_writer.dart';
import 'package:momentum/features/aufgaben/data/task_pending_definition_changes_table.dart';
import 'package:uuid/uuid.dart';

class TaskDefinitionResolver {
  TaskDefinitionResolver(this._database, {DateTime Function()? now})
    : _writer = TaskDefinitionVersionWriter(_database),
      _now = now ?? DateTime.now;

  final AppDatabase _database;
  final TaskDefinitionVersionWriter _writer;
  final DateTime Function() _now;
  final Uuid _uuid = const Uuid();

  Future<TaskDefinitionVersion?> versionForDate(String taskId, DateTime date) {
    final endExclusive = _nextLocalDay(date);
    return (_database.select(_database.taskDefinitionVersions)
          ..where(
            (version) =>
                version.taskId.equals(taskId) &
                version.supersededAt.isNull() &
                version.validFrom.isSmallerThanValue(endExclusive),
          )
          ..orderBy([
            (version) => OrderingTerm.desc(version.validFrom),
            (version) => OrderingTerm.desc(version.versionNumber),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<Aufgabe> taskForDate(Aufgabe current, DateTime date) async {
    final version = await versionForDate(current.id, date);
    return version == null ? current : taskFromVersion(current, version);
  }

  Future<Aufgabe> taskForEntry(Aufgabe current, TaskEntry entry) async {
    final versionId = entry.taskDefinitionVersionId;
    if (versionId == null) {
      return taskForDate(current, entry.scheduledDate);
    }
    final version =
        await (_database.select(_database.taskDefinitionVersions)..where(
          (candidate) => candidate.id.equals(versionId),
        )).getSingleOrNull();
    return version == null ? current : taskFromVersion(current, version);
  }

  Aufgabe taskFromVersion(Aufgabe task, TaskDefinitionVersion version) {
    return task.copyWith(
      projectId: Value(version.projectId),
      name: version.name,
      beschreibung: version.description,
      erfassungsmodus: version.captureMode,
      taskType: version.taskType,
      questionText: version.questionText,
      successValue: version.successValue,
      activeWeekdays: version.activeWeekdays,
      recurrence: version.recurrence,
      startDate: _dateOnly(version.startDate),
      endDate: Value(version.endDate),
      dueDate: Value(version.dueDate),
      missedPolicy: version.missedPolicy,
      missedConsequence: version.missedConsequence,
      missedBufferDays: version.missedBufferDays,
      postBufferBehavior: version.postBufferBehavior,
      maxCarryoverCount: version.maxCarryoverCount,
      goalType: version.goalType,
      goalValue: version.goalValue,
      goalWindowDays: Value(version.goalWindowDays),
      goalPeriod: version.goalPeriod,
      goalPeriodAlignment: version.goalPeriodAlignment,
      valueType: version.valueType,
      valueCommitment: version.valueCommitment,
      valueUnitKey: version.valueUnitKey,
      valueUnitLabel: version.valueUnitLabel,
    );
  }

  Future<TaskPendingDefinitionChange?> pendingChange(
    String taskId,
    String group,
  ) {
    return (_database.select(_database.taskPendingDefinitionChanges)
          ..where(
            (change) =>
                change.taskId.equals(taskId) &
                change.groupKey.equals(group) &
                change.state.equals(TaskPendingDefinitionChangeState.pending),
          )
          ..orderBy([(change) => OrderingTerm.desc(change.updatedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Stream<List<TaskPendingDefinitionChange>> watchPendingChanges(String taskId) {
    return (_database.select(_database.taskPendingDefinitionChanges)
          ..where(
            (change) =>
                change.taskId.equals(taskId) &
                change.state.equals(TaskPendingDefinitionChangeState.pending),
          )
          ..orderBy([(change) => OrderingTerm.asc(change.effectiveDate)]))
        .watch();
  }

  Future<void> scheduleChange({
    required String taskId,
    required String group,
    required DateTime effectiveDate,
    required String payloadJson,
  }) async {
    await _ensureWritable(taskId);
    final normalizedDate = _dateOnly(effectiveDate);
    await _database.transaction(() async {
      final existing = await pendingChange(taskId, group);
      if (existing != null &&
          existing.payloadJson == payloadJson &&
          _dateOnly(existing.effectiveDate) == normalizedDate) {
        return;
      }
      final now = _now().toUtc();
      if (existing != null) {
        await (_database.update(_database.taskPendingDefinitionChanges)
          ..where((change) => change.id.equals(existing.id))).write(
          TaskPendingDefinitionChangesCompanion(
            state: const Value(TaskPendingDefinitionChangeState.cancelled),
            updatedAt: Value(now),
          ),
        );
      }
      await _database
          .into(_database.taskPendingDefinitionChanges)
          .insert(
            TaskPendingDefinitionChangesCompanion.insert(
              id: _uuid.v4(),
              taskId: taskId,
              groupKey: group,
              effectiveDate: normalizedDate,
              payloadJson: payloadJson,
              updatedAt: Value(now),
            ),
          );
    });
  }

  Future<void> cancelPendingChange(String taskId, String group) async {
    await _ensureWritable(taskId);
    final now = _now().toUtc();
    await (_database.update(_database.taskPendingDefinitionChanges)..where(
      (change) =>
          change.taskId.equals(taskId) &
          change.groupKey.equals(group) &
          change.state.equals(TaskPendingDefinitionChangeState.pending),
    )).write(
      TaskPendingDefinitionChangesCompanion(
        state: const Value(TaskPendingDefinitionChangeState.cancelled),
        updatedAt: Value(now),
      ),
    );
  }

  Future<int> applyDueChanges(DateTime referenceDate) async {
    final endExclusive = _nextLocalDay(referenceDate);
    return _database.transaction(() async {
      final due =
          await (_database.select(_database.taskPendingDefinitionChanges)
                ..where(
                  (change) =>
                      change.state.equals(
                        TaskPendingDefinitionChangeState.pending,
                      ) &
                      change.effectiveDate.isSmallerThanValue(endExclusive),
                )
                ..orderBy([
                  (change) => OrderingTerm.asc(change.effectiveDate),
                  (change) => OrderingTerm.asc(change.createdAt),
                ]))
              .get();
      if (due.isEmpty) {
        return 0;
      }

      final groups = <String, List<TaskPendingDefinitionChange>>{};
      for (final change in due) {
        final date = _dateOnly(change.effectiveDate);
        final key = '${change.taskId}:${date.toIso8601String()}';
        groups.putIfAbsent(key, () => []).add(change);
      }

      var applied = 0;
      for (final changes in groups.values) {
        final first = changes.first;
        final storedTask =
            await (_database.select(_database.aufgaben)..where(
              (candidate) => candidate.id.equals(first.taskId),
            )).getSingle();
        var task = storedTask;
        if (task.trashedAt != null) {
          continue;
        }

        for (final change in changes) {
          if (change.groupKey == TaskPendingDefinitionChangeGroup.schedule) {
            final payload = TaskScheduleChangePayload.decode(
              change.payloadJson,
            );
            task = task.copyWith(
              activeWeekdays: payload.activeWeekdays,
              recurrence: payload.recurrence,
              missedPolicy: payload.missedPolicy,
              missedConsequence: payload.missedConsequence,
              missedBufferDays: payload.missedBufferDays,
              postBufferBehavior: payload.postBufferBehavior,
              maxCarryoverCount: payload.maxCarryoverCount,
            );
          } else if (change.groupKey == TaskPendingDefinitionChangeGroup.goal) {
            final payload = TaskGoalChangePayload.decode(change.payloadJson);
            task = task.copyWith(
              goalType: payload.goalType,
              goalValue: payload.goalValue,
              goalWindowDays: Value(payload.goalWindowDays),
              goalPeriod: payload.goalPeriod,
              goalPeriodAlignment: payload.goalPeriodAlignment,
            );
          }
        }

        final changed = !_sameAppliedDefinition(storedTask, task);
        final now = _now().toUtc();
        if (changed) {
          await (_database.update(_database.aufgaben)..where(
            (candidate) => candidate.id.equals(task.id),
          )).write(_taskCompanion(task, updatedAt: now));
          await _writer.createVersion(
            task,
            validFrom: _dateOnly(first.effectiveDate),
            createdAt: now,
          );
        }
        await (_database.update(_database.taskPendingDefinitionChanges)..where(
          (candidate) => candidate.id.isIn(changes.map((item) => item.id)),
        )).write(
          TaskPendingDefinitionChangesCompanion(
            state: const Value(TaskPendingDefinitionChangeState.applied),
            updatedAt: Value(now),
          ),
        );
        applied += changes.length;
      }
      return applied;
    });
  }

  Future<void> _ensureWritable(String taskId) async {
    final task =
        await (_database.select(_database.aufgaben)
          ..where((candidate) => candidate.id.equals(taskId))).getSingle();
    if (task.trashedAt != null) {
      throw StateError(
        'Eine Aufgabe im Papierkorb kann nicht geändert werden.',
      );
    }
  }
}

AufgabenCompanion _taskCompanion(Aufgabe task, {required DateTime updatedAt}) =>
    AufgabenCompanion(
      activeWeekdays: Value(task.activeWeekdays),
      recurrence: Value(task.recurrence),
      missedPolicy: Value(task.missedPolicy),
      missedConsequence: Value(task.missedConsequence),
      missedBufferDays: Value(task.missedBufferDays),
      postBufferBehavior: Value(task.postBufferBehavior),
      maxCarryoverCount: Value(task.maxCarryoverCount),
      goalType: Value(task.goalType),
      goalValue: Value(task.goalValue),
      goalWindowDays: Value(task.goalWindowDays),
      goalPeriod: Value(task.goalPeriod),
      goalPeriodAlignment: Value(task.goalPeriodAlignment),
      updatedAt: Value(updatedAt),
    );

bool _sameAppliedDefinition(Aufgabe first, Aufgabe second) =>
    first.activeWeekdays == second.activeWeekdays &&
    first.recurrence == second.recurrence &&
    first.missedPolicy == second.missedPolicy &&
    first.missedConsequence == second.missedConsequence &&
    first.missedBufferDays == second.missedBufferDays &&
    first.postBufferBehavior == second.postBufferBehavior &&
    first.maxCarryoverCount == second.maxCarryoverCount &&
    first.goalType == second.goalType &&
    first.goalValue == second.goalValue &&
    first.goalWindowDays == second.goalWindowDays &&
    first.goalPeriod == second.goalPeriod &&
    first.goalPeriodAlignment == second.goalPeriodAlignment;

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

DateTime _nextLocalDay(DateTime date) =>
    DateTime(date.year, date.month, date.day + 1);
