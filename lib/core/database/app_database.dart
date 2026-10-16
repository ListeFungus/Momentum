import 'dart:convert';
import 'package:momentum/core/settings/card_display_tables.dart';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_tabelle.dart';
import 'package:momentum/features/aufgaben/data/missed_policy.dart';
import 'package:momentum/features/aufgaben/data/post_buffer_behavior.dart';
import 'package:momentum/features/aufgaben/data/task_entries_tabelle.dart';
import 'package:momentum/features/aufgaben/data/task_definition_versions_table.dart';
import 'package:momentum/features/aufgaben/data/task_entry_status.dart';
import 'package:momentum/features/aufgaben/data/task_entry_values_table.dart';
import 'package:momentum/features/aufgaben/data/task_goal.dart';
import 'package:momentum/features/aufgaben/data/task_card_metric_preferences_table.dart';
import 'package:momentum/features/aufgaben/data/task_corrections_tables.dart';
import 'package:momentum/features/aufgaben/data/task_pending_definition_changes_table.dart';
import 'package:momentum/features/aufgaben/data/task_project_assignment_changes_table.dart';
import 'package:momentum/features/aufgaben/data/task_lifecycle_tables.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle_versions_table.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundles_table.dart';
import 'package:momentum/features/projekte/data/projects_table.dart';
import 'package:momentum/features/projekte/data/project_deletion_tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Projects,
    Aufgaben,
    TaskDefinitionVersions,
    TaskEntries,
    TaskEntryValues,
    TaskValueBundles,
    TaskValueBundleVersions,
    TaskCardMetricPreferences,
    TaskPendingDefinitionChanges,
    TaskProjectAssignmentChanges,
    TaskCorrectionOperations,
    TaskCorrectionItems,
    TaskPlanningInterruptions,
    EntityDeletionMarkers,
    ProjectDeletionBatches,
    ProjectDeletionBatchItems,
    CardDisplaySettings,
    CardExpansionPreferences,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'momentum'));

  AppDatabase.forTesting(super.e);

  AppDatabase.withExecutor(super.e);

  @override
  int get schemaVersion => 23;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (migrator, from, to) async {
        if (from < 2) {
          await customStatement(
            'ALTER TABLE aufgaben '
            'ADD COLUMN is_completed INTEGER NOT NULL DEFAULT 0',
          );
        }

        if (from < 3) {
          final today = _dateOnly(DateTime.now());
          final completedTasks =
              await customSelect(
                'SELECT id FROM aufgaben WHERE is_completed = 1',
              ).get();

          await customStatement('ALTER TABLE aufgaben RENAME TO aufgaben_v2');
          await migrator.createTable(aufgaben);
          await customStatement(
            '''
              INSERT INTO aufgaben (
                id,
                name,
                beschreibung,
                erfassungsmodus,
                start_date
              )
              SELECT
                id,
                name,
                beschreibung,
                erfassungsmodus,
                ?
              FROM aufgaben_v2
            ''',
            [today.millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond],
          );
          await customStatement('DROP TABLE aufgaben_v2');
          await migrator.createTable(taskEntries);

          for (final row in completedTasks) {
            final taskId = row.read<String>('id');

            await into(taskEntries).insert(
              TaskEntriesCompanion.insert(
                id: _entryId(taskId, today),
                taskId: taskId,
                scheduledDate: today,
                createdAt: Value(DateTime.now()),
                status: const Value(TaskEntryStatus.success),
                updatedAt: DateTime.now(),
                respondedAt: Value(DateTime.now()),
                finalizedAt: Value(DateTime.now()),
                effectiveAt: Value(DateTime.now()),
                resolutionOrigin: const Value(
                  TaskEntryResolutionOrigin.migration,
                ),
                checkboxValue: const Value(true),
              ),
            );
          }
        }

        if (from < 4) {
          await migrator.createTable(projects);
          if (from == 3) {
            await migrator.alterTable(TableMigration(aufgaben));
          }
        }

        if (from == 4) {
          await migrator.addColumn(projects, projects.colorHex);
        }

        if (from < 6) {
          if (from >= 4) {
            await migrator.addColumn(projects, projects.sortOrder);
          }
          if (from >= 3) {
            await migrator.addColumn(aufgaben, aufgaben.taskType);
            await migrator.addColumn(aufgaben, aufgaben.dueDate);
          }
        }

        if (from < 7) {
          if (from >= 3) {
            await migrator.addColumn(aufgaben, aufgaben.questionText);
            await migrator.addColumn(aufgaben, aufgaben.successValue);
            await migrator.addColumn(aufgaben, aufgaben.activeWeekdays);
            await migrator.addColumn(taskEntries, taskEntries.note);
          }
        }

        if (from < 8) {
          await _addTaskConfigurationColumns(migrator);
          await customStatement('''
            UPDATE aufgaben
            SET post_buffer_behavior = '${PostBufferBehavior.markAsNoEntry}'
            WHERE missed_policy = 'buffer'
              AND missed_consequence = 'keep_neutral'
          ''');
        }

        if (from < 9) {
          await _addTaskEntryResolutionColumns(migrator);
          await customStatement('''
            UPDATE task_entries
            SET status = CASE
              WHEN status = 'completed' THEN '${TaskEntryStatus.success}'
              WHEN status = 'pending'
                AND checkbox_value = 0
                AND EXISTS (
                  SELECT 1
                  FROM aufgaben
                  WHERE aufgaben.id = task_entries.task_id
                    AND aufgaben.erfassungsmodus = 'three_state'
                ) THEN '${TaskEntryStatus.failure}'
              ELSE status
            END
          ''');
          await _backfillTaskEntryResolutionMetadata();
        }

        if (from < 10) {
          await _migrateTaskDefinitionVersions(migrator);
        }

        if (from < 11) {
          await _migrateFullDefinitionSnapshotsAndRemoveCompletedAt(migrator);
        }

        if (from < 12) {
          await _migrateNoEntryTerminology();
        }

        if (from < 13) {
          await _addCreatedAtColumns(migrator);
        }

        if (from < 14) {
          await _addExtendedCaptureColumns(migrator);
        }

        if (from < 15) {
          await _migrateTaskValueBundles(migrator);
        }

        if (from < 16) {
          await _migrateTaskValueBundleDisplayAndOffsets(migrator);
        }

        if (from < 17) {
          await _migrateTaskValueBundleGoals(migrator);
        }

        if (from < 18) {
          await migrator.createTable(taskCardMetricPreferences);
        }

        if (from < 19) {
          await _migrateHistoryEditingFoundation(migrator);
        }

        if (from < 20) {
          await _migrateTaskLifecycleFoundation(migrator);
        }

        if (from < 21) {
          await _migrateProjectFoundation(migrator);
        }

        if (from < 22) {
          await _migrateSyncPreparation(migrator);
        }
        if (from < 23) {
          await migrator.createTable(cardDisplaySettings);
          await migrator.createTable(cardExpansionPreferences);
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
        if (details.versionNow >= 21) {
          await _ensureProjectAssignmentIndexes();
        }
      },
    );
  }

  Future<void> _migrateSyncPreparation(Migrator migrator) async {
    await _addColumnIfMissing(
      migrator,
      'aufgaben',
      aufgaben,
      aufgaben.updatedAt,
    );
    await _addColumnIfMissing(
      migrator,
      'task_value_bundle_versions',
      taskValueBundleVersions,
      taskValueBundleVersions.updatedAt,
    );
    // Ältere TableMigration-Pfade können eine erst später ergänzte nullable
    // Spalte bereits mit ihrem Spaltennamen als Text angelegt haben. Das ist
    // kein historischer Zeitpunkt und wird deshalb ausdrücklich unbekannt.
    await customStatement(
      'UPDATE aufgaben SET updated_at = NULL '
      "WHERE updated_at IS NOT NULL AND typeof(updated_at) <> 'integer'",
    );
    await customStatement(
      'UPDATE task_value_bundle_versions SET updated_at = NULL '
      "WHERE updated_at IS NOT NULL AND typeof(updated_at) <> 'integer'",
    );
    final hasCardPreferences =
        await customSelect(
          "SELECT 1 FROM sqlite_master WHERE type = 'table' "
          "AND name = 'task_card_metric_preferences'",
        ).getSingleOrNull() !=
        null;
    if (hasCardPreferences) {
      await _addColumnIfMissing(
        migrator,
        'task_card_metric_preferences',
        taskCardMetricPreferences,
        taskCardMetricPreferences.isReset,
      );
    } else {
      await migrator.createTable(taskCardMetricPreferences);
    }
  }

  Future<void> _ensureProjectAssignmentIndexes() async {
    await customStatement(
      'CREATE UNIQUE INDEX IF NOT EXISTS assignment_task_sequence '
      'ON task_project_assignment_changes(task_id, sequence) '
      'WHERE task_id IS NOT NULL',
    );
    await customStatement(
      'CREATE UNIQUE INDEX IF NOT EXISTS assignment_bundle_sequence '
      'ON task_project_assignment_changes(bundle_id, sequence) '
      'WHERE bundle_id IS NOT NULL',
    );
    await customStatement(
      "CREATE UNIQUE INDEX IF NOT EXISTS assignment_task_pending "
      "ON task_project_assignment_changes(task_id) "
      "WHERE task_id IS NOT NULL AND state = 'pending'",
    );
    await customStatement(
      "CREATE UNIQUE INDEX IF NOT EXISTS assignment_bundle_pending "
      "ON task_project_assignment_changes(bundle_id) "
      "WHERE bundle_id IS NOT NULL AND state = 'pending'",
    );
  }

  Future<void> _migrateProjectFoundation(Migrator migrator) async {
    final hasProjects =
        await customSelect(
          "SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = 'projects'",
        ).getSingleOrNull() !=
        null;
    if (!hasProjects) {
      await migrator.createTable(projects);
    }
    await _addColumnIfMissing(
      migrator,
      'projects',
      projects,
      projects.archivedAt,
    );
    await _addColumnIfMissing(
      migrator,
      'projects',
      projects,
      projects.trashedAt,
    );
    await _addColumnIfMissing(migrator, 'projects', projects, projects.purgeAt);
    await _addColumnIfMissing(
      migrator,
      'projects',
      projects,
      projects.deletedAt,
    );
    await _addColumnIfMissing(
      migrator,
      'projects',
      projects,
      projects.revision,
    );
    final projectColumns =
        await customSelect('PRAGMA table_info(projects)').get();
    final projectColumnNames =
        projectColumns.map((row) => row.read<String>('name')).toSet();
    if (!projectColumnNames.contains('updated_at')) {
      await customStatement(
        'ALTER TABLE projects '
        'ADD COLUMN updated_at INTEGER NOT NULL DEFAULT 0',
      );
      await customStatement(
        "UPDATE projects SET updated_at = CAST(strftime('%s', 'now') AS INTEGER) "
        'WHERE updated_at = 0',
      );
    }
    await _addColumnIfMissing(
      migrator,
      'task_value_bundles',
      taskValueBundles,
      taskValueBundles.projectId,
    );

    final assignmentColumns =
        await customSelect(
          'PRAGMA table_info(task_project_assignment_changes)',
        ).get();
    final assignmentNames =
        assignmentColumns.map((row) => row.read<String>('name')).toSet();
    if (assignmentColumns.isEmpty) {
      await migrator.createTable(taskProjectAssignmentChanges);
    } else if (!assignmentNames.contains('bundle_id') ||
        !assignmentNames.contains('origin')) {
      await customStatement(
        'ALTER TABLE task_project_assignment_changes '
        'RENAME TO task_project_assignment_changes_v20',
      );
      await migrator.createTable(taskProjectAssignmentChanges);
      await customStatement('''
        INSERT INTO task_project_assignment_changes (
          id, task_id, bundle_id, target_project_id, previous_project_id,
          scope, effective_date, sequence, state, origin, created_at, updated_at
        )
        SELECT id, task_id, NULL, target_project_id, previous_project_id,
          scope, effective_date, sequence, state, 'user', created_at, updated_at
        FROM task_project_assignment_changes_v20
      ''');
      await customStatement('DROP TABLE task_project_assignment_changes_v20');
    }

    await migrator.createTable(projectDeletionBatches);
    await migrator.createTable(projectDeletionBatchItems);
    await customStatement(
      'CREATE UNIQUE INDEX IF NOT EXISTS assignment_task_sequence '
      'ON task_project_assignment_changes(task_id, sequence) '
      'WHERE task_id IS NOT NULL',
    );
    await customStatement(
      'CREATE UNIQUE INDEX IF NOT EXISTS assignment_bundle_sequence '
      'ON task_project_assignment_changes(bundle_id, sequence) '
      'WHERE bundle_id IS NOT NULL',
    );
    await customStatement(
      "CREATE UNIQUE INDEX IF NOT EXISTS assignment_task_pending "
      "ON task_project_assignment_changes(task_id) "
      "WHERE task_id IS NOT NULL AND state = 'pending'",
    );
    await customStatement(
      "CREATE UNIQUE INDEX IF NOT EXISTS assignment_bundle_pending "
      "ON task_project_assignment_changes(bundle_id) "
      "WHERE bundle_id IS NOT NULL AND state = 'pending'",
    );
  }

  Future<void> _migrateTaskLifecycleFoundation(Migrator migrator) async {
    await _addColumnIfMissing(
      migrator,
      'aufgaben',
      aufgaben,
      aufgaben.trashedAt,
    );
    await _addColumnIfMissing(migrator, 'aufgaben', aufgaben, aufgaben.purgeAt);
    await _addColumnIfMissing(
      migrator,
      'aufgaben',
      aufgaben,
      aufgaben.lifecycleRevision,
    );
    await _addColumnIfMissing(
      migrator,
      'aufgaben',
      aufgaben,
      aufgaben.lifecycleUpdatedAt,
    );
    await _addColumnIfMissing(
      migrator,
      'task_value_bundles',
      taskValueBundles,
      taskValueBundles.trashedAt,
    );
    await _addColumnIfMissing(
      migrator,
      'task_value_bundles',
      taskValueBundles,
      taskValueBundles.purgeAt,
    );
    await _addColumnIfMissing(
      migrator,
      'task_value_bundles',
      taskValueBundles,
      taskValueBundles.lifecycleRevision,
    );
    await _addColumnIfMissing(
      migrator,
      'task_value_bundles',
      taskValueBundles,
      taskValueBundles.lifecycleUpdatedAt,
    );
    await _addColumnIfMissing(
      migrator,
      'task_entries',
      taskEntries,
      taskEntries.planningOrigin,
    );
    await migrator.createTable(taskPlanningInterruptions);
    await migrator.createTable(entityDeletionMarkers);
    await migrator.alterTable(TableMigration(taskValueBundleVersions));
  }

  Future<void> _migrateHistoryEditingFoundation(Migrator migrator) async {
    await migrator.createTable(taskPendingDefinitionChanges);
    await migrator.createTable(taskProjectAssignmentChanges);
    await migrator.createTable(taskCorrectionOperations);
    await migrator.createTable(taskCorrectionItems);

    await _addColumnIfMissing(
      migrator,
      'task_entries',
      taskEntries,
      taskEntries.originalScheduledDate,
    );
    await _addColumnIfMissing(
      migrator,
      'task_entries',
      taskEntries,
      taskEntries.performedOn,
    );
    await _addColumnIfMissing(
      migrator,
      'task_entries',
      taskEntries,
      taskEntries.performedOnSource,
    );
    await _addColumnIfMissing(
      migrator,
      'task_entries',
      taskEntries,
      taskEntries.revision,
    );
    await _addColumnIfMissing(
      migrator,
      'task_definition_versions',
      taskDefinitionVersions,
      taskDefinitionVersions.supersededAt,
    );
    await _addColumnIfMissing(
      migrator,
      'task_value_bundle_versions',
      taskValueBundleVersions,
      taskValueBundleVersions.cancelledAt,
    );

    await _migrateFutureGoalVersionsToPendingChanges();
  }

  Future<void> _addColumnIfMissing<T extends Object>(
    Migrator migrator,
    String tableName,
    TableInfo table,
    GeneratedColumn<T> column,
  ) async {
    final columns = await customSelect('PRAGMA table_info($tableName)').get();
    final names = columns.map((row) => row.read<String>('name')).toSet();
    if (!names.contains(column.$name)) {
      await migrator.addColumn(table, column);
    }
  }

  Future<void> _migrateFutureGoalVersionsToPendingChanges() async {
    final tomorrow = _nextLocalDay(DateTime.now());
    final futureVersions =
        await (select(taskDefinitionVersions)
              ..where(
                (version) =>
                    version.validFrom.isBiggerOrEqualValue(tomorrow) &
                    version.supersededAt.isNull(),
              )
              ..orderBy([
                (version) => OrderingTerm.asc(version.taskId),
                (version) => OrderingTerm.desc(version.versionNumber),
              ]))
            .get();
    final latestGoalByTask = <String, TaskDefinitionVersion>{};
    final superseded = <TaskDefinitionVersion>[];
    for (final version in futureVersions) {
      final previousId = version.previousVersionId;
      if (previousId == null) {
        continue;
      }
      final previous =
          await (select(taskDefinitionVersions)..where(
            (candidate) => candidate.id.equals(previousId),
          )).getSingleOrNull();
      if (previous == null || !_sameNonGoalDefinition(previous, version)) {
        continue;
      }
      latestGoalByTask.putIfAbsent(version.taskId, () => version);
      superseded.add(version);
    }
    final now = DateTime.now();
    for (final version in latestGoalByTask.values) {
      await into(taskPendingDefinitionChanges).insert(
        TaskPendingDefinitionChangesCompanion.insert(
          id: 'migration-goal:${version.id}',
          taskId: version.taskId,
          groupKey: TaskPendingDefinitionChangeGroup.goal,
          effectiveDate: _dateOnly(version.validFrom),
          payloadJson: jsonEncode({
            'goalType': version.goalType,
            'goalValue': version.goalValue,
            'goalWindowDays': version.goalWindowDays,
            'goalPeriod': version.goalPeriod,
            'goalPeriodAlignment': version.goalPeriodAlignment,
          }),
          updatedAt: Value(now),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
    if (superseded.isNotEmpty) {
      await (update(taskDefinitionVersions)..where(
        (version) => version.id.isIn(superseded.map((item) => item.id)),
      )).write(TaskDefinitionVersionsCompanion(supersededAt: Value(now)));
    }
  }

  bool _sameNonGoalDefinition(
    TaskDefinitionVersion first,
    TaskDefinitionVersion second,
  ) {
    return first.name == second.name &&
        first.description == second.description &&
        first.questionText == second.questionText &&
        first.projectId == second.projectId &&
        first.taskType == second.taskType &&
        first.captureMode == second.captureMode &&
        first.successValue == second.successValue &&
        first.activeWeekdays == second.activeWeekdays &&
        first.recurrence == second.recurrence &&
        first.startDate == second.startDate &&
        first.endDate == second.endDate &&
        first.dueDate == second.dueDate &&
        first.missedPolicy == second.missedPolicy &&
        first.missedConsequence == second.missedConsequence &&
        first.missedBufferDays == second.missedBufferDays &&
        first.postBufferBehavior == second.postBufferBehavior &&
        first.maxCarryoverCount == second.maxCarryoverCount &&
        first.valueType == second.valueType &&
        first.valueCommitment == second.valueCommitment &&
        first.valueUnitKey == second.valueUnitKey &&
        first.valueUnitLabel == second.valueUnitLabel;
  }

  Future<void> _addTaskConfigurationColumns(Migrator migrator) async {
    final existingColumns =
        await customSelect('PRAGMA table_info(aufgaben)').get();
    final columnNames =
        existingColumns.map((row) => row.read<String>('name')).toSet();

    Future<void> addColumnIfMissing<T extends Object>(
      String name,
      GeneratedColumn<T> column,
    ) async {
      if (columnNames.contains(name)) {
        return;
      }

      await migrator.addColumn(aufgaben, column);
      columnNames.add(name);
    }

    await addColumnIfMissing('missed_policy', aufgaben.missedPolicy);
    await addColumnIfMissing('missed_consequence', aufgaben.missedConsequence);
    await addColumnIfMissing('missed_buffer_days', aufgaben.missedBufferDays);
    await addColumnIfMissing(
      'post_buffer_behavior',
      aufgaben.postBufferBehavior,
    );
    await addColumnIfMissing('max_carryover_count', aufgaben.maxCarryoverCount);
    await addColumnIfMissing('goal_type', aufgaben.goalType);
    await addColumnIfMissing('goal_value', aufgaben.goalValue);
    await addColumnIfMissing('goal_window_days', aufgaben.goalWindowDays);
    await addColumnIfMissing('goal_period', aufgaben.goalPeriod);
    await addColumnIfMissing(
      'goal_period_alignment',
      aufgaben.goalPeriodAlignment,
    );
  }

  Future<void> _addTaskEntryResolutionColumns(Migrator migrator) async {
    final tableExists =
        await customSelect(
          "SELECT 1 FROM sqlite_master "
          "WHERE type = 'table' AND name = 'task_entries'",
        ).getSingleOrNull() !=
        null;

    if (!tableExists) {
      await migrator.createTable(taskEntries);
      return;
    }

    final existingColumns =
        await customSelect('PRAGMA table_info(task_entries)').get();
    final columnNames =
        existingColumns.map((row) => row.read<String>('name')).toSet();

    Future<void> addColumnIfMissing<T extends Object>(
      String name,
      GeneratedColumn<T> column,
    ) async {
      if (columnNames.contains(name)) {
        return;
      }

      await migrator.addColumn(taskEntries, column);
      columnNames.add(name);
    }

    await addColumnIfMissing('responded_at', taskEntries.respondedAt);
    await addColumnIfMissing('finalized_at', taskEntries.finalizedAt);
    await addColumnIfMissing('effective_at', taskEntries.effectiveAt);
    await addColumnIfMissing('resolution_origin', taskEntries.resolutionOrigin);
    await addColumnIfMissing(
      'applied_missed_policy',
      taskEntries.appliedMissedPolicy,
    );
    await addColumnIfMissing(
      'applied_missed_consequence',
      taskEntries.appliedMissedConsequence,
    );
  }

  Future<void> _migrateTaskDefinitionVersions(Migrator migrator) async {
    await migrator.createTable(taskDefinitionVersions);
    // The generated data classes reflect the newest schema. Older databases
    // need these later columns before rows can safely be mapped during the
    // version backfill.
    await _addCreatedAtColumns(migrator);
    await _addExtendedCaptureColumns(migrator);
    await _addColumnIfMissing(
      migrator,
      'aufgaben',
      aufgaben,
      aufgaben.trashedAt,
    );
    await _addColumnIfMissing(migrator, 'aufgaben', aufgaben, aufgaben.purgeAt);
    await _addColumnIfMissing(
      migrator,
      'aufgaben',
      aufgaben,
      aufgaben.lifecycleRevision,
    );
    await _addColumnIfMissing(
      migrator,
      'aufgaben',
      aufgaben,
      aufgaben.lifecycleUpdatedAt,
    );
    final entryColumns =
        await customSelect('PRAGMA table_info(task_entries)').get();
    final entryColumnNames =
        entryColumns.map((row) => row.read<String>('name')).toSet();
    if (!entryColumnNames.contains('task_definition_version_id')) {
      await migrator.addColumn(
        taskEntries,
        taskEntries.taskDefinitionVersionId,
      );
    }

    final existingTasks = await select(aufgaben).get();
    final now = DateTime.now();

    for (final task in existingTasks) {
      final versionId = '${task.id}:v1';
      await into(taskDefinitionVersions).insert(
        TaskDefinitionVersionsCompanion.insert(
          id: versionId,
          taskId: task.id,
          versionNumber: 1,
          previousVersionId: const Value(null),
          validFrom: task.startDate,
          createdAt: now,
          name: Value(task.name),
          description: Value(task.beschreibung),
          questionText: Value(task.questionText),
          projectId: Value(task.projectId),
          taskType: task.taskType,
          captureMode: task.erfassungsmodus,
          successValue: Value(task.successValue),
          activeWeekdays: task.activeWeekdays,
          recurrence: task.recurrence,
          startDate: task.startDate,
          endDate: Value(task.endDate),
          dueDate: Value(task.dueDate),
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
          valueType: Value(task.valueType),
          valueCommitment: Value(task.valueCommitment),
          valueUnitKey: Value(task.valueUnitKey),
          valueUnitLabel: Value(task.valueUnitLabel),
        ),
      );

      await (update(taskEntries)..where(
        (entry) => entry.taskId.equals(task.id),
      )).write(TaskEntriesCompanion(taskDefinitionVersionId: Value(versionId)));
    }
  }

  Future<void> _backfillTaskEntryResolutionMetadata() async {
    final columns = await customSelect('PRAGMA table_info(task_entries)').get();
    final columnNames = columns.map((row) => row.read<String>('name')).toSet();
    final historicalTimestamp =
        columnNames.contains('completed_at')
            ? 'COALESCE(completed_at, updated_at)'
            : 'updated_at';

    await customStatement('''
      UPDATE task_entries
      SET responded_at = $historicalTimestamp,
          finalized_at = $historicalTimestamp,
          effective_at = $historicalTimestamp,
          resolution_origin = '${TaskEntryResolutionOrigin.migration}'
      WHERE status IN (
        '${TaskEntryStatus.success}',
        '${TaskEntryStatus.failure}'
      )
    ''');
  }

  Future<void> _migrateFullDefinitionSnapshotsAndRemoveCompletedAt(
    Migrator migrator,
  ) async {
    final versionColumns =
        await customSelect('PRAGMA table_info(task_definition_versions)').get();
    final versionColumnNames =
        versionColumns.map((row) => row.read<String>('name')).toSet();

    Future<void> addVersionColumnIfMissing<T extends Object>(
      String name,
      GeneratedColumn<T> column,
    ) async {
      if (!versionColumnNames.contains(name)) {
        await migrator.addColumn(taskDefinitionVersions, column);
        versionColumnNames.add(name);
      }
    }

    await addVersionColumnIfMissing(
      'previous_version_id',
      taskDefinitionVersions.previousVersionId,
    );
    await addVersionColumnIfMissing('name', taskDefinitionVersions.name);
    await addVersionColumnIfMissing(
      'description',
      taskDefinitionVersions.description,
    );
    await addVersionColumnIfMissing(
      'question_text',
      taskDefinitionVersions.questionText,
    );
    await addVersionColumnIfMissing(
      'project_id',
      taskDefinitionVersions.projectId,
    );

    await customStatement('''
      UPDATE task_definition_versions
      SET name = COALESCE((
            SELECT name FROM aufgaben
            WHERE aufgaben.id = task_definition_versions.task_id
          ), name),
          description = COALESCE((
            SELECT beschreibung FROM aufgaben
            WHERE aufgaben.id = task_definition_versions.task_id
          ), description),
          question_text = COALESCE((
            SELECT question_text FROM aufgaben
            WHERE aufgaben.id = task_definition_versions.task_id
          ), question_text),
          project_id = (
            SELECT project_id FROM aufgaben
            WHERE aufgaben.id = task_definition_versions.task_id
          ),
          previous_version_id = (
            SELECT previous.id
            FROM task_definition_versions AS previous
            WHERE previous.task_id = task_definition_versions.task_id
              AND previous.version_number =
                  task_definition_versions.version_number - 1
          )
    ''');

    final entryColumns =
        await customSelect('PRAGMA table_info(task_entries)').get();
    final hasCompletedAt = entryColumns.any(
      (row) => row.read<String>('name') == 'completed_at',
    );
    if (hasCompletedAt) {
      await migrator.alterTable(
        TableMigration(
          taskEntries,
          newColumns: [
            taskEntries.originalScheduledDate,
            taskEntries.createdAt,
            taskEntries.performedOn,
            taskEntries.performedOnSource,
            taskEntries.revision,
            taskEntries.planningOrigin,
          ],
        ),
      );
    }
  }

  Future<void> _migrateNoEntryTerminology() async {
    await customStatement('''
      UPDATE task_entries
      SET status = '${TaskEntryStatus.noEntry}'
      WHERE status = 'neutral'
    ''');
  }

  Future<void> _addCreatedAtColumns(Migrator migrator) async {
    final taskColumns = await customSelect('PRAGMA table_info(aufgaben)').get();
    final taskColumnNames =
        taskColumns.map((row) => row.read<String>('name')).toSet();
    if (!taskColumnNames.contains('created_at')) {
      await customStatement('''
        ALTER TABLE aufgaben
        ADD COLUMN created_at INTEGER NOT NULL DEFAULT 0
      ''');
    }
    await customStatement('''
      UPDATE aufgaben
      SET created_at = COALESCE(
        (
          SELECT MIN(created_at)
          FROM task_definition_versions
          WHERE task_definition_versions.task_id = aufgaben.id
        ),
        start_date,
        created_at
      )
      WHERE created_at IS NULL OR created_at = 0
    ''');

    final entryColumns =
        await customSelect('PRAGMA table_info(task_entries)').get();
    final entryColumnNames =
        entryColumns.map((row) => row.read<String>('name')).toSet();
    if (!entryColumnNames.contains('created_at')) {
      await customStatement('''
        ALTER TABLE task_entries
        ADD COLUMN created_at INTEGER NOT NULL DEFAULT 0
      ''');
    }
    await customStatement('''
      UPDATE task_entries
      SET created_at = updated_at
      WHERE created_at IS NULL OR created_at = 0
    ''');
  }

  Future<void> _addExtendedCaptureColumns(Migrator migrator) async {
    final taskColumns = await customSelect('PRAGMA table_info(aufgaben)').get();
    final taskColumnNames =
        taskColumns.map((row) => row.read<String>('name')).toSet();

    Future<void> addTaskColumnIfMissing<T extends Object>(
      String name,
      GeneratedColumn<T> column,
    ) async {
      if (!taskColumnNames.contains(name)) {
        await migrator.addColumn(aufgaben, column);
        taskColumnNames.add(name);
      }
    }

    await addTaskColumnIfMissing('value_type', aufgaben.valueType);
    await addTaskColumnIfMissing('value_commitment', aufgaben.valueCommitment);
    await addTaskColumnIfMissing('value_unit_key', aufgaben.valueUnitKey);
    await addTaskColumnIfMissing('value_unit_label', aufgaben.valueUnitLabel);

    final versionTableExists =
        await customSelect(
          "SELECT 1 FROM sqlite_master "
          "WHERE type = 'table' AND name = 'task_definition_versions'",
        ).getSingleOrNull() !=
        null;

    if (versionTableExists) {
      final versionColumns =
          await customSelect(
            'PRAGMA table_info(task_definition_versions)',
          ).get();
      final versionColumnNames =
          versionColumns.map((row) => row.read<String>('name')).toSet();

      Future<void> addVersionColumnIfMissing<T extends Object>(
        String name,
        GeneratedColumn<T> column,
      ) async {
        if (!versionColumnNames.contains(name)) {
          await migrator.addColumn(taskDefinitionVersions, column);
          versionColumnNames.add(name);
        }
      }

      await addVersionColumnIfMissing(
        'value_type',
        taskDefinitionVersions.valueType,
      );
      await addVersionColumnIfMissing(
        'value_commitment',
        taskDefinitionVersions.valueCommitment,
      );
      await addVersionColumnIfMissing(
        'value_unit_key',
        taskDefinitionVersions.valueUnitKey,
      );
      await addVersionColumnIfMissing(
        'value_unit_label',
        taskDefinitionVersions.valueUnitLabel,
      );
    }

    final valueTableExists =
        await customSelect(
          "SELECT 1 FROM sqlite_master "
          "WHERE type = 'table' AND name = 'task_entry_values'",
        ).getSingleOrNull() !=
        null;

    if (!valueTableExists) {
      await migrator.createTable(taskEntryValues);
    }
  }

  Future<void> _migrateTaskValueBundles(Migrator migrator) async {
    final bundleTableExists =
        await customSelect(
          "SELECT 1 FROM sqlite_master "
          "WHERE type = 'table' AND name = 'task_value_bundles'",
        ).getSingleOrNull() !=
        null;

    if (!bundleTableExists) {
      await migrator.createTable(taskValueBundles);
    }

    final bundleVersionTableExists =
        await customSelect(
          "SELECT 1 FROM sqlite_master "
          "WHERE type = 'table' AND name = 'task_value_bundle_versions'",
        ).getSingleOrNull() !=
        null;

    if (!bundleVersionTableExists) {
      await migrator.createTable(taskValueBundleVersions);
    }
  }

  Future<void> _migrateTaskValueBundleDisplayAndOffsets(
    Migrator migrator,
  ) async {
    await _migrateTaskValueBundles(migrator);

    final columns =
        await customSelect(
          'PRAGMA table_info(task_value_bundle_versions)',
        ).get();
    final columnNames = columns.map((row) => row.read<String>('name')).toSet();

    Future<void> addColumnIfMissing<T extends Object>(
      String name,
      GeneratedColumn<T> column,
    ) async {
      if (columnNames.contains(name)) {
        return;
      }

      await migrator.addColumn(taskValueBundleVersions, column);
      columnNames.add(name);
    }

    await addColumnIfMissing(
      'display_mode',
      taskValueBundleVersions.displayMode,
    );
    await addColumnIfMissing(
      'first_task_day_offset',
      taskValueBundleVersions.firstTaskDayOffset,
    );
    await addColumnIfMissing(
      'second_task_day_offset',
      taskValueBundleVersions.secondTaskDayOffset,
    );

    await customStatement('''
      UPDATE task_value_bundle_versions
      SET display_mode = 'combined_card'
      WHERE display_mode IS NULL OR display_mode = ''
    ''');
    await customStatement('''
      UPDATE task_value_bundle_versions
      SET first_task_day_offset = 0
      WHERE first_task_day_offset IS NULL
    ''');
    await customStatement('''
      UPDATE task_value_bundle_versions
      SET second_task_day_offset = 0
      WHERE second_task_day_offset IS NULL
    ''');
  }

  Future<void> _migrateTaskValueBundleGoals(Migrator migrator) async {
    await _migrateTaskValueBundleDisplayAndOffsets(migrator);

    final columns =
        await customSelect(
          'PRAGMA table_info(task_value_bundle_versions)',
        ).get();
    final columnNames = columns.map((row) => row.read<String>('name')).toSet();

    if (!columnNames.contains('goal_type')) {
      await migrator.addColumn(
        taskValueBundleVersions,
        taskValueBundleVersions.goalType,
      );
    }
    if (!columnNames.contains('goal_value')) {
      await migrator.addColumn(
        taskValueBundleVersions,
        taskValueBundleVersions.goalValue,
      );
    }
    if (!columnNames.contains('goal_window_days')) {
      await migrator.addColumn(
        taskValueBundleVersions,
        taskValueBundleVersions.goalWindowDays,
      );
    }

    await customStatement('''
      UPDATE task_value_bundle_versions
      SET goal_type = '${TaskGoalType.none}'
      WHERE goal_type IS NULL OR goal_type = ''
    ''');
    await customStatement('''
      UPDATE task_value_bundle_versions
      SET goal_value = 1
      WHERE goal_value IS NULL OR goal_value < 1
    ''');
  }
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

DateTime _nextLocalDay(DateTime date) =>
    DateTime(date.year, date.month, date.day + 1);

String _entryId(String taskId, DateTime date) {
  final datePart =
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  return '$taskId:$datePart';
}
