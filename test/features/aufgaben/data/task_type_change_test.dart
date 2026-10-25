import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/core/backup/backup_service.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/task_type_change_service.dart';
import 'package:momentum/features/aufgaben/data/task_instance_scheduler.dart';
import 'package:momentum/features/aufgaben/data/task_definition_version_writer.dart';
import 'package:momentum/features/calendar/data/calendar_projection.dart';
import 'package:momentum/features/projekte/data/project_repository.dart';

void main() {
  late AppDatabase db;
  late AufgabenRepository repo;
  final today = DateTime(2026, 10, 22);
  final yesterday = DateTime(2026, 10, 21);
  final tomorrow = DateTime(2026, 10, 23);
  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = AufgabenRepository(db, now: () => today);
  });
  tearDown(() => db.close());
  Future<Aufgabe> create({
    String name = 'Tracking',
    bool pure = true,
    String rhythm = 'daily',
    String type = 'task',
    String policy = 'none',
  }) async {
    await repo.createTask(
      name: name,
      beschreibung: 'Beschreibung',
      erfassungsmodus: pure ? 'value' : 'checkbox',
      projectId: null,
      taskType: type,
      recurrence: rhythm,
      startDate: yesterday,
      questionText: 'Unverändert?',
      plannedStartMinute: 600,
      plannedDurationMinutes: 20,
      valueType: pure ? 'number' : 'none',
      valueCommitment: pure ? 'pure_tracking' : 'none',
      valueUnitKey: pure ? 'custom' : 'none',
      valueUnitLabel: pure ? 'kg' : '',
      missedPolicy: policy,
    );
    return (db.select(db.aufgaben)
      ..where((t) => t.name.equals(name))).getSingle();
  }

  Future<void> change(
    Aufgabe task,
    TaskTypeChangeScope scope, {
    String? target,
  }) async {
    final preview = await repo.taskTypeChanges.preview(task.id);
    await repo.taskTypeChanges.change(
      taskId: task.id,
      targetType: target ?? preview.targetType,
      scope: scope,
      expectedRevision: preview.token,
    );
  }

  Future<void> value(Aufgabe task, DateTime day, double n) =>
      repo.setTaskEntryValue(
        task: task,
        scheduledDate: day,
        valueType: 'number',
        numberValue: n,
      );
  Future<String> snapshot() async => jsonEncode({
    for (final table in db.allTables)
      table.actualTableName:
          (await db
                  .customSelect(
                    'SELECT * FROM "${table.actualTableName}" ORDER BY rowid',
                  )
                  .get())
              .map((r) => r.data)
              .toList(),
  });
  test(
    '#013 neue Einträge: gepinnte Historie, heute, Rückdatierung, Kalender und Wiederholungswechsel',
    () async {
      final task = await create();
      await value(task, today, 80);
      final entries = await db.select(db.taskEntries).get();
      final values = await db.select(db.taskEntryValues).get();
      await change(task, TaskTypeChangeScope.newEntries);
      expect((await repo.currentTask(task.id)).taskType, 'habit');
      expect((await repo.currentTask(task.id)).questionText, task.questionText);
      expect(
        (await db.select(db.taskEntries).get()).map((e) => e.toJson()),
        entries.map((e) => e.toJson()),
      );
      expect(
        (await db.select(db.taskEntryValues).get()).map((v) => v.toJson()),
        values.map((v) => v.toJson()),
      );
      expect(
        (await repo.watchTaskListForDate(today, taskType: 'task').first).tasks,
        hasLength(1),
      );
      expect(
        (await repo.watchTaskListForDate(today, taskType: 'habit').first).tasks,
        isEmpty,
      );
      await value(task, yesterday, 79);
      expect(
        (await repo.watchTaskListForDate(yesterday, taskType: 'task').first)
            .tasks,
        hasLength(1),
      );
      final beforeRead = await snapshot();
      final calendar = await repo.calendarRepository.loadRange(
        yesterday,
        tomorrow,
        const CalendarFilter(trackers: true),
      );
      expect(calendar.onDay(today).single.task.taskType, 'task');
      expect(calendar.onDay(tomorrow).single.task.taskType, 'habit');
      expect(await snapshot(), beforeRead);
      await change(task, TaskTypeChangeScope.newEntries);
      await change(task, TaskTypeChangeScope.newEntries);
      expect(await db.select(db.taskTypeChanges).get(), hasLength(3));
      expect(
        (await repo.watchTaskListForDate(today, taskType: 'task').first).tasks,
        hasLength(1),
      );
    },
  );
  test(
    '#013 gesamte Historie korrigiert nur Art und bewahrt Protokoll, No-op',
    () async {
      final task = await create();
      await value(task, yesterday, 3);
      await change(task, TaskTypeChangeScope.newEntries);
      await change(task, TaskTypeChangeScope.newEntries);
      final versions = await db.select(db.taskDefinitionVersions).get();
      final entries = await db.select(db.taskEntries).get();
      await change(task, TaskTypeChangeScope.allHistory);
      final after = await db.select(db.taskDefinitionVersions).get();
      for (final old in versions) {
        expect(after.firstWhere((v) => v.id == old.id).toJson(), {
          ...old.toJson(),
          'taskType': 'habit',
        });
      }
      expect(
        (await db.select(db.taskEntries).get()).map((e) => e.toJson()),
        entries.map((e) => e.toJson()),
      );
      final log = (await db.select(db.taskTypeChanges).get()).last;
      expect(
        jsonDecode(log.previousTypesJson),
        versions
            .map((v) => {'versionId': v.id, 'taskType': v.taskType})
            .toList(),
      );
      expect(
        (await repo.watchTaskListForDate(yesterday, taskType: 'habit').first)
            .tasks,
        hasLength(1),
      );
      final snapshotBefore = await snapshot();
      await change(task, TaskTypeChangeScope.allHistory, target: 'habit');
      expect(await snapshot(), snapshotBefore);
      await change(task, TaskTypeChangeScope.newEntries);
      expect(
        (await repo.watchTaskListForDate(yesterday, taskType: 'habit').first)
            .tasks,
        hasLength(1),
      );
    },
  );
  test('#013 veraltete Vorschau und versionslose Einträge', () async {
    final task = await create();
    await value(task, today, 1);
    await (db.update(
      db.taskEntries,
    )).write(const TaskEntriesCompanion(taskDefinitionVersionId: Value(null)));
    final preview = await repo.taskTypeChanges.preview(task.id);
    await value(task, today, 2);
    final before = await snapshot();
    await expectLater(
      repo.taskTypeChanges.change(
        taskId: task.id,
        targetType: 'habit',
        scope: TaskTypeChangeScope.newEntries,
        expectedRevision: preview.token,
      ),
      throwsStateError,
    );
    expect(await snapshot(), before);
    await change(task, TaskTypeChangeScope.newEntries);
    expect(
      (await db.select(db.taskEntries).getSingle()).taskDefinitionVersionId,
      isNotNull,
    );
  });
  for (final mode in [
    'once',
    'unknown',
    'paused',
    'interruption',
    'ended',
    'trash',
    'past',
    'future',
    'dependent_no_entry',
    'pending',
    'schedule',
    'goal',
    'project',
    'broken_version',
  ]) {
    test('#013 Sperrmatrix $mode atomar', () async {
      final task = await create(
        rhythm:
            mode == 'once'
                ? 'none'
                : mode == 'dependent_no_entry'
                ? 'weekly_after_completion'
                : 'daily',
      );
      if (mode == 'unknown') {
        await (db.update(
          db.aufgaben,
        )).write(const AufgabenCompanion(recurrence: Value('unknown')));
      }
      if (mode == 'paused') {
        await (db.update(
          db.aufgaben,
        )).write(const AufgabenCompanion(isActive: Value(false)));
      }
      if (mode == 'interruption') {
        await db
            .into(db.taskPlanningInterruptions)
            .insert(
              TaskPlanningInterruptionsCompanion.insert(
                id: 'pause',
                taskId: task.id,
                reason: 'pause',
                fromDay: '2026-10-22',
              ),
            );
      }
      if (mode == 'ended') {
        await (db.update(
          db.aufgaben,
        )).write(AufgabenCompanion(endDate: Value(yesterday)));
      }
      if (mode == 'trash') {
        await (db.update(db.aufgaben)).write(
          AufgabenCompanion(trashedAt: Value(today), purgeAt: Value(tomorrow)),
        );
      }
      if ([
        'past',
        'future',
        'dependent_no_entry',
        'broken_version',
      ].contains(mode)) {
        await db
            .into(db.taskEntries)
            .insert(
              TaskEntriesCompanion.insert(
                id: 'entry',
                taskId: task.id,
                scheduledDate:
                    mode == 'future'
                        ? tomorrow
                        : mode == 'broken_version'
                        ? yesterday.subtract(const Duration(days: 3))
                        : yesterday,
                updatedAt: today,
                status: Value(
                  mode == 'dependent_no_entry' ? 'no_entry' : 'pending',
                ),
              ),
            );
        if (mode == 'broken_version') {
          // A version from another task is never guessed or reassigned.
          final other = await create(name: 'Other');
          final v = (await db.select(db.taskDefinitionVersions).get())
              .firstWhere((v) => v.taskId == other.id);
          await (db.update(db.taskEntries)
            ..where((e) => e.id.equals('entry'))).write(
            TaskEntriesCompanion(
              status: const Value('recorded'),
              taskDefinitionVersionId: Value(v.id),
            ),
          );
        }
      }
      if (['pending', 'schedule', 'goal'].contains(mode)) {
        await db
            .into(db.taskPendingDefinitionChanges)
            .insert(
              TaskPendingDefinitionChangesCompanion.insert(
                id: 'pending',
                taskId: task.id,
                groupKey: mode == 'pending' ? 'calendar' : mode,
                effectiveDate: tomorrow,
                payloadJson: '{}',
              ),
            );
      }
      if (mode == 'project') {
        await db.customStatement(
          "INSERT INTO task_project_assignment_changes (id, task_id, sequence, effective_date, scope, state) VALUES ('project', ?, 1, ?, 'from_date', 'pending')",
          [task.id, tomorrow.millisecondsSinceEpoch ~/ 1000],
        );
      }
      final preview = await repo.taskTypeChanges.preview(task.id);
      expect(preview.newEntriesReason, isNotNull);
      for (final scope in TaskTypeChangeScope.values) {
        final before = await snapshot();
        await expectLater(change(task, scope), throwsStateError);
        expect(await snapshot(), before);
      }
    });
  }
  test(
    '#013 frühere Planung sperrt nur Rückwirkung; Scheduler/Dringlichkeit heute gepinnt',
    () async {
      final task = await create(pure: false, policy: 'direct');
      await (db.update(
        db.taskEntries,
      )).write(TaskEntriesCompanion(scheduledDate: Value(today)));
      await (db.update(db.taskDefinitionVersions)).write(
        const TaskDefinitionVersionsCompanion(recurrence: Value('none')),
      );
      await TaskDefinitionVersionWriter(
        db,
      ).createVersion(task, validFrom: today);
      final preview = await repo.taskTypeChanges.preview(task.id);
      expect(preview.newEntriesReason, isNull);
      expect(preview.allHistoryReason, isNotNull);
      await change(task, TaskTypeChangeScope.newEntries);
      expect(
        (await repo.watchTasksByUrgency().first).single.task.taskType,
        'task',
      );
      final scheduler = TaskInstanceScheduler(db, now: () => tomorrow);
      for (final type in ['habit', 'task', 'habit', 'task']) {
        await scheduler.ensureEntriesForDate(date: tomorrow, taskType: type);
      }
      final rows = await db.select(db.taskEntries).get();
      expect(
        rows.where((e) => e.scheduledDate == today).single.status,
        'failure',
      );
      expect(rows.where((e) => e.scheduledDate == tomorrow), hasLength(1));
    },
  );
  test('#013 historische/aktive Bündel und #002 Korrektur/Undo', () async {
    final first = await create(name: 'First');
    final second = await create(name: 'Second');
    final bundle = await repo.createValueBundle(
      name: 'Bündel',
      bundleType: 'difference',
      firstTaskId: first.id,
      secondTaskId: second.id,
      validFrom: yesterday,
    );
    expect(
      (await repo.taskTypeChanges.preview(first.id)).newEntriesReason,
      isNotNull,
    );
    await repo.dissolveValueBundle(bundleId: bundle, validTo: today);
    final preview = await repo.taskTypeChanges.preview(first.id);
    expect(preview.newEntriesReason, isNull);
    expect(preview.allHistoryReason, isNotNull);
    await change(first, TaskTypeChangeScope.newEntries);
    await repo.updateTask(
      taskId: first.id,
      name: first.name,
      description: first.beschreibung,
      projectId: null,
      taskType: 'habit',
      startDate: DateTime(2026, 10, 1),
      dueDate: null,
      questionText: first.questionText,
      successValue: true,
      activeWeekdays: {1, 2, 3, 4, 5, 6, 7},
      recurrence: 'daily',
    );
    await value(first, DateTime(2026, 10, 2), 5);
    await value(first, DateTime(2026, 10, 2), 6);
    expect(await repo.undoLatestTaskCorrection(first.id), isTrue);
    expect((await db.select(db.taskEntryValues).getSingle()).numberValue, 5);
    expect((await repo.currentTask(first.id)).taskType, 'habit');
  });
  test('#013 neues Backup, Schema 24 und ungültiges Protokoll', () async {
    final task = await create();
    await value(task, today, 3);
    await change(task, TaskTypeChangeScope.newEntries);
    await change(task, TaskTypeChangeScope.allHistory);
    final backup = BackupService(db);
    final bytes = await backup.export();
    final before = await snapshot();
    await backup.restore(await backup.prepare(bytes));
    expect(await snapshot(), before);
    Uint8List edit(void Function(Map<String, dynamic>) fn) {
      final envelope = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
      final content =
          jsonDecode(envelope['payload'] as String) as Map<String, dynamic>;
      fn(content);
      final payload = jsonEncode(content);
      envelope['payload'] = payload;
      envelope['sha256'] = sha256.convert(utf8.encode(payload)).toString();
      return Uint8List.fromList(utf8.encode(jsonEncode(envelope)));
    }

    await expectLater(
      backup.prepare(
        edit(
          (c) =>
              c['tables']['task_type_changes'][0]['previous_types_json'] =
                  '[{"versionId":"bad","taskType":"task"}]',
        ),
      ),
      throwsA(isA<BackupException>()),
    );
    expect(await snapshot(), before);
    final legacy = edit((c) {
      c['schemaVersion'] = 24;
      c['tables'].remove('task_type_changes');
    });
    await backup.restore(await backup.prepare(legacy));
    expect(await db.select(db.taskTypeChanges).get(), isEmpty);
    expect(
      (await db.select(db.taskEntries).getSingle()).plannedStartMinute,
      600,
    );
  });
  test(
    '#013 echte Schema-24-Migration erhält Kalender und Messwerte',
    () async {
      final dir = await Directory.systemTemp.createTemp('type-migration-');
      final file = File('${dir.path}/db.sqlite');
      var disk = AppDatabase.forTesting(NativeDatabase(file));
      await AufgabenRepository(disk).createTask(
        name: 'Alt',
        beschreibung: '',
        erfassungsmodus: 'checkbox',
        projectId: null,
        plannedStartMinute: 600,
        plannedDurationMinutes: 30,
      );
      final old = await disk.select(disk.taskEntries).getSingle();
      await disk.close();
      final raw = sqlite3.open(file.path);
      raw.execute('DROP TABLE task_type_changes');
      raw.execute('PRAGMA user_version = 24');
      raw.dispose();
      disk = AppDatabase.forTesting(NativeDatabase(file));
      try {
        expect(
          (await disk.select(disk.taskEntries).getSingle()).toJson(),
          old.toJson(),
        );
        expect(await disk.select(disk.taskTypeChanges).get(), isEmpty);
        expect(disk.schemaVersion, 25);
      } finally {
        await disk.close();
        await dir.delete(recursive: true);
      }
    },
  );

  test(
    '#013 erzwungener Schreibfehler rollt Pins, Typen und Versionen zurück',
    () async {
      final task = await create();
      await value(task, today, 5);
      await (db.update(db.taskEntries)).write(
        const TaskEntriesCompanion(taskDefinitionVersionId: Value(null)),
      );
      await db.customStatement(
        "CREATE TRIGGER reject_type_change BEFORE INSERT ON task_type_changes BEGIN SELECT RAISE(ABORT, 'test'); END",
      );
      final before = await snapshot();
      await expectLater(
        change(task, TaskTypeChangeScope.allHistory),
        throwsA(anything),
      );
      expect(await snapshot(), before);
    },
  );
  test(
    '#013 laufende Listen, Projektbestand, Diagramm und Korrektur-Undo',
    () async {
      final task = await create(pure: false);
      await repo.setBooleanHabitValue(
        task: task,
        scheduledDate: yesterday,
        value: true,
      );
      final projects = ProjectRepository(db, now: () => today);
      await projects.createProject(
        name: 'Projekt',
        description: '',
        colorHex: '#112233',
        taskIds: {task.id},
      );
      final project = await db.select(db.projects).getSingle();
      final beforeDiagram =
          await repo.watchDailyCompletionSummary(endingOn: today).first;
      final iterator = StreamIterator(
        repo.watchTaskListForDate(yesterday, taskType: 'task'),
      );
      addTearDown(iterator.cancel);
      expect(await iterator.moveNext(), isTrue);
      expect(iterator.current.tasks, hasLength(1));
      await change(task, TaskTypeChangeScope.allHistory);
      while (await iterator.moveNext().timeout(const Duration(seconds: 5))) {
        if (iterator.current.tasks.isEmpty) break;
      }
      expect(iterator.current.tasks, isEmpty);
      expect(
        (await projects.watchProjectDetail(project.id).first)!.habitCount,
        1,
      );
      final afterDiagram =
          await repo.watchDailyCompletionSummary(endingOn: today).first;
      expect(afterDiagram.total, beforeDiagram.total);
      await repo.setTaskEntryNote(
        taskId: task.id,
        scheduledDate: yesterday,
        note: 'Korrektur',
      );
      expect(await repo.undoLatestTaskCorrection(task.id), isTrue);
      expect(
        (await repo.watchTaskListForDate(yesterday, taskType: 'habit').first)
            .tasks
            .single
            .task
            .taskType,
        'habit',
      );
      expect(
        (await db.select(db.taskEntries).getSingle()).plannedStartMinute,
        600,
      );
    },
  );
  for (final policy in ['buffer', 'carryover']) {
    test(
      '#013 Scheduler $policy nach Wechsel hält Regeln und Unique-Key',
      () async {
        final task = await create(pure: false, policy: policy);
        await (db.update(
          db.taskEntries,
        )).write(TaskEntriesCompanion(scheduledDate: Value(today)));
        await change(task, TaskTypeChangeScope.newEntries);
        final future = DateTime(2026, 10, 27);
        final scheduler = TaskInstanceScheduler(db, now: () => future);
        for (final type in ['habit', 'task', 'habit', 'task']) {
          await scheduler.ensureEntriesForDate(date: future, taskType: type);
        }
        final entries = await db.select(db.taskEntries).get();
        expect(
          entries.map((e) => e.scheduledDate).toSet().length,
          entries.length,
        );
        expect(
          entries.singleWhere((e) => e.scheduledDate == today).status,
          'failure',
        );
      },
    );
  }
  test(
    '#013 bekannte Abschlussserie ohne Rückstand, No-entry-Historie, Kaskade',
    () async {
      final task = await create(rhythm: 'custom_after_completion:3');
      await value(task, today, 5);
      await change(task, TaskTypeChangeScope.allHistory);
      expect(
        (await repo.currentTask(task.id)).recurrence,
        'custom_after_completion:3',
      );
      final before = await snapshot();
      await repo.calendarRepository.loadRange(
        today,
        DateTime(2026, 11, 1),
        const CalendarFilter(trackers: true),
      );
      expect(await snapshot(), before);
      await (db.delete(db.aufgaben)..where((t) => t.id.equals(task.id))).go();
      expect(await db.select(db.taskTypeChanges).get(), isEmpty);
      expect(await db.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
      final normal = await create(name: 'Neutral');
      await value(normal, yesterday, 5);
      await (db.update(
        db.taskEntries,
      )).write(const TaskEntriesCompanion(status: Value('no_entry')));
      expect(
        (await repo.taskTypeChanges.preview(normal.id)).newEntriesReason,
        isNull,
      );
    },
  );
}
