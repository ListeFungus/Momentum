import 'package:drift/drift.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/task_types.dart';
import 'package:momentum/features/aufgaben/data/task_entry_status.dart';
import 'package:momentum/features/aufgaben/data/task_project_assignment_service.dart';
import 'package:momentum/features/aufgaben/data/task_definition_resolver.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle_calculation.dart';
import 'package:momentum/features/projekte/data/project_lifecycle_service.dart';
import 'package:uuid/uuid.dart';

class ProjectRepository {
  ProjectRepository(this._database, {DateTime Function()? now})
    : _assignmentService = TaskProjectAssignmentService(_database, now: now),
      _definitionResolver = TaskDefinitionResolver(_database, now: now),
      _aufgabenRepository = AufgabenRepository(_database, now: now),
      _lifecycle = ProjectLifecycleService(_database, now: now),
      _now = now ?? DateTime.now;

  final AppDatabase _database;
  final TaskProjectAssignmentService _assignmentService;
  final TaskDefinitionResolver _definitionResolver;
  final AufgabenRepository _aufgabenRepository;
  final ProjectLifecycleService _lifecycle;
  final DateTime Function() _now;
  final Uuid _uuid = const Uuid();

  Stream<List<Project>> watchProjects() {
    final query =
        _database.select(_database.projects)
          ..where(
            (project) =>
                project.archivedAt.isNull() &
                project.trashedAt.isNull() &
                project.deletedAt.isNull(),
          )
          ..orderBy([
            (project) => OrderingTerm.asc(project.sortOrder),
            (project) => OrderingTerm.asc(project.name),
          ]);

    return query.watch();
  }

  Stream<List<Project>> watchArchivedProjects() {
    return (_database.select(_database.projects)
          ..where(
            (project) =>
                project.archivedAt.isNotNull() &
                project.trashedAt.isNull() &
                project.deletedAt.isNull(),
          )
          ..orderBy([(project) => OrderingTerm.asc(project.name)]))
        .watch();
  }

  Stream<List<Project>> watchProjectChoices() {
    return (_database.select(_database.projects)
          ..where(
            (project) =>
                project.trashedAt.isNull() & project.deletedAt.isNull(),
          )
          ..orderBy([
            (project) => OrderingTerm.asc(project.archivedAt),
            (project) => OrderingTerm.asc(project.name),
          ]))
        .watch();
  }

  Stream<List<Project>> watchTrashedProjects() {
    return (_database.select(_database.projects)
          ..where(
            (project) =>
                project.trashedAt.isNotNull() & project.deletedAt.isNull(),
          )
          ..orderBy([(project) => OrderingTerm.desc(project.trashedAt)]))
        .watch();
  }

  Stream<ProjectDetail?> watchProjectDetail(String projectId) {
    final projectQuery = _database.select(_database.projects)
      ..where((project) => project.id.equals(projectId));

    final taskQuery = _database.select(_database.aufgaben).join([
      leftOuterJoin(
        _database.taskEntries,
        _database.taskEntries.taskId.equalsExp(_database.aufgaben.id),
      ),
    ])..where(
      _database.aufgaben.trashedAt.isNull() &
          _database.aufgaben.projectId.equals(projectId),
    );

    return _database
        .customSelect(
          'SELECT 1',
          readsFrom: {
            _database.projects,
            _database.aufgaben,
            _database.taskEntries,
            _database.taskDefinitionVersions,
            _database.taskProjectAssignmentChanges,
          },
        )
        .watch()
        .asyncMap((_) async {
          await _assignmentService.applyDueChanges(DateTime.now());
          final project = await projectQuery.getSingleOrNull();

          if (project == null) {
            return null;
          }

          final rows = await taskQuery.get();
          final taskMap = <String, _TaskSummaryBuilder>{};

          for (final row in rows) {
            final task = row.readTable(_database.aufgaben);
            final entry = row.readTableOrNull(_database.taskEntries);
            if (entry != null) {
              final snapshotTask = await _definitionResolver.taskForEntry(
                task,
                entry,
              );
              final resolvedProjectId = await _assignmentService
                  .projectIdForDate(
                    taskId: task.id,
                    date: entry.scheduledDate,
                    snapshotProjectId: snapshotTask.projectId,
                  );
              if (resolvedProjectId != projectId) continue;
            }
            taskMap.putIfAbsent(task.id, () => _TaskSummaryBuilder(task));

            if (entry != null) {
              taskMap[task.id]!.addEntry(entry);
            }
          }

          final tasks =
              taskMap.values.map((builder) => builder.build()).toList()
                ..sort((first, second) {
                  final firstDueDate = first.task.dueDate;
                  final secondDueDate = second.task.dueDate;

                  if (first.isOpen != second.isOpen) {
                    return first.isOpen ? -1 : 1;
                  }

                  if (firstDueDate != null && secondDueDate != null) {
                    final dueDateComparison = firstDueDate.compareTo(
                      secondDueDate,
                    );
                    if (dueDateComparison != 0) {
                      return dueDateComparison;
                    }
                  } else if (firstDueDate != null) {
                    return -1;
                  } else if (secondDueDate != null) {
                    return 1;
                  }

                  return first.task.name.toLowerCase().compareTo(
                    second.task.name.toLowerCase(),
                  );
                });

          final bundleRows =
              await (_database.select(_database.taskValueBundles)..where(
                (bundle) =>
                    bundle.projectId.equals(projectId) &
                    bundle.trashedAt.isNull(),
              )).get();
          final bundles = <ProjectBundleSummary>[];
          for (final bundle in bundleRows) {
            final version =
                await (_database.select(_database.taskValueBundleVersions)
                      ..where((row) => row.bundleId.equals(bundle.id))
                      ..orderBy([(row) => OrderingTerm.desc(row.versionNumber)])
                      ..limit(1))
                    .getSingleOrNull();
            bundles.add(
              ProjectBundleSummary(
                bundle: bundle,
                name: version?.name ?? 'Bündel',
                isResolved: version?.validTo != null,
              ),
            );
          }
          bundles.sort((a, b) => a.name.compareTo(b.name));

          return ProjectDetail(
            project: project,
            tasks: tasks,
            bundles: bundles,
          );
        });
  }

  Stream<ProjectAnalyticsSummary> watchProjectAnalytics(
    String projectId, {
    int? days = 7,
  }) {
    return _database
        .customSelect(
          'SELECT 1',
          readsFrom: {
            _database.projects,
            _database.aufgaben,
            _database.taskEntries,
            _database.taskEntryValues,
            _database.taskDefinitionVersions,
            _database.taskProjectAssignmentChanges,
            _database.taskValueBundles,
            _database.taskValueBundleVersions,
            _database.taskPlanningInterruptions,
            _database.entityDeletionMarkers,
          },
        )
        .watch()
        .asyncMap((_) => _buildProjectAnalytics(projectId, days: days));
  }

  Future<ProjectAnalyticsSummary> _buildProjectAnalytics(
    String projectId, {
    required int? days,
  }) async {
    await _assignmentService.applyDueChanges(DateTime.now());
    final today = _dateOnly(DateTime.now());
    final from =
        days == null
            ? DateTime.fromMillisecondsSinceEpoch(0)
            : today.subtract(Duration(days: days - 1));
    final entries =
        await (_database.select(_database.taskEntries).join([
          innerJoin(
            _database.aufgaben,
            _database.aufgaben.id.equalsExp(_database.taskEntries.taskId),
          ),
        ])..where(
          _database.taskEntries.scheduledDate.isBiggerOrEqualValue(from) &
              _database.taskEntries.scheduledDate.isSmallerOrEqualValue(today) &
              _database.aufgaben.trashedAt.isNull(),
        )).get();
    final statusCounts = <String, int>{};
    final taskNames = <String>{};
    for (final row in entries) {
      final task = row.readTable(_database.aufgaben);
      final entry = row.readTable(_database.taskEntries);
      final snapshot = await _definitionResolver.taskForEntry(task, entry);
      final resolved = await _assignmentService.projectIdForDate(
        taskId: task.id,
        date: entry.scheduledDate,
        snapshotProjectId: snapshot.projectId,
      );
      if (resolved != projectId) continue;
      statusCounts[entry.status] = (statusCounts[entry.status] ?? 0) + 1;
      taskNames.add(snapshot.name);
    }

    final candidateIds = <String>{};
    final currentBundles =
        await (_database.select(_database.taskValueBundles)..where(
          (row) => row.projectId.equals(projectId) & row.trashedAt.isNull(),
        )).get();
    candidateIds.addAll(currentBundles.map((bundle) => bundle.id));
    final historical =
        await (_database.select(_database.taskProjectAssignmentChanges)..where(
          (row) =>
              row.bundleId.isNotNull() & row.targetProjectId.equals(projectId),
        )).get();
    candidateIds.addAll(historical.map((change) => change.bundleId!));

    var complete = 0;
    var partial = 0;
    var missing = 0;
    var notCalculable = 0;
    var hasUnavailableBundle = false;
    final bundleNames = <String>{};
    for (final bundleId in candidateIds) {
      final bundle =
          await (_database.select(_database.taskValueBundles)..where(
            (row) => row.id.equals(bundleId) & row.trashedAt.isNull(),
          )).getSingleOrNull();
      if (bundle == null) continue;
      final versions =
          await (_database.select(_database.taskValueBundleVersions)
                ..where(
                  (row) =>
                      row.bundleId.equals(bundleId) & row.cancelledAt.isNull(),
                )
                ..orderBy([(row) => OrderingTerm.asc(row.validFrom)]))
              .get();
      for (final version in versions) {
        final versionFrom = _dateOnly(version.validFrom);
        final versionTo =
            version.validTo == null
                ? today
                : _dateOnly(version.validTo!).subtract(const Duration(days: 1));
        final rangeStart = versionFrom.isAfter(from) ? versionFrom : from;
        final rangeEnd = versionTo.isBefore(today) ? versionTo : today;
        if (rangeStart.isAfter(rangeEnd)) continue;
        final summary = await _aufgabenRepository
            .getTaskValueBundleAnalyticsSummaryForPeriodRange(
              version: version,
              from: rangeStart,
              to: rangeEnd,
            );
        if (!summary.isAvailable) {
          hasUnavailableBundle = true;
          bundleNames.add(version.name);
          continue;
        }
        for (final point in summary.points) {
          final resolved = await _assignmentService.bundleProjectIdForDate(
            bundleId: bundleId,
            date: point.scheduledDate,
          );
          if (resolved != projectId) continue;
          bundleNames.add(version.name);
          switch (point.status) {
            case TaskValueBundleDisplayStatus.complete:
              complete++;
            case TaskValueBundleDisplayStatus.partial:
              partial++;
            case TaskValueBundleDisplayStatus.empty:
              missing++;
            case TaskValueBundleDisplayStatus.notCalculable:
              notCalculable++;
          }
        }
      }
    }
    return ProjectAnalyticsSummary(
      from: from,
      to: today,
      taskStatusCounts: statusCounts,
      bundleCompleteCount: complete,
      bundlePartialCount: partial,
      bundleMissingCount: missing,
      bundleNotCalculableCount: notCalculable,
      taskNames: taskNames.toList()..sort(),
      bundleNames: bundleNames.toList()..sort(),
      hasUnavailableBundle: hasUnavailableBundle,
    );
  }

  Stream<List<Aufgabe>> watchAssignableTasks({String? projectId}) {
    final query =
        _database.select(_database.aufgaben)
          ..where((task) => task.trashedAt.isNull())
          ..orderBy([(task) => OrderingTerm.asc(task.name)]);

    return query.watch();
  }

  Stream<List<ProjectBundleSummary>> watchAssignableBundles() {
    return _database
        .customSelect(
          'SELECT 1',
          readsFrom: {
            _database.taskValueBundles,
            _database.taskValueBundleVersions,
          },
        )
        .watch()
        .asyncMap((_) async {
          final bundles =
              await (_database.select(_database.taskValueBundles)
                ..where((row) => row.trashedAt.isNull())).get();
          final result = <ProjectBundleSummary>[];
          for (final bundle in bundles) {
            final version =
                await (_database.select(_database.taskValueBundleVersions)
                      ..where((row) => row.bundleId.equals(bundle.id))
                      ..orderBy([(row) => OrderingTerm.desc(row.versionNumber)])
                      ..limit(1))
                    .getSingleOrNull();
            result.add(
              ProjectBundleSummary(
                bundle: bundle,
                name: version?.name ?? 'Bündel',
                isResolved: version?.validTo != null,
              ),
            );
          }
          result.sort((a, b) => a.name.compareTo(b.name));
          return result;
        });
  }

  Stream<ProjectBundleIdentity?> watchBundleIdentity(String bundleId) {
    return _database
        .customSelect(
          'SELECT 1',
          readsFrom: {
            _database.taskValueBundles,
            _database.taskValueBundleVersions,
            _database.entityDeletionMarkers,
          },
        )
        .watch()
        .asyncMap((_) async {
          final bundle =
              await (_database.select(_database.taskValueBundles)
                ..where((row) => row.id.equals(bundleId))).getSingleOrNull();
          if (bundle == null) return null;
          final versions =
              await (_database.select(_database.taskValueBundleVersions)
                    ..where((row) => row.bundleId.equals(bundleId))
                    ..orderBy([(row) => OrderingTerm.desc(row.versionNumber)]))
                  .get();
          return ProjectBundleIdentity(bundle: bundle, versions: versions);
        });
  }

  Future<void> replaceCurrentAssignments({
    required String projectId,
    required Set<String> taskIds,
    required Set<String> bundleIds,
  }) async {
    await _database.transaction(() async {
      final project =
          await (_database.select(_database.projects)
            ..where((row) => row.id.equals(projectId))).getSingle();
      if (project.archivedAt != null ||
          project.trashedAt != null ||
          project.deletedAt != null) {
        throw StateError('Nur aktive Projekte können Inhalte aufnehmen.');
      }
      final tasks =
          await (_database.select(_database.aufgaben)
            ..where((row) => row.trashedAt.isNull())).get();
      final bundles =
          await (_database.select(_database.taskValueBundles)
            ..where((row) => row.trashedAt.isNull())).get();
      final today = _dateOnly(DateTime.now());
      for (final task in tasks) {
        final shouldBelong = taskIds.contains(task.id);
        if ((task.projectId == projectId) != shouldBelong) {
          await _assignmentService.assignFromDate(
            taskId: task.id,
            targetProjectId: shouldBelong ? projectId : null,
            effectiveDate: today,
          );
        }
      }
      for (final bundle in bundles) {
        final shouldBelong = bundleIds.contains(bundle.id);
        if ((bundle.projectId == projectId) != shouldBelong) {
          await _assignmentService.assignBundleFromDate(
            bundleId: bundle.id,
            targetProjectId: shouldBelong ? projectId : null,
            effectiveDate: today,
          );
        }
      }
    });
  }

  Future<void> createProject({
    required String name,
    required String description,
    required String colorHex,
    required Set<String> taskIds,
  }) {
    final projectId = _uuid.v4();

    return _database.transaction(() async {
      final currentProjects = await _database.select(_database.projects).get();
      final nextSortOrder =
          currentProjects.isEmpty
              ? 0
              : currentProjects
                      .map((project) => project.sortOrder)
                      .reduce(
                        (first, second) => first > second ? first : second,
                      ) +
                  1;

      await _database
          .into(_database.projects)
          .insert(
            ProjectsCompanion.insert(
              id: projectId,
              name: name.trim(),
              description: Value(description.trim()),
              colorHex: Value(colorHex),
              sortOrder: Value(nextSortOrder),
            ),
          );

      await _updateProjectAssignmentsWithVersions(
        projectId: projectId,
        taskIds: taskIds,
      );
    });
  }

  Future<void> updateProject({
    required String projectId,
    required String name,
    required String description,
    required String colorHex,
    Set<String>? taskIds,
  }) {
    return _database.transaction(() async {
      final project =
          await (_database.select(_database.projects)
            ..where((row) => row.id.equals(projectId))).getSingle();
      if (project.deletedAt != null || project.trashedAt != null) {
        throw StateError('Dieses Projekt kann nicht bearbeitet werden.');
      }
      final nextName = name.trim();
      final nextDescription = description.trim();
      if (project.name == nextName &&
          project.description == nextDescription &&
          project.colorHex == colorHex) {
        return;
      }
      await (_database.update(_database.projects)
        ..where((project) => project.id.equals(projectId))).write(
        ProjectsCompanion(
          name: Value(nextName),
          description: Value(nextDescription),
          colorHex: Value(colorHex),
          revision: Value(project.revision + 1),
          updatedAt: Value(_now().toUtc()),
        ),
      );
    });
  }

  Future<void> deleteProject(String projectId) {
    return trashProject(projectId, ProjectDeletionChoice.projectOnly);
  }

  Future<ProjectDeletionPreview> previewProjectDeletion(String projectId) =>
      _lifecycle.previewDeletion(projectId);

  Future<void> trashProject(
    String projectId,
    ProjectDeletionChoice choice,
  ) async {
    final preview = await _lifecycle.previewDeletion(projectId);
    await _lifecycle.trash(preview, choice);
  }

  Future<void> confirmProjectDeletion(
    ProjectDeletionPreview preview,
    ProjectDeletionChoice choice,
  ) => _lifecycle.trash(preview, choice);

  Future<void> archiveProject(String projectId) =>
      _lifecycle.archive(projectId);
  Future<void> unarchiveProject(String projectId) =>
      _lifecycle.unarchive(projectId);
  Future<ProjectRestorePreview> previewProjectRestore(String projectId) =>
      _lifecycle.previewRestore(projectId);
  Future<void> restoreProject(
    ProjectRestorePreview preview, {
    required bool includeContents,
  }) => _lifecycle.restore(preview, includeContents: includeContents);
  Future<void> purgeProject(String projectId) => _lifecycle.purge(projectId);
  Future<int> purgeExpiredProjects() => _lifecycle.purgeExpired();

  Future<void> assignTask({
    required String taskId,
    required String? projectId,
    required DateTime effectiveDate,
  }) => _assignmentService.assignFromDate(
    taskId: taskId,
    targetProjectId: projectId,
    effectiveDate: effectiveDate,
  );

  Future<void> assignBundle({
    required String bundleId,
    required String? projectId,
    required DateTime effectiveDate,
  }) => _assignmentService.assignBundleFromDate(
    bundleId: bundleId,
    targetProjectId: projectId,
    effectiveDate: effectiveDate,
  );

  Future<void> reorderProjects(List<String> projectIds) {
    return _database.transaction(() async {
      if (projectIds.toSet().length != projectIds.length) {
        throw ArgumentError.value(projectIds, 'projectIds', 'Doppelte ID.');
      }
      if (projectIds.isEmpty) return;
      final projects =
          await (_database.select(_database.projects)
            ..where((project) => project.id.isIn(projectIds))).get();
      if (projects.length != projectIds.length) {
        throw ArgumentError.value(
          projectIds,
          'projectIds',
          'Mindestens eine Projekt-ID ist unbekannt.',
        );
      }
      final byId = {for (final project in projects) project.id: project};
      if (projects.any(
        (project) =>
            project.archivedAt != null ||
            project.trashedAt != null ||
            project.deletedAt != null,
      )) {
        throw StateError('Nur aktive Projekte können sortiert werden.');
      }
      final now = _now().toUtc();
      for (var index = 0; index < projectIds.length; index++) {
        final project = byId[projectIds[index]]!;
        if (project.sortOrder == index) continue;
        await (_database.update(_database.projects)
          ..where((row) => row.id.equals(project.id))).write(
          ProjectsCompanion(
            sortOrder: Value(index),
            revision: Value(project.revision + 1),
            updatedAt: Value(now),
          ),
        );
      }
    });
  }

  Future<void> _updateProjectAssignmentsWithVersions({
    required String projectId,
    required Set<String> taskIds,
  }) async {
    final currentlyAssigned =
        await (_database.select(_database.aufgaben)..where(
          (task) => task.projectId.equals(projectId) & task.trashedAt.isNull(),
        )).get();
    final affectedIds = {
      ...currentlyAssigned.map((task) => task.id),
      ...taskIds,
    };
    if (affectedIds.isEmpty) {
      return;
    }

    final today = _dateOnly(_now());
    for (final taskId in affectedIds) {
      await _assignmentService.assignFromDate(
        taskId: taskId,
        targetProjectId: taskIds.contains(taskId) ? projectId : null,
        effectiveDate: today,
      );
    }
  }
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

class ProjectDetail {
  const ProjectDetail({
    required this.project,
    required this.tasks,
    this.bundles = const [],
  });

  final Project project;
  final List<ProjectTaskSummary> tasks;
  final List<ProjectBundleSummary> bundles;

  int get taskCount => tasks.length;

  int get habitCount =>
      tasks.where((task) => task.task.taskType == TaskTypes.habit).length;

  int get singleTaskCount =>
      tasks.where((task) => task.task.taskType == TaskTypes.task).length;

  int get openTaskCount => tasks.where((task) => task.isOpen).length;

  int get resolvedTaskCount => tasks.where((task) => task.isResolved).length;

  int get plannedEntryCount =>
      tasks.fold(0, (sum, task) => sum + task.plannedEntryCount);

  int get completedEntryCount =>
      tasks.fold(0, (sum, task) => sum + task.completedEntryCount);

  int get pendingEntryCount =>
      tasks.fold(0, (sum, task) => sum + task.pendingEntryCount);

  double get completionRate {
    if (plannedEntryCount == 0) {
      return 0;
    }

    return completedEntryCount / plannedEntryCount;
  }

  DateTime? get nextDueDate {
    final dueDates =
        tasks
            .where((task) => task.isOpen)
            .map((task) => task.task.dueDate)
            .whereType<DateTime>()
            .toList()
          ..sort();

    return dueDates.isEmpty ? null : dueDates.first;
  }
}

class ProjectBundleSummary {
  const ProjectBundleSummary({
    required this.bundle,
    required this.name,
    required this.isResolved,
  });

  final TaskValueBundle bundle;
  final String name;
  final bool isResolved;
}

class ProjectBundleIdentity {
  const ProjectBundleIdentity({required this.bundle, required this.versions});
  final TaskValueBundle bundle;
  final List<TaskValueBundleVersion> versions;
}

class ProjectAnalyticsSummary {
  const ProjectAnalyticsSummary({
    required this.from,
    required this.to,
    required this.taskStatusCounts,
    required this.bundleCompleteCount,
    required this.bundlePartialCount,
    required this.bundleMissingCount,
    required this.bundleNotCalculableCount,
    required this.taskNames,
    required this.bundleNames,
    required this.hasUnavailableBundle,
  });

  final DateTime from;
  final DateTime to;
  final Map<String, int> taskStatusCounts;
  final int bundleCompleteCount;
  final int bundlePartialCount;
  final int bundleMissingCount;
  final int bundleNotCalculableCount;
  final List<String> taskNames;
  final List<String> bundleNames;
  final bool hasUnavailableBundle;
}

class ProjectTaskSummary {
  const ProjectTaskSummary({
    required this.task,
    required this.plannedEntryCount,
    required this.completedEntryCount,
    required this.pendingEntryCount,
    required this.lastActivityAt,
  });

  final Aufgabe task;
  final int plannedEntryCount;
  final int completedEntryCount;
  final int pendingEntryCount;
  final DateTime? lastActivityAt;

  bool get isOpen => pendingEntryCount > 0 || plannedEntryCount == 0;

  bool get isResolved => plannedEntryCount > 0 && pendingEntryCount == 0;

  double get completionRate {
    if (plannedEntryCount == 0) {
      return 0;
    }

    return completedEntryCount / plannedEntryCount;
  }
}

class _TaskSummaryBuilder {
  _TaskSummaryBuilder(this.task);

  final Aufgabe task;
  int plannedEntryCount = 0;
  int completedEntryCount = 0;
  int pendingEntryCount = 0;
  DateTime? lastActivityAt;

  void addEntry(TaskEntry entry) {
    plannedEntryCount++;

    if (entry.status == TaskEntryStatus.success) {
      completedEntryCount++;
    }

    if (entry.status == TaskEntryStatus.pending) {
      pendingEntryCount++;
    }

    final updatedAt = entry.updatedAt;
    if (lastActivityAt == null || updatedAt.isAfter(lastActivityAt!)) {
      lastActivityAt = updatedAt;
    }
  }

  ProjectTaskSummary build() {
    return ProjectTaskSummary(
      task: task,
      plannedEntryCount: plannedEntryCount,
      completedEntryCount: completedEntryCount,
      pendingEntryCount: pendingEntryCount,
      lastActivityAt: lastActivityAt,
    );
  }
}
