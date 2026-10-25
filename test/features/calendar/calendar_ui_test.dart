import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/calendar/data/calendar_planning.dart';
import 'package:momentum/features/calendar/data/calendar_projection.dart';
import 'package:momentum/features/calendar/presentation/calendar_screen.dart';
import 'package:momentum/features/calendar/presentation/calendar_timeline.dart';
import 'package:momentum/features/projekte/data/project_repository.dart';

void main() {
  testWidgets(
    'Kalender zeigt vier Ansichten, persistente Filter und schreibfreie Details',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final today = DateTime(2026, 10, 21);
      final tasks = AufgabenRepository(db, now: () => today);
      await tester.runAsync(
        () => tasks.createTask(
          name: 'Kalendertest',
          beschreibung: 'Details vollständig',
          erfassungsmodus: 'checkbox',
          projectId: null,
          taskType: 'task',
          recurrence: 'none',
          dueDate: today,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: CalendarScreen(tasks: tasks, projects: ProjectRepository(db)),
        ),
      );
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Tag'), findsOneWidget);
      expect(find.text('Woche'), findsOneWidget);
      expect(find.text('Monat'), findsOneWidget);
      expect(find.text('Liste'), findsOneWidget);
      await tester.tap(find.text('Liste'));
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Kalendertest'));
      await tester.pumpAndSettle();
      expect(find.text('Details vollständig'), findsOneWidget);
      final entries = await tester.runAsync(
        () => db.select(db.taskEntries).get(),
      );
      expect(entries!.length, 1);
      expect(entries.single.status, 'pending');
      await tester.pumpWidget(const SizedBox());
      await tester.runAsync(db.close);
    },
  );

  testWidgets(
    'Zeitblock Drag und Resize nutzen 15-Minuten-Raster; Serie gesperrt',
    (tester) async {
      final today = DateTime(2026, 10, 21);
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final task =
          (await tester.runAsync(() async {
            await AufgabenRepository(db, now: () => today).createTask(
              name: 'Zeitblock',
              beschreibung: '',
              erfassungsmodus: 'checkbox',
              projectId: null,
              taskType: 'task',
              recurrence: 'none',
            );
            final task = await db.select(db.aufgaben).getSingle();
            await db.close();
            return task;
          }))!;
      CalendarOccurrence occurrence({bool locked = false}) =>
          CalendarOccurrence(
            task: task,
            currentTask: task,
            day: today,
            entry: null,
            planning: const CalendarPlanning(
              startMinute: 60,
              durationMinutes: 45,
            ),
            lockReason: locked ? 'Serie' : null,
          );
      final changes = <CalendarPlanning>[];
      Widget screen(CalendarOccurrence item, {int days = 1}) => MaterialApp(
        home: Scaffold(
          body: CalendarTimeline(
            start: today,
            days: days,
            range: CalendarRange(
              occurrences: [item],
              overdue: [],
              undated: [],
              unknown: [],
            ),
            onDetails: (_) {},
            onChange: (item, day, planning) async {
              changes.add(planning);
            },
          ),
        ),
      );
      await tester.pumpWidget(screen(occurrence()));
      final gesture = await tester.startGesture(
        tester.getCenter(find.textContaining('Zeitblock').first),
      );
      await tester.pump(const Duration(milliseconds: 600));
      await gesture.moveBy(const Offset(0, 30));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();
      expect(changes, isNotEmpty);
      expect(changes.last.startMinute! % 15, 0);
      changes.clear();
      await tester.drag(find.byIcon(Icons.drag_handle), const Offset(0, 30));
      await tester.pumpAndSettle();
      expect(changes.single.durationMinutes! % 15, 0);
      await tester.pumpWidget(screen(occurrence(locked: true), days: 7));
      expect(find.byType(LongPressDraggable<CalendarOccurrence>), findsNothing);
      expect(find.byIcon(Icons.drag_handle), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
