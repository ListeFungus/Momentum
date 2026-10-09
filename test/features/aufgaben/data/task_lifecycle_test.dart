import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/task_capture_mode.dart';
import 'package:momentum/features/aufgaben/data/task_entry_status.dart';
import 'package:momentum/features/aufgaben/data/task_goal.dart';
import 'package:momentum/features/aufgaben/data/task_goal_evaluation_summary.dart';
import 'package:momentum/features/aufgaben/data/task_lifecycle_tables.dart';
import 'package:momentum/features/aufgaben/data/task_lifecycle_service.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle.dart';
import 'package:momentum/features/aufgaben/data/task_value_commitment.dart';
import 'package:momentum/features/aufgaben/data/task_value_type.dart';
import 'package:momentum/features/aufgaben/data/task_value_unit.dart';

void main() {
  late AppDatabase database;
  late AufgabenRepository repository;
  late DateTime now;

  setUp(() {
    now = DateTime(2026, 10, 4, 12);
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = AufgabenRepository(database, now: () => now);
  });

  tearDown(() => database.close());

  test('Papierkorb friert Aufgabe ein und Restore erhält Daten', () async {
    await _createCheckboxTask(repository, 'Historie');
    final task = await database.select(database.aufgaben).getSingle();
    await repository.setTaskCompleted(
      taskId: task.id,
      scheduledDate: DateTime(2026, 10, 4),
      isCompleted: true,
    );

    final preview = await repository.previewTaskDeletion(task.id);
    await repository.moveTaskToTrash(preview);

    expect(
      (await database.select(database.aufgaben).getSingle()).trashedAt,
      isNotNull,
    );
    expect(await repository.watchTasksForDate(now).first, isEmpty);
    expect(
      (await repository.getTaskAnalyticsSummary(
        taskId: task.id,
      )).totalInstanceCount,
      0,
    );
    expect(await repository.watchStoredTaskEntries(task.id).first, isEmpty);
    await expectLater(
      repository.setTaskEntryNote(
        taskId: task.id,
        scheduledDate: now,
        note: 'gesperrt',
      ),
      throwsA(isA<Exception>()),
    );

    now = DateTime(2026, 10, 6, 12);
    await repository.restoreTask(task.id);
    final restored = await database.select(database.aufgaben).getSingle();
    final entries = await database.select(database.taskEntries).get();
    expect(restored.trashedAt, isNull);
    expect(
      entries.where((entry) => entry.status == TaskEntryStatus.success),
      hasLength(1),
    );
    expect(
      (await repository.getTaskAnalyticsSummary(taskId: task.id)).successCount,
      1,
    );
    expect(
      entries.where(
        (entry) =>
            entry.scheduledDate.year == 2026 &&
            entry.scheduledDate.month == 10 &&
            entry.scheduledDate.day == 5,
      ),
      isEmpty,
    );
  });

  test('Pause spart Tage aus und Fortsetzen plant nur heute', () async {
    await _createCheckboxTask(repository, 'Pause');
    final task = await database.select(database.aufgaben).getSingle();

    await repository.pauseTask(task.id);
    expect(await repository.watchPausedTasks().first, hasLength(1));
    expect(
      await TaskLifecycleService(
        database,
        now: () => now,
      ).isTaskExcludedOnDay(task.id, DateTime(2026, 10, 5)),
      isTrue,
    );

    now = DateTime(2026, 10, 6, 9);
    await repository.ensureTaskInstancesUpToDate();
    var entries = await database.select(database.taskEntries).get();
    expect(
      entries.where(
        (entry) => entry.scheduledDate.day == 5 || entry.scheduledDate.day == 6,
      ),
      isEmpty,
    );

    await repository.resumeTask(task.id);
    entries = await database.select(database.taskEntries).get();
    expect(
      entries.where((entry) => entry.scheduledDate.day == 6),
      hasLength(1),
    );
    expect(entries.where((entry) => entry.scheduledDate.day == 5), isEmpty);
  });

  test('freiwilliger Pauseneintrag bleibt freiwillig', () async {
    await _createValueTask(repository, 'Freiwillig');
    final task = await database.select(database.aufgaben).getSingle();
    await repository.pauseTask(task.id);
    now = DateTime(2026, 10, 5, 10);
    expect(
      await TaskLifecycleService(
        database,
        now: () => now,
      ).isTaskExcludedOnDay(task.id, now),
      isTrue,
    );

    await repository.setTaskEntryValue(
      task: task,
      scheduledDate: now,
      valueType: TaskValueType.number,
      numberValue: 42,
    );
    final entry = await database.select(database.taskEntries).getSingle();
    expect(entry.planningOrigin, 'voluntary_pause');

    await repository.ensureTaskInstancesUpToDate(date: DateTime(2026, 10, 8));
    expect(await database.select(database.taskEntries).get(), hasLength(1));
  });

  test(
    'endgültige Löschung erhält Marker und referenzierendes Bündel',
    () async {
      await _createValueTask(repository, 'A');
      await _createValueTask(repository, 'B');
      final tasks = await database.select(database.aufgaben).get();
      final bundleId = await repository.createValueBundle(
        name: 'A+B',
        bundleType: TaskValueBundleType.sum,
        firstTaskId: tasks[0].id,
        secondTaskId: tasks[1].id,
      );

      await repository.deleteTask(tasks[0].id);
      await repository.permanentlyDeleteTask(tasks[0].id);

      expect(
        await database.select(database.entityDeletionMarkers).getSingle(),
        isA<EntityDeletionMarker>()
            .having(
              (marker) => marker.entityType,
              'Typ',
              DeletableEntityType.task,
            )
            .having((marker) => marker.entityId, 'ID', tasks[0].id),
      );
      expect(
        (await database.select(database.taskValueBundles).getSingle()).id,
        bundleId,
      );
      expect(
        (await database.select(database.taskValueBundleVersions).getSingle())
            .firstTaskId,
        tasks[0].id,
      );
    },
  );

  test('ein Tracking kann in mehreren Bündeln verwendet werden', () async {
    await _createValueTask(repository, 'A');
    await _createValueTask(repository, 'B');
    await _createValueTask(repository, 'C');
    final tasks = await database.select(database.aufgaben).get();
    await repository.createValueBundle(
      name: 'A+B',
      bundleType: TaskValueBundleType.sum,
      firstTaskId: tasks[0].id,
      secondTaskId: tasks[1].id,
    );
    await repository.createValueBundle(
      name: 'A+C',
      bundleType: TaskValueBundleType.sum,
      firstTaskId: tasks[0].id,
      secondTaskId: tasks[2].id,
    );

    expect(
      await database.select(database.taskValueBundles).get(),
      hasLength(2),
    );
  });

  test('abgelaufener Papierkorb wird idempotent bereinigt', () async {
    await _createCheckboxTask(repository, 'Ablauf');
    final task = await database.select(database.aufgaben).getSingle();
    await repository.deleteTask(task.id);
    now = now.add(const Duration(days: 7));

    expect(await repository.purgeExpiredTrash(), 1);
    expect(await repository.purgeExpiredTrash(), 0);
    expect(await database.select(database.aufgaben).get(), isEmpty);
    expect(
      await database.select(database.entityDeletionMarkers).get(),
      hasLength(1),
    );
  });

  test('Pause neutralisiert ein betroffenes Zielzeitfenster', () async {
    await repository.createTask(
      name: 'Ziel mit Pause',
      beschreibung: '',
      erfassungsmodus: TaskCaptureMode.checkbox,
      projectId: null,
      startDate: DateTime(2026, 10, 1),
      goalType: TaskGoalType.rollingSuccessCount,
      goalValue: 3,
      goalWindowDays: 7,
    );
    final task = await database.select(database.aufgaben).getSingle();
    await repository.pauseTask(task.id);
    now = DateTime(2026, 10, 5, 10);

    final summary = await repository.getTaskGoalEvaluationSummary(
      task: task,
      today: now,
    );

    expect(summary.state, TaskGoalEvaluationState.notEvaluated);
    expect(summary.message, contains('Pausiert'));
  });

  test('fehlende Bündelquelle bleibt in der Bündelübersicht erklärt', () async {
    await _createValueTask(repository, 'A');
    await _createValueTask(repository, 'B');
    final tasks = await database.select(database.aufgaben).get();
    await repository.createValueBundle(
      name: 'A+B',
      bundleType: TaskValueBundleType.sum,
      firstTaskId: tasks[0].id,
      secondTaskId: tasks[1].id,
    );
    await repository.deleteTask(tasks[0].id);
    await repository.permanentlyDeleteTask(tasks[0].id);

    final bundles = await repository.watchBundleLifecycleItems().first;

    expect(bundles, hasLength(1));
    expect(bundles.single.version.name, 'A+B');
    expect(bundles.single.unavailableReason, contains('endgültig gelöscht'));
  });

  test('Papierkorb leeren löscht den bestätigten Gesamtumfang', () async {
    await _createValueTask(repository, 'A');
    await _createValueTask(repository, 'B');
    final tasks = await database.select(database.aufgaben).get();
    final bundleId = await repository.createValueBundle(
      name: 'A+B',
      bundleType: TaskValueBundleType.sum,
      firstTaskId: tasks[0].id,
      secondTaskId: tasks[1].id,
    );
    await repository.deleteTask(tasks[0].id);
    await repository.moveBundleToTrash(
      await repository.previewBundleDeletion(bundleId),
    );
    final preview = await repository.previewEmptyTrash();

    expect(preview.tasks, hasLength(1));
    expect(preview.bundles, hasLength(1));
    await repository.emptyTrash(preview);

    expect(await database.select(database.aufgaben).get(), hasLength(1));
    expect(await database.select(database.taskValueBundles).get(), isEmpty);
    expect(
      await database.select(database.entityDeletionMarkers).get(),
      hasLength(2),
    );
  });

  test('Kalendertage bleiben an Zeitumstellungen stabil', () {
    expect(nextDayKey(DateTime(2026, 3, 28, 12)), '2026-03-29');
    expect(nextDayKey(DateTime(2026, 3, 29, 12)), '2026-03-30');
    expect(nextDayKey(DateTime(2026, 10, 24, 12)), '2026-10-25');
    expect(nextDayKey(DateTime(2026, 10, 25, 12)), '2026-10-26');
  });
}

Future<void> _createCheckboxTask(AufgabenRepository repository, String name) =>
    repository.createTask(
      name: name,
      beschreibung: '',
      erfassungsmodus: TaskCaptureMode.checkbox,
      projectId: null,
      startDate: DateTime(2026, 10, 1),
    );

Future<void> _createValueTask(AufgabenRepository repository, String name) =>
    repository.createTask(
      name: name,
      beschreibung: '',
      erfassungsmodus: TaskCaptureMode.value,
      projectId: null,
      startDate: DateTime(2026, 10, 1),
      valueType: TaskValueType.number,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.custom,
      valueUnitLabel: 'x',
    );
