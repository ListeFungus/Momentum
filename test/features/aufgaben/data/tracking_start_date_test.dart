import 'dart:convert';
import 'dart:async';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/core/backup/backup_service.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/task_analytics_period.dart';
import 'package:momentum/features/aufgaben/data/task_definition_resolver.dart';
import 'package:momentum/features/aufgaben/data/task_instance_scheduler.dart';
import 'package:momentum/features/calendar/data/calendar_projection.dart';

void main() {
  late AppDatabase db;
  late AufgabenRepository repo;
  final now = DateTime(2026, 10, 22);
  final september = DateTime(2026, 9, 20);
  final october = DateTime(2026, 10, 1);
  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = AufgabenRepository(db, now: () => now);
  });
  tearDown(() => db.close());
  Future<Aufgabe> create({
    String name = 'Gewicht',
    bool pure = true,
    String recurrence = 'daily',
  }) async {
    await repo.createTask(
      name: name,
      beschreibung: '',
      erfassungsmodus: pure ? 'value' : 'checkbox',
      projectId: null,
      taskType: 'habit',
      recurrence: recurrence,
      startDate: october,
      valueType: pure ? 'number' : 'none',
      valueCommitment: pure ? 'pure_tracking' : 'none',
      valueUnitKey: pure ? 'custom' : 'none',
      valueUnitLabel: pure ? 'kg' : '',
    );
    return (db.select(db.aufgaben)
      ..where((t) => t.name.equals(name))).getSingle();
  }

  Future<void> move(
    Aufgabe task,
    DateTime start, {
    String? name,
    String? recurrence,
  }) => repo.updateTask(
    taskId: task.id,
    name: name ?? task.name,
    description: task.beschreibung,
    projectId: task.projectId,
    taskType: task.taskType,
    startDate: start,
    dueDate: task.dueDate,
    questionText: task.questionText,
    successValue: task.successValue,
    activeWeekdays: {1, 2, 3, 4, 5, 6, 7},
    recurrence: recurrence ?? task.recurrence,
  );
  Future<void> record(
    Aufgabe task,
    DateTime day,
    double value, {
    DateTime? performed,
  }) => repo.setTaskEntryValue(
    task: task,
    scheduledDate: day,
    valueType: 'number',
    numberValue: value,
    performedOn: performed,
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
    '#002 früher/später: Historie, Kalender, Korrektur, Undo, Restore',
    () async {
      final task = await create();
      final firstVersion =
          await db.select(db.taskDefinitionVersions).getSingle();
      await move(task, october, name: 'Neuer Name');
      await move(task, september, name: 'Neuer Name');
      final effective = await TaskDefinitionResolver(
        db,
      ).taskForDate(task, september);
      expect(effective.name, 'Gewicht');
      await record(task, september, 80);
      final original = await db.select(db.taskEntries).getSingle();
      expect(original.taskDefinitionVersionId, firstVersion.id);
      final current = await db.select(db.aufgaben).getSingle();
      await move(current, october);
      expect(
        (await db.select(db.taskEntries).getSingle()).toJson(),
        original.toJson(),
      );
      final all = await repo.getTaskValueAnalyticsSummaryForPeriod(
        task: task,
        period: TaskAnalyticsPeriod.sinceStart,
        today: now,
      );
      expect(all.recordedCount, 1);
      expect(all.periodStart, september);
      expect(all.virtualMissingCount, 22);
      final fixed = await repo.getTaskValueAnalyticsSummaryForPeriod(
        task: task,
        period: TaskAnalyticsPeriod.last7Days,
        today: DateTime(2026, 9, 23),
      );
      expect(fixed.recordedCount, 1);
      expect(fixed.virtualMissingCount, 0);
      final custom =
          await repo
              .watchTaskValueAnalyticsSummaryForPeriodRange(
                task: task,
                from: september,
                to: DateTime(2026, 9, 30),
              )
              .first;
      expect(custom.recordedCount, 1);
      expect(custom.virtualMissingCount, 0);
      final calendar = await repo.calendarRepository.loadRange(
        september,
        DateTime(2026, 10, 2),
        const CalendarFilter(trackers: true),
      );
      expect(calendar.onDay(september).single.entry?.id, original.id);
      expect(calendar.onDay(DateTime(2026, 9, 21)), isEmpty);
      expect(calendar.onDay(october), hasLength(1));
      await record(task, september, 79, performed: september);
      expect((await db.select(db.taskEntryValues).getSingle()).numberValue, 79);
      expect(await repo.undoLatestTaskCorrection(task.id), isTrue);
      expect((await db.select(db.taskEntryValues).getSingle()).numberValue, 80);
      await record(task, september, 78);
      expect(await repo.undoLatestTaskCorrection(task.id), isTrue);
      await expectLater(
        record(task, DateTime(2026, 9, 21), 70),
        throwsArgumentError,
      );
      await expectLater(
        record(task, september, 70, performed: DateTime(2026, 9, 19)),
        throwsArgumentError,
      );
      await expectLater(
        record(task, DateTime(2026, 10, 23), 70),
        throwsArgumentError,
      );
      for (final start in [september, october, september, october]) {
        await move(task, start);
      }
      expect((await db.select(db.taskEntries).get()).map((e) => e.id), [
        original.id,
      ]);
      final count = (await db.select(db.taskDefinitionVersions).get()).length;
      await move(task, october);
      expect(
        await db.select(db.taskDefinitionVersions).get(),
        hasLength(count),
      );
      final target = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(target.close);
      final backup = BackupService(target);
      await backup.restore(
        await backup.prepare(await BackupService(db).export()),
      );
      expect(
        (await target.select(target.aufgaben).getSingle()).startDate,
        october,
      );
      expect(
        (await target.select(target.taskEntries).getSingle()).id,
        original.id,
      );
      expect(
        (await target.select(target.taskEntryValues).getSingle()).numberValue,
        80,
      );
    },
  );

  test(
    '#002 Terminserien und kombinierte Abstandsänderung atomar gesperrt',
    () async {
      final series = await create(pure: false);
      final before = await snapshot();
      await expectLater(
        move(series, september, name: 'Nicht speichern'),
        throwsStateError,
      );
      expect(await snapshot(), before);
      final tracker = await create(name: 'Tracker');
      final beforeTracker = await snapshot();
      await expectLater(
        move(tracker, september, recurrence: 'weekly_after_completion'),
        throwsStateError,
      );
      expect(await snapshot(), beforeTracker);
      await (db.update(db.taskDefinitionVersions)
        ..where((v) => v.taskId.equals(tracker.id))).write(
        const TaskDefinitionVersionsCompanion(
          valueCommitment: Value('required'),
        ),
      );
      expect(await repo.startDateBlockedReason(tracker.id), isNotNull);
      await expectLater(move(tracker, september), throwsStateError);
    },
  );

  test('#002 vorgemerkte Planung, Endgrenze und Pause', () async {
    final task = await create();
    await (db.update(db.aufgaben)..where(
      (t) => t.id.equals(task.id),
    )).write(AufgabenCompanion(endDate: Value(DateTime(2026, 10, 15))));
    await (db.update(db.taskDefinitionVersions)
      ..where((v) => v.taskId.equals(task.id))).write(
      TaskDefinitionVersionsCompanion(endDate: Value(DateTime(2026, 10, 15))),
    );
    await expectLater(move(task, now), throwsStateError);
    await move(task, september);
    await db.customStatement(
      "INSERT INTO task_planning_interruptions (id, task_id, reason, from_day, until_day_exclusive) VALUES ('p', ?, 'pause', '2026-09-21', '2026-09-23')",
      [task.id],
    );
    final scheduler = TaskInstanceScheduler(db);
    expect(await scheduler.isDueOnDate(task, september), isTrue);
    expect(await scheduler.isDueOnDate(task, DateTime(2026, 9, 21)), isFalse);
    expect(await scheduler.isDueOnDate(task, DateTime(2026, 10, 16)), isFalse);
    await move(task, september, recurrence: 'weekly_after_completion');
    expect(await repo.startDateBlockedReason(task.id), isNotNull);
    await expectLater(move(task, october), throwsStateError);
  });

  test(
    '#002 Bündelpaar und Teilmessung bleiben vor neuen Starts erhalten',
    () async {
      final first = await create(name: 'Aufnahme');
      final second = await create(name: 'Verbrauch');
      await move(first, september);
      await move(second, september);
      await repo.createValueBundle(
        name: 'Bilanz',
        bundleType: 'difference',
        firstTaskId: first.id,
        secondTaskId: second.id,
        validFrom: september,
      );
      await record(first, september, 100);
      await record(second, september, 40);
      await record(first, DateTime(2026, 9, 21), 90);
      final version = await db.select(db.taskValueBundleVersions).getSingle();
      await move(first, october);
      await move(second, october);
      final result = await repo
          .getTaskValueBundleAnalyticsSummaryForPeriodRange(
            version: version,
            from: september,
            to: DateTime(2026, 9, 22),
          );
      expect(result.completeCount, 1);
      expect(result.partialCount, 1);
      expect(result.missingCount, 0);
      expect(result.sum, 60);
      final day =
          await repo.watchTaskListForDate(september, taskType: 'habit').first;
      expect(day.valueBundles, hasLength(1));
      expect(
        (await db.select(db.taskValueBundleVersions).getSingle()).toJson(),
        version.toJson(),
      );
    },
  );

  test('#002 Wertziel behält sein Zeitfenster und vorhandene Werte', () async {
    final task = await create();
    await move(task, september);
    await record(task, september, 80);
    await repo.updateTask(
      taskId: task.id,
      name: task.name,
      description: '',
      projectId: null,
      taskType: task.taskType,
      startDate: october,
      dueDate: null,
      questionText: task.questionText,
      successValue: task.successValue,
      activeWeekdays: {1, 2, 3, 4, 5, 6, 7},
      recurrence: task.recurrence,
      goalType: 'value_sum_min',
      goalValue: 70,
      goalWindowDays: 40,
    );
    final current = await db.select(db.aufgaben).getSingle();
    final goal = await repo.getTaskValueGoalEvaluationSummary(
      task: current,
      today: now,
    );
    expect(goal.periodStart, DateTime(2026, 9, 13));
    expect(goal.actualValue, 80);
    expect(goal.recordedCount, 1);
    expect(goal.missingOrOpenCount, 22);
    final summary =
        await repo
            .watchTaskValueAnalyticsSummaryForPeriod(
              task: task,
              period: TaskAnalyticsPeriod.sinceStart,
              today: now,
            )
            .first;
    expect(summary.recordedCount, 1);
    expect(summary.virtualMissingCount, 22);
  });

  test(
    '#002 Zeitbündel mit Tagversatz erhält vollständige und teilweise Messungen',
    () async {
      Future<Aufgabe> timeTask(String name) async {
        await repo.createTask(
          name: name,
          beschreibung: '',
          erfassungsmodus: 'value',
          projectId: null,
          startDate: september,
          valueType: 'time_of_day',
          valueCommitment: 'pure_tracking',
          valueUnitKey: 'time_of_day',
        );
        return (db.select(db.aufgaben)
          ..where((t) => t.name.equals(name))).getSingle();
      }

      final bed = await timeTask('Bett');
      final wake = await timeTask('Aufstehen');
      final day = DateTime(2026, 9, 21);
      await repo.createValueBundle(
        name: 'Schlaf',
        bundleType: 'time_interval',
        displayMode: 'linked_cards',
        firstTaskId: bed.id,
        secondTaskId: wake.id,
        firstTaskDayOffset: -1,
        validFrom: day,
      );
      await repo.setTaskEntryValue(
        task: bed,
        scheduledDate: september,
        valueType: 'time_of_day',
        timeMinutes: 23 * 60,
      );
      await repo.setTaskEntryValue(
        task: wake,
        scheduledDate: day,
        valueType: 'time_of_day',
        timeMinutes: 7 * 60,
      );
      await repo.setTaskEntryValue(
        task: bed,
        scheduledDate: day,
        valueType: 'time_of_day',
        timeMinutes: 22 * 60,
      );
      await move(bed, october);
      await move(wake, october);
      final version = await db.select(db.taskValueBundleVersions).getSingle();
      final summary = await repo
          .getTaskValueBundleAnalyticsSummaryForPeriodRange(
            version: version,
            from: day,
            to: DateTime(2026, 9, 23),
          );
      expect(summary.completeCount, 1);
      expect(summary.partialCount, 1);
      expect(summary.average, 8 * 3600);
      final list =
          await repo.watchTaskListForDate(day, taskType: 'habit').first;
      expect(list.tasks.any((t) => t.linkedValueBundle != null), isTrue);
    },
  );

  test('#002 laufende Auswertung aktualisiert reine Startänderungen', () async {
    final task = await create();
    final iterator = StreamIterator(
      repo.watchTaskValueAnalyticsSummaryForPeriod(
        task: task,
        period: TaskAnalyticsPeriod.last7Days,
        today: now,
      ),
    );
    addTearDown(iterator.cancel);
    expect(await iterator.moveNext(), isTrue);
    expect(iterator.current.virtualMissingCount, 7);
    await move(task, now);
    expect(
      await iterator.moveNext().timeout(const Duration(seconds: 5)),
      isTrue,
    );
    expect(iterator.current.virtualMissingCount, 1);
    await expectLater(
      record(task, DateTime(2026, 10, 23), 80, performed: now),
      throwsArgumentError,
    );
  });
}
