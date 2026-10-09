import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/task_instance_scheduler.dart';
import 'package:momentum/features/aufgaben/data/habit_recurrence.dart';
import 'package:momentum/features/aufgaben/data/missed_policy.dart';
import 'package:momentum/features/aufgaben/data/post_buffer_behavior.dart';
import 'package:momentum/features/aufgaben/data/task_analytics_period.dart';
import 'package:momentum/features/aufgaben/data/task_card_metric_preference.dart';
import 'package:momentum/features/aufgaben/data/task_capture_mode.dart';
import 'package:momentum/features/aufgaben/data/task_definition_version_writer.dart';
import 'package:momentum/features/aufgaben/data/task_definition_resolver.dart';
import 'package:momentum/features/aufgaben/data/task_goal.dart';
import 'package:momentum/features/aufgaben/data/task_goal_evaluation_summary.dart';
import 'package:momentum/features/aufgaben/data/task_entry_status.dart';
import 'package:momentum/features/aufgaben/data/task_types.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle.dart';
import 'package:momentum/features/aufgaben/data/task_value_commitment.dart';
import 'package:momentum/features/aufgaben/data/task_value_type.dart';
import 'package:momentum/features/aufgaben/data/task_value_unit.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('speichert Aufgabe und heutigen Tagesstatus', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    await repository.createTask(
      name: 'Einkaufen',
      beschreibung: 'Milch und Brot',
      erfassungsmodus: 'checkbox',
      projectId: null,
    );

    final task = await database.select(database.aufgaben).getSingle();
    final entry = await database.select(database.taskEntries).getSingle();
    final definitionVersion =
        await database.select(database.taskDefinitionVersions).getSingle();

    expect(task.id, isNotEmpty);
    expect(task.name, 'Einkaufen');
    expect(task.beschreibung, 'Milch und Brot');
    expect(task.erfassungsmodus, 'checkbox');
    expect(task.recurrence, 'daily');
    expect(task.missedPolicy, MissedPolicy.none);
    expect(task.postBufferBehavior, PostBufferBehavior.markAsFailure);
    expect(task.goalType, TaskGoalType.none);
    expect(task.goalWindowDays, isNull);
    expect(task.startDate, _today());
    expect(task.createdAt, isNotNull);
    expect(entry.taskId, task.id);
    expect(entry.taskDefinitionVersionId, definitionVersion.id);
    expect(definitionVersion.taskId, task.id);
    expect(definitionVersion.versionNumber, 1);
    expect(definitionVersion.recurrence, task.recurrence);
    expect(entry.scheduledDate, _today());
    expect(entry.createdAt, isNotNull);
    expect(entry.status, TaskEntryStatus.pending);
  });

  test('speichert vollständige Aufgabenkonfiguration typsicher', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    await repository.createTask(
      name: 'Rollierendes Ziel',
      beschreibung: '',
      erfassungsmodus: 'three_state',
      projectId: null,
      missedPolicy: MissedPolicy.buffer,
      missedBufferDays: 3,
      postBufferBehavior: PostBufferBehavior.markAsNoEntry,
      goalType: TaskGoalType.rollingSuccessCount,
      goalValue: 3,
      goalWindowDays: 10,
    );

    final task = await database.select(database.aufgaben).getSingle();

    expect(task.missedPolicy, MissedPolicy.buffer);
    expect(task.missedBufferDays, 3);
    expect(task.postBufferBehavior, PostBufferBehavior.markAsNoEntry);
    expect(task.goalType, TaskGoalType.rollingSuccessCount);
    expect(task.goalValue, 3);
    expect(task.goalWindowDays, 10);
  });

  test('watchTasksForDate liefert Aufgaben eines Tages', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    await repository.createTask(
      name: 'Sport',
      beschreibung: '30 Minuten laufen',
      erfassungsmodus: 'checkbox',
      projectId: null,
    );

    final tasks = await repository.watchTasksForDate(_today()).first;

    expect(tasks, hasLength(1));
    expect(tasks.single.task.name, 'Sport');
    expect(tasks.single.isCompleted, isFalse);
  });

  test('speichert Status getrennt für jeden Tag', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    await repository.createTask(
      name: 'Lesen',
      beschreibung: '',
      erfassungsmodus: 'checkbox',
      projectId: null,
    );

    final task = await database.select(database.aufgaben).getSingle();
    final tomorrow = _today().add(const Duration(days: 1));

    await repository.setTaskCompleted(
      taskId: task.id,
      scheduledDate: _today(),
      isCompleted: true,
    );

    final todayTasks = await repository.watchTasksForDate(_today()).first;
    final tomorrowTasks = await repository.watchTasksForDate(tomorrow).first;

    expect(todayTasks.single.isCompleted, isTrue);
    expect(todayTasks.single.entry?.finalizedAt, isNotNull);
    expect(todayTasks.single.entry?.effectiveAt, isNotNull);
    expect(
      todayTasks.single.entry?.resolutionOrigin,
      TaskEntryResolutionOrigin.manual,
    );
    expect(tomorrowTasks.single.isCompleted, isFalse);
  });

  test('verschiebt Aufgabe mit Einträgen zuerst in den Papierkorb', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    await repository.createTask(
      name: 'Meditieren',
      beschreibung: '',
      erfassungsmodus: 'checkbox',
      projectId: null,
    );

    final task = await database.select(database.aufgaben).getSingle();
    final tomorrow = _today().add(const Duration(days: 1));

    await repository.watchTasksForDate(tomorrow).first;
    await repository.deleteTask(task.id);

    var tasks = await database.select(database.aufgaben).get();
    final entries = await database.select(database.taskEntries).get();

    expect(tasks.single.trashedAt, isNotNull);
    expect(tasks.single.purgeAt, isNotNull);
    expect(entries, isNotEmpty);
    expect(await repository.watchTasksForDate(tomorrow).first, isEmpty);

    await repository.permanentlyDeleteTask(task.id);
    tasks = await database.select(database.aufgaben).get();
    expect(tasks, isEmpty);
    expect(await database.select(database.taskEntries).get(), isEmpty);
  });

  test('aktualisiert Aufgabe ohne Tageswerte zu verändern', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    await repository.createTask(
      name: 'Alter Name',
      beschreibung: 'Alte Beschreibung',
      erfassungsmodus: 'checkbox',
      projectId: null,
    );

    final task = await database.select(database.aufgaben).getSingle();
    final entryBeforeUpdate =
        await database.select(database.taskEntries).getSingle();
    final versionBeforeUpdate =
        await database.select(database.taskDefinitionVersions).getSingle();

    await repository.updateTask(
      taskId: task.id,
      name: 'Neuer Name',
      description: 'Neue Beschreibung',
      projectId: null,
      taskType: task.taskType,
      startDate: task.startDate,
      dueDate: task.dueDate,
      questionText: task.questionText,
      successValue: task.successValue,
      activeWeekdays: task.activeWeekdays.split(',').map(int.parse).toSet(),
      recurrence: task.recurrence,
    );

    final updatedTask = await database.select(database.aufgaben).getSingle();
    final entryAfterUpdate =
        await database.select(database.taskEntries).getSingle();

    expect(updatedTask.name, 'Neuer Name');
    expect(updatedTask.beschreibung, 'Neue Beschreibung');
    expect(updatedTask.erfassungsmodus, 'checkbox');
    expect(entryAfterUpdate.id, entryBeforeUpdate.id);
    expect(entryAfterUpdate.status, entryBeforeUpdate.status);
    expect(entryAfterUpdate.taskDefinitionVersionId, versionBeforeUpdate.id);
    final versions =
        await (database.select(database.taskDefinitionVersions)..orderBy([
          (version) => drift.OrderingTerm.asc(version.versionNumber),
        ])).get();
    expect(versions, hasLength(2));
    expect(versions.first.name, 'Alter Name');
    expect(versions.last.name, 'Neuer Name');
    expect(versions.last.previousVersionId, versions.first.id);
  });

  test('aktualisiert und bereinigt vollständige Konfiguration', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    await repository.createTask(
      name: 'Rollierendes Ziel',
      beschreibung: '',
      erfassungsmodus: 'three_state',
      projectId: null,
      goalType: TaskGoalType.rollingSuccessCount,
      goalValue: 3,
      goalWindowDays: 10,
    );
    final task = await database.select(database.aufgaben).getSingle();

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
      activeWeekdays: task.activeWeekdays.split(',').map(int.parse).toSet(),
      recurrence: task.recurrence,
      postBufferBehavior: PostBufferBehavior.markAsNoEntry,
      goalType: TaskGoalType.none,
      goalValue: 1,
      goalWindowDays: null,
    );

    final unchangedTask = await database.select(database.aufgaben).getSingle();
    final initialVersions =
        await (database.select(database.taskDefinitionVersions)..orderBy([
          (version) => drift.OrderingTerm.asc(version.versionNumber),
        ])).get();
    expect(unchangedTask.postBufferBehavior, PostBufferBehavior.markAsFailure);
    expect(unchangedTask.goalType, TaskGoalType.rollingSuccessCount);
    expect(initialVersions, hasLength(1));
    final pending =
        await database.select(database.taskPendingDefinitionChanges).get();
    expect(pending, hasLength(2));

    final originalEntry =
        await database.select(database.taskEntries).getSingle();
    expect(originalEntry.taskDefinitionVersionId, initialVersions.first.id);

    final now = _today();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    await repository.watchTasksForDate(tomorrow).first;
    final updatedTask = await database.select(database.aufgaben).getSingle();
    final versions =
        await (database.select(database.taskDefinitionVersions)..orderBy([
          (version) => drift.OrderingTerm.asc(version.versionNumber),
        ])).get();
    expect(updatedTask.postBufferBehavior, PostBufferBehavior.markAsNoEntry);
    expect(updatedTask.goalType, TaskGoalType.none);
    expect(updatedTask.goalWindowDays, isNull);
    expect(versions, hasLength(2));
    expect(versions.first.goalType, TaskGoalType.rollingSuccessCount);
    expect(versions.last.goalType, TaskGoalType.none);
    final tomorrowEntry =
        await (database.select(database.taskEntries)
          ..where((entry) => entry.scheduledDate.equals(tomorrow))).getSingle();
    expect(tomorrowEntry.taskDefinitionVersionId, versions.last.id);
  });

  test('Scheduler holt fehlende taegliche Instanzen idempotent nach', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    final scheduler = TaskInstanceScheduler(database);
    addTearDown(database.close);

    final startDate = _today().subtract(const Duration(days: 3));

    await repository.createTask(
      name: 'Trinken',
      beschreibung: '',
      erfassungsmodus: 'checkbox',
      projectId: null,
      startDate: startDate,
    );

    final firstRunCreated = await scheduler.ensureEntriesInRange(
      from: startDate,
      to: _today(),
    );
    final secondRunCreated = await scheduler.ensureEntriesInRange(
      from: startDate,
      to: _today(),
    );
    final entries =
        await (database.select(database.taskEntries)..orderBy([
          (entry) => drift.OrderingTerm.asc(entry.scheduledDate),
        ])).get();

    expect(firstRunCreated, 3);
    expect(secondRunCreated, 0);
    expect(entries.map((entry) => entry.scheduledDate), [
      startDate,
      startDate.add(const Duration(days: 1)),
      startDate.add(const Duration(days: 2)),
      _today(),
    ]);
  });

  test('erstellt einmalige Aufgabe mit Faelligkeit als Instanzdatum', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    final dueDate = _today().add(const Duration(days: 5));

    await repository.createTask(
      name: 'Steuererklaerung',
      beschreibung: '',
      erfassungsmodus: 'checkbox',
      projectId: null,
      taskType: TaskTypes.task,
      recurrence: HabitRecurrence.none,
      dueDate: dueDate,
    );

    final entry = await database.select(database.taskEntries).getSingle();

    expect(entry.scheduledDate, dueDate);
  });

  test('Scheduler verarbeitet direkte Konsequenz als Misserfolg', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    final scheduler = TaskInstanceScheduler(database);
    addTearDown(database.close);

    final yesterday = _today().subtract(const Duration(days: 1));

    await repository.createTask(
      name: 'Training',
      beschreibung: '',
      erfassungsmodus: 'checkbox',
      projectId: null,
      startDate: yesterday,
      missedPolicy: MissedPolicy.direct,
      missedConsequence: MissedConsequence.markAsNotDone,
    );

    await scheduler.ensureEntriesInRange(from: yesterday, to: _today());

    final entry =
        await (database.select(
          database.taskEntries,
        )..where((entry) => entry.scheduledDate.equals(yesterday))).getSingle();

    expect(entry.status, TaskEntryStatus.failure);
    expect(entry.resolutionOrigin, TaskEntryResolutionOrigin.automatic);
    expect(entry.appliedMissedPolicy, MissedPolicy.direct);
    expect(entry.appliedMissedConsequence, MissedConsequence.markAsNotDone);
    expect(entry.respondedAt, isNull);
    expect(entry.finalizedAt, isNotNull);
    expect(entry.effectiveAt, yesterday.add(const Duration(days: 1)));
  });

  test('Scheduler verarbeitet direkte Konsequenz als Kein Eintrag', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    final scheduler = TaskInstanceScheduler(database);
    addTearDown(database.close);

    final yesterday = _today().subtract(const Duration(days: 1));

    await repository.createTask(
      name: 'Spaziergang',
      beschreibung: '',
      erfassungsmodus: 'checkbox',
      projectId: null,
      startDate: yesterday,
      missedPolicy: MissedPolicy.direct,
      missedConsequence: MissedConsequence.keepNeutral,
    );

    await scheduler.ensureEntriesInRange(from: yesterday, to: _today());

    final entry =
        await (database.select(
          database.taskEntries,
        )..where((entry) => entry.scheduledDate.equals(yesterday))).getSingle();

    expect(entry.status, TaskEntryStatus.noEntry);
    expect(entry.resolutionOrigin, TaskEntryResolutionOrigin.automatic);
    expect(entry.appliedMissedPolicy, MissedPolicy.direct);
    expect(entry.appliedMissedConsequence, MissedConsequence.keepNeutral);
    expect(entry.respondedAt, isNull);
    expect(entry.finalizedAt, isNotNull);
    expect(entry.effectiveAt, yesterday.add(const Duration(days: 1)));
  });

  test('Scheduler verarbeitet Puffer als Misserfolg nach Ablauf', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    final scheduler = TaskInstanceScheduler(database);
    addTearDown(database.close);

    final dueDate = _today().subtract(const Duration(days: 2));

    await repository.createTask(
      name: 'Rechnung zahlen',
      beschreibung: '',
      erfassungsmodus: 'checkbox',
      projectId: null,
      taskType: TaskTypes.task,
      recurrence: HabitRecurrence.none,
      dueDate: dueDate,
      missedPolicy: MissedPolicy.buffer,
      missedBufferDays: 1,
      postBufferBehavior: PostBufferBehavior.markAsFailure,
    );

    await scheduler.ensureEntriesInRange(from: dueDate, to: _today());

    final entry =
        await (database.select(database.taskEntries)
          ..where((entry) => entry.scheduledDate.equals(dueDate))).getSingle();

    expect(entry.status, TaskEntryStatus.failure);
    expect(entry.resolutionOrigin, TaskEntryResolutionOrigin.automatic);
    expect(entry.appliedMissedPolicy, MissedPolicy.buffer);
    expect(entry.appliedMissedConsequence, PostBufferBehavior.markAsFailure);
    expect(entry.effectiveAt, dueDate.add(const Duration(days: 2)));
  });

  test('Scheduler verarbeitet Puffer als Kein Eintrag nach Ablauf', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    final scheduler = TaskInstanceScheduler(database);
    addTearDown(database.close);

    final dueDate = _today().subtract(const Duration(days: 2));

    await repository.createTask(
      name: 'Notiz pruefen',
      beschreibung: '',
      erfassungsmodus: 'checkbox',
      projectId: null,
      taskType: TaskTypes.task,
      recurrence: HabitRecurrence.none,
      dueDate: dueDate,
      missedPolicy: MissedPolicy.buffer,
      missedBufferDays: 1,
      postBufferBehavior: PostBufferBehavior.markAsNoEntry,
    );

    await scheduler.ensureEntriesInRange(from: dueDate, to: _today());

    final entry =
        await (database.select(database.taskEntries)
          ..where((entry) => entry.scheduledDate.equals(dueDate))).getSingle();

    expect(entry.status, TaskEntryStatus.noEntry);
    expect(entry.resolutionOrigin, TaskEntryResolutionOrigin.automatic);
    expect(entry.appliedMissedPolicy, MissedPolicy.buffer);
    expect(entry.appliedMissedConsequence, PostBufferBehavior.markAsNoEntry);
    expect(entry.effectiveAt, dueDate.add(const Duration(days: 2)));
  });

  test('Scheduler verarbeitet Puffer idempotent', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    final scheduler = TaskInstanceScheduler(database);
    addTearDown(database.close);

    final dueDate = _today().subtract(const Duration(days: 2));

    await repository.createTask(
      name: 'Puffer idempotent',
      beschreibung: '',
      erfassungsmodus: 'checkbox',
      projectId: null,
      taskType: TaskTypes.task,
      recurrence: HabitRecurrence.none,
      dueDate: dueDate,
      missedPolicy: MissedPolicy.buffer,
      missedBufferDays: 1,
      postBufferBehavior: PostBufferBehavior.markAsFailure,
    );

    final firstCreated = await scheduler.ensureEntriesInRange(
      from: dueDate,
      to: _today(),
    );
    final secondCreated = await scheduler.ensureEntriesInRange(
      from: dueDate,
      to: _today(),
    );

    final entries = await database.select(database.taskEntries).get();

    expect(firstCreated, 0);
    expect(secondCreated, 0);
    expect(entries, hasLength(1));
    expect(entries.single.status, TaskEntryStatus.failure);
    expect(entries.single.appliedMissedPolicy, MissedPolicy.buffer);
  });

  test(
    'Scheduler erlaubt Puffer-Ueberschneidung mit neuer Tagesinstanz',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = AufgabenRepository(database);
      final scheduler = TaskInstanceScheduler(database);
      addTearDown(database.close);

      final yesterday = _today().subtract(const Duration(days: 1));

      await repository.createTask(
        name: 'Puffer Ueberschneidung',
        beschreibung: '',
        erfassungsmodus: 'checkbox',
        projectId: null,
        taskType: TaskTypes.task,
        recurrence: HabitRecurrence.daily,
        startDate: yesterday,
        missedPolicy: MissedPolicy.buffer,
        missedBufferDays: 2,
        postBufferBehavior: PostBufferBehavior.markAsFailure,
      );

      await scheduler.ensureEntriesInRange(from: yesterday, to: _today());

      final entries = await _entriesForTask(database, 'Puffer Ueberschneidung');

      expect(entries, hasLength(2));
      expect(_statusByDate(entries, yesterday), TaskEntryStatus.pending);
      expect(_statusByDate(entries, _today()), TaskEntryStatus.pending);
    },
  );

  test(
    'Scheduler verarbeitet Puffer bei abschlussgebundenem Rhythmus ohne Sofort-Folgeinstanz',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = AufgabenRepository(database);
      final scheduler = TaskInstanceScheduler(database);
      addTearDown(database.close);

      final startDate = _today().subtract(const Duration(days: 2));

      await repository.createTask(
        name: 'Puffer nach Abschluss',
        beschreibung: '',
        erfassungsmodus: 'checkbox',
        projectId: null,
        taskType: TaskTypes.task,
        recurrence: HabitRecurrence.customAfterCompletion(3),
        startDate: startDate,
        missedPolicy: MissedPolicy.buffer,
        missedBufferDays: 1,
        postBufferBehavior: PostBufferBehavior.markAsFailure,
      );

      await scheduler.ensureEntriesInRange(from: startDate, to: _today());

      final entries = await _entriesForTask(database, 'Puffer nach Abschluss');

      expect(entries, hasLength(1));
      expect(entries.single.status, TaskEntryStatus.failure);
      expect(
        entries.single.effectiveAt,
        startDate.add(const Duration(days: 2)),
      );
    },
  );

  test(
    'Scheduler begrenzt Carryover und verarbeitet aelteste Eintraege',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = AufgabenRepository(database);
      final scheduler = TaskInstanceScheduler(database);
      addTearDown(database.close);

      final today = _today();
      final fiveDaysAgo = today.subtract(const Duration(days: 5));
      final threeDaysAgo = today.subtract(const Duration(days: 3));
      final twoDaysAgo = today.subtract(const Duration(days: 2));

      await repository.createTask(
        name: 'Carryover begrenzt',
        beschreibung: '',
        erfassungsmodus: 'checkbox',
        projectId: null,
        startDate: fiveDaysAgo,
        missedPolicy: MissedPolicy.carryover,
        missedConsequence: MissedConsequence.markAsNotDone,
        maxCarryoverCount: 3,
      );

      await scheduler.ensureEntriesInRange(from: fiveDaysAgo, to: today);
      await scheduler.ensureEntriesInRange(from: fiveDaysAgo, to: today);

      final entries = await _entriesForTask(database, 'Carryover begrenzt');
      final pendingEntries = entries.where(
        (entry) => entry.status == TaskEntryStatus.pending,
      );
      final failureEntries = entries.where(
        (entry) => entry.status == TaskEntryStatus.failure,
      );

      expect(entries, hasLength(6));
      expect(pendingEntries, hasLength(3));
      expect(failureEntries, hasLength(3));
      expect(_statusByDate(entries, threeDaysAgo), TaskEntryStatus.failure);
      expect(_statusByDate(entries, twoDaysAgo), TaskEntryStatus.pending);
      expect(_statusByDate(entries, today), TaskEntryStatus.pending);
      expect(
        _entryByDate(entries, threeDaysAgo).appliedMissedPolicy,
        MissedPolicy.carryover,
      );
    },
  );

  test(
    'Scheduler kann Carryover-Ueberlauf als Kein Eintrag verarbeiten',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = AufgabenRepository(database);
      final scheduler = TaskInstanceScheduler(database);
      addTearDown(database.close);

      final today = _today();
      final twoDaysAgo = today.subtract(const Duration(days: 2));

      await repository.createTask(
        name: 'Carryover Kein Eintrag',
        beschreibung: '',
        erfassungsmodus: 'checkbox',
        projectId: null,
        startDate: twoDaysAgo,
        missedPolicy: MissedPolicy.carryover,
        missedConsequence: MissedConsequence.keepNeutral,
        maxCarryoverCount: 1,
      );

      await scheduler.ensureEntriesInRange(from: twoDaysAgo, to: today);

      final entries = await _entriesForTask(database, 'Carryover Kein Eintrag');

      expect(entries, hasLength(3));
      expect(_statusByDate(entries, twoDaysAgo), TaskEntryStatus.noEntry);
      expect(_statusByDate(entries, today), TaskEntryStatus.pending);
      expect(
        _entryByDate(entries, twoDaysAgo).appliedMissedConsequence,
        MissedConsequence.keepNeutral,
      );
    },
  );

  test('Tagesansicht zeigt alte offene Carryover-Instanzen', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    final today = _today();
    final yesterday = today.subtract(const Duration(days: 1));

    await repository.createTask(
      name: 'Carryover sichtbar',
      beschreibung: '',
      erfassungsmodus: 'checkbox',
      projectId: null,
      startDate: yesterday,
      missedPolicy: MissedPolicy.carryover,
      missedConsequence: MissedConsequence.markAsNotDone,
      maxCarryoverCount: 3,
    );

    final tasks = await repository.watchTasksForDate(today).first;
    final visibleCarryover =
        tasks.where((task) => task.task.name == 'Carryover sichtbar').toList();

    expect(visibleCarryover, hasLength(2));
    expect(visibleCarryover.map((task) => task.entry?.scheduledDate).toSet(), {
      yesterday,
      today,
    });
  });

  test('Tagesansicht zeigt alte offene Puffer-Instanzen im Puffer', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    final today = _today();
    final yesterday = today.subtract(const Duration(days: 1));

    await repository.createTask(
      name: 'Puffer sichtbar',
      beschreibung: '',
      erfassungsmodus: 'checkbox',
      projectId: null,
      startDate: yesterday,
      missedPolicy: MissedPolicy.buffer,
      missedBufferDays: 2,
      postBufferBehavior: PostBufferBehavior.markAsFailure,
    );

    final tasks = await repository.watchTasksForDate(today).first;
    final visibleBuffer =
        tasks.where((task) => task.task.name == 'Puffer sichtbar').toList();

    expect(visibleBuffer, hasLength(2));
    expect(visibleBuffer.map((task) => task.entry?.scheduledDate).toSet(), {
      yesterday,
      today,
    });
  });

  test('Dringlichkeitsansicht zeigt offene Carryover-Instanzen', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    final scheduler = TaskInstanceScheduler(database);
    addTearDown(database.close);

    final today = _today();
    final yesterday = today.subtract(const Duration(days: 1));

    await repository.createTask(
      name: 'Carryover Dringlichkeit',
      beschreibung: '',
      erfassungsmodus: 'checkbox',
      projectId: null,
      taskType: TaskTypes.task,
      startDate: yesterday,
      missedPolicy: MissedPolicy.carryover,
      missedConsequence: MissedConsequence.markAsNotDone,
      maxCarryoverCount: 3,
    );

    await scheduler.ensureEntriesInRange(from: yesterday, to: today);

    final tasks = await repository.watchTasksByUrgency().first;
    final visibleCarryover = tasks.where(
      (task) => task.task.name == 'Carryover Dringlichkeit',
    );

    expect(visibleCarryover, hasLength(2));
    expect(visibleCarryover.map((task) => task.entry?.scheduledDate).toSet(), {
      yesterday,
      today,
    });
  });

  test(
    'Scheduler verarbeitet komplexes Nachholszenario ohne Duplikate',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = AufgabenRepository(database);
      final scheduler = TaskInstanceScheduler(database);
      addTearDown(database.close);

      final today = _today();
      final fiveDaysAgo = today.subtract(const Duration(days: 5));
      final fourDaysAgo = today.subtract(const Duration(days: 4));
      final twoDaysAgo = today.subtract(const Duration(days: 2));
      final yesterday = today.subtract(const Duration(days: 1));

      await repository.createTask(
        name: 'Direkt Misserfolg',
        beschreibung: '',
        erfassungsmodus: 'checkbox',
        projectId: null,
        startDate: fiveDaysAgo,
        missedPolicy: MissedPolicy.direct,
        missedConsequence: MissedConsequence.markAsNotDone,
      );
      await repository.createTask(
        name: 'Direkt Kein Eintrag',
        beschreibung: '',
        erfassungsmodus: 'checkbox',
        projectId: null,
        startDate: fiveDaysAgo,
        missedPolicy: MissedPolicy.direct,
        missedConsequence: MissedConsequence.keepNeutral,
      );
      await repository.createTask(
        name: 'Ohne Missed Policy',
        beschreibung: '',
        erfassungsmodus: 'checkbox',
        projectId: null,
        startDate: fiveDaysAgo,
        missedPolicy: MissedPolicy.none,
      );
      await repository.createTask(
        name: 'Manuell bleibt erledigt',
        beschreibung: '',
        erfassungsmodus: 'checkbox',
        projectId: null,
        startDate: fourDaysAgo,
        missedPolicy: MissedPolicy.direct,
        missedConsequence: MissedConsequence.markAsNotDone,
      );
      await repository.createTask(
        name: 'Woechentlicher Fixtermin',
        beschreibung: '',
        erfassungsmodus: 'checkbox',
        projectId: null,
        startDate: twoDaysAgo,
        recurrence: HabitRecurrence.weeklyFixedDays,
        activeWeekdays: {twoDaysAgo.weekday},
        missedPolicy: MissedPolicy.direct,
        missedConsequence: MissedConsequence.markAsNotDone,
      );
      await repository.createTask(
        name: 'Einmalige Faelligkeit',
        beschreibung: '',
        erfassungsmodus: 'checkbox',
        projectId: null,
        taskType: TaskTypes.task,
        recurrence: HabitRecurrence.none,
        dueDate: yesterday,
        missedPolicy: MissedPolicy.direct,
        missedConsequence: MissedConsequence.markAsNotDone,
      );

      final manualTask = await _taskByName(database, 'Manuell bleibt erledigt');
      await repository.setTaskCompleted(
        taskId: manualTask.id,
        scheduledDate: fourDaysAgo,
        isCompleted: true,
      );

      await scheduler.ensureEntriesInRange(from: fiveDaysAgo, to: today);
      final entryCountAfterFirstRun = await database
          .select(database.taskEntries)
          .get()
          .then((entries) => entries.length);

      await scheduler.ensureEntriesInRange(from: fiveDaysAgo, to: today);
      final entriesAfterSecondRun =
          await database.select(database.taskEntries).get();

      expect(entriesAfterSecondRun, hasLength(entryCountAfterFirstRun));

      final directFailureEntries = await _entriesForTask(
        database,
        'Direkt Misserfolg',
      );
      expect(directFailureEntries, hasLength(6));
      expect(
        _statusByDate(directFailureEntries, fiveDaysAgo),
        TaskEntryStatus.failure,
      );
      expect(
        _statusByDate(directFailureEntries, yesterday),
        TaskEntryStatus.failure,
      );
      expect(
        _statusByDate(directFailureEntries, today),
        TaskEntryStatus.pending,
      );

      final directNoEntryEntries = await _entriesForTask(
        database,
        'Direkt Kein Eintrag',
      );
      expect(directNoEntryEntries, hasLength(6));
      expect(
        _statusByDate(directNoEntryEntries, fiveDaysAgo),
        TaskEntryStatus.noEntry,
      );
      expect(
        _statusByDate(directNoEntryEntries, today),
        TaskEntryStatus.pending,
      );

      final noPolicyEntries = await _entriesForTask(
        database,
        'Ohne Missed Policy',
      );
      expect(noPolicyEntries, hasLength(6));
      expect(noPolicyEntries.map((entry) => entry.status).toSet(), {
        TaskEntryStatus.pending,
      });

      final manualEntries = await _entriesForTask(
        database,
        'Manuell bleibt erledigt',
      );
      expect(
        _statusByDate(manualEntries, fourDaysAgo),
        TaskEntryStatus.success,
      );
      expect(
        _entryByDate(manualEntries, fourDaysAgo).resolutionOrigin,
        TaskEntryResolutionOrigin.manual,
      );

      final weeklyEntries = await _entriesForTask(
        database,
        'Woechentlicher Fixtermin',
      );
      expect(weeklyEntries, hasLength(1));
      expect(weeklyEntries.single.scheduledDate, twoDaysAgo);
      expect(weeklyEntries.single.status, TaskEntryStatus.failure);

      final oneTimeEntries = await _entriesForTask(
        database,
        'Einmalige Faelligkeit',
      );
      expect(oneTimeEntries, hasLength(1));
      expect(oneTimeEntries.single.scheduledDate, yesterday);
      expect(oneTimeEntries.single.status, TaskEntryStatus.failure);
      expect(
        oneTimeEntries.single.resolutionOrigin,
        TaskEntryResolutionOrigin.automatic,
      );
    },
  );

  test(
    'Scheduler verknuepft nachgeholte vergangene Instanzen mit damaliger Version',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = AufgabenRepository(database);
      final scheduler = TaskInstanceScheduler(database);
      addTearDown(database.close);

      final startDate = _today().subtract(const Duration(days: 3));
      final missedDate = startDate.add(const Duration(days: 1));

      await repository.createTask(
        name: 'Alter Name',
        beschreibung: '',
        erfassungsmodus: 'checkbox',
        projectId: null,
        startDate: startDate,
      );

      final task = await database.select(database.aufgaben).getSingle();

      await repository.updateTask(
        taskId: task.id,
        name: 'Neuer Name',
        description: task.beschreibung,
        projectId: task.projectId,
        taskType: task.taskType,
        startDate: task.startDate,
        dueDate: task.dueDate,
        questionText: task.questionText,
        successValue: task.successValue,
        activeWeekdays: task.activeWeekdays.split(',').map(int.parse).toSet(),
        recurrence: task.recurrence,
      );

      final versions =
          await (database.select(database.taskDefinitionVersions)..orderBy([
            (version) => drift.OrderingTerm.asc(version.versionNumber),
          ])).get();

      await scheduler.ensureEntriesInRange(from: missedDate, to: missedDate);

      final missedEntry =
          await (database.select(database.taskEntries)..where(
            (entry) => entry.scheduledDate.equals(missedDate),
          )).getSingle();

      expect(versions, hasLength(2));
      expect(missedEntry.taskDefinitionVersionId, versions.first.id);
    },
  );

  test('migriert bestehenden Erledigt-Status auf heutigen Eintrag', () async {
    final tempDirectory = await Directory.systemTemp.createTemp(
      'momentum_migration_test_',
    );
    final databaseFile = File('${tempDirectory.path}/momentum.sqlite');
    final sqliteDatabase = sqlite3.open(databaseFile.path);

    sqliteDatabase.execute('''
      CREATE TABLE aufgaben (
        id TEXT NOT NULL PRIMARY KEY,
        name TEXT NOT NULL,
        beschreibung TEXT NOT NULL DEFAULT '',
        erfassungsmodus TEXT NOT NULL,
        is_completed INTEGER NOT NULL DEFAULT 0
      );
    ''');
    sqliteDatabase.execute('''
      INSERT INTO aufgaben (
        id,
        name,
        beschreibung,
        erfassungsmodus,
        is_completed
      ) VALUES ('task-1', 'Lesen', '', 'checkbox', 1);
    ''');
    sqliteDatabase.execute('PRAGMA user_version = 2;');
    sqliteDatabase.dispose();

    final database = AppDatabase.forTesting(NativeDatabase(databaseFile));

    final task = await database.select(database.aufgaben).getSingle();
    final entry = await database.select(database.taskEntries).getSingle();

    expect(task.name, 'Lesen');
    expect(task.startDate, _today());
    expect(task.createdAt, isNotNull);
    expect(entry.taskId, task.id);
    expect(entry.scheduledDate, _today());
    expect(entry.createdAt, isNotNull);
    expect(entry.status, TaskEntryStatus.success);
    expect(entry.checkboxValue, isTrue);
    expect(entry.finalizedAt, isNotNull);
    expect(entry.effectiveAt, isNotNull);
    expect(entry.resolutionOrigin, TaskEntryResolutionOrigin.migration);
    final migratedVersion =
        await database.select(database.taskDefinitionVersions).getSingle();
    expect(migratedVersion.versionNumber, 1);
    expect(entry.taskDefinitionVersionId, migratedVersion.id);

    await database.close();
    await tempDirectory.delete(recursive: true);
  });

  test('speichert Nein als manuellen endgültigen Misserfolg', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    await repository.createTask(
      name: 'Positiv formulierte Frage',
      beschreibung: '',
      erfassungsmodus: 'three_state',
      projectId: null,
    );
    final task = await database.select(database.aufgaben).getSingle();

    await repository.setBooleanHabitValue(
      task: task,
      scheduledDate: _today(),
      value: false,
    );

    final entry = await database.select(database.taskEntries).getSingle();
    expect(entry.status, TaskEntryStatus.failure);
    expect(entry.checkboxValue, isFalse);
    expect(entry.respondedAt, isNotNull);
    expect(entry.finalizedAt, isNotNull);
    expect(entry.effectiveAt, isNotNull);
    expect(entry.resolutionOrigin, TaskEntryResolutionOrigin.manual);
    expect(entry.appliedMissedPolicy, isNull);
    expect(entry.appliedMissedConsequence, isNull);
  });

  test('hebt Ja Nein Auswahl wieder auf offenen Status auf', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    await repository.createTask(
      name: 'Positiv formulierte Frage',
      beschreibung: '',
      erfassungsmodus: 'three_state',
      projectId: null,
    );
    final task = await database.select(database.aufgaben).getSingle();
    await repository.setBooleanHabitValue(
      task: task,
      scheduledDate: _today(),
      value: true,
    );

    await repository.setBooleanHabitValue(
      task: task,
      scheduledDate: _today(),
      value: null,
    );

    final entry = await database.select(database.taskEntries).getSingle();
    expect(entry.status, TaskEntryStatus.pending);
    expect(entry.checkboxValue, isNull);
    expect(entry.respondedAt, isNull);
    expect(entry.finalizedAt, isNull);
    expect(entry.effectiveAt, isNull);
    expect(entry.resolutionOrigin, isNull);
  });

  test('speichert begruendeten Kein-Eintrag-Sonderfall', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    await repository.createTask(
      name: 'Positiv formulierte Frage',
      beschreibung: '',
      erfassungsmodus: 'three_state',
      projectId: null,
    );
    final task = await database.select(database.aufgaben).getSingle();

    await repository.setTaskEntryNoEntry(
      task: task,
      scheduledDate: _today(),
      reason: 'Krank',
    );

    final entry = await database.select(database.taskEntries).getSingle();
    expect(entry.status, TaskEntryStatus.noEntry);
    expect(entry.checkboxValue, isNull);
    expect(entry.note, 'Krank');
    expect(entry.respondedAt, isNotNull);
    expect(entry.finalizedAt, isNull);
    expect(entry.effectiveAt, isNull);
    expect(entry.resolutionOrigin, TaskEntryResolutionOrigin.manual);
  });

  test('berechnet Grundauswertung fuer TaskEntries', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    await repository.createTask(
      name: 'Sport',
      beschreibung: '',
      erfassungsmodus: 'three_state',
      projectId: null,
    );

    final task = await database.select(database.aufgaben).getSingle();
    final today = _today();
    final threeDaysAgo = today.subtract(const Duration(days: 3));
    final twoDaysAgo = today.subtract(const Duration(days: 2));
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));

    await repository.setBooleanHabitValue(
      task: task,
      scheduledDate: threeDaysAgo,
      value: true,
    );
    await repository.setBooleanHabitValue(
      task: task,
      scheduledDate: twoDaysAgo,
      value: false,
    );
    await repository.setTaskEntryNoEntry(
      task: task,
      scheduledDate: yesterday,
      reason: 'Krank',
    );
    await repository.setBooleanHabitValue(
      task: task,
      scheduledDate: tomorrow,
      value: null,
    );

    final summary = await repository.getTaskAnalyticsSummary(
      taskId: task.id,
      today: today,
    );

    expect(summary.successCount, 1);
    expect(summary.failureCount, 1);
    expect(summary.noEntryCount, 1);
    expect(summary.pendingCount, 2);
    expect(summary.answeredCount, 2);
    expect(summary.resolvedCount, 3);
    expect(summary.dueCount, 3);
    expect(summary.totalInstanceCount, 5);
    expect(summary.strictSuccessRate, closeTo(1 / 3, 0.0001));
    expect(summary.valuedSuccessRate, closeTo(1 / 2, 0.0001));
    expect(summary.completionRate, closeTo(3 / 5, 0.0001));
  });

  test('berechnet Grundauswertung fuer ausgewaehlten Zeitraum', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    final today = _today();
    await repository.createTask(
      name: 'Sport',
      beschreibung: '',
      erfassungsmodus: 'three_state',
      projectId: null,
      startDate: today.subtract(const Duration(days: 40)),
    );

    final task = await database.select(database.aufgaben).getSingle();
    await repository.setBooleanHabitValue(
      task: task,
      scheduledDate: today.subtract(const Duration(days: 25)),
      value: true,
    );
    await repository.setBooleanHabitValue(
      task: task,
      scheduledDate: today.subtract(const Duration(days: 6)),
      value: true,
    );
    await repository.setBooleanHabitValue(
      task: task,
      scheduledDate: today.subtract(const Duration(days: 1)),
      value: false,
    );

    final summary = await repository.getTaskAnalyticsSummaryForPeriod(
      task: task,
      period: TaskAnalyticsPeriod.last7Days,
      today: today,
    );

    expect(summary.successCount, 1);
    expect(summary.failureCount, 1);
    expect(summary.dueCount, 2);
    expect(summary.totalInstanceCount, 2);
  });

  test('bewertet rollierendes Statusziel als erreicht', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    final today = _today();
    await repository.createTask(
      name: 'Ziel erreicht',
      beschreibung: '',
      erfassungsmodus: 'three_state',
      projectId: null,
      startDate: today.subtract(const Duration(days: 10)),
      missedPolicy: MissedPolicy.direct,
      goalType: TaskGoalType.rollingSuccessCount,
      goalValue: 2,
      goalWindowDays: 7,
    );

    final task = await database.select(database.aufgaben).getSingle();
    await repository.setBooleanHabitValue(
      task: task,
      scheduledDate: today.subtract(const Duration(days: 2)),
      value: true,
    );
    await repository.setBooleanHabitValue(
      task: task,
      scheduledDate: today.subtract(const Duration(days: 1)),
      value: true,
    );

    final goal = await repository.getTaskGoalEvaluationSummary(
      task: task,
      today: today,
    );

    expect(goal.state, TaskGoalEvaluationState.achieved);
    expect(goal.requiredSuccessCount, 2);
    expect(goal.successCount, 2);
    expect(goal.windowDays, 7);
  });

  test(
    'bewertet rollierendes Statusziel mit offenen Eintraegen als auf Kurs',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = AufgabenRepository(database);
      addTearDown(database.close);

      final today = _today();
      await repository.createTask(
        name: 'Ziel auf Kurs',
        beschreibung: '',
        erfassungsmodus: 'three_state',
        projectId: null,
        startDate: today.subtract(const Duration(days: 10)),
        missedPolicy: MissedPolicy.direct,
        goalType: TaskGoalType.rollingSuccessCount,
        goalValue: 2,
        goalWindowDays: 7,
      );

      final task = await database.select(database.aufgaben).getSingle();
      await repository.setBooleanHabitValue(
        task: task,
        scheduledDate: today.subtract(const Duration(days: 1)),
        value: true,
      );
      await repository.setBooleanHabitValue(
        task: task,
        scheduledDate: today,
        value: null,
      );

      final goal = await repository.getTaskGoalEvaluationSummary(
        task: task,
        today: today,
      );

      expect(goal.state, TaskGoalEvaluationState.reachable);
      expect(goal.successCount, 1);
      expect(goal.pendingCount, 1);
    },
  );

  test(
    'bewertet rollierendes Statusziel ohne genug moegliche Erfolge als rot',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = AufgabenRepository(database);
      addTearDown(database.close);

      final today = _today();
      await repository.createTask(
        name: 'Ziel verfehlt',
        beschreibung: '',
        erfassungsmodus: 'three_state',
        projectId: null,
        startDate: today.subtract(const Duration(days: 10)),
        missedPolicy: MissedPolicy.direct,
        goalType: TaskGoalType.rollingSuccessCount,
        goalValue: 3,
        goalWindowDays: 7,
      );

      final task = await database.select(database.aufgaben).getSingle();
      await repository.setBooleanHabitValue(
        task: task,
        scheduledDate: today.subtract(const Duration(days: 2)),
        value: false,
      );
      await repository.setBooleanHabitValue(
        task: task,
        scheduledDate: today.subtract(const Duration(days: 1)),
        value: true,
      );
      await repository.setBooleanHabitValue(
        task: task,
        scheduledDate: today,
        value: null,
      );

      final goal = await repository.getTaskGoalEvaluationSummary(
        task: task,
        today: today,
      );

      expect(goal.state, TaskGoalEvaluationState.missed);
      expect(goal.successCount, 1);
      expect(goal.failureCount, 1);
      expect(goal.pendingCount, 1);
    },
  );

  test(
    'bewertet historische Statuszielbloecke als erreicht und nicht erreicht',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = AufgabenRepository(database);
      addTearDown(database.close);

      final today = _today();
      await repository.createTask(
        name: 'Zielhistorie',
        beschreibung: '',
        erfassungsmodus: 'three_state',
        projectId: null,
        startDate: today.subtract(const Duration(days: 14)),
        missedPolicy: MissedPolicy.direct,
        goalType: TaskGoalType.rollingSuccessCount,
        goalValue: 2,
        goalWindowDays: 7,
      );

      final task = await database.select(database.aufgaben).getSingle();
      await repository.setBooleanHabitValue(
        task: task,
        scheduledDate: today.subtract(const Duration(days: 14)),
        value: true,
      );
      await repository.setBooleanHabitValue(
        task: task,
        scheduledDate: today.subtract(const Duration(days: 13)),
        value: false,
      );
      await repository.setBooleanHabitValue(
        task: task,
        scheduledDate: today.subtract(const Duration(days: 7)),
        value: true,
      );
      await repository.setBooleanHabitValue(
        task: task,
        scheduledDate: today.subtract(const Duration(days: 6)),
        value: true,
      );

      final history = await repository.getTaskGoalHistorySummary(
        task: task,
        today: today,
      );

      expect(history.blocks, hasLength(2));
      expect(history.blocks.first.state, TaskGoalEvaluationState.achieved);
      expect(history.blocks.first.successCount, 2);
      expect(history.blocks.last.state, TaskGoalEvaluationState.missed);
      expect(history.blocks.last.successCount, 1);
      expect(history.evaluatedBlockCount, 2);
      expect(history.achievedBlockCount, 1);
      expect(history.achievedRate, 0.5);
    },
  );

  test('historische Statuszielbloecke listen laufenden Block nicht', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    final today = _today();
    await repository.createTask(
      name: 'Laufender Zielblock',
      beschreibung: '',
      erfassungsmodus: 'three_state',
      projectId: null,
      startDate: today.subtract(const Duration(days: 6)),
      missedPolicy: MissedPolicy.direct,
      goalType: TaskGoalType.rollingSuccessCount,
      goalValue: 2,
      goalWindowDays: 7,
    );

    final task = await database.select(database.aufgaben).getSingle();
    await repository.setBooleanHabitValue(
      task: task,
      scheduledDate: today.subtract(const Duration(days: 1)),
      value: true,
    );
    await repository.setBooleanHabitValue(
      task: task,
      scheduledDate: today,
      value: true,
    );

    final history = await repository.getTaskGoalHistorySummary(
      task: task,
      today: today,
    );

    expect(history.blocks, isEmpty);
    expect(history.evaluatedBlockCount, 0);
  });

  test(
    'wertet historische Statuszielbloecke mit offenen Eintraegen nicht',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = AufgabenRepository(database);
      addTearDown(database.close);

      final today = _today();
      await repository.createTask(
        name: 'Offener Altblock',
        beschreibung: '',
        erfassungsmodus: 'three_state',
        projectId: null,
        startDate: today.subtract(const Duration(days: 7)),
        missedPolicy: MissedPolicy.direct,
        goalType: TaskGoalType.rollingSuccessCount,
        goalValue: 2,
        goalWindowDays: 7,
      );

      final task = await database.select(database.aufgaben).getSingle();
      await repository.setBooleanHabitValue(
        task: task,
        scheduledDate: today.subtract(const Duration(days: 7)),
        value: true,
      );
      await repository.setBooleanHabitValue(
        task: task,
        scheduledDate: today.subtract(const Duration(days: 6)),
        value: null,
      );

      final history = await repository.getTaskGoalHistorySummary(
        task: task,
        today: today,
      );

      expect(history.blocks, hasLength(1));
      expect(history.blocks.single.state, TaskGoalEvaluationState.notEvaluated);
      expect(history.blocks.single.isEvaluated, isFalse);
      expect(history.blocks.single.pendingCount, 1);
      expect(history.evaluatedBlockCount, 0);
      expect(history.achievedRate, isNull);
    },
  );

  test(
    'plant reine Zielaenderung ab naechstem Zielblock ohne aktive Aufgabe zu aendern',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = AufgabenRepository(database);
      addTearDown(database.close);

      final today = _today();
      await repository.createTask(
        name: 'Geplantes Ziel',
        beschreibung: '',
        erfassungsmodus: 'three_state',
        projectId: null,
        startDate: today.subtract(const Duration(days: 6)),
        missedPolicy: MissedPolicy.direct,
        goalType: TaskGoalType.rollingSuccessCount,
        goalValue: 1,
        goalWindowDays: 7,
      );

      final task = await database.select(database.aufgaben).getSingle();
      await repository.scheduleTaskGoalChangeForNextBlock(
        taskId: task.id,
        goalType: TaskGoalType.rollingSuccessCount,
        goalValue: 2,
        goalWindowDays: 7,
        goalPeriod: GoalPeriod.week,
        goalPeriodAlignment: GoalPeriodAlignment.fromStartDate,
        today: today,
      );

      final unchangedTask =
          await database.select(database.aufgaben).getSingle();
      final versions =
          await (database.select(database.taskDefinitionVersions)..orderBy([
            (version) => drift.OrderingTerm.asc(version.validFrom),
          ])).get();

      expect(unchangedTask.goalValue, 1);
      expect(versions, hasLength(1));
      final pending =
          await database
              .select(database.taskPendingDefinitionChanges)
              .getSingle();
      expect(pending.groupKey, 'goal');
      expect(pending.effectiveDate, today.add(const Duration(days: 1)));
    },
  );

  test(
    'bewertet geplante Zielaenderung live erst ab Wirksamkeitsdatum',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = AufgabenRepository(database);
      addTearDown(database.close);

      final today = _today();
      await repository.createTask(
        name: 'Wirksames Ziel',
        beschreibung: '',
        erfassungsmodus: 'three_state',
        projectId: null,
        startDate: today.subtract(const Duration(days: 6)),
        missedPolicy: MissedPolicy.direct,
        goalType: TaskGoalType.rollingSuccessCount,
        goalValue: 1,
        goalWindowDays: 7,
      );

      final task = await database.select(database.aufgaben).getSingle();
      await repository.setBooleanHabitValue(
        task: task,
        scheduledDate: today,
        value: true,
      );
      await repository.setBooleanHabitValue(
        task: task,
        scheduledDate: today.add(const Duration(days: 1)),
        value: null,
      );
      await repository.scheduleTaskGoalChangeForNextBlock(
        taskId: task.id,
        goalType: TaskGoalType.rollingSuccessCount,
        goalValue: 2,
        goalWindowDays: 7,
        goalPeriod: GoalPeriod.week,
        goalPeriodAlignment: GoalPeriodAlignment.fromStartDate,
        today: today,
      );

      final beforeChange = await repository.getTaskGoalEvaluationSummary(
        task: task,
        today: today,
      );
      await TaskDefinitionResolver(
        database,
      ).applyDueChanges(today.add(const Duration(days: 1)));
      final afterChange = await repository.getTaskGoalEvaluationSummary(
        task: task,
        today: today.add(const Duration(days: 1)),
      );

      expect(beforeChange.requiredSuccessCount, 1);
      expect(beforeChange.state, TaskGoalEvaluationState.achieved);
      expect(afterChange.requiredSuccessCount, 2);
      expect(afterChange.state, TaskGoalEvaluationState.reachable);
    },
  );

  test(
    'bewertet historische Zielbloecke mit der am Blockstart gueltigen Zielaenderung',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = AufgabenRepository(database);
      addTearDown(database.close);

      final today = _today();
      await repository.createTask(
        name: 'Historische Zielregel',
        beschreibung: '',
        erfassungsmodus: 'three_state',
        projectId: null,
        startDate: today.subtract(const Duration(days: 14)),
        missedPolicy: MissedPolicy.direct,
        goalType: TaskGoalType.rollingSuccessCount,
        goalValue: 2,
        goalWindowDays: 7,
      );

      final task = await database.select(database.aufgaben).getSingle();
      await repository.scheduleTaskGoalChangeForNextBlock(
        taskId: task.id,
        goalType: TaskGoalType.rollingSuccessCount,
        goalValue: 3,
        goalWindowDays: 7,
        goalPeriod: GoalPeriod.week,
        goalPeriodAlignment: GoalPeriodAlignment.fromStartDate,
        today: today.subtract(const Duration(days: 8)),
      );
      await repository.setBooleanHabitValue(
        task: task,
        scheduledDate: today.subtract(const Duration(days: 14)),
        value: true,
      );
      await repository.setBooleanHabitValue(
        task: task,
        scheduledDate: today.subtract(const Duration(days: 13)),
        value: true,
      );
      await repository.setBooleanHabitValue(
        task: task,
        scheduledDate: today.subtract(const Duration(days: 7)),
        value: true,
      );
      await repository.setBooleanHabitValue(
        task: task,
        scheduledDate: today.subtract(const Duration(days: 6)),
        value: true,
      );

      await TaskDefinitionResolver(database).applyDueChanges(today);

      final history = await repository.getTaskGoalHistorySummary(
        task: task,
        today: today,
      );

      expect(history.blocks, hasLength(2));
      expect(history.blocks.first.requiredSuccessCount, 3);
      expect(history.blocks.first.successCount, 2);
      expect(history.blocks.first.state, TaskGoalEvaluationState.missed);
      expect(history.blocks.last.requiredSuccessCount, 2);
      expect(history.blocks.last.successCount, 2);
      expect(history.blocks.last.state, TaskGoalEvaluationState.achieved);
    },
  );

  test(
    'markiert sofortige Zielaenderung mitten im historischen Block als nicht gewertet',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = AufgabenRepository(database);
      addTearDown(database.close);

      final today = _today();
      await repository.createTask(
        name: 'Sofortige Zielaenderung',
        beschreibung: '',
        erfassungsmodus: 'three_state',
        projectId: null,
        startDate: today.subtract(const Duration(days: 3)),
        missedPolicy: MissedPolicy.direct,
        goalType: TaskGoalType.rollingSuccessCount,
        goalValue: 2,
        goalWindowDays: 7,
      );

      final task = await database.select(database.aufgaben).getSingle();
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
        activeWeekdays: {1, 2, 3, 4, 5, 6, 7},
        recurrence: task.recurrence,
        missedPolicy: task.missedPolicy,
        missedConsequence: task.missedConsequence,
        missedBufferDays: task.missedBufferDays,
        postBufferBehavior: task.postBufferBehavior,
        maxCarryoverCount: task.maxCarryoverCount,
        goalType: TaskGoalType.rollingSuccessCount,
        goalValue: 3,
        goalWindowDays: 7,
        goalPeriod: task.goalPeriod,
        goalPeriodAlignment: task.goalPeriodAlignment,
        valueType: task.valueType,
        valueCommitment: task.valueCommitment,
        valueUnitKey: task.valueUnitKey,
        valueUnitLabel: task.valueUnitLabel,
      );

      await repository.setBooleanHabitValue(
        task: task,
        scheduledDate: today.subtract(const Duration(days: 3)),
        value: true,
      );
      await repository.setBooleanHabitValue(
        task: task,
        scheduledDate: today.subtract(const Duration(days: 2)),
        value: true,
      );

      final history = await repository.getTaskGoalHistorySummary(
        task: task,
        today: today.add(const Duration(days: 4)),
      );

      expect(history.blocks, hasLength(1));
      expect(history.blocks.single.state, TaskGoalEvaluationState.notEvaluated);
      expect(history.blocks.single.message, contains('mitten'));
      expect(history.evaluatedBlockCount, 0);
    },
  );

  test(
    'speichert Wert-Konfiguration in Aufgabe und Definitionsversion',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = AufgabenRepository(database);
      addTearDown(database.close);

      await repository.createTask(
        name: 'Wasser trinken',
        beschreibung: '',
        erfassungsmodus: 'value',
        projectId: null,
        taskType: TaskTypes.habit,
        recurrence: HabitRecurrence.daily,
        valueType: TaskValueType.number,
        valueCommitment: TaskValueCommitment.pureTracking,
        valueUnitKey: TaskValueUnitKey.liter,
        valueUnitLabel: '',
      );

      final task = await database.select(database.aufgaben).getSingle();
      final version =
          await database.select(database.taskDefinitionVersions).getSingle();

      expect(task.erfassungsmodus, 'value');
      expect(task.valueType, TaskValueType.number);
      expect(task.valueCommitment, TaskValueCommitment.pureTracking);
      expect(task.valueUnitKey, TaskValueUnitKey.liter);
      expect(version.valueType, TaskValueType.number);
      expect(version.valueCommitment, TaskValueCommitment.pureTracking);
      expect(version.valueUnitKey, TaskValueUnitKey.liter);
    },
  );

  test('speichert Zahlenwert als recorded mit eigener Wertzeile', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    await repository.createTask(
      name: 'Wasser trinken',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      valueType: TaskValueType.number,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.liter,
      valueUnitLabel: '',
    );

    final task = await database.select(database.aufgaben).getSingle();
    await repository.setTaskEntryValue(
      task: task,
      scheduledDate: task.startDate,
      valueType: TaskValueType.number,
      numberValue: 2.5,
    );

    final entry = await database.select(database.taskEntries).getSingle();
    final value = await database.select(database.taskEntryValues).getSingle();

    expect(entry.status, TaskEntryStatus.recorded);
    expect(entry.numberValue, 2.5);
    expect(value.entryId, entry.id);
    expect(value.valueType, TaskValueType.number);
    expect(value.numberValue, 2.5);
    expect(value.normalizedNumberValue, 2500);
    expect(value.unitKey, TaskValueUnitKey.liter);
  });

  test('verbindliche Wert-Eingabe bleibt nach Erfassung recorded', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    final scheduler = TaskInstanceScheduler(database);
    addTearDown(database.close);

    final yesterday = _today().subtract(const Duration(days: 1));

    await repository.createTask(
      name: 'Pflichtwert erfasst',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: yesterday,
      missedPolicy: MissedPolicy.direct,
      missedConsequence: MissedConsequence.markAsNotDone,
      valueType: TaskValueType.number,
      valueCommitment: TaskValueCommitment.required,
      valueUnitKey: TaskValueUnitKey.liter,
      valueUnitLabel: '',
    );

    final task = await database.select(database.aufgaben).getSingle();
    await repository.setTaskEntryValue(
      task: task,
      scheduledDate: yesterday,
      valueType: TaskValueType.number,
      numberValue: 1.5,
    );

    await scheduler.ensureEntriesInRange(from: yesterday, to: _today());

    final entry =
        await (database.select(
          database.taskEntries,
        )..where((entry) => entry.scheduledDate.equals(yesterday))).getSingle();
    final value = await database.select(database.taskEntryValues).getSingle();

    expect(entry.status, TaskEntryStatus.recorded);
    expect(entry.resolutionOrigin, TaskEntryResolutionOrigin.manual);
    expect(value.numberValue, 1.5);
  });

  test('verbindliche Wert-Eingabe verarbeitet direkte Konsequenz', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    final scheduler = TaskInstanceScheduler(database);
    addTearDown(database.close);

    final yesterday = _today().subtract(const Duration(days: 1));

    await repository.createTask(
      name: 'Pflichtwert verpasst',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: yesterday,
      missedPolicy: MissedPolicy.direct,
      missedConsequence: MissedConsequence.markAsNotDone,
      valueType: TaskValueType.number,
      valueCommitment: TaskValueCommitment.required,
      valueUnitKey: TaskValueUnitKey.liter,
      valueUnitLabel: '',
    );

    await scheduler.ensureEntriesInRange(from: yesterday, to: _today());

    final entry =
        await (database.select(
          database.taskEntries,
        )..where((entry) => entry.scheduledDate.equals(yesterday))).getSingle();
    final values = await database.select(database.taskEntryValues).get();

    expect(entry.status, TaskEntryStatus.failure);
    expect(entry.resolutionOrigin, TaskEntryResolutionOrigin.automatic);
    expect(entry.appliedMissedPolicy, MissedPolicy.direct);
    expect(entry.appliedMissedConsequence, MissedConsequence.markAsNotDone);
    expect(values, isEmpty);
  });

  test(
    'verbindliche Wert-Eingabe verarbeitet Puffer als Kein Eintrag',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = AufgabenRepository(database);
      final scheduler = TaskInstanceScheduler(database);
      addTearDown(database.close);

      final twoDaysAgo = _today().subtract(const Duration(days: 2));

      await repository.createTask(
        name: 'Pflichtwert mit Puffer',
        beschreibung: '',
        erfassungsmodus: 'value',
        projectId: null,
        taskType: TaskTypes.habit,
        recurrence: HabitRecurrence.daily,
        startDate: twoDaysAgo,
        missedPolicy: MissedPolicy.buffer,
        missedBufferDays: 1,
        postBufferBehavior: PostBufferBehavior.markAsNoEntry,
        valueType: TaskValueType.timeOfDay,
        valueCommitment: TaskValueCommitment.required,
        valueUnitKey: TaskValueUnitKey.timeOfDay,
        valueUnitLabel: '',
      );

      await scheduler.ensureEntriesInRange(from: twoDaysAgo, to: _today());

      final entry =
          await (database.select(database.taskEntries)..where(
            (entry) => entry.scheduledDate.equals(twoDaysAgo),
          )).getSingle();

      expect(entry.status, TaskEntryStatus.noEntry);
      expect(entry.resolutionOrigin, TaskEntryResolutionOrigin.automatic);
      expect(entry.appliedMissedPolicy, MissedPolicy.buffer);
      expect(entry.appliedMissedConsequence, PostBufferBehavior.markAsNoEntry);
    },
  );

  test('verbindliche Wert-Eingabe begrenzt Carryover', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    final scheduler = TaskInstanceScheduler(database);
    addTearDown(database.close);

    final threeDaysAgo = _today().subtract(const Duration(days: 3));

    await repository.createTask(
      name: 'Pflichtwert mit Carryover',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: threeDaysAgo,
      missedPolicy: MissedPolicy.carryover,
      missedConsequence: MissedConsequence.markAsNotDone,
      maxCarryoverCount: 1,
      valueType: TaskValueType.duration,
      valueCommitment: TaskValueCommitment.required,
      valueUnitKey: TaskValueUnitKey.minute,
      valueUnitLabel: '',
    );

    await scheduler.ensureEntriesInRange(from: threeDaysAgo, to: _today());

    final entries = await database.select(database.taskEntries).get();
    final pendingCount =
        entries
            .where((entry) => entry.status == TaskEntryStatus.pending)
            .length;
    final failureCount =
        entries
            .where((entry) => entry.status == TaskEntryStatus.failure)
            .length;

    expect(entries, hasLength(4));
    expect(pendingCount, 1);
    expect(failureCount, 3);
  });

  test('zeigt reines Tracking ohne gespeicherten Entry', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    final today = DateTime(2026, 8, 4);

    await repository.createTask(
      name: 'Gewicht',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: today,
      valueType: TaskValueType.number,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.custom,
      valueUnitLabel: 'kg',
    );

    final entriesBefore = await database.select(database.taskEntries).get();
    expect(entriesBefore, isEmpty);

    final tasks =
        await repository
            .watchTasksForDate(today, taskType: TaskTypes.habit)
            .first;

    expect(tasks, hasLength(1));
    expect(tasks.single.task.name, 'Gewicht');
    expect(tasks.single.entry, isNull);
    expect(tasks.single.entryValue, isNull);

    final entriesAfter = await database.select(database.taskEntries).get();
    expect(entriesAfter, isEmpty);
  });

  test('Scheduler erzeugt keine leeren Entries fuer reines Tracking', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    final startDate = DateTime(2026, 8, 1);

    await repository.createTask(
      name: 'Schlafenszeit',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: startDate,
      valueType: TaskValueType.timeOfDay,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.timeOfDay,
      valueUnitLabel: '',
    );

    final createdCount = await repository.ensureTaskInstancesUpToDate(
      date: DateTime(2026, 8, 4),
    );
    final entries = await database.select(database.taskEntries).get();

    expect(createdCount, 0);
    expect(entries, isEmpty);
  });

  test('listet abgeschlossene einmalige Wert-Aufgaben', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    await repository.createTask(
      name: 'Einmaliger Messwert',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.task,
      recurrence: HabitRecurrence.none,
      valueType: TaskValueType.number,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.custom,
      valueUnitLabel: 'Schritte',
    );

    final task = await database.select(database.aufgaben).getSingle();
    await repository.setTaskEntryValue(
      task: task,
      scheduledDate: task.startDate,
      valueType: TaskValueType.number,
      numberValue: 1200,
    );

    final completedTasks = await repository.watchCompletedOneTimeTasks().first;

    expect(completedTasks, hasLength(1));
    expect(completedTasks.single.task.name, 'Einmaliger Messwert');
    expect(completedTasks.single.entry?.status, TaskEntryStatus.recorded);
    expect(completedTasks.single.entryValue?.numberValue, 1200);
  });

  test('zeigt offene einmalige reine Wert-Aufgabe in Dringlichkeit', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    await repository.createTask(
      name: 'Geld zur Seite legen',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.task,
      recurrence: HabitRecurrence.none,
      valueType: TaskValueType.number,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.custom,
      valueUnitLabel: 'Euro',
    );

    final urgencyTasksBefore = await repository.watchTasksByUrgency().first;

    expect(urgencyTasksBefore, hasLength(1));
    expect(urgencyTasksBefore.single.task.name, 'Geld zur Seite legen');
    expect(urgencyTasksBefore.single.entry, isNull);

    final task = await database.select(database.aufgaben).getSingle();
    await repository.setTaskEntryValue(
      task: task,
      scheduledDate: task.startDate,
      valueType: TaskValueType.number,
      numberValue: 50,
    );

    final urgencyTasksAfter = await repository.watchTasksByUrgency().first;
    final completedTasks = await repository.watchCompletedOneTimeTasks().first;

    expect(urgencyTasksAfter, isEmpty);
    expect(completedTasks, hasLength(1));
    expect(completedTasks.single.entry?.status, TaskEntryStatus.recorded);
    expect(completedTasks.single.entryValue?.numberValue, 50);
  });

  test(
    'Wert-Auswertung berechnet Zahlen und virtuelle Tracking-Luecken',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = AufgabenRepository(database);
      addTearDown(database.close);

      final today = DateTime(2026, 8, 10);
      final startDate = DateTime(2026, 8, 1);

      await repository.createTask(
        name: 'Wasser trinken',
        beschreibung: '',
        erfassungsmodus: 'value',
        projectId: null,
        taskType: TaskTypes.habit,
        recurrence: HabitRecurrence.daily,
        startDate: startDate,
        valueType: TaskValueType.number,
        valueCommitment: TaskValueCommitment.pureTracking,
        valueUnitKey: TaskValueUnitKey.liter,
        valueUnitLabel: '',
      );

      final task = await database.select(database.aufgaben).getSingle();
      await repository.setTaskEntryValue(
        task: task,
        scheduledDate: DateTime(2026, 8, 4),
        valueType: TaskValueType.number,
        numberValue: 1,
      );
      await repository.setTaskEntryValue(
        task: task,
        scheduledDate: DateTime(2026, 8, 5),
        valueType: TaskValueType.number,
        numberValue: 2.5,
      );
      await repository.setTaskEntryValue(
        task: task,
        scheduledDate: DateTime(2026, 8, 1),
        valueType: TaskValueType.number,
        numberValue: 99,
      );

      final entryCountBefore = await database
          .select(database.taskEntries)
          .get()
          .then((entries) => entries.length);

      final summary = await repository.getTaskValueAnalyticsSummaryForPeriod(
        task: task,
        period: TaskAnalyticsPeriod.last7Days,
        today: today,
      );

      final entryCountAfter = await database
          .select(database.taskEntries)
          .get()
          .then((entries) => entries.length);

      expect(summary.periodStart, DateTime(2026, 8, 4));
      expect(summary.periodEnd, DateTime(2026, 8, 10));
      expect(summary.recordedCount, 2);
      expect(summary.virtualMissingCount, 5);
      expect(summary.sum, 3.5);
      expect(summary.average, 1.75);
      expect(summary.minimum, 1);
      expect(summary.maximum, 2.5);
      expect(summary.unitLabel, 'Liter');
      expect(entryCountAfter, entryCountBefore);
    },
  );

  test('Wert-Auswertung zaehlt Pflichtwert-Status getrennt', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    final scheduler = TaskInstanceScheduler(database);
    addTearDown(database.close);

    final today = _today();
    final twoDaysAgo = today.subtract(const Duration(days: 2));
    final yesterday = today.subtract(const Duration(days: 1));

    await repository.createTask(
      name: 'Pflichtgewicht',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: twoDaysAgo,
      missedPolicy: MissedPolicy.direct,
      missedConsequence: MissedConsequence.markAsNotDone,
      valueType: TaskValueType.number,
      valueCommitment: TaskValueCommitment.required,
      valueUnitKey: TaskValueUnitKey.custom,
      valueUnitLabel: 'kg',
    );

    final task = await database.select(database.aufgaben).getSingle();
    await repository.setTaskEntryValue(
      task: task,
      scheduledDate: yesterday,
      valueType: TaskValueType.number,
      numberValue: 80,
    );
    await scheduler.ensureEntriesInRange(from: twoDaysAgo, to: today);

    final summary = await repository.getTaskValueAnalyticsSummaryForPeriod(
      task: task,
      period: TaskAnalyticsPeriod.last7Days,
      today: today,
    );

    expect(summary.recordedCount, 1);
    expect(summary.failureCount, 1);
    expect(summary.pendingCount, 1);
    expect(summary.virtualMissingCount, 0);
    expect(summary.sum, 80);
    expect(summary.average, 80);
  });

  test('Wertziel bewertet Mindest-Summe aus echten Zahlwerten', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    final today = _today();
    await repository.createTask(
      name: 'Wasserziel',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: today.subtract(const Duration(days: 6)),
      missedPolicy: MissedPolicy.direct,
      valueType: TaskValueType.number,
      valueCommitment: TaskValueCommitment.required,
      valueUnitKey: TaskValueUnitKey.liter,
      goalType: TaskGoalType.valueSumMin,
      goalValue: 3,
      goalWindowDays: 7,
    );

    final task = await database.select(database.aufgaben).getSingle();
    await repository.setTaskEntryValue(
      task: task,
      scheduledDate: today.subtract(const Duration(days: 1)),
      valueType: TaskValueType.number,
      numberValue: 1.5,
    );
    await repository.setTaskEntryValue(
      task: task,
      scheduledDate: today,
      valueType: TaskValueType.number,
      numberValue: 2,
    );

    final goal = await repository.getTaskValueGoalEvaluationSummary(
      task: task,
      today: today,
    );

    expect(goal.state, TaskGoalEvaluationState.reachable);
    expect(goal.actualValue, 3.5);
    expect(goal.targetValue, 3);
    expect(goal.recordedCount, 2);
  });

  test('Kartenkennzahl zeigt Wertziel mit Ergebnis und Datenbasis', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    final today = _today();
    await repository.createTask(
      name: 'Wasserziel',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: today,
      missedPolicy: MissedPolicy.direct,
      valueType: TaskValueType.number,
      valueCommitment: TaskValueCommitment.required,
      valueUnitKey: TaskValueUnitKey.liter,
      goalType: TaskGoalType.valueSumMin,
      goalValue: 2,
      goalWindowDays: 7,
    );

    final task = await database.select(database.aufgaben).getSingle();
    await repository.setTaskEntryValue(
      task: task,
      scheduledDate: today,
      valueType: TaskValueType.number,
      numberValue: 2.5,
    );

    final taskList =
        await repository
            .watchTaskListForDate(today, taskType: TaskTypes.habit)
            .first;
    final metric = taskList.tasks.single.cardMetric;

    expect(metric?.label, 'Summe');
    expect(metric?.value, '2.5 Liter');
    expect(metric?.detail, contains('Ziel: mindestens 2 Liter'));
    expect(metric?.detail, contains('1 Werte'));
  });

  test(
    'Kartenkennzahl nutzt ohne Ziel den Wertdurchschnitt als Standard',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = AufgabenRepository(database);
      addTearDown(database.close);

      final today = _today();
      await repository.createTask(
        name: 'Gewicht',
        beschreibung: '',
        erfassungsmodus: 'value',
        projectId: null,
        taskType: TaskTypes.habit,
        recurrence: HabitRecurrence.daily,
        startDate: today,
        valueType: TaskValueType.number,
        valueCommitment: TaskValueCommitment.pureTracking,
        valueUnitKey: TaskValueUnitKey.custom,
        valueUnitLabel: 'kg',
      );

      final task = await database.select(database.aufgaben).getSingle();
      await repository.setTaskEntryValue(
        task: task,
        scheduledDate: today,
        valueType: TaskValueType.number,
        numberValue: 80,
      );

      final taskList =
          await repository
              .watchTaskListForDate(today, taskType: TaskTypes.habit)
              .first;
      final metric = taskList.tasks.single.cardMetric;

      expect(metric?.label, 'Durchschnitt');
      expect(metric?.value, '80 kg');
      expect(metric?.detail, contains('Letzte 7 Tage'));
    },
  );

  test(
    'Kartenanzeige speichert Auswahl, Ausblenden und Standard getrennt',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = AufgabenRepository(database);
      addTearDown(database.close);

      await repository.createTask(
        name: 'Kartenwahl',
        beschreibung: '',
        erfassungsmodus: 'three_state',
        projectId: null,
        taskType: TaskTypes.habit,
        recurrence: HabitRecurrence.daily,
        startDate: _today(),
      );
      final task = await database.select(database.aufgaben).getSingle();
      final versionCountBefore = await database
          .select(database.taskDefinitionVersions)
          .get()
          .then((rows) => rows.length);

      await repository.setTaskCardMetricPreference(
        taskId: task.id,
        config: const TaskCardMetricPreferenceConfig(
          items: [
            TaskCardMetricPreferenceItem(
              metric: TaskCardMetricKey.successCount,
              period: TaskAnalyticsPeriod.last20Days,
            ),
          ],
        ),
      );
      final selected = await repository.getTaskCardMetricPreference(task.id);
      expect(selected.isStored, isTrue);
      expect(
        selected.config!.items.single.metric,
        TaskCardMetricKey.successCount,
      );
      expect(
        selected.config!.items.single.period,
        TaskAnalyticsPeriod.last20Days,
      );

      await repository.setTaskCardMetricPreference(
        taskId: task.id,
        config: TaskCardMetricPreferenceConfig.hidden,
      );
      expect(
        (await repository.getTaskCardMetricPreference(task.id)).isHidden,
        isTrue,
      );

      await repository.resetTaskCardMetricPreference(task.id);
      expect(
        (await repository.getTaskCardMetricPreference(task.id)).usesDefault,
        isTrue,
      );
      expect(
        await database
            .select(database.taskDefinitionVersions)
            .get()
            .then((rows) => rows.length),
        versionCountBefore,
      );
    },
  );

  test('explizit ausgeblendete Kartenanzeige lädt keine Kennzahl', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    await repository.createTask(
      name: 'Ohne Kartenwert',
      beschreibung: '',
      erfassungsmodus: 'three_state',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: _today(),
    );
    final task = await database.select(database.aufgaben).getSingle();
    await repository.setTaskCardMetricPreference(
      taskId: task.id,
      config: TaskCardMetricPreferenceConfig.hidden,
    );

    final list =
        await repository
            .watchTaskListForDate(_today(), taskType: TaskTypes.habit)
            .first;

    expect(list.tasks.single.cardMetrics, isEmpty);
    expect(list.tasks.single.cardMetric, isNull);
  });

  test('Kartenkennzahl mischt geänderte Einheiten nicht still', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);
    final today = _today();

    await repository.createTask(
      name: 'Messwert',
      beschreibung: '',
      erfassungsmodus: TaskCaptureMode.value,
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: today.subtract(const Duration(days: 2)),
      valueType: TaskValueType.number,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.custom,
      valueUnitLabel: 'kg',
    );
    var task = await database.select(database.aufgaben).getSingle();
    await repository.setTaskEntryValue(
      task: task,
      scheduledDate: today.subtract(const Duration(days: 1)),
      valueType: TaskValueType.number,
      numberValue: 80,
    );
    await (database.update(database.aufgaben)..where(
      (candidate) => candidate.id.equals(task.id),
    )).write(const AufgabenCompanion(valueUnitLabel: drift.Value('lb')));
    task = await database.select(database.aufgaben).getSingle();
    await TaskDefinitionVersionWriter(
      database,
    ).createVersion(task, validFrom: today);
    await repository.setTaskEntryValue(
      task: task,
      scheduledDate: today,
      valueType: TaskValueType.number,
      numberValue: 176,
    );

    final list =
        await repository
            .watchTaskListForDate(today, taskType: TaskTypes.habit)
            .first;

    expect(list.tasks.single.cardMetric?.value, contains('nicht verfügbar'));
  });

  test(
    'Wertziel bewertet Hoechstens-Durchschnitt bei Dauer in Minuten',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = AufgabenRepository(database);
      addTearDown(database.close);

      final today = _today();
      await repository.createTask(
        name: 'Dauerziel',
        beschreibung: '',
        erfassungsmodus: 'value',
        projectId: null,
        taskType: TaskTypes.habit,
        recurrence: HabitRecurrence.daily,
        startDate: today.subtract(const Duration(days: 6)),
        missedPolicy: MissedPolicy.direct,
        valueType: TaskValueType.duration,
        valueCommitment: TaskValueCommitment.required,
        valueUnitKey: TaskValueUnitKey.minute,
        goalType: TaskGoalType.valueAverageMax,
        goalValue: 30,
        goalWindowDays: 7,
      );

      final task = await database.select(database.aufgaben).getSingle();
      await repository.setTaskEntryValue(
        task: task,
        scheduledDate: today.subtract(const Duration(days: 1)),
        valueType: TaskValueType.duration,
        durationSeconds: 20 * 60,
      );
      await repository.setTaskEntryValue(
        task: task,
        scheduledDate: today,
        valueType: TaskValueType.duration,
        durationSeconds: 30 * 60,
      );

      final goal = await repository.getTaskValueGoalEvaluationSummary(
        task: task,
        today: today,
      );

      expect(goal.state, TaskGoalEvaluationState.reachable);
      expect(goal.actualValue, 25 * 60);
      expect(goal.targetValue, 30 * 60);
    },
  );

  test(
    'Wertziel zeigt Datenluecke als Warnstatus statt sauber gruen',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = AufgabenRepository(database);
      final scheduler = TaskInstanceScheduler(database);
      addTearDown(database.close);

      final today = _today();
      await repository.createTask(
        name: 'Lueckenziel',
        beschreibung: '',
        erfassungsmodus: 'value',
        projectId: null,
        taskType: TaskTypes.habit,
        recurrence: HabitRecurrence.daily,
        startDate: today.subtract(const Duration(days: 1)),
        missedPolicy: MissedPolicy.direct,
        missedConsequence: MissedConsequence.keepNeutral,
        valueType: TaskValueType.number,
        valueCommitment: TaskValueCommitment.required,
        valueUnitKey: TaskValueUnitKey.custom,
        valueUnitLabel: 'kcal',
        goalType: TaskGoalType.valueAverageMin,
        goalValue: 100,
        goalWindowDays: 7,
      );

      final task = await database.select(database.aufgaben).getSingle();
      await repository.setTaskEntryValue(
        task: task,
        scheduledDate: today,
        valueType: TaskValueType.number,
        numberValue: 120,
      );
      await scheduler.ensureEntriesInRange(
        from: today.subtract(const Duration(days: 1)),
        to: today,
      );

      final goal = await repository.getTaskValueGoalEvaluationSummary(
        task: task,
        today: today,
      );

      expect(goal.state, TaskGoalEvaluationState.reachable);
      expect(goal.actualValue, 120);
      expect(goal.missingOrOpenCount, 1);
    },
  );

  test('Wert-Auswertung berechnet Uhrzeit mit Folgetag-Bezug', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    final today = DateTime(2026, 8, 10);

    await repository.createTask(
      name: 'Bettgehzeit',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: DateTime(2026, 8, 9),
      valueType: TaskValueType.timeOfDay,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.timeOfDay,
      valueUnitLabel: '',
    );

    final task = await database.select(database.aufgaben).getSingle();
    await repository.setTaskEntryValue(
      task: task,
      scheduledDate: DateTime(2026, 8, 9),
      valueType: TaskValueType.timeOfDay,
      timeMinutes: 23 * 60 + 30,
    );
    await repository.setTaskEntryValue(
      task: task,
      scheduledDate: DateTime(2026, 8, 10),
      valueType: TaskValueType.timeOfDay,
      timeMinutes: 30,
      dayOffset: 1,
    );

    final summary = await repository.getTaskValueAnalyticsSummaryForPeriod(
      task: task,
      period: TaskAnalyticsPeriod.last7Days,
      today: today,
    );

    expect(summary.recordedCount, 2);
    expect(summary.sum, isNull);
    expect(summary.minimum, 1410);
    expect(summary.maximum, 1470);
    expect(summary.average, 1440);
  });

  test('Bündel berechnet Zeitintervall über Mitternacht', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    final today = DateTime(2026, 8, 4);

    await repository.createTask(
      name: 'Bettgehzeit',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: today,
      valueType: TaskValueType.timeOfDay,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.timeOfDay,
      valueUnitLabel: '',
    );
    await repository.createTask(
      name: 'Aufstehzeit',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: today,
      valueType: TaskValueType.timeOfDay,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.timeOfDay,
      valueUnitLabel: '',
    );

    final tasks = await database.select(database.aufgaben).get();
    final bedtime = tasks.singleWhere((task) => task.name == 'Bettgehzeit');
    final wakeTime = tasks.singleWhere((task) => task.name == 'Aufstehzeit');

    await repository.createValueBundle(
      name: 'Schlafdauer',
      bundleType: TaskValueBundleType.timeInterval,
      firstTaskId: bedtime.id,
      secondTaskId: wakeTime.id,
      firstRoleLabel: 'Bettgehzeit',
      secondRoleLabel: 'Aufstehzeit',
      resultLabel: 'Schlafdauer',
      validFrom: today,
    );
    await repository.setTaskEntryValue(
      task: bedtime,
      scheduledDate: today,
      valueType: TaskValueType.timeOfDay,
      timeMinutes: 23 * 60 + 30,
    );
    await repository.setTaskEntryValue(
      task: wakeTime,
      scheduledDate: today,
      valueType: TaskValueType.timeOfDay,
      timeMinutes: 7 * 60 + 15,
    );

    final taskList =
        await repository
            .watchTaskListForDate(today, taskType: TaskTypes.habit)
            .first;

    expect(taskList.tasks, isEmpty);
    expect(taskList.valueBundles, hasLength(1));
    expect(taskList.valueBundles.single.calculation?.durationSeconds, 27900);
  });

  test('Bündel-Auswertung zählt Status und aggregiert Ergebnisse', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    final startDate = DateTime(2026, 8, 4);
    final secondDate = DateTime(2026, 8, 5);
    final thirdDate = DateTime(2026, 8, 6);

    await repository.createTask(
      name: 'Bettgehzeit',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: startDate,
      valueType: TaskValueType.timeOfDay,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.timeOfDay,
      valueUnitLabel: '',
    );
    await repository.createTask(
      name: 'Aufstehzeit',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: startDate,
      valueType: TaskValueType.timeOfDay,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.timeOfDay,
      valueUnitLabel: '',
    );

    final tasks = await database.select(database.aufgaben).get();
    final bedtime = tasks.singleWhere((task) => task.name == 'Bettgehzeit');
    final wakeTime = tasks.singleWhere((task) => task.name == 'Aufstehzeit');

    await repository.createValueBundle(
      name: 'Schlafdauer',
      bundleType: TaskValueBundleType.timeInterval,
      firstTaskId: bedtime.id,
      secondTaskId: wakeTime.id,
      firstRoleLabel: 'Bettgehzeit',
      secondRoleLabel: 'Aufstehzeit',
      resultLabel: 'Schlafdauer',
      validFrom: startDate,
    );
    final version =
        await database.select(database.taskValueBundleVersions).getSingle();

    await repository.setTaskEntryValue(
      task: bedtime,
      scheduledDate: startDate,
      valueType: TaskValueType.timeOfDay,
      timeMinutes: 23 * 60,
    );
    await repository.setTaskEntryValue(
      task: wakeTime,
      scheduledDate: startDate,
      valueType: TaskValueType.timeOfDay,
      timeMinutes: 7 * 60,
    );
    await repository.setTaskEntryValue(
      task: bedtime,
      scheduledDate: secondDate,
      valueType: TaskValueType.timeOfDay,
      timeMinutes: 23 * 60 + 30,
    );

    final summary = await repository
        .getTaskValueBundleAnalyticsSummaryForPeriod(
          version: version,
          period: TaskAnalyticsPeriod.last7Days,
          today: thirdDate,
        );

    expect(summary.completeCount, 1);
    expect(summary.partialCount, 1);
    expect(summary.missingCount, 1);
    expect(summary.notCalculableCount, 0);
    expect(summary.sum, isNull);
    expect(summary.average, 8 * 60 * 60);
    expect(summary.minimum, 8 * 60 * 60);
    expect(summary.maximum, 8 * 60 * 60);
    expect(summary.points, hasLength(3));
  });

  test('Bündel-Wertziel bewertet Mindest-Summe aus Zahlendifferenz', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    final today = DateTime(2026, 8, 4);

    await repository.createTask(
      name: 'Kalorien aufgenommen',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: today.subtract(const Duration(days: 1)),
      valueType: TaskValueType.number,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.custom,
      valueUnitLabel: 'kcal',
    );
    await repository.createTask(
      name: 'Kalorien verbraucht',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: today.subtract(const Duration(days: 1)),
      valueType: TaskValueType.number,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.custom,
      valueUnitLabel: 'kcal',
    );

    final tasks = await database.select(database.aufgaben).get();
    final intake = tasks.singleWhere(
      (task) => task.name == 'Kalorien aufgenommen',
    );
    final burn = tasks.singleWhere(
      (task) => task.name == 'Kalorien verbraucht',
    );

    await repository.createValueBundle(
      name: 'Kalorienbilanz',
      bundleType: TaskValueBundleType.difference,
      firstTaskId: intake.id,
      secondTaskId: burn.id,
      goalType: TaskGoalType.valueSumMin,
      goalValue: 500,
      goalWindowDays: 7,
      validFrom: today.subtract(const Duration(days: 1)),
    );
    final version =
        await database.select(database.taskValueBundleVersions).getSingle();

    await repository.setTaskEntryValue(
      task: intake,
      scheduledDate: today.subtract(const Duration(days: 1)),
      valueType: TaskValueType.number,
      numberValue: 3000,
    );
    await repository.setTaskEntryValue(
      task: burn,
      scheduledDate: today.subtract(const Duration(days: 1)),
      valueType: TaskValueType.number,
      numberValue: 2500,
    );
    await repository.setTaskEntryValue(
      task: intake,
      scheduledDate: today,
      valueType: TaskValueType.number,
      numberValue: 2800,
    );
    await repository.setTaskEntryValue(
      task: burn,
      scheduledDate: today,
      valueType: TaskValueType.number,
      numberValue: 2200,
    );

    final goal = await repository.getTaskValueBundleGoalEvaluationSummary(
      version: version,
      today: today,
    );

    expect(goal.state, TaskGoalEvaluationState.achieved);
    expect(goal.actualValue, 1100);
    expect(goal.targetValue, 500);
    expect(goal.recordedCount, 2);
  });

  test(
    'Bündel-Wertziel bewertet Hoechstens-Durchschnitt bei Zeitintervall',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = AufgabenRepository(database);
      addTearDown(database.close);

      final today = DateTime(2026, 8, 4);

      await repository.createTask(
        name: 'Bettgehzeit',
        beschreibung: '',
        erfassungsmodus: 'value',
        projectId: null,
        taskType: TaskTypes.habit,
        recurrence: HabitRecurrence.daily,
        startDate: today,
        valueType: TaskValueType.timeOfDay,
        valueCommitment: TaskValueCommitment.pureTracking,
        valueUnitKey: TaskValueUnitKey.timeOfDay,
        valueUnitLabel: '',
      );
      await repository.createTask(
        name: 'Aufstehzeit',
        beschreibung: '',
        erfassungsmodus: 'value',
        projectId: null,
        taskType: TaskTypes.habit,
        recurrence: HabitRecurrence.daily,
        startDate: today,
        valueType: TaskValueType.timeOfDay,
        valueCommitment: TaskValueCommitment.pureTracking,
        valueUnitKey: TaskValueUnitKey.timeOfDay,
        valueUnitLabel: '',
      );

      final tasks = await database.select(database.aufgaben).get();
      final bedtime = tasks.singleWhere((task) => task.name == 'Bettgehzeit');
      final wakeTime = tasks.singleWhere((task) => task.name == 'Aufstehzeit');

      await repository.createValueBundle(
        name: 'Schlafdauer',
        bundleType: TaskValueBundleType.timeInterval,
        firstTaskId: bedtime.id,
        secondTaskId: wakeTime.id,
        goalType: TaskGoalType.valueAverageMax,
        goalValue: 8 * 60,
        goalWindowDays: 7,
        validFrom: today,
      );
      final version =
          await database.select(database.taskValueBundleVersions).getSingle();

      await repository.setTaskEntryValue(
        task: bedtime,
        scheduledDate: today,
        valueType: TaskValueType.timeOfDay,
        timeMinutes: 23 * 60,
      );
      await repository.setTaskEntryValue(
        task: wakeTime,
        scheduledDate: today,
        valueType: TaskValueType.timeOfDay,
        timeMinutes: 7 * 60,
      );

      final goal = await repository.getTaskValueBundleGoalEvaluationSummary(
        version: version,
        today: today,
      );

      expect(goal.state, TaskGoalEvaluationState.achieved);
      expect(goal.actualValue, 8 * 60 * 60);
      expect(goal.targetValue, 8 * 60 * 60);
    },
  );

  test('Bündel-Wertziel verbietet Summenziel fuer Zeitintervall', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    final today = DateTime(2026, 8, 4);

    await repository.createTask(
      name: 'Bettgehzeit',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: today,
      valueType: TaskValueType.timeOfDay,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.timeOfDay,
      valueUnitLabel: '',
    );
    await repository.createTask(
      name: 'Aufstehzeit',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: today,
      valueType: TaskValueType.timeOfDay,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.timeOfDay,
      valueUnitLabel: '',
    );

    final tasks = await database.select(database.aufgaben).get();
    final bedtime = tasks.singleWhere((task) => task.name == 'Bettgehzeit');
    final wakeTime = tasks.singleWhere((task) => task.name == 'Aufstehzeit');

    expect(
      () => repository.createValueBundle(
        name: 'Schlafdauer',
        bundleType: TaskValueBundleType.timeInterval,
        firstTaskId: bedtime.id,
        secondTaskId: wakeTime.id,
        goalType: TaskGoalType.valueSumMin,
        goalValue: 480,
        goalWindowDays: 7,
        validFrom: today,
      ),
      throwsStateError,
    );
  });

  test('Bündel berechnet Freitext-Zahlendifferenz permissiv', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    final today = DateTime(2026, 8, 4);

    await repository.createTask(
      name: 'Kalorien aufgenommen',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: today,
      valueType: TaskValueType.number,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.custom,
      valueUnitLabel: 'kcal',
    );
    await repository.createTask(
      name: 'Kalorien verbraucht',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: today,
      valueType: TaskValueType.number,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.custom,
      valueUnitLabel: 'Schritte',
    );

    final tasks = await database.select(database.aufgaben).get();
    final intake = tasks.singleWhere(
      (task) => task.name == 'Kalorien aufgenommen',
    );
    final burn = tasks.singleWhere(
      (task) => task.name == 'Kalorien verbraucht',
    );

    await repository.createValueBundle(
      name: 'Kalorienbilanz',
      bundleType: TaskValueBundleType.difference,
      firstTaskId: intake.id,
      secondTaskId: burn.id,
      firstRoleLabel: 'Aufnahme',
      secondRoleLabel: 'Verbrauch',
      resultLabel: 'Bilanz',
      validFrom: today,
    );
    await repository.setTaskEntryValue(
      task: intake,
      scheduledDate: today,
      valueType: TaskValueType.number,
      numberValue: 3000,
    );
    await repository.setTaskEntryValue(
      task: burn,
      scheduledDate: today,
      valueType: TaskValueType.number,
      numberValue: 200,
    );

    final bundles = await repository.getValueBundlesForDate(
      today,
      taskType: TaskTypes.habit,
    );

    expect(bundles.single.calculation?.numberValue, 2800);
  });

  test('Kartenkennzahl zeigt Buendel-Durchschnitt ohne Ziel', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    final today = DateTime(2026, 8, 4);

    await repository.createTask(
      name: 'Kalorien aufgenommen',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: today,
      valueType: TaskValueType.number,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.custom,
      valueUnitLabel: 'kcal',
    );
    await repository.createTask(
      name: 'Kalorien verbraucht',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: today,
      valueType: TaskValueType.number,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.custom,
      valueUnitLabel: 'kcal',
    );

    final tasks = await database.select(database.aufgaben).get();
    final intake = tasks.singleWhere(
      (task) => task.name == 'Kalorien aufgenommen',
    );
    final burn = tasks.singleWhere(
      (task) => task.name == 'Kalorien verbraucht',
    );

    await repository.createValueBundle(
      name: 'Kalorienbilanz',
      bundleType: TaskValueBundleType.difference,
      firstTaskId: intake.id,
      secondTaskId: burn.id,
      firstRoleLabel: 'Aufnahme',
      secondRoleLabel: 'Verbrauch',
      resultLabel: 'Bilanz',
      validFrom: today,
    );
    await repository.setTaskEntryValue(
      task: intake,
      scheduledDate: today,
      valueType: TaskValueType.number,
      numberValue: 3000,
    );
    await repository.setTaskEntryValue(
      task: burn,
      scheduledDate: today,
      valueType: TaskValueType.number,
      numberValue: 200,
    );

    final taskList =
        await repository
            .watchTaskListForDate(today, taskType: TaskTypes.habit)
            .first;
    final metric = taskList.valueBundles.single.cardMetric;

    expect(metric?.label, 'Durchschnitt');
    expect(metric?.value, '2800 kcal');
    expect(metric?.detail, contains('Letzte 7 Tage'));
  });

  test('Teiltracking darf in mehreren aktiven Bündeln liegen', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    final today = DateTime(2026, 8, 4);

    for (final name in ['Wert A', 'Wert B', 'Wert C']) {
      await repository.createTask(
        name: name,
        beschreibung: '',
        erfassungsmodus: 'value',
        projectId: null,
        taskType: TaskTypes.habit,
        recurrence: HabitRecurrence.daily,
        startDate: today,
        valueType: TaskValueType.number,
        valueCommitment: TaskValueCommitment.pureTracking,
        valueUnitKey: TaskValueUnitKey.custom,
        valueUnitLabel: '',
      );
    }

    final tasks = await database.select(database.aufgaben).get();
    final first = tasks.singleWhere((task) => task.name == 'Wert A');
    final second = tasks.singleWhere((task) => task.name == 'Wert B');
    final third = tasks.singleWhere((task) => task.name == 'Wert C');

    await repository.createValueBundle(
      name: 'Erstes Bündel',
      bundleType: TaskValueBundleType.sum,
      firstTaskId: first.id,
      secondTaskId: second.id,
      validFrom: today,
    );

    await repository.createValueBundle(
      name: 'Zweites Bündel',
      bundleType: TaskValueBundleType.sum,
      firstTaskId: first.id,
      secondTaskId: third.id,
      validFrom: today,
    );

    expect(await database.select(database.taskValueBundles).get(), hasLength(2));
  });

  test('Bündel-Erstellung listet nur passende zweite Trackings', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    final today = DateTime(2026, 8, 4);

    await repository.createTask(
      name: 'Bettgehzeit',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: today,
      valueType: TaskValueType.timeOfDay,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.timeOfDay,
      valueUnitLabel: '',
    );
    await repository.createTask(
      name: 'Aufstehzeit',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: today,
      valueType: TaskValueType.timeOfDay,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.timeOfDay,
      valueUnitLabel: '',
    );
    await repository.createTask(
      name: 'Wasser',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: today,
      valueType: TaskValueType.number,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.liter,
      valueUnitLabel: '',
    );

    final tasks = await database.select(database.aufgaben).get();
    final bedtime = tasks.singleWhere((task) => task.name == 'Bettgehzeit');
    final wakeTime = tasks.singleWhere((task) => task.name == 'Aufstehzeit');

    final candidates = await repository.compatibleTasksForValueBundle(
      baseTask: bedtime,
      bundleType: TaskValueBundleType.timeInterval,
      date: today,
    );

    expect(candidates.map((task) => task.name), ['Aufstehzeit']);

    await repository.createValueBundle(
      name: 'Schlafdauer',
      bundleType: TaskValueBundleType.timeInterval,
      firstTaskId: bedtime.id,
      secondTaskId: wakeTime.id,
      validFrom: today,
    );

    final candidatesAfterBundle = await repository
        .compatibleTasksForValueBundle(
          baseTask: bedtime,
          bundleType: TaskValueBundleType.timeInterval,
          date: today,
        );

    expect(candidatesAfterBundle.map((task) => task.name), ['Aufstehzeit']);
  });

  test(
    'Bündel-Erstellung speichert Gilt-ab, Richtung und Anzeigeart',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = AufgabenRepository(database);
      addTearDown(database.close);

      final firstStart = DateTime(2026, 8, 1);
      final secondStart = DateTime(2026, 8, 4);
      final validFrom = DateTime(2026, 8, 7);

      await repository.createTask(
        name: 'Aufnahme',
        beschreibung: '',
        erfassungsmodus: 'value',
        projectId: null,
        taskType: TaskTypes.habit,
        recurrence: HabitRecurrence.daily,
        startDate: firstStart,
        valueType: TaskValueType.number,
        valueCommitment: TaskValueCommitment.pureTracking,
        valueUnitKey: TaskValueUnitKey.custom,
        valueUnitLabel: 'kcal',
      );
      await repository.createTask(
        name: 'Verbrauch',
        beschreibung: '',
        erfassungsmodus: 'value',
        projectId: null,
        taskType: TaskTypes.habit,
        recurrence: HabitRecurrence.daily,
        startDate: secondStart,
        valueType: TaskValueType.number,
        valueCommitment: TaskValueCommitment.pureTracking,
        valueUnitKey: TaskValueUnitKey.custom,
        valueUnitLabel: 'kcal',
      );

      final tasks = await database.select(database.aufgaben).get();
      final intake = tasks.singleWhere((task) => task.name == 'Aufnahme');
      final burn = tasks.singleWhere((task) => task.name == 'Verbrauch');

      await repository.createValueBundle(
        name: 'Bilanz',
        bundleType: TaskValueBundleType.difference,
        firstTaskId: intake.id,
        secondTaskId: burn.id,
        direction: TaskValueBundleDirection.secondMinusFirst,
        displayMode: TaskValueBundleDisplayMode.linkedCards,
        validFrom: validFrom,
      );

      final version =
          await database.select(database.taskValueBundleVersions).getSingle();

      expect(version.validFrom, validFrom);
      expect(version.direction, TaskValueBundleDirection.secondMinusFirst);
      expect(version.displayMode, TaskValueBundleDisplayMode.linkedCards);
      expect(version.firstTaskDayOffset, 0);
      expect(version.secondTaskDayOffset, 0);
    },
  );

  test(
    'Cross-Day-Bündel berechnet Schlafdauer über Vortag und Aufstehtag',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = AufgabenRepository(database);
      addTearDown(database.close);

      final startDate = DateTime(2026, 8, 12);
      final wakeDate = DateTime(2026, 8, 13);

      await repository.createTask(
        name: 'Bettgehzeit',
        beschreibung: '',
        erfassungsmodus: 'value',
        projectId: null,
        taskType: TaskTypes.habit,
        recurrence: HabitRecurrence.daily,
        startDate: startDate,
        valueType: TaskValueType.timeOfDay,
        valueCommitment: TaskValueCommitment.pureTracking,
        valueUnitKey: TaskValueUnitKey.timeOfDay,
        valueUnitLabel: '',
      );
      await repository.createTask(
        name: 'Aufstehzeit',
        beschreibung: '',
        erfassungsmodus: 'value',
        projectId: null,
        taskType: TaskTypes.habit,
        recurrence: HabitRecurrence.daily,
        startDate: startDate,
        valueType: TaskValueType.timeOfDay,
        valueCommitment: TaskValueCommitment.pureTracking,
        valueUnitKey: TaskValueUnitKey.timeOfDay,
        valueUnitLabel: '',
      );

      final tasks = await database.select(database.aufgaben).get();
      final bedtime = tasks.singleWhere((task) => task.name == 'Bettgehzeit');
      final wakeTime = tasks.singleWhere((task) => task.name == 'Aufstehzeit');

      await repository.createValueBundle(
        name: 'Schlafdauer',
        bundleType: TaskValueBundleType.timeInterval,
        firstTaskId: bedtime.id,
        secondTaskId: wakeTime.id,
        firstRoleLabel: 'Bettgehzeit',
        secondRoleLabel: 'Aufstehzeit',
        resultLabel: 'Schlafdauer',
        displayMode: TaskValueBundleDisplayMode.linkedCards,
        firstTaskDayOffset: -1,
        validFrom: wakeDate,
      );
      await repository.setTaskEntryValue(
        task: bedtime,
        scheduledDate: startDate,
        valueType: TaskValueType.timeOfDay,
        timeMinutes: 30,
        dayOffset: 1,
      );
      await repository.setTaskEntryValue(
        task: wakeTime,
        scheduledDate: wakeDate,
        valueType: TaskValueType.timeOfDay,
        timeMinutes: 7 * 60 + 30,
      );

      final summary = await repository
          .getTaskValueBundleAnalyticsSummaryForPeriod(
            version:
                await database
                    .select(database.taskValueBundleVersions)
                    .getSingle(),
            period: TaskAnalyticsPeriod.sinceStart,
            today: wakeDate,
          );
      final taskList =
          await repository
              .watchTaskListForDate(wakeDate, taskType: TaskTypes.habit)
              .first;
      final previousDayTaskList =
          await repository
              .watchTaskListForDate(startDate, taskType: TaskTypes.habit)
              .first;

      expect(summary.completeCount, 1);
      expect(summary.average, 7 * 60 * 60);
      expect(taskList.valueBundles, isEmpty);
      expect(taskList.tasks, hasLength(2));
      expect(
        taskList.tasks
            .singleWhere((task) => task.task.id == wakeTime.id)
            .linkedValueBundle
            ?.version
            .name,
        'Schlafdauer',
      );
      expect(
        previousDayTaskList.tasks
            .singleWhere((task) => task.task.id == bedtime.id)
            .linkedValueBundle
            ?.version
            .name,
        'Schlafdauer',
      );
    },
  );

  test('Bündel auflösen macht Teiltrackings wieder sichtbar', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    final today = DateTime(2026, 8, 4);

    await repository.createTask(
      name: 'Start',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: today,
      valueType: TaskValueType.timeOfDay,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.timeOfDay,
      valueUnitLabel: '',
    );
    await repository.createTask(
      name: 'Ende',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: today,
      valueType: TaskValueType.timeOfDay,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.timeOfDay,
      valueUnitLabel: '',
    );

    final tasks = await database.select(database.aufgaben).get();
    final start = tasks.singleWhere((task) => task.name == 'Start');
    final end = tasks.singleWhere((task) => task.name == 'Ende');
    final bundleId = await repository.createValueBundle(
      name: 'Intervall',
      bundleType: TaskValueBundleType.timeInterval,
      firstTaskId: start.id,
      secondTaskId: end.id,
      validFrom: today,
    );

    final bundled =
        await repository
            .watchTaskListForDate(today, taskType: TaskTypes.habit)
            .first;
    expect(bundled.tasks, isEmpty);
    expect(bundled.valueBundles, hasLength(1));

    await repository.dissolveValueBundle(bundleId: bundleId, validTo: today);

    final dissolvedVersion =
        await database.select(database.taskValueBundleVersions).getSingle();
    expect(dissolvedVersion.cancelledAt, isNotNull);
    final sourceTasks = await database.select(database.aufgaben).get();
    expect(sourceTasks, hasLength(2));
    final scheduler = TaskInstanceScheduler(database);
    expect(await scheduler.isDueOnDate(sourceTasks.first, today), isTrue);
    expect(await scheduler.isDueOnDate(sourceTasks.last, today), isTrue);

    final dissolved =
        await repository
            .watchTaskListForDate(today, taskType: TaskTypes.habit)
            .first;
    expect(dissolved.tasks, hasLength(2));
    expect(dissolved.valueBundles, isEmpty);
  });

  test('Teiltracking kann trotz aktivem Bündel in den Papierkorb', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);

    final today = DateTime(2026, 8, 4);

    await repository.createTask(
      name: 'Teil A',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: today,
      valueType: TaskValueType.number,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.custom,
      valueUnitLabel: '',
    );
    await repository.createTask(
      name: 'Teil B',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
      startDate: today,
      valueType: TaskValueType.number,
      valueCommitment: TaskValueCommitment.pureTracking,
      valueUnitKey: TaskValueUnitKey.custom,
      valueUnitLabel: '',
    );

    final tasks = await database.select(database.aufgaben).get();
    final first = tasks.singleWhere((task) => task.name == 'Teil A');
    final second = tasks.singleWhere((task) => task.name == 'Teil B');
    final bundleId = await repository.createValueBundle(
      name: 'Geschütztes Bündel',
      bundleType: TaskValueBundleType.sum,
      firstTaskId: first.id,
      secondTaskId: second.id,
      validFrom: today,
    );

    await repository.deleteTask(first.id);

    final trashed = await (database.select(
      database.aufgaben,
    )..where((row) => row.id.equals(first.id))).getSingle();
    expect(trashed.trashedAt, isNotNull);
    expect(
      await (database.select(
        database.taskValueBundles,
      )..where((row) => row.id.equals(bundleId))).getSingleOrNull(),
      isNotNull,
    );
  });

  test('migriert rohe Konfigurationsspalten von Version 7 auf 8', () async {
    final tempDirectory = await Directory.systemTemp.createTemp(
      'momentum_config_migration_test_',
    );
    final databaseFile = File('${tempDirectory.path}/momentum.sqlite');
    final sqliteDatabase = sqlite3.open(databaseFile.path);

    sqliteDatabase.execute('''
      CREATE TABLE aufgaben (
        id TEXT NOT NULL PRIMARY KEY,
        project_id TEXT NULL,
        name TEXT NOT NULL,
        beschreibung TEXT NOT NULL DEFAULT '',
        erfassungsmodus TEXT NOT NULL,
        task_type TEXT NOT NULL DEFAULT 'habit',
        question_text TEXT NOT NULL DEFAULT '',
        success_value INTEGER NOT NULL DEFAULT 1,
        active_weekdays TEXT NOT NULL DEFAULT '1,2,3,4,5,6,7',
        recurrence TEXT NOT NULL DEFAULT 'daily',
        start_date INTEGER NOT NULL,
        end_date INTEGER NULL,
        due_date INTEGER NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        missed_policy TEXT NOT NULL DEFAULT 'none',
        missed_consequence TEXT NOT NULL DEFAULT 'mark_as_not_done',
        missed_buffer_days INTEGER NOT NULL DEFAULT 1,
        max_carryover_count INTEGER NOT NULL DEFAULT 3,
        goal_type TEXT NOT NULL DEFAULT 'none',
        goal_value INTEGER NOT NULL DEFAULT 1,
        goal_period TEXT NOT NULL DEFAULT 'week',
        goal_period_alignment TEXT NOT NULL DEFAULT 'calendar'
      );
    ''');
    sqliteDatabase.execute('''
      INSERT INTO aufgaben (
        id, name, erfassungsmodus, start_date,
        missed_policy, missed_consequence, missed_buffer_days
      ) VALUES (
        'task-buffer', 'Puffer-Aufgabe', 'three_state', 1783116000,
        'buffer', 'keep_neutral', 3
      );
    ''');
    sqliteDatabase.execute('PRAGMA user_version = 7;');
    sqliteDatabase.dispose();

    final database = AppDatabase.forTesting(NativeDatabase(databaseFile));
    final task = await database.select(database.aufgaben).getSingle();

    expect(task.missedPolicy, MissedPolicy.buffer);
    expect(task.missedBufferDays, 3);
    expect(task.postBufferBehavior, PostBufferBehavior.markAsNoEntry);
    expect(task.goalWindowDays, isNull);

    await database.close();
    await tempDirectory.delete(recursive: true);
  });

  test('migriert vollständige Snapshots und entfernt completed_at', () async {
    final tempDirectory = await Directory.systemTemp.createTemp(
      'momentum_definition_v10_migration_test_',
    );
    final databaseFile = File('${tempDirectory.path}/momentum.sqlite');
    final sqliteDatabase = sqlite3.open(databaseFile.path);

    sqliteDatabase.execute('''
      CREATE TABLE aufgaben (
        id TEXT NOT NULL PRIMARY KEY,
        project_id TEXT NULL,
        name TEXT NOT NULL,
        beschreibung TEXT NOT NULL DEFAULT '',
        erfassungsmodus TEXT NOT NULL,
        task_type TEXT NOT NULL DEFAULT 'habit',
        question_text TEXT NOT NULL DEFAULT '',
        success_value INTEGER NOT NULL DEFAULT 1,
        active_weekdays TEXT NOT NULL DEFAULT '1,2,3,4,5,6,7',
        recurrence TEXT NOT NULL DEFAULT 'daily',
        start_date INTEGER NOT NULL,
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
        goal_period_alignment TEXT NOT NULL DEFAULT 'calendar'
      );

      CREATE TABLE task_definition_versions (
        id TEXT NOT NULL PRIMARY KEY,
        task_id TEXT NOT NULL,
        version_number INTEGER NOT NULL,
        valid_from INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
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
        UNIQUE(task_id, version_number)
      );

      CREATE TABLE task_entries (
        id TEXT NOT NULL PRIMARY KEY,
        task_id TEXT NOT NULL,
        task_definition_version_id TEXT NULL,
        scheduled_date INTEGER NOT NULL,
        status TEXT NOT NULL DEFAULT 'pending',
        completed_at INTEGER NULL,
        updated_at INTEGER NOT NULL,
        responded_at INTEGER NULL,
        finalized_at INTEGER NULL,
        effective_at INTEGER NULL,
        resolution_origin TEXT NULL,
        applied_missed_policy TEXT NULL,
        applied_missed_consequence TEXT NULL,
        checkbox_value INTEGER NULL,
        number_value REAL NULL,
        note TEXT NOT NULL DEFAULT '',
        UNIQUE(task_id, scheduled_date)
      );

      INSERT INTO aufgaben (
        id, name, beschreibung, erfassungsmodus, question_text, start_date
      ) VALUES (
        'task-v10', 'Aktueller Name', 'Aktuelle Beschreibung',
        'three_state', 'Aktuelle Frage', 1783116000
      );

      INSERT INTO task_definition_versions (
        id, task_id, version_number, valid_from, created_at, task_type,
        capture_mode, active_weekdays, recurrence, start_date
      ) VALUES (
        'version-v1', 'task-v10', 1, 1783116000, 1783116000, 'habit',
        'three_state', '1,2,3,4,5,6,7', 'daily', 1783116000
      );

      INSERT INTO task_entries (
        id, task_id, task_definition_version_id, scheduled_date, status,
        completed_at, updated_at, responded_at, finalized_at, effective_at,
        resolution_origin, checkbox_value
      ) VALUES (
        'entry-v1', 'task-v10', 'version-v1', 1783116000, 'success',
        1783119600, 1783119600, 1783119600, 1783119600, 1783119600,
        'manual', 1
      );

      PRAGMA user_version = 10;
    ''');
    sqliteDatabase.dispose();

    final database = AppDatabase.forTesting(NativeDatabase(databaseFile));
    final entry = await database.select(database.taskEntries).getSingle();
    final version =
        await database.select(database.taskDefinitionVersions).getSingle();
    final entryColumns =
        await database.customSelect('PRAGMA table_info(task_entries)').get();

    expect(entry.finalizedAt, isNotNull);
    expect(entry.effectiveAt, isNotNull);
    expect(entry.createdAt, isNotNull);
    final task = await database.select(database.aufgaben).getSingle();
    expect(task.createdAt, isNotNull);
    expect(
      entryColumns.map((row) => row.read<String>('name')),
      isNot(contains('completed_at')),
    );
    expect(version.name, 'Aktueller Name');
    expect(version.description, 'Aktuelle Beschreibung');
    expect(version.questionText, 'Aktuelle Frage');
    expect(version.previousVersionId, isNull);

    await database.close();
    await tempDirectory.delete(recursive: true);
  });
}

DateTime _today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

Future<Aufgabe> _taskByName(AppDatabase database, String name) {
  return (database.select(database.aufgaben)
    ..where((task) => task.name.equals(name))).getSingle();
}

Future<List<TaskEntry>> _entriesForTask(AppDatabase database, String taskName) {
  final query =
      database.select(database.taskEntries).join([
          drift.innerJoin(
            database.aufgaben,
            database.aufgaben.id.equalsExp(database.taskEntries.taskId),
          ),
        ])
        ..where(database.aufgaben.name.equals(taskName))
        ..orderBy([drift.OrderingTerm.asc(database.taskEntries.scheduledDate)]);

  return query.get().then(
    (rows) => rows.map((row) => row.readTable(database.taskEntries)).toList(),
  );
}

TaskEntry _entryByDate(List<TaskEntry> entries, DateTime date) {
  return entries.singleWhere((entry) => entry.scheduledDate == date);
}

String _statusByDate(List<TaskEntry> entries, DateTime date) {
  return _entryByDate(entries, date).status;
}
