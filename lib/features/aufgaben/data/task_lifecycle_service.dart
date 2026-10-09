import 'package:drift/drift.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/task_lifecycle_tables.dart';
import 'package:uuid/uuid.dart';

class TaskLifecycleException implements Exception {
  const TaskLifecycleException(this.message);

  final String message;

  @override
  String toString() => message;
}

class TaskDeletionPreview {
  const TaskDeletionPreview({
    required this.entityType,
    required this.entityId,
    required this.name,
    required this.purgeAt,
    required this.lifecycleRevision,
    required this.affectedBundleIds,
    required this.affectedBundleNames,
  });

  final String entityType;
  final String entityId;
  final String name;
  final DateTime purgeAt;
  final int lifecycleRevision;
  final List<String> affectedBundleIds;
  final List<String> affectedBundleNames;
}

class TrashContentsPreview {
  const TrashContentsPreview({required this.tasks, required this.bundles});

  final List<TaskDeletionPreview> tasks;
  final List<TaskDeletionPreview> bundles;

  bool get isEmpty => tasks.isEmpty && bundles.isEmpty;
}

class TaskValueBundleLifecycleItem {
  const TaskValueBundleLifecycleItem({
    required this.bundle,
    required this.version,
    required this.unavailableReason,
  });

  final TaskValueBundle bundle;
  final TaskValueBundleVersion version;
  final String? unavailableReason;
}

class TaskLifecycleService {
  TaskLifecycleService(this._database, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  static const retention = Duration(days: 7);

  final AppDatabase _database;
  final DateTime Function() _now;
  final Uuid _uuid = const Uuid();

  Future<bool> isTaskTrashed(String taskId) async {
    final task = await _task(taskId);
    return task.trashedAt != null;
  }

  Future<void> ensureTaskWritable(String taskId) async {
    if (await isTaskTrashed(taskId)) {
      throw const TaskLifecycleException(
        'Diese Aufgabe befindet sich im Papierkorb und kann nicht bearbeitet werden.',
      );
    }
  }

  Future<bool> isTaskPaused(String taskId) async =>
      await _openInterruption(taskId, TaskPlanningInterruptionReason.pause) !=
      null;

  Future<bool> isTaskExcludedOnDay(String taskId, DateTime day) async {
    final key = dayKey(day);
    final interruptions =
        await (_database.select(_database.taskPlanningInterruptions)
          ..where((item) => item.taskId.equals(taskId))).get();
    return interruptions.any(
      (item) =>
          item.fromDay.compareTo(key) <= 0 &&
          (item.untilDayExclusive == null ||
              key.compareTo(item.untilDayExclusive!) < 0),
    );
  }

  Future<TaskDeletionPreview> previewTaskDeletion(String taskId) async {
    final task = await _task(taskId);
    final bundleIds = await _bundleIdsReferencingTask(taskId);
    final names = await _bundleNamesReferencingTask(taskId);
    final now = _now().toUtc();
    return TaskDeletionPreview(
      entityType: DeletableEntityType.task,
      entityId: task.id,
      name: task.name,
      purgeAt: task.purgeAt ?? now.add(retention),
      lifecycleRevision: task.lifecycleRevision,
      affectedBundleIds: bundleIds,
      affectedBundleNames: names,
    );
  }

  Future<TaskDeletionPreview> previewBundleDeletion(String bundleId) async {
    final bundle = await _bundle(bundleId);
    final version =
        await (_database.select(_database.taskValueBundleVersions)
              ..where((candidate) => candidate.bundleId.equals(bundleId))
              ..orderBy([
                (candidate) => OrderingTerm.desc(candidate.versionNumber),
              ])
              ..limit(1))
            .getSingleOrNull();
    final now = _now().toUtc();
    return TaskDeletionPreview(
      entityType: DeletableEntityType.bundle,
      entityId: bundle.id,
      name: version?.name ?? 'Bündel',
      purgeAt: bundle.purgeAt ?? now.add(retention),
      lifecycleRevision: bundle.lifecycleRevision,
      affectedBundleIds: const [],
      affectedBundleNames: const [],
    );
  }

  Future<TrashContentsPreview> previewEmptyTrash() async {
    final tasks =
        await (_database.select(_database.aufgaben)
          ..where((task) => task.trashedAt.isNotNull())).get();
    final bundles =
        await (_database.select(_database.taskValueBundles)
          ..where((bundle) => bundle.trashedAt.isNotNull())).get();
    return TrashContentsPreview(
      tasks: await Future.wait(
        tasks.map((task) => previewTaskDeletion(task.id)),
      ),
      bundles: await Future.wait(
        bundles.map((bundle) => previewBundleDeletion(bundle.id)),
      ),
    );
  }

  Future<void> emptyTrash(TrashContentsPreview preview) async {
    await _database.transaction(() async {
      final current = await previewEmptyTrash();
      if (!_sameDeletionScopes(current.tasks, preview.tasks) ||
          !_sameDeletionScopes(current.bundles, preview.bundles)) {
        throw const TaskLifecycleException(
          'Der Papierkorbinhalt hat sich geändert. Bitte prüfe die Vorschau erneut.',
        );
      }
      for (final task in current.tasks) {
        await purgeTask(task.entityId);
      }
      for (final bundle in current.bundles) {
        await purgeBundle(bundle.entityId);
      }
    });
  }

  Future<void> trashTask(TaskDeletionPreview preview) async {
    if (preview.entityType != DeletableEntityType.task) {
      throw const TaskLifecycleException('Ungültige Löschvorschau.');
    }
    await _database.transaction(() async {
      final task = await _task(preview.entityId);
      if (task.trashedAt != null) return;
      final currentBundleIds = await _bundleIdsReferencingTask(task.id);
      final currentNames = await _bundleNamesReferencingTask(task.id);
      if (task.lifecycleRevision != preview.lifecycleRevision ||
          !_sameStrings(currentBundleIds, preview.affectedBundleIds) ||
          !_sameStrings(currentNames, preview.affectedBundleNames)) {
        throw const TaskLifecycleException(
          'Der Löschumfang hat sich geändert. Bitte prüfe die Vorschau erneut.',
        );
      }
      final now = _now().toUtc();
      await (_database.update(_database.aufgaben)
        ..where((row) => row.id.equals(task.id))).write(
        AufgabenCompanion(
          trashedAt: Value(now),
          purgeAt: Value(now.add(retention)),
          lifecycleRevision: Value(task.lifecycleRevision + 1),
          lifecycleUpdatedAt: Value(now),
          updatedAt: Value(now),
        ),
      );
      await _openInterruptionIfNeeded(
        task.id,
        TaskPlanningInterruptionReason.trash,
        fromDay: nextDayKey(_now()),
      );
    });
  }

  Future<void> restoreTask(String taskId) async {
    await _database.transaction(() async {
      final task = await _task(taskId);
      if (task.trashedAt == null) return;
      final now = _now().toUtc();
      if (!now.isBefore(task.purgeAt!)) {
        throw const TaskLifecycleException(
          'Die Wiederherstellungsfrist ist abgelaufen.',
        );
      }
      await _closeInterruption(
        taskId,
        TaskPlanningInterruptionReason.trash,
        untilDayExclusive: dayKey(_now()),
      );
      await (_database.update(_database.aufgaben)
        ..where((row) => row.id.equals(taskId))).write(
        AufgabenCompanion(
          trashedAt: const Value(null),
          purgeAt: const Value(null),
          lifecycleRevision: Value(task.lifecycleRevision + 1),
          lifecycleUpdatedAt: Value(now),
          updatedAt: Value(now),
        ),
      );
    });
  }

  Future<void> pauseTask(String taskId) async {
    await _database.transaction(() async {
      final task = await _task(taskId);
      if (task.trashedAt != null) {
        throw const TaskLifecycleException(
          'Eine Aufgabe im Papierkorb kann nicht pausiert werden.',
        );
      }
      if (await isTaskPaused(taskId)) return;
      await _openInterruptionIfNeeded(
        taskId,
        TaskPlanningInterruptionReason.pause,
        fromDay: nextDayKey(_now()),
      );
      await _touchTask(task);
    });
  }

  Future<void> resumeTask(String taskId) async {
    await _database.transaction(() async {
      final task = await _task(taskId);
      if (task.trashedAt != null) {
        throw const TaskLifecycleException(
          'Stelle die Aufgabe zuerst aus dem Papierkorb wieder her.',
        );
      }
      final open = await _openInterruption(
        taskId,
        TaskPlanningInterruptionReason.pause,
      );
      if (open == null) return;
      await _closeInterruption(
        taskId,
        TaskPlanningInterruptionReason.pause,
        untilDayExclusive: dayKey(_now()),
      );
      await _touchTask(task);
    });
  }

  Future<void> trashBundle(TaskDeletionPreview preview) async {
    if (preview.entityType != DeletableEntityType.bundle) {
      throw const TaskLifecycleException('Ungültige Löschvorschau.');
    }
    await _database.transaction(() async {
      final bundle = await _bundle(preview.entityId);
      if (bundle.trashedAt != null) return;
      if (bundle.lifecycleRevision != preview.lifecycleRevision) {
        throw const TaskLifecycleException(
          'Das Bündel wurde geändert. Bitte prüfe die Vorschau erneut.',
        );
      }
      final now = _now().toUtc();
      await (_database.update(_database.taskValueBundles)
        ..where((row) => row.id.equals(bundle.id))).write(
        TaskValueBundlesCompanion(
          trashedAt: Value(now),
          purgeAt: Value(now.add(retention)),
          lifecycleRevision: Value(bundle.lifecycleRevision + 1),
          lifecycleUpdatedAt: Value(now),
          updatedAt: Value(now),
        ),
      );
    });
  }

  Future<void> restoreBundle(String bundleId) async {
    await _database.transaction(() async {
      final bundle = await _bundle(bundleId);
      if (bundle.trashedAt == null) return;
      final now = _now().toUtc();
      if (!now.isBefore(bundle.purgeAt!)) {
        throw const TaskLifecycleException(
          'Die Wiederherstellungsfrist ist abgelaufen.',
        );
      }
      await (_database.update(_database.taskValueBundles)
        ..where((row) => row.id.equals(bundleId))).write(
        TaskValueBundlesCompanion(
          trashedAt: const Value(null),
          purgeAt: const Value(null),
          lifecycleRevision: Value(bundle.lifecycleRevision + 1),
          lifecycleUpdatedAt: Value(now),
          updatedAt: Value(now),
        ),
      );
    });
  }

  Future<void> purgeTask(String taskId, {bool requireExpired = false}) async {
    await _database.transaction(() async {
      final task = await _task(taskId);
      if (task.trashedAt == null) {
        throw const TaskLifecycleException(
          'Nur Aufgaben im Papierkorb können endgültig gelöscht werden.',
        );
      }
      if (requireExpired && _now().toUtc().isBefore(task.purgeAt!)) return;
      await _database
          .into(_database.entityDeletionMarkers)
          .insert(
            EntityDeletionMarkersCompanion.insert(
              entityType: DeletableEntityType.task,
              entityId: taskId,
              deletedAt: _now().toUtc(),
            ),
            mode: InsertMode.insertOrIgnore,
          );
      await (_database.delete(_database.aufgaben)
        ..where((row) => row.id.equals(taskId))).go();
    });
  }

  Future<void> purgeBundle(
    String bundleId, {
    bool requireExpired = false,
  }) async {
    await _database.transaction(() async {
      final bundle = await _bundle(bundleId);
      if (bundle.trashedAt == null) {
        throw const TaskLifecycleException(
          'Nur Bündel im Papierkorb können endgültig gelöscht werden.',
        );
      }
      if (requireExpired && _now().toUtc().isBefore(bundle.purgeAt!)) return;
      await _database
          .into(_database.entityDeletionMarkers)
          .insert(
            EntityDeletionMarkersCompanion.insert(
              entityType: DeletableEntityType.bundle,
              entityId: bundleId,
              deletedAt: _now().toUtc(),
            ),
            mode: InsertMode.insertOrIgnore,
          );
      await (_database.delete(_database.taskValueBundles)
        ..where((row) => row.id.equals(bundleId))).go();
    });
  }

  Future<int> purgeExpired() async {
    final now = _now().toUtc();
    final tasks =
        await (_database.select(_database.aufgaben)
          ..where((task) => task.purgeAt.isSmallerOrEqualValue(now))).get();
    final bundles =
        await (_database.select(_database.taskValueBundles)
          ..where((bundle) => bundle.purgeAt.isSmallerOrEqualValue(now))).get();
    for (final task in tasks) {
      await purgeTask(task.id, requireExpired: true);
    }
    for (final bundle in bundles) {
      await purgeBundle(bundle.id, requireExpired: true);
    }
    return tasks.length + bundles.length;
  }

  Stream<List<Aufgabe>> watchTrashedTasks() =>
      (_database.select(_database.aufgaben)
            ..where((task) => task.trashedAt.isNotNull())
            ..orderBy([(task) => OrderingTerm.desc(task.trashedAt)]))
          .watch();

  Stream<List<Aufgabe>> watchPausedTasks() {
    final query = _database.select(_database.aufgaben).join([
      innerJoin(
        _database.taskPlanningInterruptions,
        _database.taskPlanningInterruptions.taskId.equalsExp(
          _database.aufgaben.id,
        ),
      ),
    ])..where(
      _database.aufgaben.trashedAt.isNull() &
          _database.taskPlanningInterruptions.reason.equals(
            TaskPlanningInterruptionReason.pause,
          ) &
          _database.taskPlanningInterruptions.untilDayExclusive.isNull(),
    );
    return query.watch().map(
      (rows) => rows.map((row) => row.readTable(_database.aufgaben)).toList(),
    );
  }

  Stream<List<TaskValueBundle>> watchTrashedBundles() =>
      (_database.select(_database.taskValueBundles)
            ..where((bundle) => bundle.trashedAt.isNotNull())
            ..orderBy([(bundle) => OrderingTerm.desc(bundle.trashedAt)]))
          .watch();

  Stream<List<TaskValueBundleLifecycleItem>> watchBundleLifecycleItems() {
    return _database
        .customSelect(
          'SELECT 1',
          readsFrom: {
            _database.taskValueBundles,
            _database.taskValueBundleVersions,
            _database.aufgaben,
            _database.entityDeletionMarkers,
          },
        )
        .watch()
        .asyncMap((_) async {
          final bundles =
              await _database.select(_database.taskValueBundles).get();
          final versions =
              await _database.select(_database.taskValueBundleVersions).get();
          final tasks = await _database.select(_database.aufgaben).get();
          final markers =
              await _database.select(_database.entityDeletionMarkers).get();
          final taskById = {for (final task in tasks) task.id: task};
          final deletedTaskIds =
              markers
                  .where(
                    (marker) => marker.entityType == DeletableEntityType.task,
                  )
                  .map((marker) => marker.entityId)
                  .toSet();
          final result = <TaskValueBundleLifecycleItem>[];
          for (final bundle in bundles) {
            final candidates =
                versions
                    .where((version) => version.bundleId == bundle.id)
                    .toList()
                  ..sort(
                    (first, second) =>
                        second.versionNumber.compareTo(first.versionNumber),
                  );
            if (candidates.isEmpty) continue;
            final version = candidates.first;
            final sourceIds = [version.firstTaskId, version.secondTaskId];
            final sourceTasks = sourceIds.map((id) => taskById[id]).toList();
            String? unavailableReason;
            if (sourceTasks.any((task) => task?.trashedAt != null)) {
              unavailableReason =
                  'Mindestens ein Teil-Tracking befindet sich im Papierkorb.';
            } else if (sourceTasks.any((task) => task == null)) {
              unavailableReason =
                  sourceIds.any(deletedTaskIds.contains)
                      ? 'Mindestens ein Teil-Tracking wurde endgültig gelöscht.'
                      : 'Mindestens ein Teil-Tracking ist unerwartet nicht verfügbar.';
            }
            result.add(
              TaskValueBundleLifecycleItem(
                bundle: bundle,
                version: version,
                unavailableReason: unavailableReason,
              ),
            );
          }
          result.sort(
            (first, second) =>
                first.version.name.compareTo(second.version.name),
          );
          return result;
        });
  }

  Future<Aufgabe> _task(String taskId) =>
      (_database.select(_database.aufgaben)
        ..where((task) => task.id.equals(taskId))).getSingle();

  Future<TaskValueBundle> _bundle(String bundleId) =>
      (_database.select(_database.taskValueBundles)
        ..where((bundle) => bundle.id.equals(bundleId))).getSingle();

  Future<List<String>> _bundleNamesReferencingTask(String taskId) async {
    final rows =
        await (_database.select(_database.taskValueBundleVersions)..where(
          (version) =>
              version.firstTaskId.equals(taskId) |
              version.secondTaskId.equals(taskId),
        )).get();
    return rows.map((row) => row.name).toSet().toList()..sort();
  }

  Future<List<String>> _bundleIdsReferencingTask(String taskId) async {
    final rows =
        await (_database.select(_database.taskValueBundleVersions)..where(
          (version) =>
              version.firstTaskId.equals(taskId) |
              version.secondTaskId.equals(taskId),
        )).get();
    return rows.map((row) => row.bundleId).toSet().toList()..sort();
  }

  Future<TaskPlanningInterruption?> _openInterruption(
    String taskId,
    String reason,
  ) =>
      (_database.select(_database.taskPlanningInterruptions)..where(
        (item) =>
            item.taskId.equals(taskId) &
            item.reason.equals(reason) &
            item.untilDayExclusive.isNull(),
      )).getSingleOrNull();

  Future<void> _openInterruptionIfNeeded(
    String taskId,
    String reason, {
    required String fromDay,
  }) async {
    if (await _openInterruption(taskId, reason) != null) return;
    final now = _now().toUtc();
    await _database
        .into(_database.taskPlanningInterruptions)
        .insert(
          TaskPlanningInterruptionsCompanion.insert(
            id: _uuid.v4(),
            taskId: taskId,
            reason: reason,
            fromDay: fromDay,
            updatedAt: Value(now),
          ),
        );
  }

  Future<void> _closeInterruption(
    String taskId,
    String reason, {
    required String untilDayExclusive,
  }) async {
    final open = await _openInterruption(taskId, reason);
    if (open == null) return;
    final end =
        untilDayExclusive.compareTo(open.fromDay) < 0
            ? open.fromDay
            : untilDayExclusive;
    await (_database.update(_database.taskPlanningInterruptions)
      ..where((item) => item.id.equals(open.id))).write(
      TaskPlanningInterruptionsCompanion(
        untilDayExclusive: Value(end),
        updatedAt: Value(_now().toUtc()),
        revision: Value(open.revision + 1),
      ),
    );
  }

  Future<void> _touchTask(Aufgabe task) {
    final now = _now().toUtc();
    return (_database.update(_database.aufgaben)
      ..where((row) => row.id.equals(task.id))).write(
      AufgabenCompanion(
        lifecycleRevision: Value(task.lifecycleRevision + 1),
        lifecycleUpdatedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }
}

String dayKey(DateTime value) {
  final local = value.toLocal();
  return '${local.year.toString().padLeft(4, '0')}-'
      '${local.month.toString().padLeft(2, '0')}-'
      '${local.day.toString().padLeft(2, '0')}';
}

String nextDayKey(DateTime value) {
  final local = value.toLocal();
  return dayKey(DateTime(local.year, local.month, local.day + 1));
}

bool _sameStrings(List<String> first, List<String> second) {
  if (first.length != second.length) return false;
  for (var index = 0; index < first.length; index++) {
    if (first[index] != second[index]) return false;
  }
  return true;
}

bool _sameDeletionScopes(
  List<TaskDeletionPreview> first,
  List<TaskDeletionPreview> second,
) {
  final firstRevisions = {
    for (final item in first) item.entityId: item.lifecycleRevision,
  };
  final secondRevisions = {
    for (final item in second) item.entityId: item.lifecycleRevision,
  };
  return firstRevisions.length == secondRevisions.length &&
      firstRevisions.entries.every(
        (entry) => secondRevisions[entry.key] == entry.value,
      );
}
