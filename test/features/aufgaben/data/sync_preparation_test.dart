import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/task_card_metric_preference.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle.dart';
import 'package:momentum/features/aufgaben/data/task_value_commitment.dart';
import 'package:momentum/features/aufgaben/data/task_value_type.dart';
import 'package:momentum/features/aufgaben/data/task_value_unit.dart';

void main() {
  test('Aufgabenstamm stempelt echte Änderungen, aber keine No-ops', () async {
    var now = DateTime.utc(2026, 10, 8, 8);
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database, now: () => now);
    addTearDown(database.close);

    await repository.createTask(
      name: 'Lesen',
      beschreibung: '',
      erfassungsmodus: 'checkbox',
      projectId: null,
      startDate: DateTime(2026, 10, 8),
    );
    var task = await database.select(database.aufgaben).getSingle();
    final initialVersionCount = await database
        .select(database.taskDefinitionVersions)
        .get()
        .then((rows) => rows.length);
    expect(task.updatedAt?.toUtc(), now);

    now = DateTime.utc(2026, 10, 8, 9);
    await repository.updateTask(
      taskId: task.id,
      name: task.name,
      description: task.beschreibung,
      projectId: task.projectId,
      taskType: task.taskType,
      startDate: task.startDate,
      dueDate: task.dueDate,
      questionText: task.questionText,
      successValue: task.successValue,
      activeWeekdays: const {1, 2, 3, 4, 5, 6, 7},
      recurrence: task.recurrence,
    );
    task = await database.select(database.aufgaben).getSingle();
    expect(task.updatedAt?.toUtc(), DateTime.utc(2026, 10, 8, 8));
    expect(
      await database
          .select(database.taskDefinitionVersions)
          .get()
          .then((rows) => rows.length),
      initialVersionCount,
    );

    now = DateTime.utc(2026, 10, 8, 10);
    await repository.updateTask(
      taskId: task.id,
      name: task.name,
      description: 'Mit Notizen',
      projectId: task.projectId,
      taskType: task.taskType,
      startDate: task.startDate,
      dueDate: task.dueDate,
      questionText: task.questionText,
      successValue: task.successValue,
      activeWeekdays: const {1, 2, 3, 4, 5, 6, 7},
      recurrence: task.recurrence,
    );
    task = await database.select(database.aufgaben).getSingle();
    expect(task.updatedAt?.toUtc(), now);
    expect(task.beschreibung, 'Mit Notizen');
    expect(
      await database
          .select(database.taskDefinitionVersions)
          .get()
          .then((rows) => rows.length),
      initialVersionCount + 1,
    );
  });

  test('Kartenreset bleibt als idempotente Änderung gespeichert', () async {
    var now = DateTime.utc(2026, 10, 8, 8);
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database, now: () => now);
    addTearDown(database.close);
    await repository.createTask(
      name: 'Karte',
      beschreibung: '',
      erfassungsmodus: 'checkbox',
      projectId: null,
    );
    final task = await database.select(database.aufgaben).getSingle();

    now = DateTime.utc(2026, 10, 8, 9);
    await repository.setTaskCardMetricPreference(
      taskId: task.id,
      config: TaskCardMetricPreferenceConfig.hidden,
    );
    now = DateTime.utc(2026, 10, 8, 10);
    await repository.resetTaskCardMetricPreference(task.id);
    var row =
        await database.select(database.taskCardMetricPreferences).getSingle();
    expect(row.isReset, isTrue);
    expect(row.configJson, isEmpty);
    expect(row.updatedAt.toUtc(), now);
    expect(
      (await repository.getTaskCardMetricPreference(task.id)).usesDefault,
      isTrue,
    );

    now = DateTime.utc(2026, 10, 8, 11);
    await repository.resetTaskCardMetricPreference(task.id);
    row = await database.select(database.taskCardMetricPreferences).getSingle();
    expect(row.updatedAt.toUtc(), DateTime.utc(2026, 10, 8, 10));

    await repository.setTaskCardMetricPreference(
      taskId: task.id,
      config: TaskCardMetricPreferenceConfig.hidden,
    );
    row = await database.select(database.taskCardMetricPreferences).getSingle();
    expect(row.isReset, isFalse);
    expect(
      (await repository.getTaskCardMetricPreference(task.id)).isHidden,
      isTrue,
    );
  });

  test('Bündelversionen werden gestempelt und nur einmal aufgelöst', () async {
    var now = DateTime.utc(2026, 10, 8, 8);
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database, now: () => now);
    addTearDown(database.close);
    for (final name in ['Eins', 'Zwei']) {
      await repository.createTask(
        name: name,
        beschreibung: '',
        erfassungsmodus: 'value',
        projectId: null,
        valueType: TaskValueType.number,
        valueCommitment: TaskValueCommitment.pureTracking,
        valueUnitKey: TaskValueUnitKey.custom,
        valueUnitLabel: 'kcal',
      );
    }
    final tasks = await database.select(database.aufgaben).get();
    final bundleId = await repository.createValueBundle(
      name: 'Differenz',
      bundleType: TaskValueBundleType.difference,
      firstTaskId: tasks.first.id,
      secondTaskId: tasks.last.id,
    );
    var version =
        await database.select(database.taskValueBundleVersions).getSingle();
    expect(version.updatedAt?.toUtc(), now);

    now = DateTime.utc(2026, 10, 8, 9);
    await repository.dissolveValueBundle(
      bundleId: bundleId,
      validTo: DateTime(2026, 10, 8),
    );
    version =
        await database.select(database.taskValueBundleVersions).getSingle();
    final bundle = await database.select(database.taskValueBundles).getSingle();
    expect(version.updatedAt?.toUtc(), now);
    expect(bundle.updatedAt.toUtc(), now);

    now = DateTime.utc(2026, 10, 8, 10);
    await repository.dissolveValueBundle(
      bundleId: bundleId,
      validTo: DateTime(2026, 10, 8),
    );
    version =
        await database.select(database.taskValueBundleVersions).getSingle();
    final unchangedBundle =
        await database.select(database.taskValueBundles).getSingle();
    expect(version.updatedAt?.toUtc(), DateTime.utc(2026, 10, 8, 9));
    expect(unchangedBundle.updatedAt.toUtc(), DateTime.utc(2026, 10, 8, 9));
  });
}
