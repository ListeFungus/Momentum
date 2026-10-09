import 'dart:async';

import 'package:drift/drift.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/habit_recurrence.dart';
import 'package:momentum/features/aufgaben/data/missed_policy.dart';
import 'package:momentum/features/aufgaben/data/post_buffer_behavior.dart';
import 'package:momentum/features/aufgaben/data/task_capture_mode.dart';
import 'package:momentum/features/aufgaben/data/task_goal.dart';
import 'package:momentum/features/aufgaben/data/task_analytics_period.dart';
import 'package:momentum/features/aufgaben/data/task_analytics_summary.dart';
import 'package:momentum/features/aufgaben/data/task_card_metric.dart';
import 'package:momentum/features/aufgaben/data/task_card_metric_catalog.dart';
import 'package:momentum/features/aufgaben/data/task_card_metric_preference.dart';
import 'package:momentum/features/aufgaben/data/task_definition_version_writer.dart';
import 'package:momentum/features/aufgaben/data/task_definition_change.dart';
import 'package:momentum/features/aufgaben/data/task_definition_resolver.dart';
import 'package:momentum/features/aufgaben/data/task_entry_correction_service.dart';
import 'package:momentum/features/aufgaben/data/task_entry_performed_on.dart';
import 'package:momentum/features/aufgaben/data/task_entry_with_value.dart';
import 'package:momentum/features/aufgaben/data/task_entry_status.dart';
import 'package:momentum/features/aufgaben/data/task_entries_tabelle.dart';
import 'package:momentum/features/aufgaben/data/task_for_date.dart';
import 'package:momentum/features/aufgaben/data/task_goal_evaluation_summary.dart';
import 'package:momentum/features/aufgaben/data/task_instance_scheduler.dart';
import 'package:momentum/features/aufgaben/data/task_lifecycle_service.dart';
import 'package:momentum/features/aufgaben/data/task_lifecycle_tables.dart';
import 'package:momentum/features/aufgaben/data/task_pending_definition_changes_table.dart';
import 'package:momentum/features/aufgaben/data/task_project_assignment_service.dart';
import 'package:momentum/features/aufgaben/data/task_types.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle_analytics_summary.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle_calculation.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle_for_date.dart';
import 'package:momentum/features/aufgaben/data/task_value_commitment.dart';
import 'package:momentum/features/aufgaben/data/task_value_analytics_summary.dart';
import 'package:momentum/features/aufgaben/data/task_value_type.dart';
import 'package:momentum/features/aufgaben/data/task_value_unit.dart';
import 'package:uuid/uuid.dart';

class AufgabenRepository {
  AufgabenRepository(this._database, {DateTime Function()? now})
    : _definitionVersionWriter = TaskDefinitionVersionWriter(_database),
      _definitionResolver = TaskDefinitionResolver(_database, now: now),
      _taskInstanceScheduler = TaskInstanceScheduler(_database, now: now),
      _correctionService = TaskEntryCorrectionService(_database, now: now),
      _projectAssignmentService = TaskProjectAssignmentService(
        _database,
        now: now,
      ),
      _lifecycleService = TaskLifecycleService(_database, now: now),
      _now = now ?? DateTime.now;

  final AppDatabase _database;
  final TaskDefinitionVersionWriter _definitionVersionWriter;
  final TaskDefinitionResolver _definitionResolver;
  final TaskInstanceScheduler _taskInstanceScheduler;
  final TaskEntryCorrectionService _correctionService;
  final TaskProjectAssignmentService _projectAssignmentService;
  final TaskLifecycleService _lifecycleService;
  final DateTime Function() _now;
  final Uuid _uuid = const Uuid();

  Stream<List<TaskForDate>> watchTasksForDate(
    DateTime date, {
    String taskType = TaskTypes.habit,
  }) async* {
    yield* watchTaskListForDate(
      date,
      taskType: taskType,
    ).map((list) => list.tasks);
  }

  Stream<TaskListForDate> watchTaskListForDate(
    DateTime date, {
    String taskType = TaskTypes.habit,
  }) async* {
    final selectedDate = _dateOnly(date);
    await _projectAssignmentService.applyDueChanges(selectedDate);
    await _taskInstanceScheduler.ensureEntriesForDate(
      date: selectedDate,
      taskType: taskType,
    );

    final query = _database.select(_database.aufgaben).join([
      leftOuterJoin(
        _database.taskEntries,
        _database.taskEntries.taskId.equalsExp(_database.aufgaben.id) &
            (_database.taskEntries.scheduledDate.equals(selectedDate) |
                (_database.taskEntries.status.equals(TaskEntryStatus.pending) &
                    _database.taskEntries.scheduledDate.isSmallerThanValue(
                      selectedDate,
                    ))),
      ),
      leftOuterJoin(
        _database.taskEntryValues,
        _database.taskEntryValues.entryId.equalsExp(_database.taskEntries.id),
      ),
      leftOuterJoin(
        _database.projects,
        _database.projects.id.equalsExp(_database.aufgaben.projectId),
      ),
    ]);

    query.where(
      _database.aufgaben.isActive.equals(true) &
          _database.aufgaben.trashedAt.isNull() &
          _database.aufgaben.taskType.equals(taskType),
    );

    yield* _watchWithCardMetricDependencies(query.watch(), (rows) async {
      final rawTasks = _mapAndSortTasks(rows);
      final tasks = <TaskForDate>[];
      for (final task in rawTasks) {
        tasks.add(await _resolvedTaskForDate(task, selectedDate));
      }

      final visibleTasks = <TaskForDate>[];

      for (final task in tasks) {
        if (await _isTaskVisibleOnDate(task, selectedDate)) {
          visibleTasks.add(task);
        }
      }

      final allValueBundles = [
        ...await _valueBundlesForTasks(date: selectedDate),
        ...await _valueBundlesForTasks(
          date: selectedDate.add(const Duration(days: 1)),
        ).then(
          (bundles) => bundles.where(
            (bundle) =>
                bundle.version.displayMode ==
                    TaskValueBundleDisplayMode.linkedCards &&
                _bundleUsesSourceDate(bundle, selectedDate),
          ),
        ),
      ];
      final hiddenTaskIds =
          allValueBundles
              .where(
                (bundle) =>
                    bundle.version.displayMode ==
                    TaskValueBundleDisplayMode.combinedCard,
              )
              .expand((bundle) => bundle.taskIds)
              .toSet();
      final linkedTasks = _attachLinkedValueBundles(
        tasks:
            visibleTasks
                .where((task) => !hiddenTaskIds.contains(task.task.id))
                .toList(),
        bundles:
            allValueBundles
                .where(
                  (bundle) =>
                      bundle.version.displayMode ==
                      TaskValueBundleDisplayMode.linkedCards,
                )
                .toList(),
        date: selectedDate,
      );

      return TaskListForDate(
        tasks: await _withTaskCardMetrics(linkedTasks, selectedDate),
        valueBundles: await _withBundleCardMetrics(
          allValueBundles
              .where(
                (bundle) =>
                    bundle.version.displayMode ==
                    TaskValueBundleDisplayMode.combinedCard,
              )
              .toList(),
          selectedDate,
        ),
      );
    });
  }

  Future<int> ensureTaskInstancesUpToDate({DateTime? date}) async {
    await _lifecycleService.purgeExpired();
    final selectedDate = _dateOnly(date ?? _now());
    await _projectAssignmentService.applyDueChanges(selectedDate);
    return _taskInstanceScheduler.ensureEntriesForDate(date: selectedDate);
  }

  Stream<List<Aufgabe>> watchTrashedTasks() =>
      _lifecycleService.watchTrashedTasks();

  Stream<List<Aufgabe>> watchPausedTasks() =>
      _lifecycleService.watchPausedTasks();

  Stream<List<TaskValueBundle>> watchTrashedBundles() =>
      _lifecycleService.watchTrashedBundles();

  Stream<List<TaskValueBundleLifecycleItem>> watchBundleLifecycleItems() =>
      _lifecycleService.watchBundleLifecycleItems();

  Future<TaskForDate?> taskForDateIncludingPause({
    required String taskId,
    required DateTime date,
  }) => _taskForDateById(taskId: taskId, date: date);

  Future<TaskDeletionPreview> previewTaskDeletion(String taskId) async {
    await _lifecycleService.purgeExpired();
    return _lifecycleService.previewTaskDeletion(taskId);
  }

  Future<TaskDeletionPreview> previewBundleDeletion(String bundleId) async {
    await _lifecycleService.purgeExpired();
    return _lifecycleService.previewBundleDeletion(bundleId);
  }

  Future<TrashContentsPreview> previewEmptyTrash() async {
    await _lifecycleService.purgeExpired();
    return _lifecycleService.previewEmptyTrash();
  }

  Future<void> emptyTrash(TrashContentsPreview preview) =>
      _lifecycleService.emptyTrash(preview);

  Future<void> moveTaskToTrash(TaskDeletionPreview preview) async {
    await _taskInstanceScheduler.ensureEntriesForDate(date: _now());
    await _lifecycleService.trashTask(preview);
  }

  Future<void> restoreTask(String taskId) async {
    await _lifecycleService.restoreTask(taskId);
    final task = await _taskById(taskId);
    if (await _isUnavailableProject(task.projectId)) {
      await _projectAssignmentService.detachForProjectDeletion(
        ProjectAssignableRef.task(taskId),
        task.projectId!,
      );
    }
    final today = _dateOnly(_now());
    await _definitionResolver.applyDueChanges(today);
    await _projectAssignmentService.applyDueChanges(today);
    await _taskInstanceScheduler.ensureEntriesForDate(date: today);
  }

  Future<void> permanentlyDeleteTask(String taskId) =>
      _lifecycleService.purgeTask(taskId);

  Future<void> pauseTask(String taskId) async {
    await _taskInstanceScheduler.ensureEntriesForDate(date: _now());
    await _lifecycleService.pauseTask(taskId);
  }

  Future<void> resumeTask(String taskId) async {
    await _lifecycleService.resumeTask(taskId);
    final today = _dateOnly(_now());
    await _definitionResolver.applyDueChanges(today);
    await _projectAssignmentService.applyDueChanges(today);
    await _taskInstanceScheduler.ensureEntriesForDate(date: today);
  }

  Future<void> moveBundleToTrash(TaskDeletionPreview preview) =>
      _lifecycleService.trashBundle(preview);

  Future<void> restoreBundle(String bundleId) async {
    await _lifecycleService.restoreBundle(bundleId);
    final bundle =
        await (_database.select(_database.taskValueBundles)
          ..where((row) => row.id.equals(bundleId))).getSingle();
    if (await _isUnavailableProject(bundle.projectId)) {
      await _projectAssignmentService.detachForProjectDeletion(
        ProjectAssignableRef.bundle(bundleId),
        bundle.projectId!,
      );
    }
    await _projectAssignmentService.applyDueChanges(_dateOnly(_now()));
  }

  Future<bool> _isUnavailableProject(String? projectId) async {
    if (projectId == null) return false;
    final project =
        await (_database.select(_database.projects)
          ..where((row) => row.id.equals(projectId))).getSingleOrNull();
    return project == null ||
        project.trashedAt != null ||
        project.deletedAt != null;
  }

  Future<void> permanentlyDeleteBundle(String bundleId) =>
      _lifecycleService.purgeBundle(bundleId);

  Future<int> purgeExpiredTrash() => _lifecycleService.purgeExpired();

  Stream<List<TaskPendingDefinitionChange>> watchPendingDefinitionChanges(
    String taskId,
  ) => _definitionResolver.watchPendingChanges(taskId);

  Stream<List<TaskProjectAssignmentChange>> watchProjectAssignmentChanges(
    String taskId,
  ) => _projectAssignmentService.watchChanges(taskId);

  Future<TaskCorrectionPreview> previewBulkStatusCorrection({
    required String taskId,
    required Iterable<String> entryIds,
    required String status,
    bool? checkboxValue,
  }) => _correctionService.previewBulkStatus(
    taskId: taskId,
    entryIds: entryIds,
    status: status,
    checkboxValue: checkboxValue,
  );

  Future<String?> applyStatusCorrections({
    required String taskId,
    required Iterable<TaskStatusCorrectionTarget> targets,
    String reason = '',
  }) => _correctionService.applyStatusCorrections(
    taskId: taskId,
    targets: targets,
    reason: reason,
  );

  Future<bool> undoLatestTaskCorrection(String taskId) =>
      _correctionService.undoLatest(taskId);

  Future<String?> removeTaskEntryValue({
    required String taskId,
    required String entryId,
    String reason = '',
  }) => _correctionService.removeValue(
    taskId: taskId,
    entryId: entryId,
    reason: reason,
  );

  Future<void> assignTaskProjectFromDate({
    required String taskId,
    required String? projectId,
    required DateTime effectiveDate,
  }) => _projectAssignmentService.assignFromDate(
    taskId: taskId,
    targetProjectId: projectId,
    effectiveDate: effectiveDate,
  );

  Future<void> moveTaskProjectHistory({
    required String taskId,
    required String? projectId,
  }) => _projectAssignmentService.moveAllHistory(
    taskId: taskId,
    targetProjectId: projectId,
  );

  Future<bool> undoLatestProjectAssignment(String taskId) =>
      _projectAssignmentService.undoLatest(taskId);

  Future<TaskCardMetricPreferenceSelection> getTaskCardMetricPreference(
    String taskId,
  ) => _getCardMetricPreference('task:$taskId');

  Future<TaskCardMetricPreferenceSelection> getBundleCardMetricPreference(
    String bundleId,
  ) => _getCardMetricPreference('bundle:$bundleId');

  Stream<TaskCardMetricPreferenceSelection> watchTaskCardMetricPreference(
    String taskId,
  ) => _watchCardMetricPreference('task:$taskId');

  Stream<TaskCardMetricPreferenceSelection> watchBundleCardMetricPreference(
    String bundleId,
  ) => _watchCardMetricPreference('bundle:$bundleId');

  Future<void> setTaskCardMetricPreference({
    required String taskId,
    required TaskCardMetricPreferenceConfig config,
  }) => _setCardMetricPreference(
    id: 'task:$taskId',
    taskId: taskId,
    bundleId: null,
    config: config,
  );

  Future<void> setBundleCardMetricPreference({
    required String bundleId,
    required TaskCardMetricPreferenceConfig config,
  }) => _setCardMetricPreference(
    id: 'bundle:$bundleId',
    taskId: null,
    bundleId: bundleId,
    config: config,
  );

  Future<void> resetTaskCardMetricPreference(String taskId) =>
      _resetCardMetricPreference(
        id: 'task:$taskId',
        taskId: taskId,
        bundleId: null,
      );

  Future<void> resetBundleCardMetricPreference(String bundleId) =>
      _resetCardMetricPreference(
        id: 'bundle:$bundleId',
        taskId: null,
        bundleId: bundleId,
      );

  Future<TaskCardMetricPreferenceSelection> _getCardMetricPreference(
    String id,
  ) async {
    final row =
        await (_database.select(_database.taskCardMetricPreferences)
          ..where((preference) => preference.id.equals(id))).getSingleOrNull();
    return _cardMetricPreferenceSelection(row);
  }

  Stream<TaskCardMetricPreferenceSelection> _watchCardMetricPreference(
    String id,
  ) {
    return (_database.select(_database.taskCardMetricPreferences)..where(
      (preference) => preference.id.equals(id),
    )).watchSingleOrNull().map(_cardMetricPreferenceSelection);
  }

  TaskCardMetricPreferenceSelection _cardMetricPreferenceSelection(
    TaskCardMetricPreference? row,
  ) {
    if (row == null || row.isReset) {
      return const TaskCardMetricPreferenceSelection.defaultValue();
    }
    final decoded = TaskCardMetricPreferenceConfig.decode(row.configJson);
    if (!decoded.isAvailable) {
      return const TaskCardMetricPreferenceSelection.unavailable();
    }
    return TaskCardMetricPreferenceSelection.stored(decoded.config!);
  }

  Future<void> _setCardMetricPreference({
    required String id,
    required String? taskId,
    required String? bundleId,
    required TaskCardMetricPreferenceConfig config,
  }) async {
    final encoded = config.encode();
    await _database.transaction(() async {
      await _ensureCardMetricEntityWritable(taskId, bundleId);
      final existing =
          await (_database.select(
            _database.taskCardMetricPreferences,
          )..where((preference) => preference.id.equals(id))).getSingleOrNull();
      if (existing != null &&
          !existing.isReset &&
          existing.configJson == encoded) {
        return;
      }

      await _database
          .into(_database.taskCardMetricPreferences)
          .insertOnConflictUpdate(
            TaskCardMetricPreferencesCompanion.insert(
              id: id,
              taskId: Value(taskId),
              bundleId: Value(bundleId),
              configJson: encoded,
              isReset: const Value(false),
              updatedAt: _now().toUtc(),
            ),
          );
    });
  }

  Future<void> _resetCardMetricPreference({
    required String id,
    required String? taskId,
    required String? bundleId,
  }) async {
    await _database.transaction(() async {
      await _ensureCardMetricEntityWritable(taskId, bundleId);
      final existing =
          await (_database.select(
            _database.taskCardMetricPreferences,
          )..where((preference) => preference.id.equals(id))).getSingleOrNull();
      if (existing == null || existing.isReset) return;
      await (_database.update(_database.taskCardMetricPreferences)
        ..where((preference) => preference.id.equals(id))).write(
        TaskCardMetricPreferencesCompanion(
          configJson: const Value(''),
          isReset: const Value(true),
          updatedAt: Value(_now().toUtc()),
        ),
      );
    });
  }

  Future<void> _ensureCardMetricEntityWritable(
    String? taskId,
    String? bundleId,
  ) async {
    if (taskId != null) {
      await _lifecycleService.ensureTaskWritable(taskId);
      return;
    }
    final bundle =
        await (_database.select(_database.taskValueBundles)
          ..where((row) => row.id.equals(bundleId!))).getSingle();
    if (bundle.trashedAt != null) {
      throw StateError('Ein Bündel im Papierkorb kann nicht geändert werden.');
    }
  }

  Stream<List<TaskForDate>> watchTasksByUrgency() {
    final query = _database.select(_database.aufgaben).join([
      leftOuterJoin(
        _database.taskEntries,
        _database.taskEntries.taskId.equalsExp(_database.aufgaben.id),
      ),
      leftOuterJoin(
        _database.taskEntryValues,
        _database.taskEntryValues.entryId.equalsExp(_database.taskEntries.id),
      ),
      leftOuterJoin(
        _database.projects,
        _database.projects.id.equalsExp(_database.aufgaben.projectId),
      ),
    ])..where(
      _database.aufgaben.isActive.equals(true) &
          _database.aufgaben.trashedAt.isNull() &
          _database.aufgaben.taskType.equals(TaskTypes.task) &
          (_database.taskEntries.status.equals(TaskEntryStatus.pending) |
              (_database.taskEntries.id.isNull() &
                  _database.aufgaben.recurrence.equals(HabitRecurrence.none) &
                  _database.aufgaben.erfassungsmodus.equals(
                    TaskCaptureMode.value,
                  ) &
                  _database.aufgaben.valueCommitment.equals(
                    TaskValueCommitment.pureTracking,
                  ))),
    );

    return _watchWithCardMetricDependencies(query.watch(), (rows) async {
      final rawTasks = _mapAndSortTasks(rows);
      final tasks = <TaskForDate>[];
      final today = _dateOnly(DateTime.now());
      for (final task in rawTasks) {
        tasks.add(await _resolvedTaskForDate(task, today));
      }
      return _withTaskCardMetrics(tasks, today);
    });
  }

  Stream<List<TaskForDate>> watchCompletedOneTimeTasks() {
    final query = _database.select(_database.aufgaben).join([
      innerJoin(
        _database.taskEntries,
        _database.taskEntries.taskId.equalsExp(_database.aufgaben.id),
      ),
      leftOuterJoin(
        _database.taskEntryValues,
        _database.taskEntryValues.entryId.equalsExp(_database.taskEntries.id),
      ),
      leftOuterJoin(
        _database.projects,
        _database.projects.id.equalsExp(_database.aufgaben.projectId),
      ),
    ]);

    query.where(
      _database.aufgaben.isActive.equals(true) &
          _database.aufgaben.trashedAt.isNull() &
          _database.aufgaben.taskType.equals(TaskTypes.task) &
          _database.aufgaben.recurrence.equals(HabitRecurrence.none) &
          _database.taskEntries.status.isIn(TaskEntryStatus.resolvedValues),
    );

    query.orderBy([
      OrderingTerm.desc(_database.taskEntries.finalizedAt),
      OrderingTerm.desc(_database.taskEntries.respondedAt),
      OrderingTerm.desc(_database.taskEntries.updatedAt),
      OrderingTerm.desc(_database.taskEntries.scheduledDate),
    ]);

    return _watchWithCardMetricDependencies(query.watch(), (rows) async {
      final rawTasks = _mapAndSortTasks(rows);
      final tasks = <TaskForDate>[];
      for (final task in rawTasks) {
        tasks.add(
          await _resolvedTaskForDate(
            task,
            task.entry?.scheduledDate ?? task.task.startDate,
          ),
        );
      }
      final result = <TaskForDate>[];
      for (final task in tasks) {
        result.add(
          await _withTaskCardMetric(
            task,
            task.entry?.scheduledDate ?? task.task.startDate,
          ),
        );
      }
      return result;
    });
  }

  Stream<R> _watchWithCardMetricDependencies<T, R>(
    Stream<T> source,
    Future<R> Function(T value) mapper,
  ) {
    late StreamController<R> controller;
    StreamSubscription<T>? sourceSubscription;
    final triggerSubscriptions = <StreamSubscription<dynamic>>[];
    T? latest;
    var hasLatest = false;
    var revision = 0;

    Future<void> emit(T value) async {
      final currentRevision = ++revision;
      try {
        final mapped = await mapper(value);
        if (!controller.isClosed && currentRevision == revision) {
          controller.add(mapped);
        }
      } catch (error, stackTrace) {
        if (!controller.isClosed) {
          controller.addError(error, stackTrace);
        }
      }
    }

    void refresh([Object? _]) {
      if (hasLatest) {
        unawaited(emit(latest as T));
      }
    }

    controller = StreamController<R>(
      onListen: () {
        sourceSubscription = source.listen((value) {
          latest = value;
          hasLatest = true;
          unawaited(emit(value));
        }, onError: controller.addError);
        triggerSubscriptions.addAll([
          _database
              .select(_database.taskCardMetricPreferences)
              .watch()
              .listen(refresh),
          _database
              .select(_database.taskDefinitionVersions)
              .watch()
              .listen(refresh),
          _database
              .select(_database.taskValueBundleVersions)
              .watch()
              .listen(refresh),
          _database.select(_database.taskValueBundles).watch().listen(refresh),
          _database
              .select(_database.taskPendingDefinitionChanges)
              .watch()
              .listen(refresh),
          _database
              .select(_database.taskProjectAssignmentChanges)
              .watch()
              .listen(refresh),
          _database
              .select(_database.taskCorrectionOperations)
              .watch()
              .listen(refresh),
          _database
              .select(_database.taskPlanningInterruptions)
              .watch()
              .listen(refresh),
          _database
              .select(_database.entityDeletionMarkers)
              .watch()
              .listen(refresh),
        ]);
      },
      onCancel: () async {
        await sourceSubscription?.cancel();
        for (final subscription in triggerSubscriptions) {
          await subscription.cancel();
        }
      },
    );
    return controller.stream;
  }

  Future<TaskAnalyticsSummary> getTaskAnalyticsSummary({
    String? taskId,
    DateTime? from,
    DateTime? to,
    DateTime? today,
  }) async {
    final entries =
        await _analyticsEntriesQuery(taskId: taskId, from: from, to: to).get();

    return _buildTaskAnalyticsSummary(entries: entries, today: today);
  }

  Stream<TaskAnalyticsSummary> watchTaskAnalyticsSummary({
    String? taskId,
    DateTime? from,
    DateTime? to,
    DateTime? today,
  }) {
    return _analyticsEntriesQuery(
      taskId: taskId,
      from: from,
      to: to,
    ).watch().map(
      (entries) => _buildTaskAnalyticsSummary(entries: entries, today: today),
    );
  }

  Future<TaskAnalyticsSummary> getTaskAnalyticsSummaryForPeriod({
    required Aufgabe task,
    required TaskAnalyticsPeriod period,
    DateTime? today,
  }) {
    final referenceDate = _dateOnly(today ?? DateTime.now());

    return getTaskAnalyticsSummary(
      taskId: task.id,
      from: period.rangeStart(
        taskStartDate: task.startDate,
        today: referenceDate,
      ),
      to: period.rangeEnd(referenceDate),
      today: referenceDate,
    );
  }

  Stream<TaskAnalyticsSummary> watchTaskAnalyticsSummaryForPeriod({
    required Aufgabe task,
    required TaskAnalyticsPeriod period,
    DateTime? today,
  }) {
    final referenceDate = _dateOnly(today ?? DateTime.now());

    return watchTaskAnalyticsSummary(
      taskId: task.id,
      from: period.rangeStart(
        taskStartDate: task.startDate,
        today: referenceDate,
      ),
      to: period.rangeEnd(referenceDate),
      today: referenceDate,
    );
  }

  Future<TaskGoalEvaluationSummary> getTaskGoalEvaluationSummary({
    required Aufgabe task,
    DateTime? today,
  }) async {
    final referenceDate = _dateOnly(today ?? DateTime.now());
    final effectiveTask = await _taskWithGoalDefinitionForDate(
      task,
      referenceDate,
    );
    final windowDays = goalWindowDaysForTask(effectiveTask);
    final summary = await getTaskAnalyticsSummary(
      taskId: task.id,
      from: referenceDate.subtract(Duration(days: windowDays - 1)),
      to: referenceDate,
      today: referenceDate,
    );
    final result = TaskGoalEvaluationSummary.fromStatusSummary(
      task: effectiveTask,
      summary: summary,
      today: referenceDate,
    );
    return await _hasLifecycleInterruption(
          task.id,
          result.periodStart,
          result.periodEnd,
        )
        ? _notEvaluatedStatusGoal(result)
        : result;
  }

  Stream<TaskGoalEvaluationSummary> watchTaskGoalEvaluationSummary({
    required Aufgabe task,
    DateTime? today,
  }) async* {
    final referenceDate = _dateOnly(today ?? DateTime.now());
    final effectiveTask = await _taskWithGoalDefinitionForDate(
      task,
      referenceDate,
    );
    final windowDays = goalWindowDaysForTask(effectiveTask);

    final source = watchTaskAnalyticsSummary(
      taskId: task.id,
      from: referenceDate.subtract(Duration(days: windowDays - 1)),
      to: referenceDate,
      today: referenceDate,
    );
    yield* _watchWithCardMetricDependencies(source, (summary) async {
      final result = TaskGoalEvaluationSummary.fromStatusSummary(
        task: effectiveTask,
        summary: summary,
        today: referenceDate,
      );
      return await _hasLifecycleInterruption(
            task.id,
            result.periodStart,
            result.periodEnd,
          )
          ? _notEvaluatedStatusGoal(result)
          : result;
    });
  }

  Future<TaskGoalHistorySummary> getTaskGoalHistorySummary({
    required Aufgabe task,
    DateTime? today,
  }) async {
    final referenceDate = _dateOnly(today ?? DateTime.now());
    final versions = await _goalDefinitionVersionsForTask(task.id);
    final entries =
        await _analyticsEntriesQuery(
          taskId: task.id,
          from: task.startDate,
          to: referenceDate.subtract(const Duration(days: 1)),
        ).get();

    return _buildTaskGoalHistorySummary(
      task: task,
      versions: versions,
      entries: entries,
      interruptions: await _interruptionsForTask(task.id),
      today: referenceDate,
    );
  }

  Stream<TaskGoalHistorySummary> watchTaskGoalHistorySummary({
    required Aufgabe task,
    DateTime? today,
  }) {
    final referenceDate = _dateOnly(today ?? DateTime.now());

    final source =
        _analyticsEntriesQuery(
          taskId: task.id,
          from: task.startDate,
          to: referenceDate.subtract(const Duration(days: 1)),
        ).watch();
    return _watchWithCardMetricDependencies(source, (entries) async {
      return _buildTaskGoalHistorySummary(
        task: task,
        versions: await _goalDefinitionVersionsForTask(task.id),
        entries: entries,
        interruptions: await _interruptionsForTask(task.id),
        today: referenceDate,
      );
    });
  }

  Future<TaskValueGoalEvaluationSummary> getTaskValueGoalEvaluationSummary({
    required Aufgabe task,
    DateTime? today,
  }) async {
    final referenceDate = _dateOnly(today ?? DateTime.now());
    final effectiveTask = await _taskWithGoalDefinitionForDate(
      task,
      referenceDate,
    );
    final windowDays = goalWindowDaysForTask(effectiveTask);
    final summary = await getTaskValueAnalyticsSummaryForPeriodRange(
      task: task,
      from: referenceDate.subtract(Duration(days: windowDays - 1)),
      to: referenceDate,
      today: referenceDate,
    );

    final result = TaskValueGoalEvaluationSummary.fromValueSummary(
      task: effectiveTask,
      summary: summary,
      today: referenceDate,
    );
    return await _hasLifecycleInterruption(
          task.id,
          result.periodStart,
          result.periodEnd,
        )
        ? _notEvaluatedValueGoal(result)
        : result;
  }

  Stream<TaskValueGoalEvaluationSummary> watchTaskValueGoalEvaluationSummary({
    required Aufgabe task,
    DateTime? today,
  }) async* {
    final referenceDate = _dateOnly(today ?? DateTime.now());
    final effectiveTask = await _taskWithGoalDefinitionForDate(
      task,
      referenceDate,
    );
    final windowDays = goalWindowDaysForTask(effectiveTask);

    final source = watchTaskValueAnalyticsSummaryForPeriodRange(
      task: task,
      from: referenceDate.subtract(Duration(days: windowDays - 1)),
      to: referenceDate,
      today: referenceDate,
    );
    yield* _watchWithCardMetricDependencies(source, (summary) async {
      final result = TaskValueGoalEvaluationSummary.fromValueSummary(
        task: effectiveTask,
        summary: summary,
        today: referenceDate,
      );
      return await _hasLifecycleInterruption(
            task.id,
            result.periodStart,
            result.periodEnd,
          )
          ? _notEvaluatedValueGoal(result)
          : result;
    });
  }

  Future<TaskGoalPlannedChange?> getNextPlannedGoalChange({
    required Aufgabe task,
    DateTime? today,
  }) async {
    final referenceDate = _dateOnly(today ?? DateTime.now());
    final pending =
        await (_database.select(_database.taskPendingDefinitionChanges)
              ..where(
                (change) =>
                    change.taskId.equals(task.id) &
                    change.groupKey.equals(
                      TaskPendingDefinitionChangeGroup.goal,
                    ) &
                    change.state.equals(
                      TaskPendingDefinitionChangeState.pending,
                    ) &
                    change.effectiveDate.isBiggerThanValue(referenceDate),
              )
              ..orderBy([(change) => OrderingTerm.asc(change.effectiveDate)])
              ..limit(1))
            .getSingleOrNull();

    if (pending == null) {
      return null;
    }
    final payload = TaskGoalChangePayload.decode(pending.payloadJson);

    return TaskGoalPlannedChange(
      validFrom: _dateOnly(pending.effectiveDate),
      goalType: payload.goalType,
      goalValue: payload.goalValue,
      goalWindowDays: payload.goalWindowDays,
      goalPeriod: payload.goalPeriod,
      goalPeriodAlignment: payload.goalPeriodAlignment,
    );
  }

  Future<void> scheduleTaskGoalChangeForNextBlock({
    required String taskId,
    required String goalType,
    required int goalValue,
    required int? goalWindowDays,
    required String goalPeriod,
    required String goalPeriodAlignment,
    DateTime? today,
  }) async {
    final referenceDate = _dateOnly(today ?? DateTime.now());
    final task =
        await (_database.select(_database.aufgaben)
          ..where((task) => task.id.equals(taskId))).getSingle();
    final validFrom = nextGoalBlockStartForTask(task, referenceDate);

    await _definitionResolver.scheduleChange(
      taskId: taskId,
      group: TaskPendingDefinitionChangeGroup.goal,
      effectiveDate: validFrom,
      payloadJson:
          TaskGoalChangePayload(
            goalType: goalType,
            goalValue: goalValue,
            goalWindowDays: goalWindowDays,
            goalPeriod: goalPeriod,
            goalPeriodAlignment: goalPeriodAlignment,
          ).encode(),
    );
  }

  Future<Aufgabe> _taskWithGoalDefinitionForDate(
    Aufgabe task,
    DateTime date,
  ) async {
    return _taskWithGoalDefinition(
      task,
      await _goalDefinitionVersionForDate(task.id, date),
    );
  }

  Future<TaskDefinitionVersion?> _goalDefinitionVersionForDate(
    String taskId,
    DateTime date,
  ) {
    final nextDay = _dateOnly(date).add(const Duration(days: 1));

    return (_database.select(_database.taskDefinitionVersions)
          ..where(
            (version) =>
                version.taskId.equals(taskId) &
                version.validFrom.isSmallerThanValue(nextDay) &
                version.supersededAt.isNull(),
          )
          ..orderBy([(version) => OrderingTerm.desc(version.validFrom)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<TaskDefinitionVersion>> _goalDefinitionVersionsForTask(
    String taskId,
  ) {
    return (_database.select(_database.taskDefinitionVersions)
          ..where(
            (version) =>
                version.taskId.equals(taskId) & version.supersededAt.isNull(),
          )
          ..orderBy([
            (version) => OrderingTerm.asc(version.validFrom),
            (version) => OrderingTerm.asc(version.versionNumber),
          ]))
        .get();
  }

  TaskGoalHistorySummary _buildTaskGoalHistorySummary({
    required Aufgabe task,
    required List<TaskDefinitionVersion> versions,
    required List<TaskEntry> entries,
    required List<TaskPlanningInterruption> interruptions,
    required DateTime today,
  }) {
    final referenceDate = _dateOnly(today);
    final currentTask = _taskWithGoalDefinition(
      task,
      _goalDefinitionVersionForDateFromList(versions, referenceDate),
    );

    if (currentTask.goalType == TaskGoalType.none ||
        !isSupportedStatusGoalForTask(currentTask)) {
      return TaskGoalHistorySummary.fromEntries(
        task: currentTask,
        entries: const [],
        today: referenceDate,
      );
    }

    var blockStart = _dateOnly(task.startDate);
    final sortedEntries = [...entries]..sort((first, second) {
      return first.scheduledDate.compareTo(second.scheduledDate);
    });
    final blocks = <TaskGoalHistoryBlock>[];

    while (true) {
      final blockTask = _taskWithGoalDefinition(
        task,
        _goalDefinitionVersionForDateFromList(versions, blockStart),
      );
      final windowDays = goalWindowDaysForTask(blockTask);
      final blockEnd = blockStart.add(Duration(days: windowDays - 1));

      if (!blockEnd.isBefore(referenceDate)) {
        break;
      }

      if (blockTask.goalType != TaskGoalType.none &&
          isSupportedStatusGoalForTask(blockTask)) {
        final blockEntries =
            sortedEntries.where((entry) {
              final date = _dateOnly(entry.scheduledDate);
              return !date.isBefore(blockStart) && !date.isAfter(blockEnd);
            }).toList();

        blocks.add(
          TaskGoalHistoryBlock.fromEntries(
            periodStart: blockStart,
            periodEnd: blockEnd,
            requiredSuccessCount: requiredSuccessesForTask(blockTask),
            entries: blockEntries,
            forceNotEvaluated:
                _hasGoalVersionChangeInsideBlock(
                  versions,
                  blockStart,
                  blockEnd,
                ) ||
                _interruptionsIntersect(interruptions, blockStart, blockEnd),
            notEvaluatedMessage:
                _interruptionsIntersect(interruptions, blockStart, blockEnd)
                    ? 'Pausiert oder im Papierkorb – nicht bewertet.'
                    : 'Nicht gewertet, weil die Zielregel mitten in diesem '
                        'Zielblock geändert wurde.',
          ),
        );
      }

      blockStart = blockEnd.add(const Duration(days: 1));
    }

    return TaskGoalHistorySummary(
      hasGoal: true,
      isSupported: true,
      windowDays: goalWindowDaysForTask(currentTask),
      requiredSuccessCount: requiredSuccessesForTask(currentTask),
      blocks: blocks.reversed.toList(growable: false),
    );
  }

  Aufgabe _taskWithGoalDefinition(
    Aufgabe task,
    TaskDefinitionVersion? version,
  ) {
    if (version == null) {
      return task;
    }

    return task.copyWith(
      erfassungsmodus: version.captureMode,
      startDate: _dateOnly(version.startDate),
      goalType: version.goalType,
      goalValue: version.goalValue,
      goalWindowDays: Value(version.goalWindowDays),
      goalPeriod: version.goalPeriod,
      goalPeriodAlignment: version.goalPeriodAlignment,
      valueType: version.valueType,
    );
  }

  TaskDefinitionVersion? _goalDefinitionVersionForDateFromList(
    List<TaskDefinitionVersion> versions,
    DateTime date,
  ) {
    final referenceDate = _dateOnly(date);

    for (final version in versions.reversed) {
      if (!_dateOnly(version.validFrom).isAfter(referenceDate)) {
        return version;
      }
    }

    return null;
  }

  bool _hasGoalVersionChangeInsideBlock(
    List<TaskDefinitionVersion> versions,
    DateTime blockStart,
    DateTime blockEnd,
  ) {
    final start = _dateOnly(blockStart);
    final end = _dateOnly(blockEnd);

    return versions.any((version) {
      final validFrom = _dateOnly(version.validFrom);
      return validFrom.isAfter(start) && !validFrom.isAfter(end);
    });
  }

  Future<List<TaskPlanningInterruption>> _interruptionsForTask(String taskId) =>
      (_database.select(_database.taskPlanningInterruptions)
        ..where((item) => item.taskId.equals(taskId))).get();

  Future<bool> _hasLifecycleInterruption(
    String taskId,
    DateTime from,
    DateTime to,
  ) async =>
      _interruptionsIntersect(await _interruptionsForTask(taskId), from, to);

  bool _interruptionsIntersect(
    List<TaskPlanningInterruption> interruptions,
    DateTime from,
    DateTime to,
  ) {
    final start = dayKey(from);
    final end = dayKey(to);
    return interruptions.any(
      (item) =>
          item.fromDay.compareTo(end) <= 0 &&
          (item.untilDayExclusive == null ||
              item.untilDayExclusive!.compareTo(start) > 0),
    );
  }

  Future<TaskValueAnalyticsSummary> getTaskValueAnalyticsSummaryForPeriod({
    required Aufgabe task,
    required TaskAnalyticsPeriod period,
    DateTime? today,
  }) async {
    final referenceDate = _dateOnly(today ?? DateTime.now());
    final range = _valueAnalyticsRange(
      task: task,
      period: period,
      today: referenceDate,
    );
    final query = _taskValueAnalyticsRowsQuery(
      taskId: task.id,
      from: range.start,
      to: range.end,
    );
    final rows = await query.get();

    return _buildTaskValueAnalyticsSummary(
      task: task,
      periodStart: range.start,
      periodEnd: range.end,
      rows: rows,
    );
  }

  Future<TaskValueAnalyticsSummary> getTaskValueAnalyticsSummaryForPeriodRange({
    required Aufgabe task,
    required DateTime from,
    required DateTime to,
    DateTime? today,
  }) async {
    final query = _taskValueAnalyticsRowsQuery(
      taskId: task.id,
      from: _dateOnly(from),
      to: _dateOnly(to),
    );
    final rows = await query.get();

    return _buildTaskValueAnalyticsSummary(
      task: task,
      periodStart: _dateOnly(from),
      periodEnd: _dateOnly(to),
      rows: rows,
    );
  }

  Stream<TaskValueAnalyticsSummary> watchTaskValueAnalyticsSummaryForPeriod({
    required Aufgabe task,
    required TaskAnalyticsPeriod period,
    DateTime? today,
  }) {
    final referenceDate = _dateOnly(today ?? DateTime.now());
    final range = _valueAnalyticsRange(
      task: task,
      period: period,
      today: referenceDate,
    );
    final query = _taskValueAnalyticsRowsQuery(
      taskId: task.id,
      from: range.start,
      to: range.end,
    );

    return query.watch().asyncMap((rows) {
      return _buildTaskValueAnalyticsSummary(
        task: task,
        periodStart: range.start,
        periodEnd: range.end,
        rows: rows,
      );
    });
  }

  Stream<TaskValueAnalyticsSummary>
  watchTaskValueAnalyticsSummaryForPeriodRange({
    required Aufgabe task,
    required DateTime from,
    required DateTime to,
    DateTime? today,
  }) {
    final query = _taskValueAnalyticsRowsQuery(
      taskId: task.id,
      from: _dateOnly(from),
      to: _dateOnly(to),
    );

    return query.watch().asyncMap((rows) {
      return _buildTaskValueAnalyticsSummary(
        task: task,
        periodStart: _dateOnly(from),
        periodEnd: _dateOnly(to),
        rows: rows,
      );
    });
  }

  Stream<OneTimeTaskAnalyticsSummary>
  watchOneTimeTaskAnalyticsSummaryForPeriod({
    required TaskAnalyticsPeriod period,
    DateTime? today,
  }) {
    final referenceDate = _dateOnly(today ?? DateTime.now());
    final from = period.rangeStart(
      taskStartDate: DateTime.fromMillisecondsSinceEpoch(0),
      today: referenceDate,
    );
    final to = period.rangeEnd(referenceDate);

    final query = _database.select(_database.aufgaben).join([
      leftOuterJoin(
        _database.taskEntries,
        _database.taskEntries.taskId.equalsExp(_database.aufgaben.id),
      ),
    ]);

    query.where(
      _database.aufgaben.trashedAt.isNull() &
          _database.aufgaben.taskType.equals(TaskTypes.task) &
          _database.aufgaben.recurrence.equals(HabitRecurrence.none) &
          _database.aufgaben.createdAt.isBiggerOrEqualValue(from) &
          _database.aufgaben.createdAt.isSmallerOrEqualValue(
            to
                .add(const Duration(days: 1))
                .subtract(const Duration(milliseconds: 1)),
          ),
    );

    return query.watch().map((rows) {
      return _buildOneTimeTaskAnalyticsSummary(
        rows: rows,
        today: referenceDate,
      );
    });
  }

  Stream<TaskEntry?> watchLatestTaskEntry(String taskId) {
    final readableTaskIds =
        _database.selectOnly(_database.aufgaben)
          ..addColumns([_database.aufgaben.id])
          ..where(_database.aufgaben.trashedAt.isNull());
    final query =
        _database.select(_database.taskEntries)
          ..where(
            (entry) =>
                entry.taskId.equals(taskId) &
                entry.taskId.isInQuery(readableTaskIds),
          )
          ..orderBy([(entry) => OrderingTerm.desc(entry.scheduledDate)])
          ..limit(1);

    return query.watchSingleOrNull();
  }

  Stream<TaskEntryWithValue?> watchLatestTaskEntryWithValue(String taskId) {
    final readableTaskIds =
        _database.selectOnly(_database.aufgaben)
          ..addColumns([_database.aufgaben.id])
          ..where(_database.aufgaben.trashedAt.isNull());
    final query =
        _database.select(_database.taskEntries).join([
            leftOuterJoin(
              _database.taskEntryValues,
              _database.taskEntryValues.entryId.equalsExp(
                _database.taskEntries.id,
              ),
            ),
          ])
          ..where(
            _database.taskEntries.taskId.equals(taskId) &
                _database.taskEntries.taskId.isInQuery(readableTaskIds),
          )
          ..orderBy([OrderingTerm.desc(_database.taskEntries.scheduledDate)])
          ..limit(1);

    return query.watch().map((rows) {
      if (rows.isEmpty) {
        return null;
      }

      final row = rows.single;
      return TaskEntryWithValue(
        entry: row.readTable(_database.taskEntries),
        entryValue: row.readTableOrNull(_database.taskEntryValues),
      );
    });
  }

  Stream<List<TaskEntryWithValue>> watchStoredTaskEntries(String taskId) {
    final readableTaskIds =
        _database.selectOnly(_database.aufgaben)
          ..addColumns([_database.aufgaben.id])
          ..where(_database.aufgaben.trashedAt.isNull());
    final query =
        _database.select(_database.taskEntries).join([
            leftOuterJoin(
              _database.taskEntryValues,
              _database.taskEntryValues.entryId.equalsExp(
                _database.taskEntries.id,
              ),
            ),
          ])
          ..where(
            _database.taskEntries.taskId.equals(taskId) &
                _database.taskEntries.taskId.isInQuery(readableTaskIds),
          )
          ..orderBy([OrderingTerm.desc(_database.taskEntries.scheduledDate)]);
    return query.watch().map(
      (rows) => rows
          .map(
            (row) => TaskEntryWithValue(
              entry: row.readTable(_database.taskEntries),
              entryValue: row.readTableOrNull(_database.taskEntryValues),
            ),
          )
          .toList(growable: false),
    );
  }

  Future<Aufgabe> _taskById(String taskId) {
    return (_database.select(_database.aufgaben)
      ..where((task) => task.id.equals(taskId))).getSingle();
  }

  Future<Aufgabe?> _taskByIdOrNull(String taskId) =>
      (_database.select(_database.aufgaben)
        ..where((task) => task.id.equals(taskId))).getSingleOrNull();

  Future<String?> _bundleSourceUnavailableReason({
    required Aufgabe? firstTask,
    required Aufgabe? secondTask,
    required String firstTaskId,
    required String secondTaskId,
  }) async {
    if (firstTask?.trashedAt != null || secondTask?.trashedAt != null) {
      return 'Mindestens ein Teil-Tracking befindet sich im Papierkorb.';
    }
    if (firstTask != null && secondTask != null) return null;
    final missingIds = <String>{
      if (firstTask == null) firstTaskId,
      if (secondTask == null) secondTaskId,
    };
    final markers =
        await (_database.select(_database.entityDeletionMarkers)..where(
          (marker) =>
              marker.entityType.equals(DeletableEntityType.task) &
              marker.entityId.isIn(missingIds),
        )).get();
    return markers.isNotEmpty
        ? 'Mindestens ein Teil-Tracking wurde endgültig gelöscht.'
        : 'Mindestens ein Teil-Tracking ist unerwartet nicht verfügbar.';
  }

  Future<List<TaskValueBundleForDate>> _valueBundlesForTasks({
    required DateTime date,
  }) async {
    final rows = await _activeValueBundleRowsForDate(date);
    final result = <TaskValueBundleForDate>[];

    for (final row in rows) {
      final bundle = row.readTable(_database.taskValueBundles);
      final version = row.readTable(_database.taskValueBundleVersions);
      final firstDate = _bundleSourceDate(date, version.firstTaskDayOffset);
      final secondDate = _bundleSourceDate(date, version.secondTaskDayOffset);
      final firstTask = await _taskForDateById(
        taskId: version.firstTaskId,
        date: firstDate,
      );
      final secondTask = await _taskForDateById(
        taskId: version.secondTaskId,
        date: secondDate,
      );

      if (firstTask == null || secondTask == null) {
        continue;
      }

      final firstDue = await _taskInstanceScheduler.isDueOnDate(
        firstTask.task,
        firstDate,
      );
      final secondDue = await _taskInstanceScheduler.isDueOnDate(
        secondTask.task,
        secondDate,
      );

      if (!firstDue && !secondDue) {
        continue;
      }

      final calculation = calculateTaskValueBundle(
        version: version,
        firstTask: firstTask,
        secondTask: secondTask,
      );

      result.add(
        TaskValueBundleForDate(
          scheduledDate: _dateOnly(date),
          bundle: bundle,
          version: version,
          firstTask: firstTask,
          secondTask: secondTask,
          calculation: calculation,
          status: _bundleDisplayStatus(
            firstTask: firstTask,
            secondTask: secondTask,
            calculation: calculation,
          ),
        ),
      );
    }

    result.sort(
      (first, second) => first.version.name.toLowerCase().compareTo(
        second.version.name.toLowerCase(),
      ),
    );

    return result;
  }

  List<TaskForDate> _attachLinkedValueBundles({
    required List<TaskForDate> tasks,
    required List<TaskValueBundleForDate> bundles,
    required DateTime date,
  }) {
    if (bundles.isEmpty) {
      return tasks;
    }

    final bundlesByVisibleTaskId = <String, List<TaskValueBundleForDate>>{};

    for (final bundle in bundles) {
      final version = bundle.version;
      if (_bundleSourceDate(bundle.scheduledDate, version.firstTaskDayOffset) ==
          _dateOnly(date)) {
        bundlesByVisibleTaskId
            .putIfAbsent(version.firstTaskId, () => [])
            .add(bundle);
      }
      if (_bundleSourceDate(
            bundle.scheduledDate,
            version.secondTaskDayOffset,
          ) ==
          _dateOnly(date)) {
        bundlesByVisibleTaskId
            .putIfAbsent(version.secondTaskId, () => [])
            .add(bundle);
      }
    }

    if (bundlesByVisibleTaskId.isEmpty) {
      return tasks;
    }

    return tasks.map((task) {
      final linkedBundles = bundlesByVisibleTaskId[task.task.id];

      if (linkedBundles == null) {
        return task;
      }

      return TaskForDate(
        task: task.task,
        entry: task.entry,
        entryValue: task.entryValue,
        project: task.project,
        cardMetrics: task.cardMetrics,
        linkedValueBundles: linkedBundles,
      );
    }).toList();
  }

  Future<List<TaskForDate>> _withTaskCardMetrics(
    List<TaskForDate> tasks,
    DateTime date,
  ) async {
    final context = _CardMetricLoadContext();
    final result = <TaskForDate>[];
    for (final task in tasks) {
      result.add(await _withTaskCardMetric(task, date, context: context));
    }

    return result;
  }

  Future<TaskForDate> _withTaskCardMetric(
    TaskForDate task,
    DateTime date, {
    _CardMetricLoadContext? context,
  }) async {
    final metrics = await _taskCardMetricsFor(
      task,
      date,
      context ?? _CardMetricLoadContext(),
    );
    return TaskForDate(
      task: task.task,
      entry: task.entry,
      entryValue: task.entryValue,
      project: task.project,
      cardMetrics: metrics,
      linkedValueBundles: task.linkedValueBundles,
    );
  }

  Future<List<TaskCardMetric>> _taskCardMetricsFor(
    TaskForDate task,
    DateTime date,
    _CardMetricLoadContext context,
  ) async {
    final selectedDate = _dateOnly(date);
    final today = _dateOnly(DateTime.now());
    final statisticsDate = selectedDate.isAfter(today) ? today : selectedDate;
    final preference = await context.taskPreferences.putIfAbsent(
      task.task.id,
      () => getTaskCardMetricPreference(task.task.id),
    );
    if (preference.isUnavailable) {
      return const [
        TaskCardMetric(
          label: 'Kartenanzeige',
          value: 'Einstellung nicht verfügbar',
          tone: TaskCardMetricTone.neutral,
        ),
      ];
    }
    if (preference.isHidden) {
      return const [];
    }
    final effectiveTask = await _taskWithGoalDefinitionForDate(
      task.task,
      statisticsDate,
    );
    if (_dateOnly(task.task.startDate).isAfter(statisticsDate)) {
      return const [
        TaskCardMetric(
          label: 'Kartenanzeige',
          value: 'Noch nicht gestartet',
          tone: TaskCardMetricTone.neutral,
          detail: 'Stand heute',
        ),
      ];
    }
    final item =
        preference.config?.items.firstOrNull ??
        _defaultTaskCardMetric(effectiveTask);
    final available = TaskCardMetricCatalog.forTask(
      effectiveTask,
    ).any((option) => option.key == item.metric);
    if (!available && item.metric != TaskCardMetricKey.goal) {
      return const [
        TaskCardMetric(
          label: 'Kartenanzeige',
          value: 'Kennzahl hier nicht verfügbar',
          tone: TaskCardMetricTone.neutral,
          detail: 'Über Kartenanzeige ändern',
        ),
      ];
    }
    final metric = await _taskCardMetricForItem(
      task: task,
      effectiveTask: effectiveTask,
      item: item,
      statisticsDate: statisticsDate,
      isFutureView: selectedDate.isAfter(today),
      context: context,
    );
    return [metric];
  }

  TaskCardMetricPreferenceItem _defaultTaskCardMetric(Aufgabe task) {
    if (task.goalType != TaskGoalType.none &&
        (isSupportedStatusGoalForTask(task) ||
            isSupportedValueGoalForTask(task))) {
      return const TaskCardMetricPreferenceItem(metric: TaskCardMetricKey.goal);
    }
    if (task.recurrence != HabitRecurrence.none) {
      return TaskCardMetricPreferenceItem(
        metric:
            task.erfassungsmodus == TaskCaptureMode.value
                ? TaskCardMetricKey.average
                : TaskCardMetricKey.strictSuccessRate,
        period: TaskAnalyticsPeriod.last7Days,
      );
    }
    return TaskCardMetricPreferenceItem(
      metric:
          task.erfassungsmodus == TaskCaptureMode.value
              ? TaskCardMetricKey.entryValue
              : TaskCardMetricKey.entryStatus,
    );
  }

  TaskCardMetricPreferenceItem _defaultBundleCardMetric(
    TaskValueBundleVersion version,
  ) {
    if (version.goalType != TaskGoalType.none &&
        isSupportedValueGoalForBundle(version)) {
      return const TaskCardMetricPreferenceItem(metric: TaskCardMetricKey.goal);
    }
    return const TaskCardMetricPreferenceItem(
      metric: TaskCardMetricKey.average,
      period: TaskAnalyticsPeriod.last7Days,
    );
  }

  Future<TaskCardMetric> _taskCardMetricForItem({
    required TaskForDate task,
    required Aufgabe effectiveTask,
    required TaskCardMetricPreferenceItem item,
    required DateTime statisticsDate,
    required bool isFutureView,
    required _CardMetricLoadContext context,
  }) async {
    final futureDetail = isFutureView ? 'Stand heute' : null;
    switch (item.metric) {
      case TaskCardMetricKey.goal:
        if (effectiveTask.goalType == TaskGoalType.none) {
          return const TaskCardMetric(
            label: 'Ziel',
            value: 'Kein Ziel für diesen Tag',
            tone: TaskCardMetricTone.neutral,
          );
        }
        if (effectiveTask.erfassungsmodus == TaskCaptureMode.value &&
            isValueGoalType(effectiveTask.goalType)) {
          final key = '${task.task.id}:${statisticsDate.toIso8601String()}';
          final summary = await context.valueGoals.putIfAbsent(
            key,
            () => getTaskValueGoalEvaluationSummary(
              task: task.task,
              today: statisticsDate,
            ),
          );
          if (await _hasIncompatibleTaskValueDefinitions(
            task.task,
            summary.periodStart,
            summary.periodEnd,
            includeRhythm:
                _isPureTrackingTask(task.task) &&
                summary.missingOrOpenCount > 0,
          )) {
            return _changedDefinitionMetric();
          }
          return _metricFromValueGoalSummary(
            summary,
            futureDetail: futureDetail,
          );
        }
        if (isSupportedStatusGoalForTask(effectiveTask)) {
          final key = '${task.task.id}:${statisticsDate.toIso8601String()}';
          final summary = await context.statusGoals.putIfAbsent(
            key,
            () => getTaskGoalEvaluationSummary(
              task: task.task,
              today: statisticsDate,
            ),
          );
          return _metricFromStatusGoalSummary(
            summary,
            futureDetail: futureDetail,
          );
        }
        return const TaskCardMetric(
          label: 'Ziel',
          value: 'Kennzahl hier nicht verfügbar',
          tone: TaskCardMetricTone.neutral,
        );
      case TaskCardMetricKey.strictSuccessRate:
      case TaskCardMetricKey.successCount:
        final period = item.period!;
        final key =
            '${task.task.id}:${period.name}:${statisticsDate.toIso8601String()}';
        final summary = await context.statusSummaries.putIfAbsent(
          key,
          () => getTaskAnalyticsSummaryForPeriod(
            task: task.task,
            period: period,
            today: statisticsDate,
          ),
        );
        if (item.metric == TaskCardMetricKey.successCount) {
          return TaskCardMetric(
            label: 'Erfolge',
            value: '${summary.successCount}',
            tone: TaskCardMetricTone.neutral,
            detail: _joinMetricDetails([period.label, futureDetail]),
          );
        }
        return TaskCardMetric(
          label: 'Erfolgsquote',
          value:
              summary.strictSuccessRate == null
                  ? 'Keine Daten'
                  : '${(summary.strictSuccessRate! * 100).toStringAsFixed(0)} %',
          tone: TaskCardMetricTone.neutral,
          detail: _joinMetricDetails([
            '${summary.successCount}/${summary.dueCount}',
            period.label,
            futureDetail,
          ]),
        );
      case TaskCardMetricKey.average:
      case TaskCardMetricKey.sum:
        final period = item.period!;
        final key =
            '${task.task.id}:${period.name}:${statisticsDate.toIso8601String()}';
        final summary = await context.valueSummaries.putIfAbsent(
          key,
          () => getTaskValueAnalyticsSummaryForPeriod(
            task: task.task,
            period: period,
            today: statisticsDate,
          ),
        );
        if (await _hasIncompatibleTaskValueDefinitions(
          task.task,
          summary.periodStart,
          summary.periodEnd,
          includeRhythm:
              _isPureTrackingTask(task.task) && summary.missingOrOpenCount > 0,
        )) {
          return _changedDefinitionMetric();
        }
        final value =
            item.metric == TaskCardMetricKey.average
                ? summary.average
                : summary.sum;
        return TaskCardMetric(
          label:
              item.metric == TaskCardMetricKey.average
                  ? 'Durchschnitt'
                  : 'Summe',
          value: _formatValueSummaryMetric(value, summary),
          tone: TaskCardMetricTone.neutral,
          detail: _joinMetricDetails([
            period.label,
            '${summary.recordedCount} Werte',
            if (summary.missingOrOpenCount > 0)
              '${summary.missingOrOpenCount} fehlend/offen',
            futureDetail,
          ]),
        );
      case TaskCardMetricKey.entryValue:
        return _metricFromTaskValue(task) ??
            const TaskCardMetric(
              label: 'Wert',
              value: 'Noch nicht erfasst',
              tone: TaskCardMetricTone.neutral,
            );
      case TaskCardMetricKey.entryStatus:
        return TaskCardMetric(
          label: 'Status',
          value:
              task.entry == null
                  ? 'Noch kein Eintrag'
                  : _entryStatusLabel(task.entry!.status),
          tone:
              task.entry == null
                  ? TaskCardMetricTone.neutral
                  : _toneForEntryStatus(task.entry!.status),
        );
      default:
        return const TaskCardMetric(
          label: 'Kartenanzeige',
          value: 'Kennzahl hier nicht verfügbar',
          tone: TaskCardMetricTone.neutral,
        );
    }
  }

  Future<TaskCardMetric> _bundleCardMetricForItem({
    required TaskValueBundleForDate bundle,
    required TaskValueBundleVersion effectiveVersion,
    required TaskCardMetricPreferenceItem item,
    required DateTime statisticsDate,
    required bool isFutureView,
    required _CardMetricLoadContext context,
  }) async {
    final futureDetail = isFutureView ? 'Stand heute' : null;
    if (item.metric == TaskCardMetricKey.bundleResult) {
      if (bundle.calculation != null) {
        return TaskCardMetric(
          label:
              bundle.version.resultLabel.trim().isEmpty
                  ? 'Ergebnis'
                  : bundle.version.resultLabel.trim(),
          value: _formatCalculationMetric(bundle.calculation!),
          tone: TaskCardMetricTone.neutral,
        );
      }
      return TaskCardMetric(
        label: 'Ergebnis',
        value:
            bundle.status == TaskValueBundleDisplayStatus.partial
                ? 'Teilweise erfasst'
                : 'Noch kein Ergebnis',
        tone:
            bundle.status == TaskValueBundleDisplayStatus.partial
                ? TaskCardMetricTone.warning
                : TaskCardMetricTone.neutral,
      );
    }
    if (item.metric == TaskCardMetricKey.goal) {
      if (effectiveVersion.goalType == TaskGoalType.none) {
        return const TaskCardMetric(
          label: 'Ziel',
          value: 'Kein Ziel für diesen Tag',
          tone: TaskCardMetricTone.neutral,
        );
      }
      final key = '${bundle.bundle.id}:${statisticsDate.toIso8601String()}';
      final summary = await context.bundleGoals.putIfAbsent(
        key,
        () => getTaskValueBundleGoalEvaluationSummary(
          version: effectiveVersion,
          today: statisticsDate,
        ),
      );
      if (await _hasIncompatibleBundleDefinitions(
        effectiveVersion,
        summary.periodStart,
        summary.periodEnd,
        includeRhythm: summary.missingOrOpenCount > 0,
      )) {
        return _changedDefinitionMetric();
      }
      return _metricFromValueGoalSummary(summary, futureDetail: futureDetail);
    }
    final period = item.period!;
    final key =
        '${bundle.bundle.id}:${effectiveVersion.id}:${period.name}:'
        '${statisticsDate.toIso8601String()}';
    final summary = await context.bundleSummaries.putIfAbsent(
      key,
      () => getTaskValueBundleAnalyticsSummaryForPeriod(
        version: effectiveVersion,
        period: period,
        today: statisticsDate,
      ),
    );
    if (await _hasIncompatibleBundleDefinitions(
      effectiveVersion,
      summary.periodStart,
      summary.periodEnd,
      includeRhythm:
          summary.partialCount +
              summary.missingCount +
              summary.notCalculableCount >
          0,
    )) {
      return _changedDefinitionMetric();
    }
    final value =
        item.metric == TaskCardMetricKey.sum ? summary.sum : summary.average;
    return TaskCardMetric(
      label: item.metric == TaskCardMetricKey.sum ? 'Summe' : 'Durchschnitt',
      value: _formatBundleSummaryMetric(value, summary),
      tone: TaskCardMetricTone.neutral,
      detail: _joinMetricDetails([
        period.label,
        '${summary.completeCount} Werte',
        if (summary.partialCount + summary.missingCount > 0)
          '${summary.partialCount + summary.missingCount} fehlend/offen',
        futureDetail,
      ]),
    );
  }

  Future<List<TaskValueBundleForDate>> _withBundleCardMetrics(
    List<TaskValueBundleForDate> bundles,
    DateTime date,
  ) async {
    final context = _CardMetricLoadContext();
    final result = <TaskValueBundleForDate>[];
    for (final bundle in bundles) {
      result.add(await _withBundleCardMetric(bundle, date, context));
    }

    return result;
  }

  Future<bool> _hasIncompatibleTaskValueDefinitions(
    Aufgabe task,
    DateTime from,
    DateTime to, {
    required bool includeRhythm,
  }) async {
    final start = _dateOnly(from);
    final end = _dateOnly(to);
    final endExclusive = _nextLocalDay(end);
    final versions =
        await (_database.select(_database.taskDefinitionVersions)
              ..where(
                (version) =>
                    version.taskId.equals(task.id) &
                    version.supersededAt.isNull() &
                    version.validFrom.isSmallerThanValue(endExclusive),
              )
              ..orderBy([
                (version) => OrderingTerm.asc(version.validFrom),
                (version) => OrderingTerm.asc(version.versionNumber),
              ]))
            .get();
    final effectiveAtStart = _goalDefinitionVersionForDateFromList(
      versions,
      start,
    );
    final relevant = <TaskDefinitionVersion>[
      if (effectiveAtStart != null) effectiveAtStart,
      ...versions.where((version) {
        final validFrom = _dateOnly(version.validFrom);
        return validFrom.isAfter(start) && !validFrom.isAfter(end);
      }),
    ];
    if (relevant.length < 2) {
      return false;
    }
    final baseline = relevant.first;
    return relevant
        .skip(1)
        .any(
          (version) =>
              version.valueType != baseline.valueType ||
              version.valueUnitKey != baseline.valueUnitKey ||
              version.valueUnitLabel.trim() != baseline.valueUnitLabel.trim() ||
              includeRhythm &&
                  (version.recurrence != baseline.recurrence ||
                      version.activeWeekdays != baseline.activeWeekdays),
        );
  }

  Future<bool> _hasIncompatibleBundleDefinitions(
    TaskValueBundleVersion current,
    DateTime from,
    DateTime to, {
    required bool includeRhythm,
  }) async {
    final start = _dateOnly(from);
    final end = _dateOnly(to);
    final endExclusive = _nextLocalDay(end);
    final versions =
        await (_database.select(_database.taskValueBundleVersions)
              ..where(
                (version) =>
                    version.bundleId.equals(current.bundleId) &
                    version.cancelledAt.isNull() &
                    version.validFrom.isSmallerThanValue(endExclusive),
              )
              ..orderBy([
                (version) => OrderingTerm.asc(version.validFrom),
                (version) => OrderingTerm.asc(version.versionNumber),
              ]))
            .get();
    TaskValueBundleVersion? effectiveAtStart;
    for (final version in versions) {
      if (!_dateOnly(version.validFrom).isAfter(start)) {
        effectiveAtStart = version;
      }
    }
    final relevant = <TaskValueBundleVersion>[
      if (effectiveAtStart != null) effectiveAtStart,
      ...versions.where((version) {
        final validFrom = _dateOnly(version.validFrom);
        return validFrom.isAfter(start) && !validFrom.isAfter(end);
      }),
    ];
    if (relevant.length > 1) {
      final baseline = relevant.first;
      if (relevant
          .skip(1)
          .any(
            (version) =>
                version.bundleType != baseline.bundleType ||
                version.firstTaskId != baseline.firstTaskId ||
                version.secondTaskId != baseline.secondTaskId ||
                version.direction != baseline.direction ||
                version.firstTaskDayOffset != baseline.firstTaskDayOffset ||
                version.secondTaskDayOffset != baseline.secondTaskDayOffset,
          )) {
        return true;
      }
    }

    final firstTask = await _taskById(current.firstTaskId);
    final secondTask = await _taskById(current.secondTaskId);
    return await _hasIncompatibleTaskValueDefinitions(
          firstTask,
          from.add(Duration(days: current.firstTaskDayOffset)),
          to.add(Duration(days: current.firstTaskDayOffset)),
          includeRhythm: includeRhythm && _isPureTrackingTask(firstTask),
        ) ||
        await _hasIncompatibleTaskValueDefinitions(
          secondTask,
          from.add(Duration(days: current.secondTaskDayOffset)),
          to.add(Duration(days: current.secondTaskDayOffset)),
          includeRhythm: includeRhythm && _isPureTrackingTask(secondTask),
        );
  }

  Future<TaskValueBundleForDate> _withBundleCardMetric(
    TaskValueBundleForDate bundle,
    DateTime date,
    _CardMetricLoadContext context,
  ) async {
    final metrics = await _bundleCardMetricsFor(bundle, date, context);
    return TaskValueBundleForDate(
      scheduledDate: bundle.scheduledDate,
      bundle: bundle.bundle,
      version: bundle.version,
      firstTask: bundle.firstTask,
      secondTask: bundle.secondTask,
      calculation: bundle.calculation,
      status: bundle.status,
      cardMetrics: metrics,
    );
  }

  Future<List<TaskCardMetric>> _bundleCardMetricsFor(
    TaskValueBundleForDate bundle,
    DateTime date,
    _CardMetricLoadContext context,
  ) async {
    final selectedDate = _dateOnly(date);
    final today = _dateOnly(DateTime.now());
    final statisticsDate = selectedDate.isAfter(today) ? today : selectedDate;
    final preference = await context.bundlePreferences.putIfAbsent(
      bundle.bundle.id,
      () => getBundleCardMetricPreference(bundle.bundle.id),
    );
    if (preference.isUnavailable) {
      return const [
        TaskCardMetric(
          label: 'Kartenanzeige',
          value: 'Einstellung nicht verfügbar',
          tone: TaskCardMetricTone.neutral,
        ),
      ];
    }
    if (preference.isHidden) {
      return const [];
    }
    final activeVersion = await _activeValueBundleVersionByBundleId(
      bundle.bundle.id,
      statisticsDate,
    );
    if (activeVersion == null &&
        bundle.version.validFrom.isAfter(statisticsDate)) {
      return const [
        TaskCardMetric(
          label: 'Kartenanzeige',
          value: 'Noch nicht gestartet',
          tone: TaskCardMetricTone.neutral,
          detail: 'Stand heute',
        ),
      ];
    }
    final effectiveVersion = activeVersion ?? bundle.version;
    final item =
        preference.config?.items.firstOrNull ??
        _defaultBundleCardMetric(effectiveVersion);
    final available = TaskCardMetricCatalog.forBundle(
      effectiveVersion,
    ).any((option) => option.key == item.metric);
    if (!available && item.metric != TaskCardMetricKey.goal) {
      return const [
        TaskCardMetric(
          label: 'Kartenanzeige',
          value: 'Kennzahl hier nicht verfügbar',
          tone: TaskCardMetricTone.neutral,
          detail: 'Über Kartenanzeige ändern',
        ),
      ];
    }
    final metric = await _bundleCardMetricForItem(
      bundle: bundle,
      effectiveVersion: effectiveVersion,
      item: item,
      statisticsDate: statisticsDate,
      isFutureView: selectedDate.isAfter(today),
      context: context,
    );
    return [metric];
  }

  String _bundleDisplayStatus({
    required TaskForDate firstTask,
    required TaskForDate secondTask,
    required TaskValueBundleCalculation? calculation,
  }) {
    final firstHasValue = firstTask.entryValue != null;
    final secondHasValue = secondTask.entryValue != null;

    if (!firstHasValue && !secondHasValue) {
      return TaskValueBundleDisplayStatus.empty;
    }

    if (firstHasValue != secondHasValue) {
      return TaskValueBundleDisplayStatus.partial;
    }

    if (calculation == null) {
      return TaskValueBundleDisplayStatus.notCalculable;
    }

    return TaskValueBundleDisplayStatus.complete;
  }

  Future<List<TypedResult>> _activeValueBundleRowsForDate(DateTime date) {
    final query = _database.select(_database.taskValueBundles).join([
      innerJoin(
        _database.taskValueBundleVersions,
        _database.taskValueBundleVersions.bundleId.equalsExp(
          _database.taskValueBundles.id,
        ),
      ),
    ]);

    query.where(
      _database.taskValueBundles.trashedAt.isNull() &
          _database.taskValueBundleVersions.cancelledAt.isNull() &
          _database.taskValueBundleVersions.validFrom.isSmallerOrEqualValue(
            date,
          ) &
          (_database.taskValueBundleVersions.validTo.isNull() |
              _database.taskValueBundleVersions.validTo.isBiggerThanValue(
                date,
              )),
    );

    return query.get();
  }

  Future<TaskValueBundleVersion?> _activeValueBundleVersionByBundleId(
    String bundleId,
    DateTime date,
  ) async {
    final selectedDate = _dateOnly(date);
    final versions =
        await (_database.select(_database.taskValueBundleVersions)
              ..where((version) => version.bundleId.equals(bundleId))
              ..orderBy([
                (version) => OrderingTerm.desc(version.validFrom),
                (version) => OrderingTerm.desc(version.versionNumber),
              ]))
            .get();
    return versions.where((version) {
      if (version.cancelledAt != null ||
          _dateOnly(version.validFrom).isAfter(selectedDate)) {
        return false;
      }
      final validTo = version.validTo;
      return validTo == null || _dateOnly(validTo).isAfter(selectedDate);
    }).firstOrNull;
  }

  Future<TaskForDate?> _taskForDateById({
    required String taskId,
    required DateTime date,
  }) async {
    final selectedDate = _dateOnly(date);
    final query =
        _database.select(_database.aufgaben).join([
            leftOuterJoin(
              _database.taskEntries,
              _database.taskEntries.taskId.equalsExp(_database.aufgaben.id) &
                  _database.taskEntries.scheduledDate.equals(selectedDate),
            ),
            leftOuterJoin(
              _database.taskEntryValues,
              _database.taskEntryValues.entryId.equalsExp(
                _database.taskEntries.id,
              ),
            ),
            leftOuterJoin(
              _database.projects,
              _database.projects.id.equalsExp(_database.aufgaben.projectId),
            ),
          ])
          ..where(
            _database.aufgaben.id.equals(taskId) &
                _database.aufgaben.isActive.equals(true) &
                _database.aufgaben.trashedAt.isNull(),
          )
          ..limit(1);

    final row = await query.getSingleOrNull();
    if (row == null) {
      return null;
    }

    final raw = TaskForDate(
      task: row.readTable(_database.aufgaben),
      entry: row.readTableOrNull(_database.taskEntries),
      entryValue: row.readTableOrNull(_database.taskEntryValues),
      project: _availableProject(row.readTableOrNull(_database.projects)),
    );
    return _resolvedTaskForDate(raw, selectedDate);
  }

  bool _areTasksCompatibleForBundle({
    required Aufgabe firstTask,
    required Aufgabe secondTask,
    required String bundleType,
  }) {
    if (firstTask.erfassungsmodus != TaskCaptureMode.value ||
        secondTask.erfassungsmodus != TaskCaptureMode.value) {
      return false;
    }

    if (!TaskValueType.phase12Values.contains(firstTask.valueType) ||
        !TaskValueType.phase12Values.contains(secondTask.valueType)) {
      return false;
    }

    if (firstTask.taskType != secondTask.taskType) {
      return false;
    }

    return switch (bundleType) {
      TaskValueBundleType.timeInterval =>
        firstTask.valueType == TaskValueType.timeOfDay &&
            secondTask.valueType == TaskValueType.timeOfDay,
      TaskValueBundleType.difference || TaskValueBundleType.sum =>
        _areTasksCompatibleForArithmeticBundle(firstTask, secondTask),
      _ => false,
    };
  }

  bool _areTasksCompatibleForArithmeticBundle(
    Aufgabe firstTask,
    Aufgabe secondTask,
  ) {
    if (firstTask.valueType != secondTask.valueType) {
      return false;
    }

    if (firstTask.valueType == TaskValueType.duration) {
      return true;
    }

    if (firstTask.valueType != TaskValueType.number) {
      return false;
    }

    return _areNumberUnitsCompatibleForPhase12(firstTask, secondTask);
  }

  bool _areNumberUnitsCompatibleForPhase12(
    Aufgabe firstTask,
    Aufgabe secondTask,
  ) {
    final firstUnit = TaskValueUnits.byKey(firstTask.valueUnitKey);
    final secondUnit = TaskValueUnits.byKey(secondTask.valueUnitKey);

    if (firstTask.valueUnitKey == TaskValueUnitKey.custom &&
        secondTask.valueUnitKey == TaskValueUnitKey.custom) {
      return true;
    }

    if (firstUnit == null || secondUnit == null) {
      return firstTask.valueUnitKey == secondTask.valueUnitKey;
    }

    return firstUnit.family == secondUnit.family;
  }

  Future<List<Aufgabe>> compatibleTasksForValueBundle({
    required Aufgabe baseTask,
    required String bundleType,
    DateTime? date,
  }) async {
    final query = _database.select(_database.aufgaben)..where(
      (task) =>
          task.isActive.equals(true) &
          task.trashedAt.isNull() &
          task.id.equals(baseTask.id).not() &
          task.taskType.equals(baseTask.taskType) &
          task.erfassungsmodus.equals(TaskCaptureMode.value),
    );

    final candidates = await query.get();
    final result = <Aufgabe>[];

    for (final candidate in candidates) {
      if (_areTasksCompatibleForBundle(
        firstTask: baseTask,
        secondTask: candidate,
        bundleType: bundleType,
      )) {
        result.add(candidate);
      }
    }

    result.sort(
      (first, second) =>
          first.name.toLowerCase().compareTo(second.name.toLowerCase()),
    );

    return result;
  }

  Future<String> createValueBundle({
    required String name,
    String description = '',
    required String bundleType,
    required String firstTaskId,
    required String secondTaskId,
    String firstRoleLabel = '',
    String secondRoleLabel = '',
    String resultLabel = '',
    String direction = TaskValueBundleDirection.firstMinusSecond,
    String displayMode = TaskValueBundleDisplayMode.combinedCard,
    String goalType = TaskGoalType.none,
    int goalValue = 1,
    int? goalWindowDays,
    int firstTaskDayOffset = 0,
    int secondTaskDayOffset = 0,
    DateTime? validFrom,
    String? projectId,
  }) async {
    if (!TaskValueBundleType.values.contains(bundleType)) {
      throw ArgumentError.value(bundleType, 'bundleType');
    }
    if (!TaskValueBundleDirection.values.contains(direction)) {
      throw ArgumentError.value(direction, 'direction');
    }
    if (!TaskValueBundleDisplayMode.values.contains(displayMode)) {
      throw ArgumentError.value(displayMode, 'displayMode');
    }
    if (!TaskGoalType.values.contains(goalType) ||
        (goalType != TaskGoalType.none && !isValueGoalType(goalType))) {
      throw ArgumentError.value(goalType, 'goalType');
    }
    if (goalValue < 1) {
      throw ArgumentError.value(goalValue, 'goalValue');
    }
    if (goalType != TaskGoalType.none && (goalWindowDays ?? 0) < 1) {
      throw ArgumentError.value(goalWindowDays, 'goalWindowDays');
    }
    if (goalType == TaskGoalType.valueSumMin &&
        bundleType == TaskValueBundleType.timeInterval) {
      throw StateError(
        'Zeitintervall-Buendel unterstuetzen keine Summenziele.',
      );
    }
    if (firstTaskId == secondTaskId) {
      throw ArgumentError.value(firstTaskId, 'secondTaskId');
    }
    if (firstTaskDayOffset != -1 && firstTaskDayOffset != 0) {
      throw ArgumentError.value(firstTaskDayOffset, 'firstTaskDayOffset');
    }
    if (secondTaskDayOffset != 0) {
      throw ArgumentError.value(secondTaskDayOffset, 'secondTaskDayOffset');
    }
    final isCrossDay = firstTaskDayOffset != 0 || secondTaskDayOffset != 0;
    if (isCrossDay &&
        (bundleType != TaskValueBundleType.timeInterval ||
            displayMode != TaskValueBundleDisplayMode.linkedCards)) {
      throw StateError(
        'Cross-Day-Buendel sind in Phase 13c.1 nur als verknuepfte '
        'Zeitintervall-Buendel erlaubt.',
      );
    }
    if (bundleType != TaskValueBundleType.timeInterval &&
        (firstTaskDayOffset != 0 || secondTaskDayOffset != 0)) {
      throw StateError(
        'Summe und Differenz bleiben in Phase 13c.1 Same-Day-Buendel.',
      );
    }

    final startsAt = _dateOnly(validFrom ?? _now());
    final firstTask = await _taskById(firstTaskId);
    final secondTask = await _taskById(secondTaskId);
    if (firstTask.trashedAt != null || secondTask.trashedAt != null) {
      throw StateError(
        'Aufgaben im Papierkorb können nicht zu einem Bündel verbunden werden.',
      );
    }

    if (!_areTasksCompatibleForBundle(
      firstTask: firstTask,
      secondTask: secondTask,
      bundleType: bundleType,
    )) {
      throw StateError(
        'Die Teil-Trackings sind fuer dieses Buendel ungueltig.',
      );
    }

    final now = _now().toUtc();
    final bundleId = _uuid.v4();
    final versionId = _uuid.v4();

    await _database.transaction(() async {
      await _database
          .into(_database.taskValueBundles)
          .insert(
            TaskValueBundlesCompanion.insert(
              id: bundleId,
              createdAt: Value(now),
              updatedAt: now,
            ),
          );

      await _database
          .into(_database.taskValueBundleVersions)
          .insert(
            TaskValueBundleVersionsCompanion.insert(
              id: versionId,
              bundleId: bundleId,
              versionNumber: 1,
              previousVersionId: const Value(null),
              validFrom: startsAt,
              validTo: const Value(null),
              createdAt: Value(now),
              updatedAt: Value(now),
              name: Value(name.trim()),
              description: Value(description.trim()),
              bundleType: bundleType,
              firstTaskId: firstTaskId,
              secondTaskId: secondTaskId,
              firstRoleLabel: Value(firstRoleLabel.trim()),
              secondRoleLabel: Value(secondRoleLabel.trim()),
              resultLabel: Value(resultLabel.trim()),
              direction: Value(direction),
              displayMode: Value(displayMode),
              goalType: Value(goalType),
              goalValue: Value(goalValue),
              goalWindowDays: Value(
                goalType == TaskGoalType.none ? null : goalWindowDays,
              ),
              firstTaskDayOffset: Value(firstTaskDayOffset),
              secondTaskDayOffset: Value(secondTaskDayOffset),
            ),
          );

      if (projectId != null) {
        final today = _dateOnly(_now());
        if (!startsAt.isAfter(today)) {
          await _projectAssignmentService.moveBundleAllHistory(
            bundleId: bundleId,
            targetProjectId: projectId,
          );
        } else {
          await _projectAssignmentService.assignBundleFromDate(
            bundleId: bundleId,
            targetProjectId: projectId,
            effectiveDate: today,
          );
        }
      }
    });

    return bundleId;
  }

  Future<List<TaskValueBundleForDate>> getValueBundlesForDate(
    DateTime date, {
    String taskType = TaskTypes.habit,
  }) async {
    final taskList = await watchTaskListForDate(date, taskType: taskType).first;
    return taskList.valueBundles;
  }

  Future<TaskValueBundleAnalyticsSummary>
  getTaskValueBundleAnalyticsSummaryForPeriodRange({
    required TaskValueBundleVersion version,
    required DateTime from,
    required DateTime to,
  }) {
    return _buildTaskValueBundleAnalyticsSummary(
      version: version,
      periodStart: _dateOnly(from),
      periodEnd: _dateOnly(to),
    );
  }

  Future<TaskValueGoalEvaluationSummary>
  getTaskValueBundleGoalEvaluationSummary({
    required TaskValueBundleVersion version,
    DateTime? today,
  }) async {
    final effectiveToday = _dateOnly(today ?? DateTime.now());
    final windowDays = goalWindowDaysForBundle(version);
    final periodEnd = effectiveToday;
    final periodStart = periodEnd.subtract(Duration(days: windowDays - 1));
    final summary = await _buildTaskValueBundleAnalyticsSummary(
      version: version,
      periodStart: periodStart,
      periodEnd: periodEnd,
    );

    final result = TaskValueGoalEvaluationSummary.fromBundleSummary(
      summary: summary,
      today: effectiveToday,
    );
    final interrupted =
        await _hasLifecycleInterruption(
          version.firstTaskId,
          periodStart.add(Duration(days: version.firstTaskDayOffset)),
          periodEnd.add(Duration(days: version.firstTaskDayOffset)),
        ) ||
        await _hasLifecycleInterruption(
          version.secondTaskId,
          periodStart.add(Duration(days: version.secondTaskDayOffset)),
          periodEnd.add(Duration(days: version.secondTaskDayOffset)),
        );
    return interrupted ? _notEvaluatedValueGoal(result) : result;
  }

  Stream<TaskValueGoalEvaluationSummary>
  watchTaskValueBundleGoalEvaluationSummary({
    required TaskValueBundleVersion version,
    DateTime? today,
  }) {
    final effectiveToday = _dateOnly(today ?? DateTime.now());
    final windowDays = goalWindowDaysForBundle(version);
    final periodEnd = effectiveToday;
    final periodStart = periodEnd.subtract(Duration(days: windowDays - 1));
    final query = _database.select(_database.taskEntries).join([
      leftOuterJoin(
        _database.taskEntryValues,
        _database.taskEntryValues.entryId.equalsExp(_database.taskEntries.id),
      ),
    ]);

    query.where(
      (_database.taskEntries.taskId.equals(version.firstTaskId) |
              _database.taskEntries.taskId.equals(version.secondTaskId)) &
          _database.taskEntries.scheduledDate.isBiggerOrEqualValue(
            periodStart.add(Duration(days: version.firstTaskDayOffset)),
          ) &
          _database.taskEntries.scheduledDate.isSmallerOrEqualValue(periodEnd),
    );

    return _watchWithCardMetricDependencies(query.watch(), (_) async {
      final summary = await _buildTaskValueBundleAnalyticsSummary(
        version: version,
        periodStart: periodStart,
        periodEnd: periodEnd,
      );

      final result = TaskValueGoalEvaluationSummary.fromBundleSummary(
        summary: summary,
        today: effectiveToday,
      );
      final interrupted =
          await _hasLifecycleInterruption(
            version.firstTaskId,
            periodStart.add(Duration(days: version.firstTaskDayOffset)),
            periodEnd.add(Duration(days: version.firstTaskDayOffset)),
          ) ||
          await _hasLifecycleInterruption(
            version.secondTaskId,
            periodStart.add(Duration(days: version.secondTaskDayOffset)),
            periodEnd.add(Duration(days: version.secondTaskDayOffset)),
          );
      return interrupted ? _notEvaluatedValueGoal(result) : result;
    });
  }

  Future<TaskValueBundleAnalyticsSummary>
  getTaskValueBundleAnalyticsSummaryForPeriod({
    required TaskValueBundleVersion version,
    required TaskAnalyticsPeriod period,
    DateTime? today,
  }) async {
    final referenceDate = _dateOnly(today ?? DateTime.now());
    final range = _bundleAnalyticsRange(
      version: version,
      period: period,
      today: referenceDate,
    );

    return _buildTaskValueBundleAnalyticsSummary(
      version: version,
      periodStart: range.start,
      periodEnd: range.end,
    );
  }

  Stream<TaskValueBundleAnalyticsSummary>
  watchTaskValueBundleAnalyticsSummaryForPeriod({
    required TaskValueBundleVersion version,
    required TaskAnalyticsPeriod period,
    DateTime? today,
  }) {
    final referenceDate = _dateOnly(today ?? DateTime.now());
    final range = _bundleAnalyticsRange(
      version: version,
      period: period,
      today: referenceDate,
    );
    final query = _database.select(_database.taskEntries).join([
      leftOuterJoin(
        _database.taskEntryValues,
        _database.taskEntryValues.entryId.equalsExp(_database.taskEntries.id),
      ),
    ]);

    query.where(
      (_database.taskEntries.taskId.equals(version.firstTaskId) |
              _database.taskEntries.taskId.equals(version.secondTaskId)) &
          _database.taskEntries.scheduledDate.isBiggerOrEqualValue(
            range.start,
          ) &
          _database.taskEntries.scheduledDate.isSmallerOrEqualValue(range.end),
    );

    return query.watch().asyncMap((_) {
      return _buildTaskValueBundleAnalyticsSummary(
        version: version,
        periodStart: range.start,
        periodEnd: range.end,
      );
    });
  }

  Future<void> dissolveValueBundle({
    required String bundleId,
    DateTime? validTo,
  }) async {
    final storedBundle =
        await (_database.select(_database.taskValueBundles)
          ..where((row) => row.id.equals(bundleId))).getSingle();
    if (storedBundle.trashedAt != null) {
      throw StateError('Ein Bündel im Papierkorb kann nicht aufgelöst werden.');
    }
    final endsAt = _dateOnly(validTo ?? _now());
    final bundleVersions =
        await (_database.select(_database.taskValueBundleVersions)
              ..where((version) => version.bundleId.equals(bundleId))
              ..orderBy([
                (version) => OrderingTerm.desc(version.versionNumber),
              ]))
            .get();
    final activeVersion =
        bundleVersions
            .where(
              (version) =>
                  version.validTo == null && version.cancelledAt == null,
            )
            .firstOrNull;

    if (!storedBundle.isActive || activeVersion == null) return;
    final now = _now().toUtc();
    await _database.transaction(() async {
      final createdAndDissolvedSameDay =
          !_dateOnly(activeVersion.validFrom).isBefore(endsAt);
      await (_database.update(_database.taskValueBundleVersions)
        ..where((version) => version.id.equals(activeVersion.id))).write(
        TaskValueBundleVersionsCompanion(
          validTo:
              createdAndDissolvedSameDay ? const Value(null) : Value(endsAt),
          cancelledAt:
              createdAndDissolvedSameDay ? Value(now) : const Value(null),
          updatedAt: Value(now),
        ),
      );

      await (_database.update(_database.taskValueBundles)
        ..where((bundle) => bundle.id.equals(bundleId))).write(
        TaskValueBundlesCompanion(
          isActive: const Value(false),
          updatedAt: Value(now),
        ),
      );
    });
  }

  Future<void> updateValueBundleMetadata({
    required String bundleId,
    required String name,
    required String description,
    DateTime? effectiveDate,
  }) async {
    final storedBundle =
        await (_database.select(_database.taskValueBundles)
          ..where((row) => row.id.equals(bundleId))).getSingle();
    if (storedBundle.trashedAt != null) {
      throw StateError('Ein Bündel im Papierkorb kann nicht geändert werden.');
    }
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Der Name darf nicht leer sein.');
    }
    final date = _dateOnly(effectiveDate ?? _now());
    final current = await _activeValueBundleVersionByBundleId(bundleId, date);
    if (current == null) {
      throw StateError('Das Bündel ist an diesem Tag nicht aktiv.');
    }
    final trimmedDescription = description.trim();
    if (current.name == trimmedName &&
        current.description == trimmedDescription) {
      return;
    }
    final now = _now().toUtc();
    await _database.transaction(() async {
      if (_dateOnly(current.validFrom) == date) {
        await (_database.update(_database.taskValueBundleVersions)
          ..where((version) => version.id.equals(current.id))).write(
          TaskValueBundleVersionsCompanion(
            name: Value(trimmedName),
            description: Value(trimmedDescription),
            updatedAt: Value(now),
          ),
        );
      } else {
        await (_database.update(_database.taskValueBundleVersions)
          ..where((version) => version.id.equals(current.id))).write(
          TaskValueBundleVersionsCompanion(
            validTo: Value(date),
            updatedAt: Value(now),
          ),
        );
        await _database
            .into(_database.taskValueBundleVersions)
            .insert(
              TaskValueBundleVersionsCompanion.insert(
                id: _uuid.v4(),
                bundleId: bundleId,
                versionNumber: current.versionNumber + 1,
                previousVersionId: Value(current.id),
                validFrom: date,
                createdAt: Value(now),
                updatedAt: Value(now),
                name: Value(trimmedName),
                description: Value(trimmedDescription),
                bundleType: current.bundleType,
                firstTaskId: current.firstTaskId,
                secondTaskId: current.secondTaskId,
                firstRoleLabel: Value(current.firstRoleLabel),
                secondRoleLabel: Value(current.secondRoleLabel),
                resultLabel: Value(current.resultLabel),
                direction: Value(current.direction),
                displayMode: Value(current.displayMode),
                goalType: Value(current.goalType),
                goalValue: Value(current.goalValue),
                goalWindowDays: Value(current.goalWindowDays),
                firstTaskDayOffset: Value(current.firstTaskDayOffset),
                secondTaskDayOffset: Value(current.secondTaskDayOffset),
              ),
            );
      }
      await (_database.update(_database.taskValueBundles)..where(
        (bundle) => bundle.id.equals(bundleId),
      )).write(TaskValueBundlesCompanion(updatedAt: Value(now)));
    });
  }

  SimpleSelectStatement<$TaskEntriesTable, TaskEntry> _analyticsEntriesQuery({
    String? taskId,
    DateTime? from,
    DateTime? to,
  }) {
    final startDate = from == null ? null : _dateOnly(from);
    final endDate = to == null ? null : _dateOnly(to);
    final query = _database.select(_database.taskEntries);
    final readableTaskIds =
        _database.selectOnly(_database.aufgaben)
          ..addColumns([_database.aufgaben.id])
          ..where(_database.aufgaben.trashedAt.isNull());

    query.where((entry) {
      Expression<bool> expression = entry.taskId.isInQuery(readableTaskIds);

      if (taskId != null) {
        expression = expression & entry.taskId.equals(taskId);
      }

      if (startDate != null) {
        expression =
            expression & entry.scheduledDate.isBiggerOrEqualValue(startDate);
      }

      if (endDate != null) {
        expression =
            expression & entry.scheduledDate.isSmallerOrEqualValue(endDate);
      }

      return expression;
    });

    return query;
  }

  _ValueAnalyticsRange _bundleAnalyticsRange({
    required TaskValueBundleVersion version,
    required TaskAnalyticsPeriod period,
    required DateTime today,
  }) {
    final start = period.rangeStart(
      taskStartDate: version.validFrom,
      today: today,
    );
    var end = period.rangeEnd(today);
    final validTo = version.validTo;

    if (validTo != null && _dateOnly(validTo).isBefore(end)) {
      end = _dateOnly(validTo).subtract(const Duration(days: 1));
    }

    return _ValueAnalyticsRange(start: start, end: end);
  }

  Future<TaskValueBundleAnalyticsSummary>
  _buildTaskValueBundleAnalyticsSummary({
    required TaskValueBundleVersion version,
    required DateTime periodStart,
    required DateTime periodEnd,
  }) async {
    final firstTask = await _taskByIdOrNull(version.firstTaskId);
    final secondTask = await _taskByIdOrNull(version.secondTaskId);
    final unavailableReason = await _bundleSourceUnavailableReason(
      firstTask: firstTask,
      secondTask: secondTask,
      firstTaskId: version.firstTaskId,
      secondTaskId: version.secondTaskId,
    );
    if (unavailableReason != null) {
      return TaskValueBundleAnalyticsSummary(
        version: version,
        periodStart: periodStart,
        periodEnd: periodEnd,
        completeCount: 0,
        partialCount: 0,
        missingCount: 0,
        notCalculableCount: 0,
        sum: null,
        average: null,
        minimum: null,
        maximum: null,
        points: const [],
        isAvailable: false,
        unavailableReason: unavailableReason,
      );
    }
    final availableFirstTask = firstTask!;
    final availableSecondTask = secondTask!;
    final pairsByTaskDate = await _taskEntryValuePairsByTaskDate(
      taskIds: {version.firstTaskId, version.secondTaskId},
      from: periodStart.add(Duration(days: version.firstTaskDayOffset)),
      to: periodEnd,
    );

    final points = <TaskValueBundleAnalyticsPoint>[];
    final values = <double>[];
    var completeCount = 0;
    var partialCount = 0;
    var missingCount = 0;
    var notCalculableCount = 0;

    if (!periodStart.isAfter(periodEnd)) {
      var date = periodStart;
      while (!date.isAfter(periodEnd)) {
        final firstDate = _bundleSourceDate(date, version.firstTaskDayOffset);
        final secondDate = _bundleSourceDate(date, version.secondTaskDayOffset);
        final firstDue = await _taskInstanceScheduler.isDueOnDate(
          availableFirstTask,
          firstDate,
        );
        final secondDue = await _taskInstanceScheduler.isDueOnDate(
          availableSecondTask,
          secondDate,
        );

        if (firstDue || secondDue) {
          final firstPair =
              pairsByTaskDate[_taskDateKey(availableFirstTask.id, firstDate)];
          final secondPair =
              pairsByTaskDate[_taskDateKey(availableSecondTask.id, secondDate)];
          final firstTaskForDate = TaskForDate(
            task: availableFirstTask,
            entry: firstPair?.entry,
            entryValue: firstPair?.entryValue,
            project: null,
          );
          final secondTaskForDate = TaskForDate(
            task: availableSecondTask,
            entry: secondPair?.entry,
            entryValue: secondPair?.entryValue,
            project: null,
          );
          final calculation = calculateTaskValueBundle(
            version: version,
            firstTask: firstTaskForDate,
            secondTask: secondTaskForDate,
          );
          final status = _bundleDisplayStatus(
            firstTask: firstTaskForDate,
            secondTask: secondTaskForDate,
            calculation: calculation,
          );
          final value = _bundleAnalyticsValueFor(
            version: version,
            calculation: calculation,
          );
          final bundleForDate = TaskValueBundleForDate(
            scheduledDate: date,
            bundle: TaskValueBundle(
              id: version.bundleId,
              createdAt: version.createdAt,
              updatedAt: version.createdAt,
              projectId: null,
              isActive: true,
              trashedAt: null,
              purgeAt: null,
              lifecycleRevision: 0,
              lifecycleUpdatedAt: null,
            ),
            version: version,
            firstTask: firstTaskForDate,
            secondTask: secondTaskForDate,
            calculation: calculation,
            status: status,
          );

          switch (status) {
            case TaskValueBundleDisplayStatus.complete:
              completeCount++;
              if (value == null) {
                notCalculableCount++;
              } else {
                values.add(value);
              }
              break;
            case TaskValueBundleDisplayStatus.partial:
              partialCount++;
              break;
            case TaskValueBundleDisplayStatus.empty:
              missingCount++;
              break;
            case TaskValueBundleDisplayStatus.notCalculable:
              notCalculableCount++;
              break;
          }

          points.add(
            TaskValueBundleAnalyticsPoint(
              scheduledDate: date,
              bundleForDate: bundleForDate,
              status: status,
              value: value,
            ),
          );
        }

        date = date.add(const Duration(days: 1));
      }
    }

    final canSum = version.bundleType != TaskValueBundleType.timeInterval;
    final total = values.fold<double>(0, (sum, value) => sum + value);
    final sum = canSum && values.isNotEmpty ? total : null;
    final average = values.isEmpty ? null : total / values.length;
    final minimum =
        values.isEmpty ? null : values.reduce((a, b) => a < b ? a : b);
    final maximum =
        values.isEmpty ? null : values.reduce((a, b) => a > b ? a : b);

    return TaskValueBundleAnalyticsSummary(
      version: version,
      periodStart: periodStart,
      periodEnd: periodEnd,
      completeCount: completeCount,
      partialCount: partialCount,
      missingCount: missingCount,
      notCalculableCount: notCalculableCount,
      sum: sum,
      average: average,
      minimum: minimum,
      maximum: maximum,
      points: points,
    );
  }

  Future<Map<String, _TaskEntryValuePair>> _taskEntryValuePairsByTaskDate({
    required Set<String> taskIds,
    required DateTime from,
    required DateTime to,
  }) async {
    if (taskIds.isEmpty || from.isAfter(to)) {
      return const {};
    }

    final query = _database.select(_database.taskEntries).join([
      leftOuterJoin(
        _database.taskEntryValues,
        _database.taskEntryValues.entryId.equalsExp(_database.taskEntries.id),
      ),
    ]);

    query.where(
      _database.taskEntries.taskId.isIn(taskIds) &
          _database.taskEntries.scheduledDate.isBiggerOrEqualValue(from) &
          _database.taskEntries.scheduledDate.isSmallerOrEqualValue(to),
    );

    final rows = await query.get();
    return {
      for (final row in rows)
        _taskDateKey(
          row.readTable(_database.taskEntries).taskId,
          row.readTable(_database.taskEntries).scheduledDate,
        ): _TaskEntryValuePair(
          entry: row.readTable(_database.taskEntries),
          entryValue: row.readTableOrNull(_database.taskEntryValues),
        ),
    };
  }

  double? _bundleAnalyticsValueFor({
    required TaskValueBundleVersion version,
    required TaskValueBundleCalculation? calculation,
  }) {
    if (calculation == null) {
      return null;
    }

    if (calculation.valueType == TaskValueType.duration) {
      return calculation.durationSeconds?.toDouble();
    }

    if (calculation.valueType == TaskValueType.number) {
      return calculation.numberValue;
    }

    return null;
  }

  Selectable<TypedResult> _taskValueAnalyticsRowsQuery({
    required String taskId,
    required DateTime from,
    required DateTime to,
  }) {
    final query = _database.select(_database.taskEntries).join([
      leftOuterJoin(
        _database.taskEntryValues,
        _database.taskEntryValues.entryId.equalsExp(_database.taskEntries.id),
      ),
    ]);

    query.where(
      _database.taskEntries.taskId.equals(taskId) &
          _database.taskEntries.scheduledDate.isBiggerOrEqualValue(from) &
          _database.taskEntries.scheduledDate.isSmallerOrEqualValue(to),
    );

    return query;
  }

  _ValueAnalyticsRange _valueAnalyticsRange({
    required Aufgabe task,
    required TaskAnalyticsPeriod period,
    required DateTime today,
  }) {
    final start = period.rangeStart(
      taskStartDate: task.startDate,
      today: today,
    );
    var end = period.rangeEnd(today);
    final taskEndDate = task.endDate;

    if (taskEndDate != null && _dateOnly(taskEndDate).isBefore(end)) {
      end = _dateOnly(taskEndDate);
    }

    return _ValueAnalyticsRange(start: start, end: end);
  }

  Future<TaskValueAnalyticsSummary> _buildTaskValueAnalyticsSummary({
    required Aufgabe task,
    required DateTime periodStart,
    required DateTime periodEnd,
    required List<TypedResult> rows,
  }) async {
    final points = <TaskValueAnalyticsPoint>[];
    final values = <double>[];
    var recordedCount = 0;
    final entryDates = <DateTime>{};
    var pendingCount = 0;
    var noEntryCount = 0;
    var failureCount = 0;
    var notCalculableCount = 0;

    for (final row in rows) {
      final entry = row.readTable(_database.taskEntries);
      final entryValue = row.readTableOrNull(_database.taskEntryValues);
      final scheduledDate = _dateOnly(entry.scheduledDate);
      entryDates.add(scheduledDate);

      double? value;
      switch (entry.status) {
        case TaskEntryStatus.recorded:
          recordedCount++;
          final historicalTask = await _definitionResolver.taskForEntry(
            task,
            entry,
          );
          value = _analyticsValueFor(
            task: historicalTask,
            entryValue: entryValue,
          );
          if (value == null) {
            notCalculableCount++;
          } else {
            values.add(value);
          }
          break;
        case TaskEntryStatus.pending:
          pendingCount++;
          break;
        case TaskEntryStatus.noEntry:
          noEntryCount++;
          break;
        case TaskEntryStatus.failure:
          failureCount++;
          break;
      }

      points.add(
        TaskValueAnalyticsPoint(
          scheduledDate: scheduledDate,
          status: entry.status,
          value: value,
          entry: entry,
          entryValue: entryValue,
        ),
      );
    }

    var virtualMissingCount = 0;
    if (_isPureTrackingTask(task) && !periodStart.isAfter(periodEnd)) {
      var date = periodStart;
      while (!date.isAfter(periodEnd)) {
        if (!entryDates.contains(date) &&
            await _taskInstanceScheduler.isDueOnDate(task, date)) {
          virtualMissingCount++;
          points.add(
            TaskValueAnalyticsPoint(
              scheduledDate: date,
              status: TaskValueAnalyticsPointStatus.virtualMissing,
              isVirtualMissing: true,
            ),
          );
        }
        date = date.add(const Duration(days: 1));
      }
    }

    points.sort((first, second) {
      return first.scheduledDate.compareTo(second.scheduledDate);
    });

    final hasIncompatibleDefinitions =
        await _hasIncompatibleTaskValueDefinitions(
          task,
          periodStart,
          periodEnd,
          includeRhythm: false,
        );

    final sum =
        hasIncompatibleDefinitions ||
                task.valueType == TaskValueType.timeOfDay ||
                values.isEmpty
            ? null
            : values.fold<double>(0, (total, value) => total + value);
    final average =
        hasIncompatibleDefinitions || values.isEmpty
            ? null
            : values.fold<double>(0, (total, value) => total + value) /
                values.length;
    final minimum =
        hasIncompatibleDefinitions || values.isEmpty
            ? null
            : values.reduce((a, b) => a < b ? a : b);
    final maximum =
        hasIncompatibleDefinitions || values.isEmpty
            ? null
            : values.reduce((a, b) => a > b ? a : b);

    return TaskValueAnalyticsSummary(
      valueType: task.valueType,
      unitKey: task.valueUnitKey,
      unitLabel: _taskValueUnitLabel(task),
      periodStart: periodStart,
      periodEnd: periodEnd,
      recordedCount: recordedCount,
      virtualMissingCount: virtualMissingCount,
      pendingCount: pendingCount,
      noEntryCount: noEntryCount,
      failureCount: failureCount,
      notCalculableCount: notCalculableCount,
      sum: sum,
      average: average,
      minimum: minimum,
      maximum: maximum,
      points: points,
      isAggregateAvailable: !hasIncompatibleDefinitions,
      aggregateUnavailableReason:
          hasIncompatibleDefinitions
              ? 'In diesem Zeitraum wurden Wertart oder Einheit geändert. '
                  'Die Rohwerte bleiben sichtbar, werden aber nicht vermischt.'
              : null,
    );
  }

  double? _analyticsValueFor({
    required Aufgabe task,
    required TaskEntryValue? entryValue,
  }) {
    if (entryValue == null) {
      return null;
    }

    switch (task.valueType) {
      case TaskValueType.number:
        return entryValue.numberValue;
      case TaskValueType.duration:
        return entryValue.durationSeconds?.toDouble();
      case TaskValueType.timeOfDay:
        final timeMinutes = entryValue.timeMinutes;
        if (timeMinutes == null) {
          return null;
        }
        return (timeMinutes + entryValue.dayOffset * 24 * 60).toDouble();
    }

    return null;
  }

  String _taskValueUnitLabel(Aufgabe task) {
    if (task.valueUnitLabel.trim().isNotEmpty) {
      return task.valueUnitLabel.trim();
    }

    return TaskValueUnits.byKey(task.valueUnitKey)?.label ?? '';
  }

  TaskAnalyticsSummary _buildTaskAnalyticsSummary({
    required List<TaskEntry> entries,
    DateTime? today,
  }) {
    final referenceDate = _dateOnly(today ?? DateTime.now());

    var successCount = 0;
    var recordedCount = 0;
    var failureCount = 0;
    var noEntryCount = 0;
    var pendingCount = 0;
    var dueCount = 0;
    var overdueEntryCount = 0;
    var overdueDays = 0;
    var bufferCompletionCount = 0;
    var manualResolutionCount = 0;
    var automaticResolutionCount = 0;

    for (final entry in entries) {
      final scheduledDate = _dateOnly(entry.scheduledDate);
      switch (entry.status) {
        case TaskEntryStatus.success:
          successCount++;
          break;
        case TaskEntryStatus.recorded:
          recordedCount++;
          break;
        case TaskEntryStatus.failure:
          failureCount++;
          break;
        case TaskEntryStatus.noEntry:
          noEntryCount++;
          break;
        case TaskEntryStatus.pending:
          pendingCount++;
          break;
      }

      if (TaskEntryStatus.isResolved(entry.status) &&
          !scheduledDate.isAfter(referenceDate)) {
        dueCount++;
      }

      if (TaskEntryStatus.isResolved(entry.status)) {
        if (entry.resolutionOrigin == TaskEntryResolutionOrigin.manual) {
          manualResolutionCount++;
        } else if (entry.resolutionOrigin ==
            TaskEntryResolutionOrigin.automatic) {
          automaticResolutionCount++;
        }

        if (entry.appliedMissedPolicy == MissedPolicy.buffer &&
            entry.resolutionOrigin == TaskEntryResolutionOrigin.manual) {
          bufferCompletionCount++;
        }
      }

      if (entry.status == TaskEntryStatus.pending &&
          scheduledDate.isBefore(referenceDate)) {
        overdueEntryCount++;
        overdueDays += referenceDate.difference(scheduledDate).inDays;
      }
    }

    return TaskAnalyticsSummary(
      dueCount: dueCount,
      totalInstanceCount: entries.length,
      successCount: successCount,
      recordedCount: recordedCount,
      failureCount: failureCount,
      noEntryCount: noEntryCount,
      pendingCount: pendingCount,
      overdueEntryCount: overdueEntryCount,
      overdueDays: overdueDays,
      bufferCompletionCount: bufferCompletionCount,
      manualResolutionCount: manualResolutionCount,
      automaticResolutionCount: automaticResolutionCount,
    );
  }

  OneTimeTaskAnalyticsSummary _buildOneTimeTaskAnalyticsSummary({
    required List<TypedResult> rows,
    required DateTime today,
  }) {
    var totalCount = 0;
    var successCount = 0;
    var recordedCount = 0;
    var failureCount = 0;
    var noEntryCount = 0;
    var pendingCount = 0;
    var beforeDueCount = 0;
    var onDueCount = 0;
    var afterDueCount = 0;
    var manualResolutionCount = 0;
    var automaticResolutionCount = 0;
    var totalDaysToCompletion = 0;
    var completedWithDurationCount = 0;
    var totalDueDeviationDays = 0;
    var completedWithDueDateCount = 0;
    var totalCurrentOverdueDays = 0;
    var currentOverdueCount = 0;

    for (final row in rows) {
      final task = row.readTable(_database.aufgaben);
      final entry = row.readTableOrNull(_database.taskEntries);
      final status = entry?.status ?? TaskEntryStatus.pending;
      totalCount++;

      switch (status) {
        case TaskEntryStatus.success:
          successCount++;
          break;
        case TaskEntryStatus.recorded:
          recordedCount++;
          break;
        case TaskEntryStatus.failure:
          failureCount++;
          break;
        case TaskEntryStatus.noEntry:
          noEntryCount++;
          break;
        case TaskEntryStatus.pending:
          pendingCount++;
          break;
      }

      final completionTime = _completionTime(entry);
      if (completionTime != null) {
        final start = _dateOnly(task.startDate);
        final end = _dateOnly(completionTime);
        totalDaysToCompletion += end.difference(start).inDays;
        completedWithDurationCount++;

        if (task.dueDate != null) {
          final deviation = end.difference(_dateOnly(task.dueDate!)).inDays;
          totalDueDeviationDays += deviation;
          completedWithDueDateCount++;

          if (deviation < 0) {
            beforeDueCount++;
          } else if (deviation == 0) {
            onDueCount++;
          } else {
            afterDueCount++;
          }
        }
      } else if (task.dueDate != null &&
          _dateOnly(task.dueDate!).isBefore(today)) {
        currentOverdueCount++;
        totalCurrentOverdueDays +=
            today.difference(_dateOnly(task.dueDate!)).inDays;
      }

      if (TaskEntryStatus.isResolved(status)) {
        if (entry?.resolutionOrigin == TaskEntryResolutionOrigin.manual) {
          manualResolutionCount++;
        } else if (entry?.resolutionOrigin ==
            TaskEntryResolutionOrigin.automatic) {
          automaticResolutionCount++;
        }
      }
    }

    return OneTimeTaskAnalyticsSummary(
      totalCount: totalCount,
      successCount: successCount,
      recordedCount: recordedCount,
      failureCount: failureCount,
      noEntryCount: noEntryCount,
      pendingCount: pendingCount,
      beforeDueCount: beforeDueCount,
      onDueCount: onDueCount,
      afterDueCount: afterDueCount,
      manualResolutionCount: manualResolutionCount,
      automaticResolutionCount: automaticResolutionCount,
      totalDaysToCompletion: totalDaysToCompletion,
      completedWithDurationCount: completedWithDurationCount,
      totalDueDeviationDays: totalDueDeviationDays,
      completedWithDueDateCount: completedWithDueDateCount,
      totalCurrentOverdueDays: totalCurrentOverdueDays,
      currentOverdueCount: currentOverdueCount,
    );
  }

  Future<void> setTaskCompleted({
    required String taskId,
    required DateTime scheduledDate,
    required bool isCompleted,
    DateTime? performedOn,
  }) async {
    await _lifecycleService.ensureTaskWritable(taskId);
    final date = _dateOnly(scheduledDate);
    final performedDate =
        isCompleted
            ? performedOn == null
                ? date
                : await _validatedPerformedOn(taskId, performedOn)
            : null;
    final now = DateTime.now();
    final definitionVersionId = await _definitionVersionIdForEntry(
      taskId,
      date,
    );
    final existingEntry = await _entryForTaskDate(taskId, date);
    final planningOrigin = await _planningOriginForEntry(
      taskId,
      date,
      existingEntry,
    );
    if (existingEntry != null &&
        (existingEntry.status != TaskEntryStatus.pending ||
            existingEntry.checkboxValue != null)) {
      await _correctionService.applyStatusCorrections(
        taskId: taskId,
        targets: [
          TaskStatusCorrectionTarget(
            entryId: existingEntry.id,
            status:
                isCompleted ? TaskEntryStatus.success : TaskEntryStatus.pending,
            checkboxValue: isCompleted ? true : null,
            performedOn: performedDate,
          ),
        ],
      );
      return;
    }

    await _database
        .into(_database.taskEntries)
        .insertOnConflictUpdate(
          TaskEntriesCompanion.insert(
            id: existingEntry?.id ?? _uuid.v4(),
            taskId: taskId,
            taskDefinitionVersionId: Value(definitionVersionId),
            scheduledDate: date,
            createdAt: Value(existingEntry?.createdAt ?? now),
            status: Value(
              isCompleted ? TaskEntryStatus.success : TaskEntryStatus.pending,
            ),
            updatedAt: now,
            respondedAt: Value(isCompleted ? now : null),
            finalizedAt: Value(isCompleted ? now : null),
            effectiveAt: Value(isCompleted ? performedDate : null),
            performedOn: Value(isCompleted ? performedDate : null),
            performedOnSource: Value(
              isCompleted ? TaskEntryPerformedOnSource.user : null,
            ),
            resolutionOrigin: Value(
              isCompleted ? TaskEntryResolutionOrigin.manual : null,
            ),
            appliedMissedPolicy: const Value(null),
            appliedMissedConsequence: const Value(null),
            checkboxValue: Value(isCompleted),
            revision: Value((existingEntry?.revision ?? -1) + 1),
            planningOrigin: Value(planningOrigin),
          ),
        );
  }

  Future<void> setBooleanHabitValue({
    required Aufgabe task,
    required DateTime scheduledDate,
    required bool? value,
    DateTime? performedOn,
  }) async {
    await _lifecycleService.ensureTaskWritable(task.id);
    final date = _dateOnly(scheduledDate);
    final now = DateTime.now();
    final isPending = value == null;
    final isSuccessful = value != null && value == task.successValue;
    final performedDate =
        isSuccessful
            ? performedOn == null
                ? date
                : await _validatedPerformedOn(task.id, performedOn)
            : null;
    final definitionVersionId = await _definitionVersionIdForEntry(
      task.id,
      date,
    );
    final existingEntry = await _entryForTaskDate(task.id, date);
    final planningOrigin = await _planningOriginForEntry(
      task.id,
      date,
      existingEntry,
    );
    if (existingEntry != null &&
        (existingEntry.status != TaskEntryStatus.pending ||
            existingEntry.checkboxValue != null)) {
      await _correctionService.applyStatusCorrections(
        taskId: task.id,
        targets: [
          TaskStatusCorrectionTarget(
            entryId: existingEntry.id,
            status:
                isPending
                    ? TaskEntryStatus.pending
                    : isSuccessful
                    ? TaskEntryStatus.success
                    : TaskEntryStatus.failure,
            checkboxValue: value,
            performedOn: performedDate,
          ),
        ],
      );
      return;
    }

    await _database
        .into(_database.taskEntries)
        .insertOnConflictUpdate(
          TaskEntriesCompanion.insert(
            id: existingEntry?.id ?? _uuid.v4(),
            taskId: task.id,
            taskDefinitionVersionId: Value(definitionVersionId),
            scheduledDate: date,
            createdAt: Value(existingEntry?.createdAt ?? now),
            status: Value(
              isPending
                  ? TaskEntryStatus.pending
                  : isSuccessful
                  ? TaskEntryStatus.success
                  : TaskEntryStatus.failure,
            ),
            updatedAt: now,
            respondedAt: Value(isPending ? null : now),
            finalizedAt: Value(isPending ? null : now),
            effectiveAt: Value(
              isPending
                  ? null
                  : isSuccessful
                  ? performedDate
                  : now,
            ),
            performedOn: Value(isSuccessful ? performedDate : null),
            performedOnSource: Value(
              isSuccessful ? TaskEntryPerformedOnSource.user : null,
            ),
            resolutionOrigin: Value(
              isPending ? null : TaskEntryResolutionOrigin.manual,
            ),
            appliedMissedPolicy: const Value(null),
            appliedMissedConsequence: const Value(null),
            checkboxValue: Value(value),
            revision: Value((existingEntry?.revision ?? -1) + 1),
            planningOrigin: Value(planningOrigin),
          ),
        );
  }

  Future<void> setTaskEntryNoEntry({
    required Aufgabe task,
    required DateTime scheduledDate,
    required String reason,
  }) async {
    await _lifecycleService.ensureTaskWritable(task.id);
    final date = _dateOnly(scheduledDate);
    final now = DateTime.now();
    final definitionVersionId = await _definitionVersionIdForEntry(
      task.id,
      date,
    );
    final existingEntry = await _entryForTaskDate(task.id, date);
    final planningOrigin = await _planningOriginForEntry(
      task.id,
      date,
      existingEntry,
    );
    if (existingEntry != null &&
        existingEntry.status != TaskEntryStatus.pending) {
      await _correctionService.applyStatusCorrections(
        taskId: task.id,
        targets: [
          TaskStatusCorrectionTarget(
            entryId: existingEntry.id,
            status: TaskEntryStatus.noEntry,
          ),
        ],
        reason: reason,
      );
      return;
    }

    await _database
        .into(_database.taskEntries)
        .insertOnConflictUpdate(
          TaskEntriesCompanion.insert(
            id: existingEntry?.id ?? _uuid.v4(),
            taskId: task.id,
            taskDefinitionVersionId: Value(definitionVersionId),
            scheduledDate: date,
            createdAt: Value(existingEntry?.createdAt ?? now),
            status: const Value(TaskEntryStatus.noEntry),
            updatedAt: now,
            respondedAt: Value(now),
            finalizedAt: const Value(null),
            effectiveAt: const Value(null),
            resolutionOrigin: const Value(TaskEntryResolutionOrigin.manual),
            appliedMissedPolicy: const Value(null),
            appliedMissedConsequence: const Value(null),
            checkboxValue: const Value(null),
            note: Value(reason.trim()),
            revision: Value((existingEntry?.revision ?? -1) + 1),
            planningOrigin: Value(planningOrigin),
          ),
        );
  }

  Future<void> setTaskEntryValue({
    required Aufgabe task,
    required DateTime scheduledDate,
    required String valueType,
    double? numberValue,
    int? durationSeconds,
    int? timeMinutes,
    int dayOffset = 0,
    DateTime? performedOn,
  }) async {
    await _lifecycleService.ensureTaskWritable(task.id);
    if (!TaskValueType.phase12Values.contains(valueType)) {
      throw ArgumentError.value(valueType, 'valueType');
    }

    final date = _dateOnly(scheduledDate);
    final performedDate =
        performedOn == null
            ? date
            : await _validatedPerformedOn(task.id, performedOn);
    final now = DateTime.now();
    final existingEntry = await _entryForTaskDate(task.id, date);
    final planningOrigin = await _planningOriginForEntry(
      task.id,
      date,
      existingEntry,
    );
    final entryId = existingEntry?.id ?? _uuid.v4();
    final definitionVersionId = await _definitionVersionIdForEntry(
      task.id,
      date,
    );
    final unitDefinition = TaskValueUnits.byKey(task.valueUnitKey);
    final normalizedNumberValue =
        numberValue == null
            ? null
            : numberValue * (unitDefinition?.factorToBaseUnit ?? 1);
    final existingValue =
        await (_database.select(_database.taskEntryValues)
          ..where((value) => value.entryId.equals(entryId))).getSingleOrNull();

    if (existingEntry != null &&
        (existingValue != null ||
            existingEntry.status != TaskEntryStatus.pending)) {
      await _correctionService.replaceValue(
        taskId: task.id,
        entryId: entryId,
        valueType: valueType,
        numberValue: numberValue,
        normalizedNumberValue: normalizedNumberValue,
        unitKey: task.valueUnitKey,
        unitLabel: task.valueUnitLabel,
        durationSeconds: durationSeconds,
        timeMinutes: timeMinutes,
        dayOffset: dayOffset,
        performedOn: performedDate,
      );
      return;
    }

    await _database.transaction(() async {
      await _database
          .into(_database.taskEntries)
          .insertOnConflictUpdate(
            TaskEntriesCompanion.insert(
              id: entryId,
              taskId: task.id,
              taskDefinitionVersionId: Value(definitionVersionId),
              scheduledDate: date,
              createdAt: Value(existingEntry?.createdAt ?? now),
              status: const Value(TaskEntryStatus.recorded),
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
              note: Value(existingEntry?.note ?? ''),
              revision: Value((existingEntry?.revision ?? -1) + 1),
              planningOrigin: Value(planningOrigin),
            ),
          );

      await _database
          .into(_database.taskEntryValues)
          .insertOnConflictUpdate(
            TaskEntryValuesCompanion.insert(
              id: existingValue?.id ?? _uuid.v4(),
              entryId: entryId,
              valueType: valueType,
              numberValue: Value(numberValue),
              normalizedNumberValue: Value(normalizedNumberValue),
              unitKey: Value(task.valueUnitKey),
              unitLabel: Value(task.valueUnitLabel),
              durationSeconds: Value(durationSeconds),
              timeMinutes: Value(timeMinutes),
              dayOffset: Value(dayOffset),
              createdAt: Value(existingValue?.createdAt ?? now),
              updatedAt: now,
            ),
          );
    });
  }

  Future<void> setTaskEntryNote({
    required String taskId,
    required DateTime scheduledDate,
    required String note,
  }) async {
    await _lifecycleService.ensureTaskWritable(taskId);
    final date = _dateOnly(scheduledDate);
    final existingEntry = await _entryForTaskDate(taskId, date);
    final planningOrigin = await _planningOriginForEntry(
      taskId,
      date,
      existingEntry,
    );
    final entryId = existingEntry?.id ?? _uuid.v4();
    final definitionVersionId =
        existingEntry?.taskDefinitionVersionId ??
        await _definitionVersionWriter.currentVersionId(taskId);

    if (existingEntry != null) {
      await _correctionService.correctNote(
        taskId: taskId,
        entryId: entryId,
        note: note,
      );
      return;
    }

    await _database
        .into(_database.taskEntries)
        .insertOnConflictUpdate(
          TaskEntriesCompanion.insert(
            id: entryId,
            taskId: taskId,
            taskDefinitionVersionId: Value(definitionVersionId),
            scheduledDate: date,
            createdAt: Value(existingEntry?.createdAt ?? DateTime.now()),
            status: Value(existingEntry?.status ?? TaskEntryStatus.pending),
            updatedAt: DateTime.now(),
            respondedAt: Value(existingEntry?.respondedAt),
            finalizedAt: Value(existingEntry?.finalizedAt),
            effectiveAt: Value(existingEntry?.effectiveAt),
            resolutionOrigin: Value(existingEntry?.resolutionOrigin),
            appliedMissedPolicy: Value(existingEntry?.appliedMissedPolicy),
            appliedMissedConsequence: Value(
              existingEntry?.appliedMissedConsequence,
            ),
            checkboxValue: Value(existingEntry?.checkboxValue),
            numberValue: Value(existingEntry?.numberValue),
            note: Value(note.trim()),
            revision: Value((existingEntry?.revision ?? -1) + 1),
            planningOrigin: Value(planningOrigin),
          ),
        );
  }

  Future<void> deleteTask(String taskId) async {
    await moveTaskToTrash(await previewTaskDeletion(taskId));
  }

  Future<void> updateTask({
    required String taskId,
    required String name,
    required String description,
    required String? projectId,
    required String taskType,
    required DateTime startDate,
    required DateTime? dueDate,
    required String questionText,
    required bool successValue,
    required Set<int> activeWeekdays,
    required String recurrence,
    String? missedPolicy,
    String? missedConsequence,
    int? missedBufferDays,
    String? postBufferBehavior,
    int? maxCarryoverCount,
    String? goalType,
    int? goalValue,
    int? goalWindowDays,
    String? goalPeriod,
    String? goalPeriodAlignment,
    String? valueType,
    String? valueCommitment,
    String? valueUnitKey,
    String? valueUnitLabel,
  }) async {
    await _lifecycleService.ensureTaskWritable(taskId);
    await _database.transaction(() async {
      final previousTask =
          await (_database.select(_database.aufgaben)
            ..where((task) => task.id.equals(taskId))).getSingle();

      if (previousTask.taskType != taskType ||
          _dateOnly(previousTask.startDate) != _dateOnly(startDate) ||
          (valueType != null && previousTask.valueType != valueType) ||
          (valueCommitment != null &&
              previousTask.valueCommitment != valueCommitment) ||
          (valueUnitKey != null && previousTask.valueUnitKey != valueUnitKey) ||
          (valueUnitLabel != null &&
              previousTask.valueUnitLabel.trim() != valueUnitLabel.trim())) {
        throw StateError(
          'Aufgabenart, Startdatum und Messkonfiguration sind nach der '
          'Erstellung gesperrt. Verwende „Als neue Aufgabe kopieren“.',
        );
      }

      final nextActiveWeekdays = _encodeWeekdays(activeWeekdays);
      final nextName = name.trim();
      final nextDescription = description.trim();
      final nextQuestionText = questionText.trim();
      final nextDueDate = dueDate == null ? null : _dateOnly(dueDate);
      final scheduleChanged =
          previousTask.activeWeekdays != nextActiveWeekdays ||
          previousTask.recurrence != recurrence ||
          (missedPolicy != null && previousTask.missedPolicy != missedPolicy) ||
          (missedConsequence != null &&
              previousTask.missedConsequence != missedConsequence) ||
          (missedBufferDays != null &&
              previousTask.missedBufferDays != missedBufferDays) ||
          (postBufferBehavior != null &&
              previousTask.postBufferBehavior != postBufferBehavior) ||
          (maxCarryoverCount != null &&
              previousTask.maxCarryoverCount != maxCarryoverCount);
      final hasGoalUpdate =
          goalType != null ||
          goalValue != null ||
          goalWindowDays != null ||
          goalPeriod != null ||
          goalPeriodAlignment != null;
      final nextGoalWindowDays =
          goalWindowDays ??
          (goalType == TaskGoalType.none ? null : previousTask.goalWindowDays);
      final goalChanged =
          (goalType != null && previousTask.goalType != goalType) ||
          (goalValue != null && previousTask.goalValue != goalValue) ||
          (hasGoalUpdate &&
              previousTask.goalWindowDays != nextGoalWindowDays) ||
          (goalPeriod != null && previousTask.goalPeriod != goalPeriod) ||
          (goalPeriodAlignment != null &&
              previousTask.goalPeriodAlignment != goalPeriodAlignment);
      final dueDateChanged = previousTask.dueDate != nextDueDate;
      final projectChanged = previousTask.projectId != projectId;
      final textChanged =
          previousTask.name != nextName ||
          previousTask.beschreibung != nextDescription ||
          previousTask.questionText != nextQuestionText;
      final successValueChanged = previousTask.successValue != successValue;
      final directGoalChanged = !scheduleChanged && goalChanged;
      final taskRowChanged =
          textChanged ||
          successValueChanged ||
          dueDateChanged ||
          directGoalChanged;

      if (scheduleChanged) {
        final tomorrow = _nextLocalDay(_now());
        await _definitionResolver.scheduleChange(
          taskId: taskId,
          group: TaskPendingDefinitionChangeGroup.schedule,
          effectiveDate: tomorrow,
          payloadJson:
              TaskScheduleChangePayload(
                activeWeekdays: nextActiveWeekdays,
                recurrence: recurrence,
                missedPolicy: missedPolicy ?? previousTask.missedPolicy,
                missedConsequence:
                    missedConsequence ?? previousTask.missedConsequence,
                missedBufferDays:
                    missedBufferDays ?? previousTask.missedBufferDays,
                postBufferBehavior:
                    postBufferBehavior ?? previousTask.postBufferBehavior,
                maxCarryoverCount:
                    maxCarryoverCount ?? previousTask.maxCarryoverCount,
              ).encode(),
        );
        if (goalChanged) {
          await _definitionResolver.scheduleChange(
            taskId: taskId,
            group: TaskPendingDefinitionChangeGroup.goal,
            effectiveDate: tomorrow,
            payloadJson:
                TaskGoalChangePayload(
                  goalType: goalType ?? previousTask.goalType,
                  goalValue: goalValue ?? previousTask.goalValue,
                  goalWindowDays: nextGoalWindowDays,
                  goalPeriod: goalPeriod ?? previousTask.goalPeriod,
                  goalPeriodAlignment:
                      goalPeriodAlignment ?? previousTask.goalPeriodAlignment,
                ).encode(),
          );
        }
      }

      String? rescheduledEntryId;
      if (dueDateChanged) {
        rescheduledEntryId = await _rescheduleOneTimeEntry(
          task: previousTask,
          newDueDate: nextDueDate,
        );
      }

      if (taskRowChanged) {
        final changedAt = _now().toUtc();
        await (_database.update(_database.aufgaben)
          ..where((task) => task.id.equals(taskId))).write(
          AufgabenCompanion(
            name: Value(nextName),
            beschreibung: Value(nextDescription),
            questionText: Value(nextQuestionText),
            successValue: Value(successValue),
            dueDate: Value(nextDueDate),
            goalType:
                directGoalChanged && goalType != null
                    ? Value(goalType)
                    : const Value.absent(),
            goalValue:
                directGoalChanged && goalValue != null
                    ? Value(goalValue)
                    : const Value.absent(),
            goalWindowDays:
                directGoalChanged
                    ? Value(nextGoalWindowDays)
                    : const Value.absent(),
            goalPeriod:
                directGoalChanged && goalPeriod != null
                    ? Value(goalPeriod)
                    : const Value.absent(),
            goalPeriodAlignment:
                directGoalChanged && goalPeriodAlignment != null
                    ? Value(goalPeriodAlignment)
                    : const Value.absent(),
            updatedAt: Value(changedAt),
          ),
        );
      }

      if (projectChanged) {
        await _projectAssignmentService.assignFromDate(
          taskId: taskId,
          targetProjectId: projectId,
          effectiveDate: _dateOnly(_now()),
        );
      }

      final updatedTask =
          await (_database.select(_database.aufgaben)
            ..where((task) => task.id.equals(taskId))).getSingle();
      if (textChanged ||
          successValueChanged ||
          dueDateChanged ||
          directGoalChanged) {
        final versionId = await _definitionVersionWriter.createVersion(
          updatedTask,
          createdAt: updatedTask.updatedAt,
        );
        if (rescheduledEntryId != null) {
          final rescheduledEntry =
              await (_database.select(_database.taskEntries)..where(
                (entry) => entry.id.equals(rescheduledEntryId!),
              )).getSingle();
          await (_database.update(_database.taskEntries)
            ..where((entry) => entry.id.equals(rescheduledEntryId!))).write(
            TaskEntriesCompanion(
              taskDefinitionVersionId: Value(versionId),
              revision: Value(rescheduledEntry.revision + 1),
            ),
          );
        }
      }
    });
  }

  Future<String?> _rescheduleOneTimeEntry({
    required Aufgabe task,
    required DateTime? newDueDate,
  }) async {
    if (task.taskType != TaskTypes.task ||
        task.recurrence != HabitRecurrence.none) {
      throw StateError(
        'Nur eine offene einmalige Aufgabe kann einen Termin verschieben.',
      );
    }
    final normalizedDueDate = newDueDate == null ? null : _dateOnly(newDueDate);
    final today = _dateOnly(_now());
    if (normalizedDueDate != null && normalizedDueDate.isBefore(today)) {
      throw StateError(
        'Der neue Termin muss heute oder in der Zukunft liegen.',
      );
    }
    final entries =
        await (_database.select(_database.taskEntries)
          ..where((entry) => entry.taskId.equals(task.id))).get();
    if (entries.length > 1) {
      throw StateError(
        'Die einmalige Aufgabe besitzt mehrere Einträge und kann nicht sicher '
        'verschoben werden.',
      );
    }
    final existing = entries.firstOrNull;
    if (existing != null && TaskEntryStatus.isResolved(existing.status)) {
      throw StateError(
        'Abgeschlossene Aufgaben behalten ihren damaligen Termin. Erstelle '
        'für einen neuen Versuch eine Kopie.',
      );
    }
    final now = _now().toUtc();
    if (existing == null) {
      if (normalizedDueDate == null) {
        return null;
      }
      final id = _uuid.v4();
      await _database
          .into(_database.taskEntries)
          .insert(
            TaskEntriesCompanion.insert(
              id: id,
              taskId: task.id,
              taskDefinitionVersionId: Value(
                await _definitionVersionWriter.currentVersionId(task.id),
              ),
              scheduledDate: normalizedDueDate,
              createdAt: Value(now),
              updatedAt: now,
            ),
          );
      return id;
    }
    await (_database.update(_database.taskEntries)
      ..where((entry) => entry.id.equals(existing.id))).write(
      TaskEntriesCompanion(
        scheduledDate:
            normalizedDueDate == null
                ? const Value.absent()
                : Value(normalizedDueDate),
        originalScheduledDate: Value(
          existing.originalScheduledDate ?? existing.scheduledDate,
        ),
        updatedAt: Value(now),
        revision: Value(existing.revision + 1),
      ),
    );
    return existing.id;
  }

  Future<void> createTask({
    required String name,
    required String beschreibung,
    required String erfassungsmodus,
    required String? projectId,
    String taskType = TaskTypes.habit,
    DateTime? startDate,
    DateTime? dueDate,
    String questionText = '',
    bool successValue = true,
    Set<int> activeWeekdays = const {1, 2, 3, 4, 5, 6, 7},
    String recurrence = HabitRecurrence.daily,
    String missedPolicy = MissedPolicy.none,
    String missedConsequence = MissedConsequence.markAsNotDone,
    int missedBufferDays = 1,
    String postBufferBehavior = PostBufferBehavior.markAsFailure,
    int maxCarryoverCount = 3,
    String goalType = TaskGoalType.none,
    int goalValue = 1,
    int? goalWindowDays,
    String goalPeriod = GoalPeriod.week,
    String goalPeriodAlignment = GoalPeriodAlignment.calendar,
    String valueType = TaskValueType.none,
    String valueCommitment = 'none',
    String valueUnitKey = TaskValueUnitKey.none,
    String valueUnitLabel = '',
  }) {
    final taskId = _uuid.v4();
    final clock = _now();
    final now = clock.toUtc();
    final today = _dateOnly(clock);
    final selectedStartDate = startDate == null ? today : _dateOnly(startDate);
    final selectedDueDate = dueDate == null ? null : _dateOnly(dueDate);
    final initialEntryDate =
        taskType == TaskTypes.task &&
                recurrence == HabitRecurrence.none &&
                selectedDueDate != null
            ? selectedDueDate
            : selectedStartDate;
    final shouldCreateInitialEntry =
        !_isPureTrackingConfiguration(
          erfassungsmodus: erfassungsmodus,
          valueCommitment: valueCommitment,
        );

    return _database.transaction(() async {
      await _database
          .into(_database.aufgaben)
          .insert(
            AufgabenCompanion.insert(
              id: taskId,
              name: name.trim(),
              beschreibung: Value(beschreibung.trim()),
              erfassungsmodus: erfassungsmodus,
              projectId: Value(projectId),
              createdAt: Value(now),
              updatedAt: Value(now),
              taskType: Value(taskType),
              questionText: Value(questionText.trim()),
              successValue: Value(successValue),
              activeWeekdays: Value(_encodeWeekdays(activeWeekdays)),
              recurrence: Value(recurrence),
              startDate: selectedStartDate,
              dueDate: Value(selectedDueDate),
              missedPolicy: Value(missedPolicy),
              missedConsequence: Value(missedConsequence),
              missedBufferDays: Value(missedBufferDays),
              postBufferBehavior: Value(postBufferBehavior),
              maxCarryoverCount: Value(maxCarryoverCount),
              goalType: Value(goalType),
              goalValue: Value(goalValue),
              goalWindowDays: Value(goalWindowDays),
              goalPeriod: Value(goalPeriod),
              goalPeriodAlignment: Value(goalPeriodAlignment),
              valueType: Value(valueType),
              valueCommitment: Value(valueCommitment),
              valueUnitKey: Value(valueUnitKey),
              valueUnitLabel: Value(valueUnitLabel.trim()),
            ),
          );

      final task =
          await (_database.select(_database.aufgaben)
            ..where((task) => task.id.equals(taskId))).getSingle();
      final definitionVersionId = await _definitionVersionWriter.createVersion(
        task,
        validFrom: selectedStartDate,
        createdAt: now,
      );

      if (shouldCreateInitialEntry) {
        await _database
            .into(_database.taskEntries)
            .insert(
              TaskEntriesCompanion.insert(
                id: _uuid.v4(),
                taskId: taskId,
                taskDefinitionVersionId: Value(definitionVersionId),
                scheduledDate: initialEntryDate,
                createdAt: Value(now),
                updatedAt: now,
              ),
            );
      }
    });
  }

  List<TaskForDate> _mapAndSortTasks(List<TypedResult> rows) {
    final tasks =
        rows.map((row) {
          return TaskForDate(
            task: row.readTable(_database.aufgaben),
            entry: row.readTableOrNull(_database.taskEntries),
            entryValue: row.readTableOrNull(_database.taskEntryValues),
            project: _availableProject(row.readTableOrNull(_database.projects)),
          );
        }).toList();

    tasks.sort((first, second) {
      final firstEntryDate = first.entry?.scheduledDate;
      final secondEntryDate = second.entry?.scheduledDate;
      if (firstEntryDate != null && secondEntryDate != null) {
        final entryDateOrder = firstEntryDate.compareTo(secondEntryDate);
        if (entryDateOrder != 0) {
          return entryDateOrder;
        }
      } else if (firstEntryDate != null) {
        return -1;
      } else if (secondEntryDate != null) {
        return 1;
      }

      final firstProjectOrder = first.project?.sortOrder ?? 1 << 30;
      final secondProjectOrder = second.project?.sortOrder ?? 1 << 30;
      final projectOrder = firstProjectOrder.compareTo(secondProjectOrder);

      if (projectOrder != 0) {
        return projectOrder;
      }

      return first.task.name.toLowerCase().compareTo(
        second.task.name.toLowerCase(),
      );
    });

    return tasks;
  }

  Future<TaskForDate> _resolvedTaskForDate(
    TaskForDate value,
    DateTime selectedDate,
  ) async {
    final definitionDate = value.entry?.scheduledDate ?? selectedDate;
    final historicalTask =
        value.entry == null
            ? await _definitionResolver.taskForDate(value.task, definitionDate)
            : await _definitionResolver.taskForEntry(value.task, value.entry!);
    final projectId = await _projectAssignmentService.projectIdForDate(
      taskId: historicalTask.id,
      date: definitionDate,
      snapshotProjectId: historicalTask.projectId,
    );
    final project =
        projectId == null
            ? null
            : await (_database.select(_database.projects)..where(
              (candidate) => candidate.id.equals(projectId),
            )).getSingleOrNull();
    return TaskForDate(
      task: historicalTask.copyWith(projectId: Value(projectId)),
      entry: value.entry,
      entryValue: value.entryValue,
      project: project,
      cardMetrics: value.cardMetrics,
      linkedValueBundle: value.linkedValueBundle,
    );
  }

  Future<bool> _isTaskVisibleOnDate(TaskForDate task, DateTime date) async {
    final entry = task.entry;
    if (entry != null &&
        {
          MissedPolicy.carryover,
          MissedPolicy.buffer,
        }.contains(task.task.missedPolicy) &&
        entry.status == TaskEntryStatus.pending &&
        !entry.scheduledDate.isAfter(date)) {
      return true;
    }

    if (entry != null && _dateOnly(entry.scheduledDate) != _dateOnly(date)) {
      return false;
    }

    if (entry != null) {
      return true;
    }

    return _taskInstanceScheduler.isDueOnDate(task.task, date);
  }

  Future<String> _definitionVersionIdForEntry(
    String taskId,
    DateTime scheduledDate,
  ) async {
    final existingEntry =
        await (_database.select(_database.taskEntries)..where(
          (entry) =>
              entry.taskId.equals(taskId) &
              entry.scheduledDate.equals(scheduledDate),
        )).getSingleOrNull();

    final existingVersionId = existingEntry?.taskDefinitionVersionId;
    if (existingVersionId != null) {
      return existingVersionId;
    }

    return _definitionVersionWriter.versionIdForScheduledDate(
      taskId,
      scheduledDate,
    );
  }

  Future<TaskEntry?> _entryForTaskDate(String taskId, DateTime date) {
    return (_database.select(_database.taskEntries)
          ..where(
            (entry) =>
                entry.taskId.equals(taskId) &
                entry.scheduledDate.equals(_dateOnly(date)),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  Future<String> _planningOriginForEntry(
    String taskId,
    DateTime date,
    TaskEntry? existing,
  ) async {
    if (existing != null) return existing.planningOrigin;
    return await _lifecycleService.isTaskExcludedOnDay(taskId, date)
        ? TaskEntryPlanningOrigin.voluntaryPause
        : TaskEntryPlanningOrigin.planned;
  }

  Future<DateTime> _validatedPerformedOn(String taskId, DateTime value) async {
    final performedOn = _dateOnly(value);
    final today = _dateOnly(DateTime.now());
    final task =
        await (_database.select(_database.aufgaben)
          ..where((candidate) => candidate.id.equals(taskId))).getSingle();
    if (performedOn.isAfter(today)) {
      throw ArgumentError.value(
        value,
        'performedOn',
        'Der Durchführungstag darf nicht in der Zukunft liegen.',
      );
    }
    if (performedOn.isBefore(_dateOnly(task.startDate))) {
      throw ArgumentError.value(
        value,
        'performedOn',
        'Der Durchführungstag darf nicht vor dem Aufgabenstart liegen.',
      );
    }
    return performedOn;
  }
}

String _encodeWeekdays(Set<int> weekdays) {
  final sortedWeekdays = weekdays.toList()..sort();
  return sortedWeekdays.join(',');
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

TaskGoalEvaluationSummary _notEvaluatedStatusGoal(
  TaskGoalEvaluationSummary value,
) => TaskGoalEvaluationSummary(
  state: TaskGoalEvaluationState.notEvaluated,
  goalType: value.goalType,
  periodStart: value.periodStart,
  periodEnd: value.periodEnd,
  windowDays: value.windowDays,
  requiredSuccessCount: value.requiredSuccessCount,
  successCount: value.successCount,
  failureCount: value.failureCount,
  noEntryCount: value.noEntryCount,
  pendingCount: value.pendingCount,
  totalInstanceCount: value.totalInstanceCount,
  message: 'Pausiert oder im Papierkorb – nicht bewertet.',
);

TaskValueGoalEvaluationSummary _notEvaluatedValueGoal(
  TaskValueGoalEvaluationSummary value,
) => TaskValueGoalEvaluationSummary(
  state: TaskGoalEvaluationState.notEvaluated,
  goalType: value.goalType,
  periodStart: value.periodStart,
  periodEnd: value.periodEnd,
  windowDays: value.windowDays,
  targetValue: value.targetValue,
  actualValue: value.actualValue,
  recordedCount: value.recordedCount,
  missingOrOpenCount: value.missingOrOpenCount,
  valueType: value.valueType,
  unitLabel: value.unitLabel,
  message: 'Pausiert oder im Papierkorb – nicht bewertet.',
);

DateTime _nextLocalDay(DateTime date) =>
    DateTime(date.year, date.month, date.day + 1);

DateTime _bundleSourceDate(DateTime bundleDate, int dayOffset) {
  return _dateOnly(bundleDate).add(Duration(days: dayOffset));
}

bool _bundleUsesSourceDate(TaskValueBundleForDate bundle, DateTime sourceDate) {
  final date = _dateOnly(sourceDate);
  final version = bundle.version;

  return _bundleSourceDate(bundle.scheduledDate, version.firstTaskDayOffset) ==
          date ||
      _bundleSourceDate(bundle.scheduledDate, version.secondTaskDayOffset) ==
          date;
}

Project? _availableProject(Project? project) {
  if (project == null ||
      project.trashedAt != null ||
      project.deletedAt != null) {
    return null;
  }
  return project;
}

bool _isPureTrackingConfiguration({
  required String erfassungsmodus,
  required String valueCommitment,
}) {
  return erfassungsmodus == TaskCaptureMode.value &&
      valueCommitment == TaskValueCommitment.pureTracking;
}

bool _isPureTrackingTask(Aufgabe task) {
  return _isPureTrackingConfiguration(
    erfassungsmodus: task.erfassungsmodus,
    valueCommitment: task.valueCommitment,
  );
}

TaskCardMetric _metricFromStatusGoalSummary(
  TaskGoalEvaluationSummary summary, {
  String? futureDetail,
}) {
  if (!summary.hasGoal || !summary.isSupported) {
    return const TaskCardMetric(
      label: 'Ziel',
      value: 'Kennzahl hier nicht verfügbar',
      tone: TaskCardMetricTone.neutral,
    );
  }

  return TaskCardMetric(
    label: 'Ziel',
    value:
        summary.requiredSuccessCount > 0
            ? '${summary.successCount} von ${summary.requiredSuccessCount}'
            : _goalStateLabel(summary.state),
    tone: _toneForGoalState(summary.state),
    detail: _joinMetricDetails([
      _goalStateLabel(summary.state),
      '${summary.windowDays} Tage',
      futureDetail,
    ]),
  );
}

TaskCardMetric _metricFromValueGoalSummary(
  TaskValueGoalEvaluationSummary summary, {
  String? futureDetail,
}) {
  if (!summary.hasGoal || !summary.isSupported) {
    return const TaskCardMetric(
      label: 'Ziel',
      value: 'Kennzahl hier nicht verfügbar',
      tone: TaskCardMetricTone.neutral,
    );
  }

  final isAverage = summary.goalType != TaskGoalType.valueSumMin;
  final targetRelation =
      summary.goalType == TaskGoalType.valueAverageMax
          ? 'höchstens'
          : 'mindestens';
  return TaskCardMetric(
    label: isAverage ? 'Durchschnitt' : 'Summe',
    value:
        summary.actualValue == null
            ? 'Keine Daten'
            : _formatGoalValueMetric(summary.actualValue!, summary),
    tone: _toneForGoalState(summary.state),
    detail: _joinMetricDetails([
      'Ziel: $targetRelation '
          '${_formatGoalValueMetric(summary.targetValue, summary)}',
      '${summary.windowDays} Tage',
      '${summary.recordedCount} Werte',
      if (summary.missingOrOpenCount > 0)
        '${summary.missingOrOpenCount} fehlend/offen',
      _valueGoalStateLabel(summary.state),
      futureDetail,
    ]),
  );
}

TaskCardMetric? _metricFromTaskValue(TaskForDate task) {
  final entryValue = task.entryValue;
  if (entryValue == null) {
    return null;
  }

  return TaskCardMetric(
    label: 'Wert',
    value: switch (task.task.valueType) {
      TaskValueType.duration =>
        entryValue.durationSeconds == null
            ? '–'
            : _formatDurationMetric(entryValue.durationSeconds!),
      TaskValueType.timeOfDay =>
        entryValue.timeMinutes == null
            ? '–'
            : _formatTimeMetric(
              entryValue.timeMinutes!,
              dayOffset: entryValue.dayOffset,
            ),
      _ => _formatNumberMetric(
        entryValue.numberValue,
        entryValue.unitLabel.isEmpty
            ? task.task.valueUnitLabel
            : entryValue.unitLabel,
      ),
    },
    tone: TaskCardMetricTone.neutral,
  );
}

String _goalStateLabel(String state) {
  return switch (state) {
    TaskGoalEvaluationState.achieved => 'Erreicht',
    TaskGoalEvaluationState.reachable => 'Auf Kurs',
    TaskGoalEvaluationState.missed => 'Nicht erreicht',
    TaskGoalEvaluationState.noData => 'Keine Daten',
    TaskGoalEvaluationState.notEvaluated => 'Nicht gewertet',
    _ => 'Unklar',
  };
}

String _valueGoalStateLabel(String state) {
  return switch (state) {
    TaskGoalEvaluationState.achieved => 'Ziel erreicht',
    TaskGoalEvaluationState.reachable => 'Erreicht mit Datenlücke',
    TaskGoalEvaluationState.missed => 'Ziel nicht erreicht',
    TaskGoalEvaluationState.noData => 'Keine Daten',
    _ => 'Nicht gewertet',
  };
}

String _toneForGoalState(String state) {
  return switch (state) {
    TaskGoalEvaluationState.achieved => TaskCardMetricTone.good,
    TaskGoalEvaluationState.reachable => TaskCardMetricTone.warning,
    TaskGoalEvaluationState.missed => TaskCardMetricTone.bad,
    _ => TaskCardMetricTone.neutral,
  };
}

String _entryStatusLabel(String status) {
  return switch (status) {
    TaskEntryStatus.success => 'Erledigt',
    TaskEntryStatus.failure => 'Nicht erledigt',
    TaskEntryStatus.noEntry => 'Kein Eintrag',
    TaskEntryStatus.recorded => 'Erfasst',
    _ => 'Offen',
  };
}

String _toneForEntryStatus(String status) {
  return switch (status) {
    TaskEntryStatus.success => TaskCardMetricTone.good,
    TaskEntryStatus.recorded => TaskCardMetricTone.neutral,
    TaskEntryStatus.failure => TaskCardMetricTone.bad,
    TaskEntryStatus.noEntry => TaskCardMetricTone.neutral,
    _ => TaskCardMetricTone.neutral,
  };
}

String _formatGoalValueMetric(
  double value,
  TaskValueGoalEvaluationSummary summary,
) {
  if (summary.valueType == TaskValueType.duration) {
    return _formatDurationMetric(value.round());
  }

  return _formatNumberMetric(value, summary.unitLabel);
}

String _formatValueSummaryMetric(
  double? value,
  TaskValueAnalyticsSummary summary,
) {
  if (value == null) {
    return 'Keine Daten';
  }
  return switch (summary.valueType) {
    TaskValueType.duration => _formatDurationMetric(value.round()),
    TaskValueType.timeOfDay => _formatTimeMetric(
      value.round(),
      dayOffset: _dayOffsetForAbsoluteMinutes(value.round()),
    ),
    _ => _formatNumberMetric(value, summary.unitLabel),
  };
}

int _dayOffsetForAbsoluteMinutes(int minutes) {
  const dayMinutes = 24 * 60;
  if (minutes >= 0) {
    return minutes ~/ dayMinutes;
  }
  return (minutes - dayMinutes + 1) ~/ dayMinutes;
}

String _formatBundleSummaryMetric(
  double? value,
  TaskValueBundleAnalyticsSummary summary,
) {
  if (value == null) {
    return 'Keine Daten';
  }
  if (summary.version.bundleType == TaskValueBundleType.timeInterval) {
    return _formatDurationMetric(value.round());
  }
  final unitLabel = summary.points
      .map((point) => point.bundleForDate.calculation?.unitLabel ?? '')
      .firstWhere((label) => label.trim().isNotEmpty, orElse: () => '');
  return _formatNumberMetric(value, unitLabel);
}

String? _joinMetricDetails(List<String?> parts) {
  final visible = parts
      .whereType<String>()
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .toList(growable: false);
  return visible.isEmpty ? null : visible.join(' · ');
}

TaskCardMetric _changedDefinitionMetric() {
  return const TaskCardMetric(
    label: 'Kartenanzeige',
    value: 'Auswertung nach Änderung nicht verfügbar',
    tone: TaskCardMetricTone.neutral,
    detail: 'Historische Wertart, Einheit oder Rhythmus haben sich geändert.',
  );
}

String _formatCalculationMetric(TaskValueBundleCalculation calculation) {
  if (calculation.valueType == TaskValueType.duration) {
    final seconds = calculation.durationSeconds;
    return seconds == null ? '–' : _formatDurationMetric(seconds);
  }

  return _formatNumberMetric(calculation.numberValue, calculation.unitLabel);
}

String _formatNumberMetric(double? value, String unitLabel) {
  if (value == null) {
    return '–';
  }

  final formatted =
      value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(1);
  final unit = unitLabel.trim();
  return unit.isEmpty ? formatted : '$formatted $unit';
}

String _formatDurationMetric(int seconds) {
  final sign = seconds < 0 ? '−' : '';
  final absoluteSeconds = seconds.abs();
  final hours = absoluteSeconds ~/ 3600;
  final minutes = (absoluteSeconds % 3600) ~/ 60;

  if (hours > 0) {
    return '$sign$hours h ${minutes.toString().padLeft(2, '0')} min';
  }

  return '$sign$minutes min';
}

String _formatTimeMetric(int minutes, {required int dayOffset}) {
  final normalizedMinutes = minutes % (24 * 60);
  final hour = normalizedMinutes ~/ 60;
  final minute = normalizedMinutes % 60;
  final suffix =
      dayOffset == 0
          ? ''
          : dayOffset > 0
          ? ' +$dayOffset'
          : ' $dayOffset';

  return '${hour.toString().padLeft(2, '0')}:'
      '${minute.toString().padLeft(2, '0')}$suffix';
}

String _taskDateKey(String taskId, DateTime date) {
  final datePart =
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  return '$taskId:$datePart';
}

DateTime? _completionTime(TaskEntry? entry) {
  if (entry == null || !TaskEntryStatus.isResolved(entry.status)) {
    return null;
  }

  return entry.effectiveAt ?? entry.finalizedAt ?? entry.respondedAt;
}

class _ValueAnalyticsRange {
  const _ValueAnalyticsRange({required this.start, required this.end});

  final DateTime start;
  final DateTime end;
}

class _TaskEntryValuePair {
  const _TaskEntryValuePair({required this.entry, required this.entryValue});

  final TaskEntry entry;
  final TaskEntryValue? entryValue;
}

class _CardMetricLoadContext {
  final Map<String, Future<TaskCardMetricPreferenceSelection>> taskPreferences =
      {};
  final Map<String, Future<TaskCardMetricPreferenceSelection>>
  bundlePreferences = {};
  final Map<String, Future<TaskAnalyticsSummary>> statusSummaries = {};
  final Map<String, Future<TaskValueAnalyticsSummary>> valueSummaries = {};
  final Map<String, Future<TaskValueBundleAnalyticsSummary>> bundleSummaries =
      {};
  final Map<String, Future<TaskGoalEvaluationSummary>> statusGoals = {};
  final Map<String, Future<TaskValueGoalEvaluationSummary>> valueGoals = {};
  final Map<String, Future<TaskValueGoalEvaluationSummary>> bundleGoals = {};
}
