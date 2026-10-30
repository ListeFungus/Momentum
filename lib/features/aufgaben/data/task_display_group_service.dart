import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:momentum/core/database/app_database.dart';
import 'aufgaben_repository.dart';
import 'task_display_group_store.dart';
import 'task_for_date.dart';
import 'task_value_draft.dart';

String groupOccurrenceKey(TaskForDate t, DateTime date) =>
    '${t.task.id}:${(t.entry?.scheduledDate ?? date).toIso8601String()}';
bool groupOccurrenceComplete(TaskForDate t) {
  if (!t.isAnswered) return false;
  if (t.task.erfassungsmodus == 'value') {
    final v = t.entryValue;
    if (v == null || v.valueType != t.task.valueType) return false;
    return switch (v.valueType) {
      'number' => v.numberValue != null && v.numberValue!.isFinite,
      'duration' => v.durationSeconds != null && v.durationSeconds! >= 0,
      'time_of_day' =>
        v.timeMinutes != null && v.timeMinutes! >= 0 && v.timeMinutes! < 1440,
      _ => false,
    };
  }
  if (t.task.erfassungsmodus == 'three_state' ||
      (t.task.erfassungsmodus == 'checkbox' && t.task.taskType == 'habit')) {
    return t.booleanValue != null;
  }
  return t.task.erfassungsmodus == 'checkbox' &&
      t.isCompleted &&
      t.booleanValue == true;
}

class DisplayGroupDay {
  const DisplayGroupDay(this.group, this.members, this.items, this.date);
  final TaskDisplayGroup group;
  final List<TaskDisplayGroupMember> members;
  final List<TaskForDate> items;
  final DateTime date;
  int get completed => items.where(groupOccurrenceComplete).length;
  bool get complete => items.isNotEmpty && completed == items.length;
}

class GroupActionPreview {
  const GroupActionPreview(
    this.day,
    this.token,
    this.errors,
    this.checkableKeys,
    this.values,
  );
  final DisplayGroupDay day;
  final String token;
  final Map<String, String> errors;
  final Set<String> checkableKeys;
  final Map<String, ParsedTaskValue> values;
}

class GroupActionBlocked implements Exception {
  const GroupActionBlocked(this.errors);
  final Map<String, String> errors;
  @override
  String toString() => errors.values.toSet().join('\n');
}

class TaskDisplayGroupService {
  TaskDisplayGroupService(this.db, this.repo, {DateTime Function()? now})
    : now = now ?? DateTime.now;
  final AppDatabase db;
  final AufgabenRepository repo;
  final DateTime Function() now;
  TaskDisplayGroupStore get store => TaskDisplayGroupStore(db);
  Future<List<Aufgabe>> choices() =>
      (db.select(db.aufgaben)
            ..where((t) => t.trashedAt.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .get();
  Stream<List<DisplayGroupDay>> watchDay(DateTime date) async* {
    if (_day(date).isAfter(_day(now()))) {
      throw StateError('Zukunft bitte im Kalender planen.');
    }
    await repo.ensureTaskInstancesUpToDate(date: date);
    yield* db
        .customSelect('SELECT 1', readsFrom: db.allTables.toSet())
        .watch()
        .asyncMap((_) => readDay(date));
  }

  Future<List<DisplayGroupDay>> readDay(DateTime date) async {
    final groups =
        await (db.select(db.taskDisplayGroups)..orderBy([
          (g) => OrderingTerm.asc(g.sortOrder),
          (g) => OrderingTerm.asc(g.id),
        ])).get();
    final members =
        await (db.select(db.taskDisplayGroupMembers)..orderBy([
          (m) => OrderingTerm.asc(m.sortOrder),
          (m) => OrderingTerm.asc(m.taskId),
        ])).get();
    final tasks = await repo.readDisplayGroupDay(_day(date));
    return [
      for (final group in groups)
        DisplayGroupDay(
          group,
          members.where((m) => m.groupId == group.id).toList(),
          [
            for (final m in members.where((m) => m.groupId == group.id))
              ...tasks.where((t) => t.task.id == m.taskId),
          ],
          _day(date),
        ),
    ];
  }

  Future<String> _token(DateTime date) async {
    final data = <Object?>[
      _day(now()).toIso8601String(),
      date.toIso8601String(),
    ];
    // Covers revisions, membership, effective definitions, pending rules and
    // lifecycle data; conservative invalidation is preferable to stale writes.
    for (final table in db.allTables) {
      data.add(
        (await db
                .customSelect(
                  'SELECT * FROM "${table.actualTableName}" ORDER BY rowid',
                )
                .get())
            .map((r) => r.data)
            .toList(),
      );
    }
    return sha256.convert(utf8.encode(jsonEncode(data))).toString();
  }

  Future<GroupActionPreview> preview(
    String groupId,
    DateTime date, {
    Map<String, TaskValueDraft> drafts = const {},
  }) => db.transaction(() => _preview(groupId, _day(date), drafts));
  Future<GroupActionPreview> _preview(
    String id,
    DateTime date,
    Map<String, TaskValueDraft> drafts,
  ) async {
    final day =
        (await readDay(date)).where((g) => g.group.id == id).firstOrNull;
    if (day == null) {
      throw StateError('Gruppe wurde geändert. Bitte neu laden.');
    }
    final errors = <String, String>{};
    final checkable = <String>{};
    final values = <String, ParsedTaskValue>{};
    if (day.items.isEmpty) errors['group'] = 'Keine anstehenden Einträge.';
    if (date != _day(now())) {
      errors['group'] =
          'Ältere Einträge bitte einzeln bearbeiten. Zukunft bitte im Kalender planen.';
    }
    for (final item in day.items) {
      final key = groupOccurrenceKey(item, date);
      final entryDay = _day(item.entry?.scheduledDate ?? date);
      final draft = drafts[key];
      if (groupOccurrenceComplete(item) && draft == null) continue;
      if (entryDay != _day(now()) || date != _day(now())) {
        errors[key] = 'Ältere Einträge bitte einzeln bearbeiten.';
        continue;
      }
      final current = await repo.currentTask(item.task.id);
      final interruptions =
          await (db.select(db.taskPlanningInterruptions)
            ..where((p) => p.taskId.equals(current.id))).get();
      if (!current.isActive ||
          current.trashedAt != null ||
          (current.endDate != null &&
              _day(current.endDate!).isBefore(_day(now()))) ||
          interruptions.any(
            (p) =>
                !entryDay.isBefore(DateTime.parse(p.fromDay)) &&
                (p.untilDayExclusive == null ||
                    entryDay.isBefore(DateTime.parse(p.untilDayExclusive!))),
          )) {
        errors[key] =
            'Pausierte, beendete oder gelöschte Einträge zuerst regulär fortsetzen.';
        continue;
      }
      await store.ensureNotBundled(current.id);
      if (item.task.erfassungsmodus == 'value') {
        if (draft == null) {
          errors[key] = 'Bitte einen gültigen Wert eingeben und speichern.';
          continue;
        }
        try {
          values[key] = draft.parse(item.task);
        } on FormatException catch (e) {
          errors[key] = e.message;
        }
      } else if ({
        'checkbox',
        'three_state',
      }.contains(item.task.erfassungsmodus)) {
        // Never replace an explicit answer, including a deliberate No.
        if (item.booleanValue == null ||
            (item.task.erfassungsmodus == 'checkbox' &&
                item.task.taskType != 'habit' &&
                item.entry?.status == 'pending')) {
          checkable.add(key);
        } else {
          errors[key] = 'Eintrag bitte einzeln bearbeiten.';
        }
      } else {
        errors[key] = 'Unbekannter Erfassungsmodus. Bitte einzeln prüfen.';
      }
    }
    for (final key in drafts.keys) {
      if (!day.items.any((t) => groupOccurrenceKey(t, date) == key)) {
        errors[key] = 'Einträge haben sich geändert. Bitte erneut prüfen.';
      }
    }
    return GroupActionPreview(
      day,
      await _token(date),
      errors,
      checkable,
      values,
    );
  }

  Future<void> complete(
    GroupActionPreview expected, {
    Map<String, TaskValueDraft> drafts = const {},
    bool checkableOnly = false,
  }) => db.transaction(() async {
    final fresh = await _preview(
      expected.day.group.id,
      expected.day.date,
      drafts,
    );
    if (fresh.token != expected.token) {
      throw StateError('Einträge haben sich geändert. Bitte erneut prüfen.');
    }
    if (!checkableOnly && fresh.errors.isNotEmpty) {
      throw GroupActionBlocked(fresh.errors);
    }
    if (checkableOnly &&
        (fresh.day.date != _day(now()) || fresh.checkableKeys.isEmpty)) {
      throw const GroupActionBlocked({
        'group': 'Keine zulässigen abhakbaren Einträge.',
      });
    }
    for (final item in fresh.day.items) {
      final key = groupOccurrenceKey(item, fresh.day.date);
      final date = item.entry?.scheduledDate ?? fresh.day.date;
      if (fresh.checkableKeys.contains(key)) {
        if (item.task.erfassungsmodus == 'checkbox' &&
            item.task.taskType != 'habit') {
          await repo.setTaskCompleted(
            taskId: item.task.id,
            scheduledDate: date,
            isCompleted: true,
            performedOn: _day(now()),
          );
        } else {
          await repo.setBooleanHabitValue(
            task: item.task,
            scheduledDate: date,
            value: item.task.successValue,
            performedOn: _day(now()),
          );
        }
      } else if (!checkableOnly && fresh.values.containsKey(key)) {
        final v = fresh.values[key]!;
        await repo.setTaskEntryValue(
          task: item.task,
          scheduledDate: date,
          valueType: item.task.valueType,
          numberValue: v.numberValue,
          durationSeconds: v.durationSeconds,
          timeMinutes: v.timeMinutes,
          dayOffset: v.dayOffset,
          performedOn: _day(now()),
        );
      }
    }
  });
}

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);
