import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:uuid/uuid.dart';
import 'task_definition_version_writer.dart';
import 'habit_recurrence.dart';

enum TaskTypeChangeScope {
  newEntries,
  allHistory;

  String get key => this == newEntries ? 'new_entries' : 'all_history';
}

class TaskTypeChangePreview {
  const TaskTypeChangePreview({
    required this.task,
    required this.token,
    required this.entryCount,
    required this.hasTodayEntry,
    required this.newEntriesReason,
    required this.allHistoryReason,
  });
  final Aufgabe task;
  final String token;
  final int entryCount;
  final bool hasTodayEntry;
  final String? newEntriesReason, allHistoryReason;
  String get targetType => task.taskType == 'task' ? 'habit' : 'task';
  String? reason(TaskTypeChangeScope scope) =>
      scope == TaskTypeChangeScope.newEntries
          ? newEntriesReason
          : allHistoryReason;
}

/// Narrow transactional command: never calls the scheduler or applies pending edits.
class TaskTypeChangeService {
  TaskTypeChangeService(this.db, {DateTime Function()? now})
    : now = now ?? DateTime.now;
  final AppDatabase db;
  final DateTime Function() now;
  static bool knownRhythm(String value) =>
      {
        'daily',
        'weekly_fixed_days',
        'monthly_fixed_days',
        'weekly_after_completion',
      }.contains(value) ||
      (value.startsWith(HabitRecurrence.customAfterCompletionPrefix) &&
          (int.tryParse(
                    value.substring(
                      HabitRecurrence.customAfterCompletionPrefix.length,
                    ),
                  ) ??
                  0) >
              0);

  static bool validDays(String rhythm, String days) {
    if (rhythm != 'weekly_fixed_days' && rhythm != 'monthly_fixed_days') {
      return true;
    }
    final parsed = days.split(',').map(int.tryParse);
    final limit = rhythm == 'weekly_fixed_days' ? 7 : 32;
    return parsed.isNotEmpty &&
        parsed.every((d) => d != null && d >= 1 && d <= limit);
  }

  Future<TaskTypeChangePreview> preview(String taskId) =>
      db.transaction(() async {
        final state = await _load(taskId);
        return _preview(state);
      });

  TaskTypeChangePreview _preview(_TypeState state) {
    final task = state.task;
    final today = _day(now());
    String? reason;
    if (!task.isActive ||
        task.trashedAt != null ||
        (task.endDate != null && _day(task.endDate!).isBefore(today)) ||
        state.interruptions.any(
          (p) =>
              !today.isBefore(DateTime.parse(p.fromDay)) &&
              (p.untilDayExclusive == null ||
                  today.isBefore(DateTime.parse(p.untilDayExclusive!))),
        )) {
      reason =
          'Pausiert, beendet oder im Papierkorb. Erst regulär fortsetzen oder wiederherstellen.';
    } else if (task.recurrence == 'none') {
      reason =
          'Einmalige Aufgaben können nicht umgewandelt werden. Lege einen neuen Habit an.';
    } else if (!knownRhythm(task.recurrence) ||
        !validDays(task.recurrence, task.activeWeekdays) ||
        !{'task', 'habit'}.contains(task.taskType) ||
        !{'checkbox', 'three_state', 'value'}.contains(task.erfassungsmodus)) {
      reason =
          'Unbekannte Konfiguration: Die Art kann nicht sicher geändert werden.';
    } else if (state.pending.any((p) => p.state == 'pending') ||
        state.assignments.any((p) => p.state == 'pending')) {
      reason =
          'Es gibt vorgemerkte Änderungen. Zuerst regulär anwenden lassen oder bewusst abbrechen.';
    } else if (state.bundles.any(
      (b) =>
          b.cancelledAt == null &&
          (b.validTo == null || _day(b.validTo!).isAfter(today)),
    )) {
      reason =
          'Die Aufgabe ist mit einem Bündel verknüpft. Zuerst über die Bündelverwaltung lösen.';
    } else if (state.entries.any(
      (e) =>
          (e.status == 'pending' && _day(e.scheduledDate) != today) ||
          (e.status == 'no_entry' &&
              task.recurrence.contains('after_completion')),
    )) {
      reason =
          'Offene Rückstände oder Zukunftseinträge zuerst über die regulären Wege klären.';
    } else if (state.versions.isEmpty ||
        state.entries.any((e) => _entryVersion(state, e) == null)) {
      reason =
          'Die historische Versionszuordnung ist nicht eindeutig. Änderung abgelehnt; bitte Daten prüfen.';
    }
    var historicalReason = reason;
    if (historicalReason == null &&
        state.bundles.any((b) => b.cancelledAt == null)) {
      historicalReason =
          'Frühere Bündelverknüpfung: Nur neue Einträge können umgeordnet werden. Erneutes Auflösen ändert die alte Paarung nicht.';
    }
    if (historicalReason == null &&
        state.versions.any(
          (v) =>
              !knownRhythm(v.recurrence) ||
              !validDays(v.recurrence, v.activeWeekdays),
        )) {
      historicalReason =
          'Frühere Planung kann nicht sicher umgeordnet werden. Wechsel nur für neue Einträge möglich.';
    }
    return TaskTypeChangePreview(
      task: task,
      token: state.token(today),
      entryCount: state.entries.length,
      hasTodayEntry: state.entries.any((e) => _day(e.scheduledDate) == today),
      newEntriesReason: reason,
      allHistoryReason: historicalReason,
    );
  }

  TaskDefinitionVersion? _entryVersion(_TypeState state, TaskEntry entry) {
    if (entry.taskDefinitionVersionId != null) {
      return state.versions
          .where((v) => v.id == entry.taskDefinitionVersionId)
          .firstOrNull;
    }
    final nextDay = DateTime(
      entry.scheduledDate.year,
      entry.scheduledDate.month,
      entry.scheduledDate.day + 1,
    );
    final valid =
        state.versions
            .where(
              (v) => v.supersededAt == null && v.validFrom.isBefore(nextDay),
            )
            .toList();
    if (valid.isNotEmpty) return valid.last;
    if (state.task.erfassungsmodus == 'value' &&
        state.task.valueCommitment == 'pure_tracking') {
      return state.versions.where((v) => v.supersededAt == null).firstOrNull;
    }
    return null;
  }

  Future<void> change({
    required String taskId,
    required String targetType,
    required TaskTypeChangeScope scope,
    required String expectedRevision,
  }) => db.transaction(() async {
    if (!{'task', 'habit'}.contains(targetType)) {
      throw ArgumentError('Unbekannte Zielart.');
    }
    final state = await _load(taskId);
    if (state.task.taskType == targetType) return;
    final preview = _preview(state);
    if (preview.token != expectedRevision) {
      throw StateError('Daten wurden inzwischen geändert. Bitte neu laden.');
    }
    final reason = preview.reason(scope);
    if (reason != null) throw StateError(reason);
    for (final entry in state.entries.where(
      (e) => e.taskDefinitionVersionId == null,
    )) {
      await (db.update(db.taskEntries)
        ..where((e) => e.id.equals(entry.id))).write(
        TaskEntriesCompanion(
          taskDefinitionVersionId: Value(_entryVersion(state, entry)!.id),
        ),
      );
    }
    final previous = <Map<String, String>>[];
    if (scope == TaskTypeChangeScope.allHistory) {
      for (final version in state.versions) {
        previous.add({'versionId': version.id, 'taskType': version.taskType});
      }
      await (db.update(db.taskDefinitionVersions)..where(
        (v) => v.taskId.equals(taskId),
      )).write(TaskDefinitionVersionsCompanion(taskType: Value(targetType)));
    }
    final instant = now().toUtc();
    final updated = state.task.copyWith(
      taskType: targetType,
      updatedAt: Value(instant),
    );
    await (db.update(db.aufgaben)..where((t) => t.id.equals(taskId))).write(
      AufgabenCompanion(taskType: Value(targetType), updatedAt: Value(instant)),
    );
    final version = await TaskDefinitionVersionWriter(
      db,
    ).createVersion(updated, validFrom: instant, createdAt: instant);
    await db
        .into(db.taskTypeChanges)
        .insert(
          TaskTypeChangesCompanion.insert(
            id: const Uuid().v4(),
            taskId: taskId,
            sequence:
                state.changes.fold<int>(
                  0,
                  (s, c) => c.sequence > s ? c.sequence : s,
                ) +
                1,
            changedAt: instant,
            previousType: state.task.taskType,
            targetType: targetType,
            scope: scope.key,
            definitionVersionId: version,
            previousTypesJson: Value(jsonEncode(previous)),
          ),
        );
  });

  Future<_TypeState> _load(String id) async => _TypeState(
    await (db.select(db.aufgaben)..where((t) => t.id.equals(id))).getSingle(),
    await (db.select(db.taskDefinitionVersions)
          ..where((v) => v.taskId.equals(id))
          ..orderBy([
            (v) => OrderingTerm.asc(v.validFrom),
            (v) => OrderingTerm.asc(v.versionNumber),
          ]))
        .get(),
    await (db.select(db.taskEntries)
          ..where((e) => e.taskId.equals(id))
          ..orderBy([(e) => OrderingTerm.asc(e.id)]))
        .get(),
    await (db.select(db.taskPendingDefinitionChanges)
          ..where((p) => p.taskId.equals(id))
          ..orderBy([(p) => OrderingTerm.asc(p.id)]))
        .get(),
    await (db.select(db.taskProjectAssignmentChanges)
          ..where((p) => p.taskId.equals(id))
          ..orderBy([(p) => OrderingTerm.asc(p.id)]))
        .get(),
    await (db.select(db.taskValueBundleVersions)
          ..where((b) => b.firstTaskId.equals(id) | b.secondTaskId.equals(id))
          ..orderBy([(b) => OrderingTerm.asc(b.id)]))
        .get(),
    await (db.select(db.taskPlanningInterruptions)
          ..where((p) => p.taskId.equals(id))
          ..orderBy([(p) => OrderingTerm.asc(p.id)]))
        .get(),
    await (db.select(db.taskTypeChanges)
          ..where((c) => c.taskId.equals(id))
          ..orderBy([(c) => OrderingTerm.asc(c.sequence)]))
        .get(),
  );
}

class _TypeState {
  _TypeState(
    this.task,
    this.versions,
    this.entries,
    this.pending,
    this.assignments,
    this.bundles,
    this.interruptions,
    this.changes,
  );
  final Aufgabe task;
  final List<TaskDefinitionVersion> versions;
  final List<TaskEntry> entries;
  final List<TaskPendingDefinitionChange> pending;
  final List<TaskProjectAssignmentChange> assignments;
  final List<TaskValueBundleVersion> bundles;
  final List<TaskPlanningInterruption> interruptions;
  final List<TaskTypeChange> changes;
  String token(DateTime today) =>
      sha256
          .convert(
            utf8.encode(
              jsonEncode([
                today.toIso8601String(),
                task.toJson(),
                versions.map((v) => v.toJson()).toList(),
                entries.map((v) => v.toJson()).toList(),
                pending.map((v) => v.toJson()).toList(),
                assignments.map((v) => v.toJson()).toList(),
                bundles.map((v) => v.toJson()).toList(),
                interruptions.map((v) => v.toJson()).toList(),
                changes.map((v) => v.toJson()).toList(),
              ]),
            ),
          )
          .toString();
}

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);
