import 'package:drift/drift.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/task_project_assignment_changes_table.dart';
import 'package:uuid/uuid.dart';

enum ProjectAssignableType { task, bundle }

class ProjectAssignableRef {
  const ProjectAssignableRef.task(this.id) : type = ProjectAssignableType.task;
  const ProjectAssignableRef.bundle(this.id)
    : type = ProjectAssignableType.bundle;

  final ProjectAssignableType type;
  final String id;
}

class TaskProjectAssignmentService {
  TaskProjectAssignmentService(this._database, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final AppDatabase _database;
  final DateTime Function() _now;
  final Uuid _uuid = const Uuid();

  Future<TaskProjectAssignmentChange?> pendingChange(String taskId) =>
      pendingChangeFor(ProjectAssignableRef.task(taskId));

  Future<TaskProjectAssignmentChange?> pendingBundleChange(String bundleId) =>
      pendingChangeFor(ProjectAssignableRef.bundle(bundleId));

  Future<TaskProjectAssignmentChange?> pendingChangeFor(
    ProjectAssignableRef ref,
  ) =>
      (_database.select(_database.taskProjectAssignmentChanges)
            ..where(
              (change) =>
                  _matches(change, ref) &
                  change.state.equals(TaskProjectAssignmentState.pending),
            )
            ..orderBy([(change) => OrderingTerm.desc(change.sequence)])
            ..limit(1))
          .getSingleOrNull();

  Stream<List<TaskProjectAssignmentChange>> watchChanges(String taskId) =>
      watchChangesFor(ProjectAssignableRef.task(taskId));

  Stream<List<TaskProjectAssignmentChange>> watchBundleChanges(
    String bundleId,
  ) => watchChangesFor(ProjectAssignableRef.bundle(bundleId));

  Stream<List<TaskProjectAssignmentChange>> watchChangesFor(
    ProjectAssignableRef ref,
  ) =>
      (_database.select(_database.taskProjectAssignmentChanges)
            ..where((change) => _matches(change, ref))
            ..orderBy([(change) => OrderingTerm.asc(change.sequence)]))
          .watch();

  Future<void> assignFromDate({
    required String taskId,
    required String? targetProjectId,
    required DateTime effectiveDate,
  }) => assignObjectFromDate(
    ref: ProjectAssignableRef.task(taskId),
    targetProjectId: targetProjectId,
    effectiveDate: effectiveDate,
  );

  Future<void> assignBundleFromDate({
    required String bundleId,
    required String? targetProjectId,
    required DateTime effectiveDate,
  }) => assignObjectFromDate(
    ref: ProjectAssignableRef.bundle(bundleId),
    targetProjectId: targetProjectId,
    effectiveDate: effectiveDate,
  );

  Future<void> assignObjectFromDate({
    required ProjectAssignableRef ref,
    required String? targetProjectId,
    required DateTime effectiveDate,
    String origin = ProjectAssignmentOrigin.user,
  }) async {
    final today = _dateOnly(_now());
    final date = _dateOnly(effectiveDate);
    if (origin == ProjectAssignmentOrigin.user && date.isBefore(today)) {
      throw ArgumentError.value(
        effectiveDate,
        'effectiveDate',
        'Ein Projektstichtag darf nicht in der Vergangenheit liegen.',
      );
    }
    await _database.transaction(() async {
      final current = await _currentProject(ref, requireWritable: true);
      await _ensureTargetActive(targetProjectId);
      final pending = await pendingChangeFor(ref);
      if (pending != null &&
          pending.targetProjectId == targetProjectId &&
          _dateOnly(pending.effectiveDate) == date) {
        return;
      }
      await _cancelPending(ref);
      if (date == today && current == targetProjectId) {
        return;
      }
      await _insertChange(
        ref: ref,
        targetProjectId: targetProjectId,
        previousProjectId: current,
        scope: TaskProjectAssignmentScope.fromDate,
        effectiveDate: date,
        state:
            date == today
                ? TaskProjectAssignmentState.applied
                : TaskProjectAssignmentState.pending,
        origin: origin,
      );
      if (date == today) {
        await _setCurrentProject(ref, targetProjectId);
      }
    });
  }

  Future<void> moveAllHistory({
    required String taskId,
    required String? targetProjectId,
  }) => moveObjectAllHistory(
    ref: ProjectAssignableRef.task(taskId),
    targetProjectId: targetProjectId,
  );

  Future<void> moveBundleAllHistory({
    required String bundleId,
    required String? targetProjectId,
  }) => moveObjectAllHistory(
    ref: ProjectAssignableRef.bundle(bundleId),
    targetProjectId: targetProjectId,
  );

  Future<void> moveObjectAllHistory({
    required ProjectAssignableRef ref,
    required String? targetProjectId,
  }) async {
    await _database.transaction(() async {
      final current = await _currentProject(ref, requireWritable: true);
      await _ensureTargetActive(targetProjectId);
      await _cancelPending(ref);
      final latest = await _latestApplied(ref);
      if (current == targetProjectId &&
          latest?.scope == TaskProjectAssignmentScope.allHistory &&
          latest?.targetProjectId == targetProjectId) {
        return;
      }
      await _insertChange(
        ref: ref,
        targetProjectId: targetProjectId,
        previousProjectId: current,
        scope: TaskProjectAssignmentScope.allHistory,
        effectiveDate: await _startDate(ref),
        state: TaskProjectAssignmentState.applied,
        origin: ProjectAssignmentOrigin.user,
      );
      await _setCurrentProject(ref, targetProjectId);
    });
  }

  Future<void> cancelPending(String taskId) =>
      cancelPendingFor(ProjectAssignableRef.task(taskId));

  Future<void> cancelPendingFor(ProjectAssignableRef ref) =>
      _database.transaction(() => _cancelPending(ref));

  Future<int> applyDueChanges(DateTime referenceDate) async {
    final today = _dateOnly(_now());
    final requested = _dateOnly(referenceDate);
    final through = requested.isAfter(today) ? today : requested;
    final due =
        await (_database.select(_database.taskProjectAssignmentChanges)
              ..where(
                (change) =>
                    change.state.equals(TaskProjectAssignmentState.pending) &
                    change.effectiveDate.isSmallerThanValue(
                      _nextLocalDay(through),
                    ),
              )
              ..orderBy([
                (change) => OrderingTerm.asc(change.effectiveDate),
                (change) => OrderingTerm.asc(change.sequence),
              ]))
            .get();
    var applied = 0;
    await _database.transaction(() async {
      for (final change in due) {
        final ref = _refFor(change);
        if (ref == null || !await _isWritable(ref)) {
          continue;
        }
        if (change.targetProjectId != null &&
            !await _isActiveProject(change.targetProjectId!)) {
          await _setChangeState(
            change.id,
            TaskProjectAssignmentState.cancelled,
          );
          continue;
        }
        await _setCurrentProject(ref, change.targetProjectId);
        await _setChangeState(change.id, TaskProjectAssignmentState.applied);
        applied++;
      }
    });
    return applied;
  }

  Future<String?> projectIdForDate({
    required String taskId,
    required DateTime date,
    required String? snapshotProjectId,
  }) => projectIdForObjectDate(
    ref: ProjectAssignableRef.task(taskId),
    date: date,
    snapshotProjectId: snapshotProjectId,
  );

  Future<String?> bundleProjectIdForDate({
    required String bundleId,
    required DateTime date,
  }) => projectIdForObjectDate(
    ref: ProjectAssignableRef.bundle(bundleId),
    date: date,
    snapshotProjectId: null,
  );

  Future<String?> projectIdForObjectDate({
    required ProjectAssignableRef ref,
    required DateTime date,
    required String? snapshotProjectId,
  }) async {
    final changes =
        await (_database.select(_database.taskProjectAssignmentChanges)
              ..where(
                (change) =>
                    _matches(change, ref) &
                    change.state.isIn({
                      TaskProjectAssignmentState.applied,
                      TaskProjectAssignmentState.pending,
                    }) &
                    (change.scope.equals(
                          TaskProjectAssignmentScope.allHistory,
                        ) |
                        change.effectiveDate.isSmallerThanValue(
                          _nextLocalDay(date),
                        )),
              )
              ..orderBy([(change) => OrderingTerm.asc(change.sequence)]))
            .get();
    var result = snapshotProjectId;
    for (final change in changes) {
      result = change.targetProjectId;
    }
    return result;
  }

  Future<bool> undoLatest(String taskId) =>
      undoLatestFor(ProjectAssignableRef.task(taskId));

  Future<bool> undoLatestFor(ProjectAssignableRef ref) async {
    return _database.transaction(() async {
      await _currentProject(ref, requireWritable: true);
      final latest = await _latestApplied(ref);
      if (latest == null ||
          latest.origin == ProjectAssignmentOrigin.projectDeletion) {
        return false;
      }
      await _setChangeState(latest.id, TaskProjectAssignmentState.undone);
      final resolved = await projectIdForObjectDate(
        ref: ref,
        date: _dateOnly(_now()),
        snapshotProjectId: await _baselineProject(ref),
      );
      await _setCurrentProject(
        ref,
        resolved != null && !await _isActiveProject(resolved) ? null : resolved,
      );
      return true;
    });
  }

  Future<void> detachForProjectDeletion(
    ProjectAssignableRef ref,
    String projectId,
  ) async {
    await _database.transaction(() async {
      final current = await _currentProject(ref, requireWritable: false);
      final pending = await pendingChangeFor(ref);
      final preserveOutgoing =
          pending != null &&
          pending.targetProjectId != null &&
          pending.targetProjectId != projectId;
      if (pending?.targetProjectId == projectId || preserveOutgoing) {
        await _cancelPending(ref);
      }
      if (current == projectId) {
        await _insertChange(
          ref: ref,
          targetProjectId: null,
          previousProjectId: current,
          scope: TaskProjectAssignmentScope.fromDate,
          effectiveDate: _dateOnly(_now()),
          state: TaskProjectAssignmentState.applied,
          origin: ProjectAssignmentOrigin.projectDeletion,
        );
        await _setCurrentProject(ref, null);
      }
      if (preserveOutgoing) {
        await _insertChange(
          ref: ref,
          targetProjectId: pending.targetProjectId,
          previousProjectId: null,
          scope: TaskProjectAssignmentScope.fromDate,
          effectiveDate: pending.effectiveDate,
          state: TaskProjectAssignmentState.pending,
          origin: ProjectAssignmentOrigin.user,
        );
      }
    });
  }

  Future<void> cancelIncomingToProject(
    ProjectAssignableRef ref,
    String projectId,
  ) async {
    final pending = await pendingChangeFor(ref);
    if (pending?.targetProjectId == projectId) {
      await cancelPendingFor(ref);
    }
  }

  Expression<bool> _matches(
    TaskProjectAssignmentChanges table,
    ProjectAssignableRef ref,
  ) =>
      ref.type == ProjectAssignableType.task
          ? table.taskId.equals(ref.id)
          : table.bundleId.equals(ref.id);

  ProjectAssignableRef? _refFor(TaskProjectAssignmentChange change) {
    if (change.taskId != null) {
      return ProjectAssignableRef.task(change.taskId!);
    }
    if (change.bundleId != null) {
      return ProjectAssignableRef.bundle(change.bundleId!);
    }
    return null;
  }

  Future<void> _insertChange({
    required ProjectAssignableRef ref,
    required String? targetProjectId,
    required String? previousProjectId,
    required String scope,
    required DateTime effectiveDate,
    required String state,
    required String origin,
  }) async {
    final max = _database.taskProjectAssignmentChanges.sequence.max();
    final row =
        await (_database.selectOnly(_database.taskProjectAssignmentChanges)
              ..addColumns([max])
              ..where(_matches(_database.taskProjectAssignmentChanges, ref)))
            .getSingle();
    await _database
        .into(_database.taskProjectAssignmentChanges)
        .insert(
          TaskProjectAssignmentChangesCompanion.insert(
            id: _uuid.v4(),
            taskId: Value(
              ref.type == ProjectAssignableType.task ? ref.id : null,
            ),
            bundleId: Value(
              ref.type == ProjectAssignableType.bundle ? ref.id : null,
            ),
            targetProjectId: Value(targetProjectId),
            previousProjectId: Value(previousProjectId),
            scope: scope,
            effectiveDate: _dateOnly(effectiveDate),
            sequence: (row.read(max) ?? 0) + 1,
            state: Value(state),
            origin: Value(origin),
            updatedAt: Value(_now()),
          ),
        );
  }

  Future<void> _ensureTargetActive(String? projectId) async {
    if (projectId != null && !await _isActiveProject(projectId)) {
      throw StateError('Nur aktive Projekte können neu zugeordnet werden.');
    }
  }

  Future<bool> _isActiveProject(String projectId) async {
    final project =
        await (_database.select(_database.projects)
          ..where((row) => row.id.equals(projectId))).getSingleOrNull();
    return project != null &&
        project.archivedAt == null &&
        project.trashedAt == null &&
        project.deletedAt == null;
  }

  Future<String?> _currentProject(
    ProjectAssignableRef ref, {
    required bool requireWritable,
  }) async {
    if (ref.type == ProjectAssignableType.task) {
      final task =
          await (_database.select(_database.aufgaben)
            ..where((row) => row.id.equals(ref.id))).getSingle();
      if (requireWritable && task.trashedAt != null) {
        throw StateError(
          'Eine Aufgabe im Papierkorb kann nicht geändert werden.',
        );
      }
      return task.projectId;
    }
    final bundle =
        await (_database.select(_database.taskValueBundles)
          ..where((row) => row.id.equals(ref.id))).getSingle();
    if (requireWritable && bundle.trashedAt != null) {
      throw StateError('Ein Bündel im Papierkorb kann nicht geändert werden.');
    }
    return bundle.projectId;
  }

  Future<bool> _isWritable(ProjectAssignableRef ref) async {
    try {
      await _currentProject(ref, requireWritable: true);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<DateTime> _startDate(ProjectAssignableRef ref) async {
    if (ref.type == ProjectAssignableType.task) {
      final task =
          await (_database.select(_database.aufgaben)
            ..where((row) => row.id.equals(ref.id))).getSingle();
      return _dateOnly(task.startDate);
    }
    final first =
        await (_database.select(_database.taskValueBundleVersions)
              ..where((row) => row.bundleId.equals(ref.id))
              ..orderBy([(row) => OrderingTerm.asc(row.validFrom)])
              ..limit(1))
            .getSingle();
    return _dateOnly(first.validFrom);
  }

  Future<String?> _baselineProject(ProjectAssignableRef ref) async {
    if (ref.type == ProjectAssignableType.bundle) return null;
    final first =
        await (_database.select(_database.taskDefinitionVersions)
              ..where((row) => row.taskId.equals(ref.id))
              ..orderBy([(row) => OrderingTerm.asc(row.versionNumber)])
              ..limit(1))
            .getSingleOrNull();
    return first?.projectId;
  }

  Future<TaskProjectAssignmentChange?> _latestApplied(
    ProjectAssignableRef ref,
  ) =>
      (_database.select(_database.taskProjectAssignmentChanges)
            ..where(
              (change) =>
                  _matches(change, ref) &
                  change.state.equals(TaskProjectAssignmentState.applied),
            )
            ..orderBy([(change) => OrderingTerm.desc(change.sequence)])
            ..limit(1))
          .getSingleOrNull();

  Future<void> _cancelPending(ProjectAssignableRef ref) =>
      (_database.update(_database.taskProjectAssignmentChanges)..where(
        (change) =>
            _matches(change, ref) &
            change.state.equals(TaskProjectAssignmentState.pending),
      )).write(
        TaskProjectAssignmentChangesCompanion(
          state: const Value(TaskProjectAssignmentState.cancelled),
          updatedAt: Value(_now()),
        ),
      );

  Future<void> _setCurrentProject(
    ProjectAssignableRef ref,
    String? projectId,
  ) async {
    final current = await _currentProject(ref, requireWritable: false);
    if (current == projectId) return;
    final now = _now().toUtc();
    if (ref.type == ProjectAssignableType.task) {
      await (_database.update(_database.aufgaben)
        ..where((row) => row.id.equals(ref.id))).write(
        AufgabenCompanion(projectId: Value(projectId), updatedAt: Value(now)),
      );
      return;
    }
    await (_database.update(_database.taskValueBundles)
      ..where((row) => row.id.equals(ref.id))).write(
      TaskValueBundlesCompanion(
        projectId: Value(projectId),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> _setChangeState(String id, String state) =>
      (_database.update(_database.taskProjectAssignmentChanges)
        ..where((row) => row.id.equals(id))).write(
        TaskProjectAssignmentChangesCompanion(
          state: Value(state),
          updatedAt: Value(_now()),
        ),
      );
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);
DateTime _nextLocalDay(DateTime date) =>
    DateTime(date.year, date.month, date.day + 1);
