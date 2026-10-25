import 'dart:convert';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/task_definition_resolver.dart';
import 'package:momentum/features/calendar/data/calendar_clock.dart';
import 'package:momentum/features/calendar/data/calendar_commands.dart';
import 'package:momentum/features/calendar/data/calendar_planning.dart';
import 'package:momentum/features/calendar/data/calendar_projection.dart';
import 'package:momentum/features/calendar/data/calendar_repository.dart';

void main() {
  late AppDatabase db;
  late AufgabenRepository tasks;
  late CalendarRepository calendar;
  late CalendarCommands commands;
  final today = DateTime(2026, 10, 21);
  final clock = CalendarClock(now: () => today, uniqueMinute: (_, _) => true);
  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    tasks = AufgabenRepository(db, now: () => today);
    calendar = CalendarRepository(db, clock: clock);
    commands = CalendarCommands(db, clock: clock);
  });
  tearDown(() => db.close());
  Future<Aufgabe> create(
    String name, {
    String recurrence = 'none',
    String type = 'task',
    bool tracker = false,
    DateTime? due,
    Set<int> weekdays = const {1, 2, 3, 4, 5, 6, 7},
  }) async {
    await tasks.createTask(
      name: name,
      beschreibung: '',
      erfassungsmodus: tracker ? 'value' : 'checkbox',
      projectId: null,
      taskType: type,
      recurrence: recurrence,
      startDate: today,
      dueDate: due,
      activeWeekdays: weekdays,
      valueType: tracker ? 'number' : 'none',
      valueCommitment: tracker ? 'pure_tracking' : 'none',
      plannedStartMinute: 600,
      plannedDurationMinutes: 45,
    );
    return (db.select(db.aufgaben)
      ..where((t) => t.name.equals(name))).getSingle();
  }

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

  test('Erste historische Notiz übernimmt damalige Planungszeit', () async {
    final yesterday = calendarAddDays(today, -1);
    await tasks.createTask(
      name: 'Historisch',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      startDate: yesterday,
      recurrence: 'daily',
      valueType: 'number',
      valueCommitment: 'pure_tracking',
      plannedStartMinute: 600,
      plannedDurationMinutes: 30,
    );
    final task = await db.select(db.aufgaben).getSingle();
    final resolver = TaskDefinitionResolver(db, now: () => today);
    await resolver.scheduleChange(
      taskId: task.id,
      group: 'calendar',
      effectiveDate: today,
      payloadJson:
          const CalendarPlanning(
            startMinute: 800,
            durationMinutes: 45,
          ).encode(),
    );
    await resolver.applyDueChanges(today);
    await tasks.setTaskEntryNote(
      taskId: task.id,
      scheduledDate: yesterday,
      note: 'Nachgetragen',
    );
    final entry = await db.select(db.taskEntries).getSingle();
    expect(entry.plannedStartMinute, 600);
    expect(entry.plannedDurationMinutes, 30);
  });

  test(
    'Serienzeit gilt ab morgen und erhält heutigen Abschluss sowie Zielvormerkung',
    () async {
      final task = await create('Serie', recurrence: 'daily');
      await tasks.setTaskCompleted(
        taskId: task.id,
        scheduledDate: today,
        isCompleted: true,
      );
      final before = (await db.select(db.taskEntries).getSingle()).toJson();
      final resolver = TaskDefinitionResolver(db, now: () => today);
      await resolver.scheduleChange(
        taskId: task.id,
        group: 'goal',
        effectiveDate: calendarAddDays(today, 1),
        payloadJson:
            '{"goalType":"none","goalValue":1,"goalWindowDays":null,"goalPeriod":"week","goalPeriodAlignment":"calendar"}',
      );
      await tasks.updateTask(
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
        calendarPlanning: const CalendarPlanning(
          startMinute: 800,
          durationMinutes: 40,
        ),
      );
      final pending = await resolver.watchPendingChanges(task.id).first;
      expect(pending.map((p) => p.groupKey).toSet(), {'calendar', 'goal'});
      expect(
        (await db.select(db.aufgaben).getSingle()).plannedStartMinute,
        600,
      );
      expect(await resolver.applyDueChanges(today), 0);
      expect(await resolver.applyDueChanges(calendarAddDays(today, 1)), 2);
      expect(
        (await db.select(db.aufgaben).getSingle()).plannedStartMinute,
        800,
      );
      expect((await db.select(db.taskEntries).getSingle()).toJson(), before);
    },
  );

  for (final rule in ['series', 'closed', 'pause', 'bundle']) {
    test('Direkter Kalenderbefehl sperrt $rule ohne Teilspeicherung', () async {
      final task = await create(
        'Guard',
        recurrence: rule == 'series' ? 'daily' : 'none',
        due: today,
      );
      if (rule == 'closed') {
        await tasks.setTaskCompleted(
          taskId: task.id,
          scheduledDate: today,
          isCompleted: true,
        );
      }
      if (rule == 'pause') {
        await db.customStatement(
          "INSERT INTO task_planning_interruptions (id, task_id, reason, from_day) VALUES ('p', ?, 'pause', '2026-10-21')",
          [task.id],
        );
      }
      if (rule == 'bundle') {
        final other = await create('Andere', due: today);
        await db.customStatement(
          "INSERT INTO task_value_bundles (id,updated_at) VALUES ('b', 1)",
        );
        await db.customStatement(
          "INSERT INTO task_value_bundle_versions (id,bundle_id,version_number,valid_from,bundle_type,first_task_id,second_task_id) VALUES ('bv','b',1,1,'difference',?,?)",
          [task.id, other.id],
        );
      }
      final entry = (await db.select(db.taskEntries).get()).firstWhere(
        (e) => e.taskId == task.id,
      );
      final before = await snapshot();
      await expectLater(
        commands.change(
          expectedTask: task,
          expectedEntry: entry,
          day: calendarAddDays(today, 1),
          planning: const CalendarPlanning(durationMinutes: 50),
        ),
        throwsStateError,
      );
      expect(await snapshot(), before);
    });
  }

  test(
    'Zukunftsprojektion, Detailsdaten und Filter lassen alle Tabellen unverändert',
    () async {
      final daily = await create('Täglich', recurrence: 'daily');
      await create('Habit', recurrence: 'daily', type: 'habit');
      await create('Tracker', recurrence: 'daily', tracker: true);
      await TaskDefinitionResolver(db, now: () => today).scheduleChange(
        taskId: daily.id,
        group: 'calendar',
        effectiveDate: calendarAddDays(today, 2),
        payloadJson:
            const CalendarPlanning(
              startMinute: 720,
              durationMinutes: 30,
            ).encode(),
      );
      final before = await snapshot();
      final range = await calendar.loadRange(
        calendarAddDays(today, 1),
        calendarAddDays(today, 7),
        const CalendarFilter(),
      );
      expect(range.occurrences.length, 7);
      expect(
        range.onDay(calendarAddDays(today, 2)).single.planning.startMinute,
        720,
      );
      expect(range.occurrences.every((e) => e.isVirtual), isTrue);
      final all = await calendar.loadRange(
        today,
        calendarAddDays(today, 1),
        const CalendarFilter(tasks: true, habits: true, trackers: true),
      );
      expect(all.occurrences.length, 6);
      expect(
        (await calendar.loadRange(
          today,
          today,
          const CalendarFilter(tasks: false),
        )).occurrences,
        isEmpty,
      );
      expect(await snapshot(), before);
    },
  );

  test(
    'Einmalige undatierte und überfällige Termine bleiben getrennt',
    () async {
      await create('Undatiert');
      final due = await create('Termin', due: today);
      final tomorrow = CalendarRepository(
        db,
        clock: CalendarClock(now: () => calendarAddDays(today, 1)),
      );
      final range = await tomorrow.loadRange(
        calendarAddDays(today, 8),
        calendarAddDays(today, 14),
        const CalendarFilter(),
      );
      expect(range.occurrences, isEmpty);
      expect(range.undated.single.task.name, 'Undatiert');
      expect(range.overdue.single.task.id, due.id);
      expect(range.overdue.single.day, today);
    },
  );

  test(
    'Abschlussserie zeigt genau einen nächsten Termin und einen unbekannten Nachfolger',
    () async {
      final task = await create(
        'Abhängig',
        recurrence: 'custom_after_completion:3',
        tracker: true,
      );
      await tasks.setTaskEntryValue(
        task: task,
        scheduledDate: today,
        valueType: 'number',
        numberValue: 1,
      );
      final range = await calendar.loadRange(
        today,
        calendarAddDays(today, 20),
        const CalendarFilter(trackers: true),
      );
      expect(range.occurrences.map((e) => e.day), [
        today,
        calendarAddDays(today, 3),
      ]);
      expect(range.unknown.length, 1);
      expect(range.unknown.single.earliest, calendarAddDays(today, 6));
    },
  );

  test('Feste Wochentage, Monatstage und Pause begrenzen Vorschau', () async {
    await create('Montag', recurrence: 'weekly_fixed_days', weekdays: {1});
    await create(
      'Monatsende',
      recurrence: 'monthly_fixed_days',
      weekdays: {32},
    );
    final paused = await create('Pause', recurrence: 'daily');
    await db
        .into(db.taskPlanningInterruptions)
        .insert(
          TaskPlanningInterruptionsCompanion.insert(
            id: 'pause',
            taskId: paused.id,
            reason: 'pause',
            fromDay: '2026-10-22',
          ),
        );
    final range = await calendar.loadRange(
      calendarAddDays(today, 1),
      DateTime(2026, 11, 1),
      const CalendarFilter(),
    );
    expect(range.occurrences.map((e) => e.task.name), ['Montag', 'Monatsende']);
  });

  test(
    'Terminänderung ist atomar, erhält Ursprung und lehnt veraltete Revision ab',
    () async {
      final task = await create('Termin', due: today);
      final entry = await db.select(db.taskEntries).getSingle();
      await commands.change(
        expectedTask: task,
        expectedEntry: entry,
        day: calendarAddDays(today, 2),
        planning: const CalendarPlanning(startMinute: 780, durationMinutes: 60),
      );
      final saved = await db.select(db.taskEntries).getSingle();
      expect(saved.originalScheduledDate, today);
      expect(saved.scheduledDate, calendarAddDays(today, 2));
      expect(saved.plannedStartMinute, 780);
      final before = await snapshot();
      await expectLater(
        commands.change(
          expectedTask: task,
          expectedEntry: entry,
          day: today,
          planning: const CalendarPlanning(durationMinutes: 30),
        ),
        throwsStateError,
      );
      expect(await snapshot(), before);
    },
  );

  test(
    'No-op, Vergangenheit, Serie, Abschluss und Vormerkung schreiben nicht',
    () async {
      final task = await create('Termin', due: today);
      final entry = await db.select(db.taskEntries).getSingle();
      final before = await snapshot();
      await commands.change(
        expectedTask: task,
        expectedEntry: entry,
        day: today,
        planning: const CalendarPlanning(startMinute: 600, durationMinutes: 45),
      );
      expect(await snapshot(), before);
      await expectLater(
        commands.change(
          expectedTask: task,
          expectedEntry: entry,
          day: calendarAddDays(today, -1),
          planning: const CalendarPlanning(),
        ),
        throwsStateError,
      );
      expect(await snapshot(), before);
      await TaskDefinitionResolver(db).scheduleChange(
        taskId: task.id,
        group: 'calendar',
        effectiveDate: calendarAddDays(today, 1),
        payloadJson: const CalendarPlanning().encode(),
      );
      final pending = await snapshot();
      await expectLater(
        commands.change(
          expectedTask: task,
          expectedEntry: entry,
          day: today,
          planning: const CalendarPlanning(),
        ),
        throwsStateError,
      );
      expect(await snapshot(), pending);
    },
  );

  test(
    'DST ungültige Minuten werden beim Schreiben gesperrt und als Vorschau gewarnt',
    () async {
      final task = await create('Termin', due: today);
      final entry = await db.select(db.taskEntries).getSingle();
      final dst = CalendarClock(
        now: () => today,
        uniqueMinute: (_, minute) => minute != 600,
      );
      final before = await snapshot();
      await expectLater(
        CalendarCommands(db, clock: dst).change(
          expectedTask: task,
          expectedEntry: entry,
          day: today,
          planning: const CalendarPlanning(
            startMinute: 600,
            durationMinutes: 30,
          ),
        ),
        throwsStateError,
      );
      final projected = await CalendarRepository(
        db,
        clock: dst,
      ).loadRange(today, today, const CalendarFilter());
      expect(projected.occurrences.single.warning, isNotNull);
      expect(projected.occurrences.single.visibleStart, isNull);
      expect(await snapshot(), before);
    },
  );
}
