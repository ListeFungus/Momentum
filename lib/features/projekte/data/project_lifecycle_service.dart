import 'package:drift/drift.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/task_lifecycle_service.dart';
import 'package:momentum/features/aufgaben/data/task_definition_resolver.dart';
import 'package:momentum/features/aufgaben/data/task_instance_scheduler.dart';
import 'package:momentum/features/aufgaben/data/task_project_assignment_service.dart';
import 'package:momentum/features/projekte/data/project_deletion_tables.dart';
import 'package:uuid/uuid.dart';

enum ProjectDeletionChoice { projectOnly, projectAndContents }

class ProjectLifecycleException implements Exception {
  const ProjectLifecycleException(this.message);
  final String message;
  @override
  String toString() => message;
}

class ProjectDeletionPreview {
  const ProjectDeletionPreview({
    required this.project,
    required this.tasks,
    required this.bundles,
    required this.alreadyTrashedTaskIds,
    required this.alreadyTrashedBundleIds,
    required this.purgeAt,
  });

  final Project project;
  final List<Aufgabe> tasks;
  final List<ProjectBundleItem> bundles;
  final List<String> alreadyTrashedTaskIds;
  final List<String> alreadyTrashedBundleIds;
  final DateTime purgeAt;
}

class ProjectBundleItem {
  const ProjectBundleItem({required this.bundle, required this.name});
  final TaskValueBundle bundle;
  final String name;
}

class ProjectRestorePreview {
  const ProjectRestorePreview({
    required this.project,
    required this.restorableTaskIds,
    required this.restorableBundleIds,
    required this.skippedCount,
  });

  final Project project;
  final List<String> restorableTaskIds;
  final List<String> restorableBundleIds;
  final int skippedCount;
}

class ProjectLifecycleService {
  ProjectLifecycleService(this._database, {DateTime Function()? now})
    : _now = now ?? DateTime.now,
      _assignment = TaskProjectAssignmentService(_database, now: now),
      _taskLifecycle = TaskLifecycleService(_database, now: now),
      _definitionResolver = TaskDefinitionResolver(_database),
      _scheduler = TaskInstanceScheduler(_database, now: now);

  static const retention = Duration(days: 7);
  static const deletedProjectLabel = 'Gelöschtes Projekt';

  final AppDatabase _database;
  final DateTime Function() _now;
  final TaskProjectAssignmentService _assignment;
  final TaskLifecycleService _taskLifecycle;
  final TaskDefinitionResolver _definitionResolver;
  final TaskInstanceScheduler _scheduler;
  final Uuid _uuid = const Uuid();

  Future<void> archive(String projectId) async {
    final project = await _project(projectId);
    if (project.deletedAt != null || project.trashedAt != null) {
      throw const ProjectLifecycleException(
        'Nur ein verfügbares Projekt kann archiviert werden.',
      );
    }
    if (project.archivedAt != null) return;
    await _writeProjectState(
      project,
      ProjectsCompanion(archivedAt: Value(_now().toUtc())),
    );
  }

  Future<void> unarchive(String projectId) async {
    final project = await _project(projectId);
    if (project.deletedAt != null || project.trashedAt != null) {
      throw const ProjectLifecycleException(
        'Das Projekt kann nicht aus dem Archiv geholt werden.',
      );
    }
    if (project.archivedAt == null) return;
    await _writeProjectState(
      project,
      const ProjectsCompanion(archivedAt: Value(null)),
    );
  }

  Future<ProjectDeletionPreview> previewDeletion(String projectId) async {
    await _assignment.applyDueChanges(_now());
    final project = await _project(projectId);
    if (project.deletedAt != null) {
      throw const ProjectLifecycleException(
        'Das Projekt ist bereits gelöscht.',
      );
    }
    final tasks =
        await (_database.select(_database.aufgaben)
          ..where((row) => row.projectId.equals(projectId))).get();
    final bundles =
        await (_database.select(_database.taskValueBundles)
          ..where((row) => row.projectId.equals(projectId))).get();
    final names = <String, String>{};
    for (final bundle in bundles) {
      final version =
          await (_database.select(_database.taskValueBundleVersions)
                ..where((row) => row.bundleId.equals(bundle.id))
                ..orderBy([(row) => OrderingTerm.desc(row.versionNumber)])
                ..limit(1))
              .getSingleOrNull();
      names[bundle.id] = version?.name ?? 'Bündel';
    }
    final now = _now().toUtc();
    return ProjectDeletionPreview(
      project: project,
      tasks: tasks.where((task) => task.trashedAt == null).toList(),
      bundles:
          bundles
              .where((bundle) => bundle.trashedAt == null)
              .map(
                (bundle) =>
                    ProjectBundleItem(bundle: bundle, name: names[bundle.id]!),
              )
              .toList(),
      alreadyTrashedTaskIds:
          tasks
              .where((task) => task.trashedAt != null)
              .map((task) => task.id)
              .toList(),
      alreadyTrashedBundleIds:
          bundles
              .where((bundle) => bundle.trashedAt != null)
              .map((bundle) => bundle.id)
              .toList(),
      purgeAt: project.purgeAt ?? now.add(retention),
    );
  }

  Future<void> trash(
    ProjectDeletionPreview preview,
    ProjectDeletionChoice choice,
  ) async {
    await _database.transaction(() async {
      final current = await previewDeletion(preview.project.id);
      if (current.project.revision != preview.project.revision ||
          !_sameIds(
            current.tasks.map((item) => item.id),
            preview.tasks.map((item) => item.id),
          ) ||
          !_sameIds(
            current.bundles.map((item) => item.bundle.id),
            preview.bundles.map((item) => item.bundle.id),
          ) ||
          !_sameIds(
            current.alreadyTrashedTaskIds,
            preview.alreadyTrashedTaskIds,
          ) ||
          !_sameIds(
            current.alreadyTrashedBundleIds,
            preview.alreadyTrashedBundleIds,
          )) {
        throw const ProjectLifecycleException(
          'Der Löschumfang hat sich geändert. Bitte prüfe ihn erneut.',
        );
      }
      final now = _now().toUtc();
      final batchId = _uuid.v4();
      await _database
          .into(_database.projectDeletionBatches)
          .insert(
            ProjectDeletionBatchesCompanion.insert(
              id: batchId,
              projectId: current.project.id,
              mode:
                  choice == ProjectDeletionChoice.projectOnly
                      ? ProjectDeletionMode.projectOnly
                      : ProjectDeletionMode.projectAndContents,
              deletedAt: now,
              projectRevision: current.project.revision + 1,
            ),
          );

      final incoming =
          await (_database.select(_database.taskProjectAssignmentChanges)
            ..where(
              (row) =>
                  row.targetProjectId.equals(current.project.id) &
                  row.state.equals('pending'),
            )).get();
      for (final change in incoming) {
        if (change.taskId != null) {
          await _assignment.cancelIncomingToProject(
            ProjectAssignableRef.task(change.taskId!),
            current.project.id,
          );
        } else if (change.bundleId != null) {
          await _assignment.cancelIncomingToProject(
            ProjectAssignableRef.bundle(change.bundleId!),
            current.project.id,
          );
        }
      }

      for (final id in current.alreadyTrashedTaskIds) {
        await _assignment.detachForProjectDeletion(
          ProjectAssignableRef.task(id),
          current.project.id,
        );
      }
      for (final id in current.alreadyTrashedBundleIds) {
        await _assignment.detachForProjectDeletion(
          ProjectAssignableRef.bundle(id),
          current.project.id,
        );
      }

      if (choice == ProjectDeletionChoice.projectOnly) {
        for (final task in current.tasks) {
          await _assignment.detachForProjectDeletion(
            ProjectAssignableRef.task(task.id),
            current.project.id,
          );
        }
        for (final item in current.bundles) {
          await _assignment.detachForProjectDeletion(
            ProjectAssignableRef.bundle(item.bundle.id),
            current.project.id,
          );
        }
      } else {
        for (final task in current.tasks) {
          await _assignment.cancelIncomingToProject(
            ProjectAssignableRef.task(task.id),
            current.project.id,
          );
          await _taskLifecycle.trashTask(
            await _taskLifecycle.previewTaskDeletion(task.id),
          );
          final trashed =
              await (_database.select(_database.aufgaben)
                ..where((row) => row.id.equals(task.id))).getSingle();
          await _insertBatchItem(
            batchId,
            ProjectDeletionObjectType.task,
            trashed.id,
            trashed.lifecycleRevision,
            trashed.trashedAt!,
          );
        }
        for (final item in current.bundles) {
          await _assignment.cancelIncomingToProject(
            ProjectAssignableRef.bundle(item.bundle.id),
            current.project.id,
          );
          await _taskLifecycle.trashBundle(
            await _taskLifecycle.previewBundleDeletion(item.bundle.id),
          );
          final trashed =
              await (_database.select(_database.taskValueBundles)
                ..where((row) => row.id.equals(item.bundle.id))).getSingle();
          await _insertBatchItem(
            batchId,
            ProjectDeletionObjectType.bundle,
            trashed.id,
            trashed.lifecycleRevision,
            trashed.trashedAt!,
          );
        }
      }

      await (_database.update(_database.projects)
        ..where((row) => row.id.equals(current.project.id))).write(
        ProjectsCompanion(
          trashedAt: Value(now),
          purgeAt: Value(now.add(retention)),
          revision: Value(current.project.revision + 1),
          updatedAt: Value(now),
        ),
      );
    });
  }

  Future<ProjectRestorePreview> previewRestore(String projectId) async {
    final project = await _project(projectId);
    if (project.trashedAt == null || project.deletedAt != null) {
      throw const ProjectLifecycleException(
        'Dieses Projekt kann nicht wiederhergestellt werden.',
      );
    }
    final batch =
        await (_database.select(_database.projectDeletionBatches)
              ..where((row) => row.projectId.equals(projectId))
              ..orderBy([(row) => OrderingTerm.desc(row.deletedAt)])
              ..limit(1))
            .getSingleOrNull();
    if (batch == null || batch.mode == ProjectDeletionMode.projectOnly) {
      return ProjectRestorePreview(
        project: project,
        restorableTaskIds: const [],
        restorableBundleIds: const [],
        skippedCount: 0,
      );
    }
    final items =
        await (_database.select(_database.projectDeletionBatchItems)
          ..where((row) => row.batchId.equals(batch.id))).get();
    final tasks = <String>[];
    final bundles = <String>[];
    var skipped = 0;
    for (final item in items) {
      if (item.objectType == ProjectDeletionObjectType.task) {
        final task =
            await (_database.select(_database.aufgaben)
              ..where((row) => row.id.equals(item.objectId))).getSingleOrNull();
        if (task != null &&
            task.trashedAt == item.trashedAt &&
            task.lifecycleRevision == item.lifecycleRevision &&
            _now().toUtc().isBefore(task.purgeAt!)) {
          tasks.add(task.id);
        } else {
          skipped++;
        }
      } else {
        final bundle =
            await (_database.select(_database.taskValueBundles)
              ..where((row) => row.id.equals(item.objectId))).getSingleOrNull();
        if (bundle != null &&
            bundle.trashedAt == item.trashedAt &&
            bundle.lifecycleRevision == item.lifecycleRevision &&
            _now().toUtc().isBefore(bundle.purgeAt!)) {
          bundles.add(bundle.id);
        } else {
          skipped++;
        }
      }
    }
    return ProjectRestorePreview(
      project: project,
      restorableTaskIds: tasks,
      restorableBundleIds: bundles,
      skippedCount: skipped,
    );
  }

  Future<void> restore(
    ProjectRestorePreview preview, {
    required bool includeContents,
  }) async {
    await _database.transaction(() async {
      final current = await previewRestore(preview.project.id);
      if (current.project.revision != preview.project.revision ||
          !_sameIds(current.restorableTaskIds, preview.restorableTaskIds) ||
          !_sameIds(current.restorableBundleIds, preview.restorableBundleIds)) {
        throw const ProjectLifecycleException(
          'Der Wiederherstellungsumfang hat sich geändert.',
        );
      }
      final project = current.project;
      if (!_now().toUtc().isBefore(project.purgeAt!)) {
        throw const ProjectLifecycleException(
          'Die Wiederherstellungsfrist ist abgelaufen.',
        );
      }
      await (_database.update(_database.projects)
        ..where((row) => row.id.equals(project.id))).write(
        ProjectsCompanion(
          trashedAt: const Value(null),
          purgeAt: const Value(null),
          revision: Value(project.revision + 1),
          updatedAt: Value(_now().toUtc()),
        ),
      );
      if (includeContents) {
        for (final id in current.restorableTaskIds) {
          await _taskLifecycle.restoreTask(id);
        }
        for (final id in current.restorableBundleIds) {
          await _taskLifecycle.restoreBundle(id);
        }
        await _assignment.applyDueChanges(_now());
        await _definitionResolver.applyDueChanges(_now());
        await _scheduler.ensureEntriesForDate(date: _now());
      }
      await (_database.delete(_database.projectDeletionBatches)
        ..where((row) => row.projectId.equals(project.id))).go();
    });
  }

  Future<int> purgeExpired() async {
    final due =
        await (_database.select(_database.projects)..where(
          (row) =>
              row.trashedAt.isNotNull() &
              row.purgeAt.isSmallerOrEqualValue(_now().toUtc()),
        )).get();
    for (final project in due) {
      await purge(project.id, requireExpired: true);
    }
    return due.length;
  }

  Future<void> purge(String projectId, {bool requireExpired = false}) async {
    await _database.transaction(() async {
      final project = await _project(projectId);
      if (project.trashedAt == null) {
        throw const ProjectLifecycleException(
          'Nur Projekte im Papierkorb können endgültig gelöscht werden.',
        );
      }
      if (requireExpired && _now().toUtc().isBefore(project.purgeAt!)) return;
      final tasks =
          await (_database.select(_database.aufgaben)
            ..where((row) => row.projectId.equals(projectId))).get();
      final bundles =
          await (_database.select(_database.taskValueBundles)
            ..where((row) => row.projectId.equals(projectId))).get();
      for (final task in tasks) {
        await _assignment.detachForProjectDeletion(
          ProjectAssignableRef.task(task.id),
          projectId,
        );
      }
      for (final bundle in bundles) {
        await _assignment.detachForProjectDeletion(
          ProjectAssignableRef.bundle(bundle.id),
          projectId,
        );
      }
      await (_database.delete(_database.projectDeletionBatches)
        ..where((row) => row.projectId.equals(projectId))).go();
      await (_database.update(_database.projects)
        ..where((row) => row.id.equals(projectId))).write(
        ProjectsCompanion(
          name: const Value(''),
          description: const Value(''),
          colorHex: const Value(''),
          sortOrder: const Value(0),
          archivedAt: const Value(null),
          trashedAt: const Value(null),
          purgeAt: const Value(null),
          deletedAt: Value(_now().toUtc()),
          revision: Value(project.revision + 1),
          updatedAt: Value(_now().toUtc()),
        ),
      );
    });
  }

  Future<Project> _project(String id) =>
      (_database.select(_database.projects)
        ..where((row) => row.id.equals(id))).getSingle();

  Future<void> _writeProjectState(Project project, ProjectsCompanion changes) =>
      (_database.update(_database.projects)
        ..where((row) => row.id.equals(project.id))).write(
        changes.copyWith(
          revision: Value(project.revision + 1),
          updatedAt: Value(_now().toUtc()),
        ),
      );

  Future<void> _insertBatchItem(
    String batchId,
    String type,
    String id,
    int revision,
    DateTime trashedAt,
  ) => _database
      .into(_database.projectDeletionBatchItems)
      .insert(
        ProjectDeletionBatchItemsCompanion.insert(
          batchId: batchId,
          objectType: type,
          objectId: id,
          lifecycleRevision: revision,
          trashedAt: trashedAt,
        ),
      );
}

bool _sameIds(Iterable<String> first, Iterable<String> second) {
  final a = first.toList()..sort();
  final b = second.toList()..sort();
  if (a.length != b.length) return false;
  for (var index = 0; index < a.length; index++) {
    if (a[index] != b[index]) return false;
  }
  return true;
}
