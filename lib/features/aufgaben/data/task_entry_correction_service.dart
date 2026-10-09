import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/habit_recurrence.dart';
import 'package:momentum/features/aufgaben/data/missed_policy.dart';
import 'package:momentum/features/aufgaben/data/task_capture_mode.dart';
import 'package:momentum/features/aufgaben/data/task_corrections_tables.dart';
import 'package:momentum/features/aufgaben/data/task_definition_resolver.dart';
import 'package:momentum/features/aufgaben/data/task_entry_performed_on.dart';
import 'package:momentum/features/aufgaben/data/task_entry_status.dart';
import 'package:momentum/features/aufgaben/data/task_value_commitment.dart';
import 'package:uuid/uuid.dart';

class TaskCorrectionException implements Exception {
  const TaskCorrectionException(this.message);

  final String message;

  @override
  String toString() => message;
}

class TaskStatusCorrectionTarget {
  const TaskStatusCorrectionTarget({
    required this.entryId,
    required this.status,
    this.checkboxValue,
    this.performedOn,
    this.expectedRevision,
  });

  final String entryId;
  final String status;
  final bool? checkboxValue;
  final DateTime? performedOn;
  final int? expectedRevision;
}

class TaskCorrectionPreview {
  const TaskCorrectionPreview({
    required this.taskId,
    required this.targets,
    required this.skippedCount,
    required this.excludedValueCount,
  });

  final String taskId;
  final List<TaskStatusCorrectionTarget> targets;
  final int skippedCount;
  final int excludedValueCount;

  int get changedCount => targets.length;
}

class TaskEntryCorrectionService {
  TaskEntryCorrectionService(this._database, {DateTime Function()? now})
    : _resolver = TaskDefinitionResolver(_database),
      _now = now ?? DateTime.now;

  final AppDatabase _database;
  final TaskDefinitionResolver _resolver;
  final DateTime Function() _now;
  final Uuid _uuid = const Uuid();

  Future<TaskCorrectionPreview> previewBulkStatus({
    required String taskId,
    required Iterable<String> entryIds,
    required String status,
    bool? checkboxValue,
  }) async {
    await _ensureTaskWritable(taskId);
    final ids = entryIds.toSet();
    if (ids.isEmpty) {
      return TaskCorrectionPreview(
        taskId: taskId,
        targets: const [],
        skippedCount: 0,
        excludedValueCount: 0,
      );
    }
    final entries =
        await (_database.select(_database.taskEntries)..where(
          (entry) => entry.taskId.equals(taskId) & entry.id.isIn(ids),
        )).get();
    final values =
        await (_database.select(_database.taskEntryValues)..where(
          (value) => value.entryId.isIn(entries.map((entry) => entry.id)),
        )).get();
    final entryIdsWithValues = values.map((value) => value.entryId).toSet();
    final targets = <TaskStatusCorrectionTarget>[];
    var skipped = ids.length - entries.length;
    var excludedValues = 0;
    for (final entry in entries) {
      if (entryIdsWithValues.contains(entry.id)) {
        excludedValues++;
        continue;
      }
      if (entry.status == status && entry.checkboxValue == checkboxValue) {
        skipped++;
        continue;
      }
      targets.add(
        TaskStatusCorrectionTarget(
          entryId: entry.id,
          status: status,
          checkboxValue: checkboxValue,
          performedOn:
              status == TaskEntryStatus.success
                  ? _dateOnly(entry.scheduledDate)
                  : null,
          expectedRevision: entry.revision,
        ),
      );
    }
    return TaskCorrectionPreview(
      taskId: taskId,
      targets: targets,
      skippedCount: skipped,
      excludedValueCount: excludedValues,
    );
  }

  Future<String?> applyStatusCorrections({
    required String taskId,
    required Iterable<TaskStatusCorrectionTarget> targets,
    String reason = '',
    String operationType = TaskCorrectionOperationType.answer,
  }) async {
    await _ensureTaskWritable(taskId);
    final requested = targets.toList(growable: false);
    if (requested.isEmpty) {
      return null;
    }
    if (requested.any((target) => target.status == TaskEntryStatus.noEntry) &&
        reason.trim().isEmpty) {
      throw const TaskCorrectionException(
        'Kein Eintrag benötigt eine kurze Begründung.',
      );
    }

    return _database.transaction(() async {
      final entries =
          await (_database.select(_database.taskEntries)..where(
            (entry) =>
                entry.taskId.equals(taskId) &
                entry.id.isIn(requested.map((target) => target.entryId)),
          )).get();
      if (entries.length != requested.length) {
        throw const TaskCorrectionException(
          'Mindestens ein Eintrag wurde inzwischen geändert oder entfernt.',
        );
      }
      final task =
          await (_database.select(_database.aufgaben)
            ..where((candidate) => candidate.id.equals(taskId))).getSingle();
      final entryById = {for (final entry in entries) entry.id: entry};
      final changes = <_PreparedCorrection>[];
      for (final target in requested) {
        final entry = entryById[target.entryId]!;
        if (target.expectedRevision != null &&
            target.expectedRevision != entry.revision) {
          throw const TaskCorrectionException(
            'Mindestens ein Eintrag wurde seit der Vorschau geändert. '
            'Bitte prüfe die Auswahl erneut.',
          );
        }
        final historicalTask = await _taskForEntry(task, entry);
        await _validateStatusTarget(
          task: historicalTask,
          entry: entry,
          status: target.status,
          performedOn: target.performedOn,
        );
        final currentValue =
            await (_database.select(_database.taskEntryValues)..where(
              (value) => value.entryId.equals(entry.id),
            )).getSingleOrNull();
        if (currentValue != null) {
          throw const TaskCorrectionException(
            'Einträge mit Messwert werden nur einzeln korrigiert.',
          );
        }
        final after = _statusAfter(entry, target, reason: reason, now: _now());
        if (_sameEntryState(entry, after)) {
          continue;
        }
        changes.add(
          _PreparedCorrection(
            beforeEntry: entry,
            afterEntry: after,
            beforeValue: null,
            afterValue: null,
          ),
        );
      }
      return _applyPrepared(
        taskId: taskId,
        type:
            changes.length > 1
                ? TaskCorrectionOperationType.bulkStatus
                : operationType,
        reason: reason,
        changes: changes,
      );
    });
  }

  Future<String?> removeValue({
    required String taskId,
    required String entryId,
    String reason = '',
  }) async {
    await _ensureTaskWritable(taskId);
    return _database.transaction(() async {
      final task =
          await (_database.select(_database.aufgaben)
            ..where((candidate) => candidate.id.equals(taskId))).getSingle();
      final entry =
          await (_database.select(_database.taskEntries)..where(
            (candidate) =>
                candidate.id.equals(entryId) & candidate.taskId.equals(taskId),
          )).getSingle();
      final value =
          await (_database.select(_database.taskEntryValues)..where(
            (candidate) => candidate.entryId.equals(entryId),
          )).getSingleOrNull();
      if (value == null) {
        return null;
      }
      final historicalTask = await _taskForEntry(task, entry);
      final canReopen = await _canReopen(historicalTask, entry);
      final nextStatus =
          historicalTask.valueCommitment == TaskValueCommitment.pureTracking ||
                  !canReopen
              ? TaskEntryStatus.noEntry
              : TaskEntryStatus.pending;
      final now = _now();
      final after = entry.copyWith(
        status: nextStatus,
        updatedAt: now,
        respondedAt: Value(nextStatus == TaskEntryStatus.pending ? null : now),
        finalizedAt: const Value(null),
        effectiveAt: const Value(null),
        performedOn: const Value(null),
        performedOnSource: const Value(null),
        resolutionOrigin: Value(
          nextStatus == TaskEntryStatus.pending
              ? null
              : TaskEntryResolutionOrigin.manual,
        ),
        checkboxValue: const Value(null),
        numberValue: const Value(null),
        note: reason.trim().isEmpty ? entry.note : reason.trim(),
        revision: entry.revision + 1,
      );
      return _applyPrepared(
        taskId: taskId,
        type: TaskCorrectionOperationType.removeValue,
        reason: reason,
        changes: [
          _PreparedCorrection(
            beforeEntry: entry,
            afterEntry: after,
            beforeValue: value,
            afterValue: null,
          ),
        ],
      );
    });
  }

  Future<String?> replaceValue({
    required String taskId,
    required String entryId,
    required String valueType,
    required double? numberValue,
    required double? normalizedNumberValue,
    required String unitKey,
    required String unitLabel,
    required int? durationSeconds,
    required int? timeMinutes,
    required int dayOffset,
    required DateTime performedOn,
  }) async {
    await _ensureTaskWritable(taskId);
    return _database.transaction(() async {
      final entry =
          await (_database.select(_database.taskEntries)..where(
            (candidate) =>
                candidate.id.equals(entryId) & candidate.taskId.equals(taskId),
          )).getSingle();
      final beforeValue =
          await (_database.select(_database.taskEntryValues)..where(
            (candidate) => candidate.entryId.equals(entryId),
          )).getSingleOrNull();
      final now = _now();
      final afterValue = TaskEntryValue(
        id: beforeValue?.id ?? _uuid.v4(),
        entryId: entryId,
        valueType: valueType,
        numberValue: numberValue,
        normalizedNumberValue: normalizedNumberValue,
        unitKey: unitKey,
        unitLabel: unitLabel,
        durationSeconds: durationSeconds,
        timeMinutes: timeMinutes,
        dayOffset: dayOffset,
        createdAt: beforeValue?.createdAt ?? now,
        updatedAt: now,
      );
      final performedDate = _dateOnly(performedOn);
      final afterEntry = entry.copyWith(
        status: TaskEntryStatus.recorded,
        updatedAt: now,
        respondedAt: Value(now),
        finalizedAt: Value(now),
        effectiveAt: Value(performedDate),
        performedOn: Value(performedDate),
        performedOnSource: const Value(TaskEntryPerformedOnSource.user),
        resolutionOrigin: const Value(TaskEntryResolutionOrigin.manual),
        appliedMissedPolicy: const Value(null),
        appliedMissedConsequence: const Value(null),
        checkboxValue: const Value(null),
        numberValue: Value(numberValue),
        revision: entry.revision + 1,
      );
      if (beforeValue != null &&
          _sameValueState(beforeValue, afterValue) &&
          _sameEntryState(entry, afterEntry)) {
        return null;
      }
      return _applyPrepared(
        taskId: taskId,
        type: TaskCorrectionOperationType.value,
        reason: '',
        changes: [
          _PreparedCorrection(
            beforeEntry: entry,
            afterEntry: afterEntry,
            beforeValue: beforeValue,
            afterValue: afterValue,
          ),
        ],
      );
    });
  }

  Future<String?> correctNote({
    required String taskId,
    required String entryId,
    required String note,
  }) async {
    await _ensureTaskWritable(taskId);
    return _database.transaction(() async {
      final entry =
          await (_database.select(_database.taskEntries)..where(
            (candidate) =>
                candidate.id.equals(entryId) & candidate.taskId.equals(taskId),
          )).getSingle();
      final value =
          await (_database.select(_database.taskEntryValues)..where(
            (candidate) => candidate.entryId.equals(entryId),
          )).getSingleOrNull();
      if (entry.note == note.trim()) {
        return null;
      }
      final after = entry.copyWith(
        note: note.trim(),
        updatedAt: _now(),
        revision: entry.revision + 1,
      );
      return _applyPrepared(
        taskId: taskId,
        type: TaskCorrectionOperationType.note,
        reason: '',
        changes: [
          _PreparedCorrection(
            beforeEntry: entry,
            afterEntry: after,
            beforeValue: value,
            afterValue: value,
          ),
        ],
      );
    });
  }

  Future<bool> undoLatest(String taskId) async {
    await _ensureTaskWritable(taskId);
    return _database.transaction(() async {
      final operation =
          await (_database.select(_database.taskCorrectionOperations)
                ..where(
                  (candidate) =>
                      candidate.taskId.equals(taskId) &
                      candidate.state.equals(
                        TaskCorrectionOperationState.applied,
                      ),
                )
                ..orderBy([
                  (candidate) => OrderingTerm.desc(candidate.createdAt),
                ])
                ..limit(1))
              .getSingleOrNull();
      if (operation == null) {
        return false;
      }
      final items =
          await (_database.select(_database.taskCorrectionItems)
            ..where((item) => item.operationId.equals(operation.id))).get();
      for (final item in items) {
        final entry =
            await (_database.select(_database.taskEntries)..where(
              (candidate) => candidate.id.equals(item.entryId),
            )).getSingleOrNull();
        if (entry == null || entry.revision != item.expectedRevision) {
          throw const TaskCorrectionException(
            'Ein betroffener Eintrag wurde inzwischen geändert. Diese '
            'Korrektur kann deshalb nicht vollständig rückgängig gemacht werden.',
          );
        }
        final before = _EntryState.decode(item.beforeJson);
        if (before.status == TaskEntryStatus.pending) {
          final task =
              await (_database.select(
                _database.aufgaben,
              )..where((candidate) => candidate.id.equals(taskId))).getSingle();
          final historicalTask = await _taskForEntry(task, entry);
          if (!await _canReopen(historicalTask, entry)) {
            throw const TaskCorrectionException(
              'Die Frist oder Folgeplanung lässt ein erneutes Öffnen nicht mehr zu.',
            );
          }
        }
      }

      final now = _now();
      for (final item in items) {
        final current =
            await (_database.select(_database.taskEntries)..where(
              (candidate) => candidate.id.equals(item.entryId),
            )).getSingle();
        final before = _EntryState.decode(item.beforeJson);
        await (_database.update(_database.taskEntries)
          ..where((candidate) => candidate.id.equals(item.entryId))).write(
          before.toCompanion(
            updatedAt: now,
            revision: current.revision + 1,
            fallbackPlanningOrigin: current.planningOrigin,
          ),
        );
        await _restoreValue(item.entryId, before.value, now);
      }
      await (_database.update(_database.taskCorrectionOperations)
        ..where((candidate) => candidate.id.equals(operation.id))).write(
        TaskCorrectionOperationsCompanion(
          state: const Value(TaskCorrectionOperationState.undone),
          updatedAt: Value(now),
        ),
      );
      return true;
    });
  }

  Future<void> _ensureTaskWritable(String taskId) async {
    final task =
        await (_database.select(_database.aufgaben)
          ..where((candidate) => candidate.id.equals(taskId))).getSingle();
    if (task.trashedAt != null) {
      throw const TaskCorrectionException(
        'Eine Aufgabe im Papierkorb kann nicht korrigiert werden.',
      );
    }
  }

  Future<String?> _applyPrepared({
    required String taskId,
    required String type,
    required String reason,
    required List<_PreparedCorrection> changes,
  }) async {
    if (changes.isEmpty) {
      return null;
    }
    final now = _now();
    await (_database.update(_database.taskCorrectionOperations)..where(
      (operation) =>
          operation.taskId.equals(taskId) &
          operation.state.equals(TaskCorrectionOperationState.applied),
    )).write(
      TaskCorrectionOperationsCompanion(
        state: const Value(TaskCorrectionOperationState.blocked),
        updatedAt: Value(now),
      ),
    );
    final operationId = _uuid.v4();
    await _database
        .into(_database.taskCorrectionOperations)
        .insert(
          TaskCorrectionOperationsCompanion.insert(
            id: operationId,
            taskId: taskId,
            type: type,
            reason: Value(reason.trim()),
            updatedAt: Value(now),
          ),
        );
    for (final change in changes) {
      await (_database.update(_database.taskEntries)..where(
        (candidate) => candidate.id.equals(change.beforeEntry.id),
      )).write(_entryCompanion(change.afterEntry));
      await _restoreValue(
        change.beforeEntry.id,
        change.afterValue == null
            ? null
            : _ValueState.fromValue(change.afterValue!),
        now,
      );
      await _database
          .into(_database.taskCorrectionItems)
          .insert(
            TaskCorrectionItemsCompanion.insert(
              id: _uuid.v4(),
              operationId: operationId,
              entryId: change.beforeEntry.id,
              beforeJson:
                  _EntryState.from(
                    change.beforeEntry,
                    change.beforeValue,
                  ).encode(),
              afterJson:
                  _EntryState.from(
                    change.afterEntry,
                    change.afterValue,
                  ).encode(),
              expectedRevision: change.afterEntry.revision,
            ),
          );
    }
    return operationId;
  }

  Future<Aufgabe> _taskForEntry(Aufgabe task, TaskEntry entry) async {
    final versionId = entry.taskDefinitionVersionId;
    if (versionId == null) {
      return _resolver.taskForDate(task, entry.scheduledDate);
    }
    final version =
        await (_database.select(_database.taskDefinitionVersions)..where(
          (candidate) => candidate.id.equals(versionId),
        )).getSingleOrNull();
    return version == null ? task : _resolver.taskFromVersion(task, version);
  }

  Future<void> _validateStatusTarget({
    required Aufgabe task,
    required TaskEntry entry,
    required String status,
    required DateTime? performedOn,
  }) async {
    if (!TaskEntryStatus.values.contains(status)) {
      throw TaskCorrectionException('Unbekannter Zielstatus: $status');
    }
    final pureTracking =
        task.erfassungsmodus == TaskCaptureMode.value &&
        task.valueCommitment == TaskValueCommitment.pureTracking;
    if (pureTracking &&
        status != TaskEntryStatus.noEntry &&
        status != TaskEntryStatus.pending) {
      throw const TaskCorrectionException(
        'Reines Tracking wird nicht als Erfolg oder Misserfolg bewertet.',
      );
    }
    if (status == TaskEntryStatus.recorded) {
      throw const TaskCorrectionException(
        'Erfasst entsteht nur durch einen echten Messwert.',
      );
    }
    if (status == TaskEntryStatus.pending && !await _canReopen(task, entry)) {
      throw const TaskCorrectionException(
        'Die Frist, Folgeplanung oder Carryover-Grenze lässt ein erneutes '
        'Öffnen nicht zu.',
      );
    }
    if (performedOn != null) {
      final date = _dateOnly(performedOn);
      if (date.isAfter(_dateOnly(_now())) ||
          date.isBefore(_dateOnly(task.startDate))) {
        throw const TaskCorrectionException(
          'Der Durchführungstag liegt außerhalb des zulässigen Bereichs.',
        );
      }
    }
  }

  Future<bool> _canReopen(Aufgabe task, TaskEntry entry) async {
    final today = _dateOnly(_now());
    if (task.recurrence == HabitRecurrence.weeklyAfterCompletion ||
        HabitRecurrence.isCustomAfterCompletion(task.recurrence)) {
      final laterEntry =
          await (_database.select(_database.taskEntries)
                ..where(
                  (candidate) =>
                      candidate.taskId.equals(task.id) &
                      candidate.scheduledDate.isBiggerThanValue(
                        entry.scheduledDate,
                      ),
                )
                ..limit(1))
              .getSingleOrNull();
      if (laterEntry != null) {
        return false;
      }
    }
    if (task.missedPolicy == MissedPolicy.direct &&
        !today.isBefore(_nextLocalDay(entry.scheduledDate))) {
      return false;
    }
    if (task.missedPolicy == MissedPolicy.buffer) {
      final deadline = DateTime(
        entry.scheduledDate.year,
        entry.scheduledDate.month,
        entry.scheduledDate.day + task.missedBufferDays + 1,
      );
      if (!today.isBefore(deadline)) {
        return false;
      }
    }
    if (task.missedPolicy == MissedPolicy.carryover) {
      final pendingCount =
          await (_database.selectOnly(_database.taskEntries)
                ..addColumns([_database.taskEntries.id.count()])
                ..where(
                  _database.taskEntries.taskId.equals(task.id) &
                      _database.taskEntries.status.equals(
                        TaskEntryStatus.pending,
                      ),
                ))
              .map((row) => row.read(_database.taskEntries.id.count()) ?? 0)
              .getSingle();
      if (pendingCount >= task.maxCarryoverCount) {
        return false;
      }
    }
    return true;
  }

  TaskEntry _statusAfter(
    TaskEntry entry,
    TaskStatusCorrectionTarget target, {
    required String reason,
    required DateTime now,
  }) {
    final isPending = target.status == TaskEntryStatus.pending;
    final isSuccess = target.status == TaskEntryStatus.success;
    final performed =
        isSuccess ? _dateOnly(target.performedOn ?? entry.scheduledDate) : null;
    return entry.copyWith(
      status: target.status,
      updatedAt: now,
      respondedAt: Value(isPending ? null : now),
      finalizedAt: Value(isPending ? null : now),
      effectiveAt: Value(isPending ? null : performed ?? now),
      performedOn: Value(performed),
      performedOnSource: Value(
        performed == null ? null : TaskEntryPerformedOnSource.user,
      ),
      resolutionOrigin: Value(
        isPending ? null : TaskEntryResolutionOrigin.manual,
      ),
      appliedMissedPolicy: const Value(null),
      appliedMissedConsequence: const Value(null),
      checkboxValue: Value(target.checkboxValue),
      note:
          target.status == TaskEntryStatus.noEntry && reason.trim().isNotEmpty
              ? reason.trim()
              : entry.note,
      revision: entry.revision + 1,
    );
  }

  Future<void> _restoreValue(
    String entryId,
    _ValueState? state,
    DateTime now,
  ) async {
    if (state == null) {
      await (_database.delete(_database.taskEntryValues)
        ..where((value) => value.entryId.equals(entryId))).go();
      return;
    }
    await _database
        .into(_database.taskEntryValues)
        .insertOnConflictUpdate(state.toCompanion(entryId, now));
  }
}

class _PreparedCorrection {
  const _PreparedCorrection({
    required this.beforeEntry,
    required this.afterEntry,
    required this.beforeValue,
    required this.afterValue,
  });

  final TaskEntry beforeEntry;
  final TaskEntry afterEntry;
  final TaskEntryValue? beforeValue;
  final TaskEntryValue? afterValue;
}

class _EntryState {
  const _EntryState({
    required this.status,
    required this.respondedAt,
    required this.finalizedAt,
    required this.effectiveAt,
    required this.performedOn,
    required this.performedOnSource,
    required this.resolutionOrigin,
    required this.appliedMissedPolicy,
    required this.appliedMissedConsequence,
    required this.checkboxValue,
    required this.numberValue,
    required this.note,
    required this.planningOrigin,
    required this.value,
  });

  factory _EntryState.from(TaskEntry entry, TaskEntryValue? value) =>
      _EntryState(
        status: entry.status,
        respondedAt: entry.respondedAt,
        finalizedAt: entry.finalizedAt,
        effectiveAt: entry.effectiveAt,
        performedOn: entry.performedOn,
        performedOnSource: entry.performedOnSource,
        resolutionOrigin: entry.resolutionOrigin,
        appliedMissedPolicy: entry.appliedMissedPolicy,
        appliedMissedConsequence: entry.appliedMissedConsequence,
        checkboxValue: entry.checkboxValue,
        numberValue: entry.numberValue,
        note: entry.note,
        planningOrigin: entry.planningOrigin,
        value: value == null ? null : _ValueState.fromValue(value),
      );

  factory _EntryState.decode(String source) {
    final json = jsonDecode(source) as Map<String, dynamic>;
    return _EntryState(
      status: json['status'] as String,
      respondedAt: _decodeDate(json['respondedAt']),
      finalizedAt: _decodeDate(json['finalizedAt']),
      effectiveAt: _decodeDate(json['effectiveAt']),
      performedOn: _decodeDate(json['performedOn']),
      performedOnSource: json['performedOnSource'] as String?,
      resolutionOrigin: json['resolutionOrigin'] as String?,
      appliedMissedPolicy: json['appliedMissedPolicy'] as String?,
      appliedMissedConsequence: json['appliedMissedConsequence'] as String?,
      checkboxValue: json['checkboxValue'] as bool?,
      numberValue: (json['numberValue'] as num?)?.toDouble(),
      note: json['note'] as String? ?? '',
      planningOrigin: json['planningOrigin'] as String?,
      value:
          json['value'] == null
              ? null
              : _ValueState.fromJson(json['value'] as Map<String, dynamic>),
    );
  }

  final String status;
  final DateTime? respondedAt;
  final DateTime? finalizedAt;
  final DateTime? effectiveAt;
  final DateTime? performedOn;
  final String? performedOnSource;
  final String? resolutionOrigin;
  final String? appliedMissedPolicy;
  final String? appliedMissedConsequence;
  final bool? checkboxValue;
  final double? numberValue;
  final String note;
  final String? planningOrigin;
  final _ValueState? value;

  String encode() => jsonEncode({
    'status': status,
    'respondedAt': respondedAt?.toIso8601String(),
    'finalizedAt': finalizedAt?.toIso8601String(),
    'effectiveAt': effectiveAt?.toIso8601String(),
    'performedOn': performedOn?.toIso8601String(),
    'performedOnSource': performedOnSource,
    'resolutionOrigin': resolutionOrigin,
    'appliedMissedPolicy': appliedMissedPolicy,
    'appliedMissedConsequence': appliedMissedConsequence,
    'checkboxValue': checkboxValue,
    'numberValue': numberValue,
    'note': note,
    'planningOrigin': planningOrigin,
    'value': value?.toJson(),
  });

  TaskEntriesCompanion toCompanion({
    required DateTime updatedAt,
    required int revision,
    required String fallbackPlanningOrigin,
  }) => TaskEntriesCompanion(
    status: Value(status),
    updatedAt: Value(updatedAt),
    respondedAt: Value(respondedAt),
    finalizedAt: Value(finalizedAt),
    effectiveAt: Value(effectiveAt),
    performedOn: Value(performedOn),
    performedOnSource: Value(performedOnSource),
    resolutionOrigin: Value(resolutionOrigin),
    appliedMissedPolicy: Value(appliedMissedPolicy),
    appliedMissedConsequence: Value(appliedMissedConsequence),
    checkboxValue: Value(checkboxValue),
    numberValue: Value(numberValue),
    note: Value(note),
    revision: Value(revision),
    planningOrigin: Value(planningOrigin ?? fallbackPlanningOrigin),
  );
}

class _ValueState {
  const _ValueState({
    required this.id,
    required this.valueType,
    required this.numberValue,
    required this.normalizedNumberValue,
    required this.unitKey,
    required this.unitLabel,
    required this.durationSeconds,
    required this.timeMinutes,
    required this.dayOffset,
    required this.createdAt,
  });

  factory _ValueState.fromValue(TaskEntryValue value) => _ValueState(
    id: value.id,
    valueType: value.valueType,
    numberValue: value.numberValue,
    normalizedNumberValue: value.normalizedNumberValue,
    unitKey: value.unitKey,
    unitLabel: value.unitLabel,
    durationSeconds: value.durationSeconds,
    timeMinutes: value.timeMinutes,
    dayOffset: value.dayOffset,
    createdAt: value.createdAt,
  );

  factory _ValueState.fromJson(Map<String, dynamic> json) => _ValueState(
    id: json['id'] as String,
    valueType: json['valueType'] as String,
    numberValue: (json['numberValue'] as num?)?.toDouble(),
    normalizedNumberValue: (json['normalizedNumberValue'] as num?)?.toDouble(),
    unitKey: json['unitKey'] as String,
    unitLabel: json['unitLabel'] as String,
    durationSeconds: json['durationSeconds'] as int?,
    timeMinutes: json['timeMinutes'] as int?,
    dayOffset: json['dayOffset'] as int,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  final String id;
  final String valueType;
  final double? numberValue;
  final double? normalizedNumberValue;
  final String unitKey;
  final String unitLabel;
  final int? durationSeconds;
  final int? timeMinutes;
  final int dayOffset;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'valueType': valueType,
    'numberValue': numberValue,
    'normalizedNumberValue': normalizedNumberValue,
    'unitKey': unitKey,
    'unitLabel': unitLabel,
    'durationSeconds': durationSeconds,
    'timeMinutes': timeMinutes,
    'dayOffset': dayOffset,
    'createdAt': createdAt.toIso8601String(),
  };

  TaskEntryValuesCompanion toCompanion(String entryId, DateTime updatedAt) =>
      TaskEntryValuesCompanion.insert(
        id: id,
        entryId: entryId,
        valueType: valueType,
        numberValue: Value(numberValue),
        normalizedNumberValue: Value(normalizedNumberValue),
        unitKey: Value(unitKey),
        unitLabel: Value(unitLabel),
        durationSeconds: Value(durationSeconds),
        timeMinutes: Value(timeMinutes),
        dayOffset: Value(dayOffset),
        createdAt: Value(createdAt),
        updatedAt: updatedAt,
      );
}

TaskEntriesCompanion _entryCompanion(TaskEntry entry) => TaskEntriesCompanion(
  status: Value(entry.status),
  updatedAt: Value(entry.updatedAt),
  respondedAt: Value(entry.respondedAt),
  finalizedAt: Value(entry.finalizedAt),
  effectiveAt: Value(entry.effectiveAt),
  performedOn: Value(entry.performedOn),
  performedOnSource: Value(entry.performedOnSource),
  resolutionOrigin: Value(entry.resolutionOrigin),
  appliedMissedPolicy: Value(entry.appliedMissedPolicy),
  appliedMissedConsequence: Value(entry.appliedMissedConsequence),
  checkboxValue: Value(entry.checkboxValue),
  numberValue: Value(entry.numberValue),
  note: Value(entry.note),
  revision: Value(entry.revision),
  planningOrigin: Value(entry.planningOrigin),
);

bool _sameEntryState(TaskEntry first, TaskEntry second) =>
    first.status == second.status &&
    first.checkboxValue == second.checkboxValue &&
    first.note == second.note &&
    first.performedOn == second.performedOn &&
    first.planningOrigin == second.planningOrigin;

bool _sameValueState(TaskEntryValue first, TaskEntryValue second) =>
    first.valueType == second.valueType &&
    first.numberValue == second.numberValue &&
    first.normalizedNumberValue == second.normalizedNumberValue &&
    first.unitKey == second.unitKey &&
    first.unitLabel == second.unitLabel &&
    first.durationSeconds == second.durationSeconds &&
    first.timeMinutes == second.timeMinutes &&
    first.dayOffset == second.dayOffset;

DateTime? _decodeDate(Object? value) =>
    value == null ? null : DateTime.parse(value as String);

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

DateTime _nextLocalDay(DateTime date) =>
    DateTime(date.year, date.month, date.day + 1);
