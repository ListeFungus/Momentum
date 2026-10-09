import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/habit_recurrence.dart';
import 'package:momentum/features/aufgaben/data/missed_policy.dart';
import 'package:momentum/features/aufgaben/data/post_buffer_behavior.dart';
import 'package:momentum/features/aufgaben/data/task_capture_mode.dart';
import 'package:momentum/features/aufgaben/data/task_definition_resolver.dart';
import 'package:momentum/features/aufgaben/data/task_entry_status.dart';
import 'package:momentum/features/aufgaben/data/task_types.dart';
import 'package:momentum/features/aufgaben/data/task_value_commitment.dart';
import 'package:momentum/features/aufgaben/data/task_value_type.dart';
import 'package:momentum/features/aufgaben/data/task_value_unit.dart';

void main() {
  test('Planungsänderung bleibt bis morgen vorgemerkt', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);
    final today = _today();

    await repository.createTask(
      name: 'Planung',
      beschreibung: '',
      erfassungsmodus: TaskCaptureMode.threeState,
      projectId: null,
      startDate: today,
      missedPolicy: MissedPolicy.direct,
    );
    final task = await database.select(database.aufgaben).getSingle();
    final originalVersion =
        await database.select(database.taskDefinitionVersions).getSingle();

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
      missedPolicy: MissedPolicy.buffer,
      missedConsequence: task.missedConsequence,
      missedBufferDays: 2,
      postBufferBehavior: PostBufferBehavior.markAsNoEntry,
      maxCarryoverCount: task.maxCarryoverCount,
      goalType: task.goalType,
      goalValue: task.goalValue,
      goalWindowDays: task.goalWindowDays,
      goalPeriod: task.goalPeriod,
      goalPeriodAlignment: task.goalPeriodAlignment,
      valueType: task.valueType,
      valueCommitment: task.valueCommitment,
      valueUnitKey: task.valueUnitKey,
      valueUnitLabel: task.valueUnitLabel,
    );

    expect(
      (await database.select(database.aufgaben).getSingle()).missedPolicy,
      MissedPolicy.direct,
    );
    expect(
      await database.select(database.taskPendingDefinitionChanges).get(),
      hasLength(1),
    );

    final tomorrow = _nextDay(today);
    await TaskDefinitionResolver(database).applyDueChanges(tomorrow);
    final updated = await database.select(database.aufgaben).getSingle();
    final entry = await database.select(database.taskEntries).getSingle();
    final historical = await TaskDefinitionResolver(
      database,
    ).taskForEntry(updated, entry);
    expect(updated.missedPolicy, MissedPolicy.buffer);
    expect(historical.missedPolicy, MissedPolicy.direct);
    expect(entry.taskDefinitionVersionId, originalVersion.id);
    expect(
      await database.select(database.taskDefinitionVersions).get(),
      hasLength(2),
    );
  });

  test('einmalige Fälligkeit verschiebt dieselbe Eintrags-ID', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);
    final today = _today();
    final firstDue = DateTime(today.year, today.month, today.day + 2);
    final secondDue = DateTime(today.year, today.month, today.day + 4);

    await repository.createTask(
      name: 'Einmalig',
      beschreibung: '',
      erfassungsmodus: TaskCaptureMode.checkbox,
      projectId: null,
      taskType: TaskTypes.task,
      recurrence: HabitRecurrence.none,
      startDate: today,
      dueDate: firstDue,
    );
    final task = await database.select(database.aufgaben).getSingle();
    final before = await database.select(database.taskEntries).getSingle();
    await repository.setTaskEntryNote(
      taskId: task.id,
      scheduledDate: firstDue,
      note: 'bleibt erhalten',
    );

    await repository.updateTask(
      taskId: task.id,
      name: task.name,
      description: task.beschreibung,
      projectId: task.projectId,
      taskType: task.taskType,
      startDate: task.startDate,
      dueDate: secondDue,
      questionText: task.questionText,
      successValue: task.successValue,
      activeWeekdays: const {1, 2, 3, 4, 5, 6, 7},
      recurrence: task.recurrence,
      valueType: task.valueType,
      valueCommitment: task.valueCommitment,
      valueUnitKey: task.valueUnitKey,
      valueUnitLabel: task.valueUnitLabel,
    );

    final after = await database.select(database.taskEntries).getSingle();
    expect(after.id, before.id);
    expect(after.scheduledDate, secondDue);
    expect(after.originalScheduledDate, firstDue);
    expect(after.note, 'bleibt erhalten');
    expect(after.revision, greaterThan(before.revision));
  });

  test('Sammelkorrektur bleibt nach Repository-Neustart undo-fähig', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    var repository = AufgabenRepository(database);
    addTearDown(database.close);
    final today = _today();
    final yesterday = DateTime(today.year, today.month, today.day - 1);

    await repository.createTask(
      name: 'Korrektur',
      beschreibung: '',
      erfassungsmodus: TaskCaptureMode.checkbox,
      projectId: null,
      startDate: yesterday,
      missedPolicy: MissedPolicy.none,
    );
    await repository.ensureTaskInstancesUpToDate(date: today);
    final task = await database.select(database.aufgaben).getSingle();
    final entries = await database.select(database.taskEntries).get();
    final preview = await repository.previewBulkStatusCorrection(
      taskId: task.id,
      entryIds: entries.map((entry) => entry.id),
      status: TaskEntryStatus.success,
      checkboxValue: true,
    );
    expect(preview.changedCount, 2);
    await repository.applyStatusCorrections(
      taskId: task.id,
      targets: preview.targets,
    );
    expect(
      (await database.select(database.taskEntries).get()).every(
        (entry) => entry.status == TaskEntryStatus.success,
      ),
      isTrue,
    );

    repository = AufgabenRepository(database);
    expect(await repository.undoLatestTaskCorrection(task.id), isTrue);
    expect(
      (await database.select(database.taskEntries).get()).every(
        (entry) => entry.status == TaskEntryStatus.pending,
      ),
      isTrue,
    );
  });

  test('Wert entfernen und Undo erhalten den ursprünglichen Wert', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);
    final today = _today();

    await repository.createTask(
      name: 'Messung',
      beschreibung: '',
      erfassungsmodus: TaskCaptureMode.value,
      projectId: null,
      startDate: today,
      valueType: TaskValueType.number,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.custom,
      valueUnitLabel: 'kcal',
    );
    final task = await database.select(database.aufgaben).getSingle();
    await repository.setTaskEntryValue(
      task: task,
      scheduledDate: today,
      valueType: TaskValueType.number,
      numberValue: 2100,
    );
    final entry = await database.select(database.taskEntries).getSingle();

    await repository.removeTaskEntryValue(
      taskId: task.id,
      entryId: entry.id,
      reason: 'Fehleingabe',
    );
    expect(await database.select(database.taskEntryValues).get(), isEmpty);
    expect(
      (await database.select(database.taskEntries).getSingle()).status,
      TaskEntryStatus.noEntry,
    );

    expect(await repository.undoLatestTaskCorrection(task.id), isTrue);
    final restored =
        await database.select(database.taskEntryValues).getSingle();
    expect(restored.numberValue, 2100);
    expect(
      (await database.select(database.taskEntries).getSingle()).status,
      TaskEntryStatus.recorded,
    );
  });

  test('Projektstichtag und gesamte Historie bleiben getrennt', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);
    final today = _today();
    final tomorrow = _nextDay(today);
    await database
        .into(database.projects)
        .insert(ProjectsCompanion.insert(id: 'a', name: 'Alt'));
    await database
        .into(database.projects)
        .insert(ProjectsCompanion.insert(id: 'b', name: 'Neu'));
    await repository.createTask(
      name: 'Projektaufgabe',
      beschreibung: '',
      erfassungsmodus: TaskCaptureMode.checkbox,
      projectId: 'a',
      startDate: today,
    );
    final task = await database.select(database.aufgaben).getSingle();

    await repository.assignTaskProjectFromDate(
      taskId: task.id,
      projectId: 'b',
      effectiveDate: tomorrow,
    );
    expect(
      (await repository.watchTasksForDate(today).first).single.project?.id,
      'a',
    );
    expect(
      (await repository.watchTasksForDate(tomorrow).first).single.project?.id,
      'b',
    );

    await repository.moveTaskProjectHistory(taskId: task.id, projectId: 'b');
    expect(
      (await repository.watchTasksForDate(today).first).single.project?.id,
      'b',
    );
    expect(await repository.undoLatestProjectAssignment(task.id), isTrue);
    expect(
      (await repository.watchTasksForDate(today).first).single.project?.id,
      'a',
    );
  });

  test('Messkonfiguration ist auch im Repository gesperrt', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    await repository.createTask(
      name: 'Fest',
      beschreibung: '',
      erfassungsmodus: TaskCaptureMode.value,
      projectId: null,
      valueType: TaskValueType.number,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.custom,
      valueUnitLabel: 'kg',
    );
    final task = await database.select(database.aufgaben).getSingle();

    expect(
      () => repository.updateTask(
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
        valueType: task.valueType,
        valueCommitment: task.valueCommitment,
        valueUnitKey: task.valueUnitKey,
        valueUnitLabel: 'lb',
      ),
      throwsStateError,
    );
  });
}

DateTime _today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

DateTime _nextDay(DateTime date) =>
    DateTime(date.year, date.month, date.day + 1);
