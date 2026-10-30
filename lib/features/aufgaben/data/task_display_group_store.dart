import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:momentum/core/database/app_database.dart';

/// Current display ownership, never part of a task's historical definition.
class TaskDisplayGroupStore {
  TaskDisplayGroupStore(this.db);
  final AppDatabase db;
  Stream<List<TaskDisplayGroup>> watch() =>
      (db.select(db.taskDisplayGroups)..orderBy([
        (g) => OrderingTerm.asc(g.sortOrder),
        (g) => OrderingTerm.asc(g.id),
      ])).watch();
  Stream<List<TaskDisplayGroupMember>> watchMembers() =>
      db.select(db.taskDisplayGroupMembers).watch();
  Future<void> ensureNotBundled(String taskId) async {
    final rows =
        await (db.select(db.taskValueBundleVersions)..where(
          (v) =>
              (v.firstTaskId.equals(taskId) | v.secondTaskId.equals(taskId)) &
              v.cancelledAt.isNull(),
        )).get();
    if (rows.isNotEmpty) {
      throw StateError(
        'Bündelgebundene Einträge können derzeit keiner Gruppe zugeordnet werden.',
      );
    }
  }

  static Future<void> ensureBundleSourcesFree(
    AppDatabase db,
    Iterable<String> ids,
  ) async {
    final rows =
        await (db.select(db.taskDisplayGroupMembers)
          ..where((m) => m.taskId.isIn(ids))).get();
    if (rows.isNotEmpty) {
      throw StateError('Entferne den Eintrag zuerst aus seiner Gruppe.');
    }
  }

  Future<String> create(String name) => db.transaction(() async {
    _name(name);
    final rows = await db.select(db.taskDisplayGroups).get();
    final order =
        rows.fold<int>(-1, (n, g) => g.sortOrder > n ? g.sortOrder : n) + 1;
    final id = const Uuid().v4();
    await db
        .into(db.taskDisplayGroups)
        .insert(
          TaskDisplayGroupsCompanion.insert(
            id: id,
            name: name.trim(),
            sortOrder: order,
          ),
        );
    return id;
  });
  Future<void> update(String id, {String? name, bool? collapsed}) =>
      db.transaction(() async {
        if (name != null) _name(name);
        final g =
            await (db.select(db.taskDisplayGroups)
              ..where((g) => g.id.equals(id))).getSingle();
        await (db.update(db.taskDisplayGroups)
          ..where((g) => g.id.equals(id))).write(
          TaskDisplayGroupsCompanion(
            name: name == null ? const Value.absent() : Value(name.trim()),
            isCollapsed:
                collapsed == null ? const Value.absent() : Value(collapsed),
            revision: Value(g.revision + 1),
            updatedAt: Value(DateTime.now()),
          ),
        );
      });
  Future<void> assign(
    String taskId,
    String groupId, {
    String? expectedPreviousGroup,
  }) => db.transaction(() async {
    await ensureNotBundled(taskId);
    final previous =
        await (db.select(db.taskDisplayGroupMembers)
          ..where((m) => m.taskId.equals(taskId))).getSingleOrNull();
    if (previous?.groupId == groupId) return;
    if (previous?.groupId != expectedPreviousGroup) {
      throw StateError(
        'Zuordnung geändert. Bitte erneut prüfen und Verschieben bestätigen.',
      );
    }
    final members =
        await (db.select(db.taskDisplayGroupMembers)
          ..where((m) => m.groupId.equals(groupId))).get();
    final order =
        members.fold<int>(-1, (n, m) => m.sortOrder > n ? m.sortOrder : n) + 1;
    await db
        .into(db.taskDisplayGroupMembers)
        .insertOnConflictUpdate(
          TaskDisplayGroupMembersCompanion.insert(
            taskId: taskId,
            groupId: groupId,
            sortOrder: order,
          ),
        );
  });
  Future<void> remove(String taskId, String groupId) =>
      (db.delete(db.taskDisplayGroupMembers)..where(
        (m) => m.taskId.equals(taskId) & m.groupId.equals(groupId),
      )).go();
  Future<void> delete(String id) =>
      (db.delete(db.taskDisplayGroups)..where((g) => g.id.equals(id))).go();
  Future<void> reorder(List<String> ids, {String? groupId}) =>
      db.transaction(() async {
        final actual =
            groupId == null
                ? (await db.select(db.taskDisplayGroups).get())
                    .map((g) => g.id)
                    .toSet()
                : (await (db.select(db.taskDisplayGroupMembers)
                      ..where((m) => m.groupId.equals(groupId))).get())
                    .map((m) => m.taskId)
                    .toSet();
        if (ids.length != actual.length ||
            ids.toSet().length != ids.length ||
            !actual.containsAll(ids)) {
          throw StateError('Liste geändert. Bitte neu laden.');
        }
        for (var i = 0; i < ids.length; i++) {
          if (groupId == null) {
            await (db.update(db.taskDisplayGroups)..where(
              (g) => g.id.equals(ids[i]),
            )).write(TaskDisplayGroupsCompanion(sortOrder: Value(i)));
          } else {
            await (db.update(db.taskDisplayGroupMembers)..where(
              (m) => m.taskId.equals(ids[i]),
            )).write(TaskDisplayGroupMembersCompanion(sortOrder: Value(i)));
          }
        }
      });
  void _name(String name) {
    if (name.trim().isEmpty) {
      throw ArgumentError('Bitte einen Gruppennamen eingeben.');
    }
  }
}
