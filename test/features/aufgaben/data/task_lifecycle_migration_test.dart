import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('migriert echte Schema-19-Lebenszyklusdaten verlustfrei', () async {
    final directory = await Directory.systemTemp.createTemp(
      'momentum_phase17_migration_',
    );
    final file = File('${directory.path}/momentum.sqlite');
    addTearDown(() => directory.delete(recursive: true));

    final sqlite = sqlite3.open(file.path);
    _createSchema19Fixture(sqlite);
    sqlite.dispose();

    final database = AppDatabase.forTesting(NativeDatabase(file));
    addTearDown(database.close);

    final tasks = await database.select(database.aufgaben).get();
    final entries = await database.select(database.taskEntries).get();
    final bundles = await database.select(database.taskValueBundles).get();
    final versions =
        await database.select(database.taskValueBundleVersions).get();

    expect(database.schemaVersion, 22);
    expect(tasks.map((task) => task.id), containsAll(['task-a', 'task-b']));
    expect(tasks.every((task) => task.trashedAt == null), isTrue);
    expect(tasks.every((task) => task.lifecycleRevision == 0), isTrue);
    expect(tasks.every((task) => task.updatedAt == null), isTrue);
    expect(entries.single.planningOrigin, 'planned');
    expect(bundles.single.id, 'bundle-1');
    expect(bundles.single.trashedAt, isNull);
    expect(versions.single.firstTaskId, 'task-a');
    expect(versions.single.secondTaskId, 'task-b');
    expect(versions.single.updatedAt, isNull);
    final preference =
        await database.select(database.taskCardMetricPreferences).getSingle();
    expect(preference.configJson, '{"version":1,"items":[]}');
    expect(preference.isReset, isFalse);

    final foreignKeys =
        await database
            .customSelect('PRAGMA foreign_key_list(task_value_bundle_versions)')
            .get();
    expect(
      foreignKeys.map((row) => row.read<String>('table')),
      isNot(contains('aufgaben')),
    );
    expect(
      await database.customSelect('PRAGMA foreign_key_check').get(),
      isEmpty,
    );
    expect(
      await database
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type = 'table' AND "
            "name IN ('task_planning_interruptions', 'entity_deletion_markers')",
          )
          .get(),
      hasLength(2),
    );
  });

  test('migriert echte Schema-20-Projekt- und Zuordnungsdaten', () async {
    final directory = await Directory.systemTemp.createTemp(
      'momentum_phase18_migration_',
    );
    final file = File('${directory.path}/momentum.sqlite');
    addTearDown(() => directory.delete(recursive: true));

    final sqlite = sqlite3.open(file.path);
    _createSchema19Fixture(sqlite);
    _upgradeFixtureToSchema20(sqlite);
    sqlite.dispose();

    final database = AppDatabase.forTesting(NativeDatabase(file));
    addTearDown(database.close);
    final project = await database.select(database.projects).getSingle();
    final bundle = await database.select(database.taskValueBundles).getSingle();
    final changes =
        await database.select(database.taskProjectAssignmentChanges).get();

    expect(database.schemaVersion, 22);
    expect(project.name, 'Bestand');
    expect(project.archivedAt, isNull);
    expect(project.revision, 0);
    expect(bundle.projectId, isNull);
    expect(changes.single.taskId, 'task-a');
    expect(changes.single.bundleId, isNull);
    expect(changes.single.origin, 'user');
    expect(
      await database.customSelect('PRAGMA foreign_key_check').get(),
      isEmpty,
    );
  });
}

void _upgradeFixtureToSchema20(Database database) {
  final now = DateTime(2026, 10, 5).millisecondsSinceEpoch ~/ 1000;
  database.execute(
    "INSERT INTO projects (id, name) VALUES ('project-1', 'Bestand')",
  );
  database.execute('ALTER TABLE aufgaben ADD COLUMN trashed_at INTEGER NULL');
  database.execute('ALTER TABLE aufgaben ADD COLUMN purge_at INTEGER NULL');
  database.execute(
    'ALTER TABLE aufgaben ADD COLUMN lifecycle_revision INTEGER NOT NULL DEFAULT 0',
  );
  database.execute(
    'ALTER TABLE aufgaben ADD COLUMN lifecycle_updated_at INTEGER NULL',
  );
  database.execute(
    "ALTER TABLE task_entries ADD COLUMN planning_origin TEXT NOT NULL DEFAULT 'planned'",
  );
  database.execute(
    'ALTER TABLE task_value_bundles ADD COLUMN trashed_at INTEGER NULL',
  );
  database.execute(
    'ALTER TABLE task_value_bundles ADD COLUMN purge_at INTEGER NULL',
  );
  database.execute(
    'ALTER TABLE task_value_bundles ADD COLUMN lifecycle_revision INTEGER NOT NULL DEFAULT 0',
  );
  database.execute(
    'ALTER TABLE task_value_bundles ADD COLUMN lifecycle_updated_at INTEGER NULL',
  );
  database.execute('''
    CREATE TABLE task_project_assignment_changes (
      id TEXT NOT NULL PRIMARY KEY,
      task_id TEXT NOT NULL REFERENCES aufgaben(id) ON DELETE CASCADE,
      target_project_id TEXT NULL REFERENCES projects(id) ON DELETE SET NULL,
      previous_project_id TEXT NULL REFERENCES projects(id) ON DELETE SET NULL,
      scope TEXT NOT NULL,
      effective_date INTEGER NOT NULL,
      sequence INTEGER NOT NULL,
      state TEXT NOT NULL DEFAULT 'pending',
      created_at INTEGER NOT NULL DEFAULT (unixepoch()),
      updated_at INTEGER NOT NULL DEFAULT (unixepoch()),
      UNIQUE(task_id, sequence)
    )
  ''');
  database.execute(
    "INSERT INTO task_project_assignment_changes "
    "(id, task_id, target_project_id, scope, effective_date, sequence, state, updated_at) "
    "VALUES ('change-1', 'task-a', 'project-1', 'from_date', $now, 1, 'applied', $now)",
  );
  database.execute('''
    CREATE TABLE task_planning_interruptions (
      id TEXT NOT NULL PRIMARY KEY,
      task_id TEXT NOT NULL REFERENCES aufgaben(id) ON DELETE CASCADE,
      reason TEXT NOT NULL,
      from_day TEXT NOT NULL,
      until_day_exclusive TEXT NULL,
      created_at INTEGER NOT NULL DEFAULT (unixepoch()),
      updated_at INTEGER NOT NULL DEFAULT (unixepoch()),
      revision INTEGER NOT NULL DEFAULT 0
    )
  ''');
  database.execute('''
    CREATE TABLE entity_deletion_markers (
      entity_type TEXT NOT NULL,
      entity_id TEXT NOT NULL,
      deleted_at INTEGER NOT NULL,
      PRIMARY KEY (entity_type, entity_id)
    )
  ''');
  database.execute('PRAGMA user_version = 20');
}

void _createSchema19Fixture(Database database) {
  database.execute('PRAGMA foreign_keys = ON');
  database.execute('''
    CREATE TABLE projects (
      id TEXT NOT NULL PRIMARY KEY,
      name TEXT NOT NULL,
      description TEXT NOT NULL DEFAULT '',
      color_hex TEXT NOT NULL DEFAULT '#5B67D6',
      sort_order INTEGER NOT NULL DEFAULT 0
    )
  ''');
  database.execute('''
    CREATE TABLE aufgaben (
      id TEXT NOT NULL PRIMARY KEY,
      project_id TEXT NULL REFERENCES projects(id) ON DELETE SET NULL,
      name TEXT NOT NULL,
      beschreibung TEXT NOT NULL DEFAULT '',
      erfassungsmodus TEXT NOT NULL,
      task_type TEXT NOT NULL DEFAULT 'habit',
      question_text TEXT NOT NULL DEFAULT '',
      success_value INTEGER NOT NULL DEFAULT 1,
      active_weekdays TEXT NOT NULL DEFAULT '1,2,3,4,5,6,7',
      recurrence TEXT NOT NULL DEFAULT 'daily',
      start_date INTEGER NOT NULL,
      created_at INTEGER NOT NULL DEFAULT (unixepoch()),
      end_date INTEGER NULL,
      due_date INTEGER NULL,
      is_active INTEGER NOT NULL DEFAULT 1,
      missed_policy TEXT NOT NULL DEFAULT 'none',
      missed_consequence TEXT NOT NULL DEFAULT 'mark_as_not_done',
      missed_buffer_days INTEGER NOT NULL DEFAULT 1,
      post_buffer_behavior TEXT NOT NULL DEFAULT 'mark_as_failure',
      max_carryover_count INTEGER NOT NULL DEFAULT 3,
      goal_type TEXT NOT NULL DEFAULT 'none',
      goal_value INTEGER NOT NULL DEFAULT 1,
      goal_window_days INTEGER NULL,
      goal_period TEXT NOT NULL DEFAULT 'week',
      goal_period_alignment TEXT NOT NULL DEFAULT 'calendar',
      value_type TEXT NOT NULL DEFAULT 'none',
      value_commitment TEXT NOT NULL DEFAULT 'none',
      value_unit_key TEXT NOT NULL DEFAULT 'none',
      value_unit_label TEXT NOT NULL DEFAULT ''
    )
  ''');
  database.execute('''
    CREATE TABLE task_definition_versions (
      id TEXT NOT NULL PRIMARY KEY,
      task_id TEXT NOT NULL REFERENCES aufgaben(id) ON DELETE CASCADE,
      version_number INTEGER NOT NULL,
      previous_version_id TEXT NULL,
      valid_from INTEGER NOT NULL,
      created_at INTEGER NOT NULL,
      superseded_at INTEGER NULL,
      name TEXT NOT NULL DEFAULT '',
      description TEXT NOT NULL DEFAULT '',
      question_text TEXT NOT NULL DEFAULT '',
      project_id TEXT NULL,
      task_type TEXT NOT NULL,
      capture_mode TEXT NOT NULL,
      success_value INTEGER NOT NULL DEFAULT 1,
      active_weekdays TEXT NOT NULL,
      recurrence TEXT NOT NULL,
      start_date INTEGER NOT NULL,
      end_date INTEGER NULL,
      due_date INTEGER NULL,
      missed_policy TEXT NOT NULL DEFAULT 'none',
      missed_consequence TEXT NOT NULL DEFAULT 'mark_as_not_done',
      missed_buffer_days INTEGER NOT NULL DEFAULT 1,
      post_buffer_behavior TEXT NOT NULL DEFAULT 'mark_as_failure',
      max_carryover_count INTEGER NOT NULL DEFAULT 3,
      goal_type TEXT NOT NULL DEFAULT 'none',
      goal_value INTEGER NOT NULL DEFAULT 1,
      goal_window_days INTEGER NULL,
      goal_period TEXT NOT NULL DEFAULT 'week',
      goal_period_alignment TEXT NOT NULL DEFAULT 'calendar',
      value_type TEXT NOT NULL DEFAULT 'none',
      value_commitment TEXT NOT NULL DEFAULT 'none',
      value_unit_key TEXT NOT NULL DEFAULT 'none',
      value_unit_label TEXT NOT NULL DEFAULT '',
      UNIQUE(task_id, version_number)
    )
  ''');
  database.execute('''
    CREATE TABLE task_entries (
      id TEXT NOT NULL PRIMARY KEY,
      task_id TEXT NOT NULL REFERENCES aufgaben(id) ON DELETE CASCADE,
      task_definition_version_id TEXT NULL REFERENCES task_definition_versions(id) ON DELETE SET NULL,
      scheduled_date INTEGER NOT NULL,
      original_scheduled_date INTEGER NULL,
      created_at INTEGER NOT NULL DEFAULT (unixepoch()),
      status TEXT NOT NULL DEFAULT 'pending',
      updated_at INTEGER NOT NULL,
      responded_at INTEGER NULL,
      finalized_at INTEGER NULL,
      effective_at INTEGER NULL,
      performed_on INTEGER NULL,
      performed_on_source TEXT NULL,
      revision INTEGER NOT NULL DEFAULT 0,
      resolution_origin TEXT NULL,
      applied_missed_policy TEXT NULL,
      applied_missed_consequence TEXT NULL,
      checkbox_value INTEGER NULL,
      number_value REAL NULL,
      note TEXT NOT NULL DEFAULT '',
      UNIQUE(task_id, scheduled_date)
    )
  ''');
  database.execute('''
    CREATE TABLE task_value_bundles (
      id TEXT NOT NULL PRIMARY KEY,
      created_at INTEGER NOT NULL DEFAULT (unixepoch()),
      updated_at INTEGER NOT NULL,
      is_active INTEGER NOT NULL DEFAULT 1
    )
  ''');
  database.execute('''
    CREATE TABLE task_value_bundle_versions (
      id TEXT NOT NULL PRIMARY KEY,
      bundle_id TEXT NOT NULL REFERENCES task_value_bundles(id) ON DELETE CASCADE,
      version_number INTEGER NOT NULL,
      previous_version_id TEXT NULL,
      valid_from INTEGER NOT NULL,
      valid_to INTEGER NULL,
      cancelled_at INTEGER NULL,
      created_at INTEGER NOT NULL DEFAULT (unixepoch()),
      name TEXT NOT NULL DEFAULT '',
      description TEXT NOT NULL DEFAULT '',
      bundle_type TEXT NOT NULL,
      first_task_id TEXT NOT NULL REFERENCES aufgaben(id) ON DELETE RESTRICT,
      second_task_id TEXT NOT NULL REFERENCES aufgaben(id) ON DELETE RESTRICT,
      first_role_label TEXT NOT NULL DEFAULT '',
      second_role_label TEXT NOT NULL DEFAULT '',
      result_label TEXT NOT NULL DEFAULT '',
      direction TEXT NOT NULL DEFAULT 'first_minus_second',
      display_mode TEXT NOT NULL DEFAULT 'combined_card',
      goal_type TEXT NOT NULL DEFAULT 'none',
      goal_value INTEGER NOT NULL DEFAULT 1,
      goal_window_days INTEGER NULL,
      first_task_day_offset INTEGER NOT NULL DEFAULT 0,
      second_task_day_offset INTEGER NOT NULL DEFAULT 0,
      UNIQUE(bundle_id, version_number)
    )
  ''');
  database.execute('''
    CREATE TABLE task_card_metric_preferences (
      id TEXT NOT NULL PRIMARY KEY,
      task_id TEXT NULL REFERENCES aufgaben(id) ON DELETE CASCADE,
      bundle_id TEXT NULL REFERENCES task_value_bundles(id) ON DELETE CASCADE,
      config_json TEXT NOT NULL,
      updated_at INTEGER NOT NULL,
      UNIQUE(task_id),
      UNIQUE(bundle_id),
      CHECK ((task_id IS NOT NULL AND bundle_id IS NULL) OR
        (task_id IS NULL AND bundle_id IS NOT NULL))
    )
  ''');

  final day = DateTime(2026, 10, 4).millisecondsSinceEpoch ~/ 1000;
  database.execute(
    "INSERT INTO aufgaben (id, name, erfassungsmodus, start_date) VALUES "
    "('task-a', 'A', 'value', $day), ('task-b', 'B', 'value', $day)",
  );
  database.execute(
    "INSERT INTO task_entries "
    "(id, task_id, scheduled_date, status, updated_at) "
    "VALUES ('entry-a', 'task-a', $day, 'recorded', $day)",
  );
  database.execute(
    "INSERT INTO task_value_bundles (id, updated_at) "
    "VALUES ('bundle-1', $day)",
  );
  database.execute(
    "INSERT INTO task_value_bundle_versions "
    "(id, bundle_id, version_number, valid_from, name, bundle_type, "
    "first_task_id, second_task_id) VALUES "
    "('bundle-version-1', 'bundle-1', 1, $day, 'A plus B', 'sum', "
    "'task-a', 'task-b')",
  );
  database.execute(
    "INSERT INTO task_card_metric_preferences "
    "(id, task_id, config_json, updated_at) VALUES "
    "('task:task-a', 'task-a', '{\"version\":1,\"items\":[]}', $day)",
  );
  database.execute('PRAGMA user_version = 19');
}
