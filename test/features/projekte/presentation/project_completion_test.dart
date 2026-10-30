import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/core/date/calendar_days.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_modes/value_task_input.dart';
import 'package:momentum/features/projekte/data/project_repository.dart';
import 'package:momentum/features/projekte/presentation/project_detail_screen.dart';
import 'package:momentum/features/projekte/presentation/project_task_entry_input.dart';

Future<void> refresh(WidgetTester tester) async {
  for (var i = 0; i < 4; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 80)),
    );
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

void main() {
  late AppDatabase db;
  late AufgabenRepository tasks;
  late ProjectRepository projects;
  late String projectId;
  final today = calendarDay(DateTime.now());

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    tasks = AufgabenRepository(db);
    projects = ProjectRepository(db);
    await projects.createProject(
      name: 'Mein Projekt',
      description: '',
      colorHex: '#5B67D6',
      taskIds: {},
    );
    projectId = (await db.select(db.projects).getSingle()).id;
  });
  tearDown(
    () => TestWidgetsFlutterBinding.ensureInitialized().runAsync(db.close),
  );

  Future<void> open(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder:
              (context) => Scaffold(
                body: TextButton(
                  onPressed:
                      () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder:
                              (_) => ProjectDetailScreen(
                                projectId: projectId,
                                repository: projects,
                                aufgabenRepository: tasks,
                              ),
                        ),
                      ),
                  child: const Text('Öffnen'),
                ),
              ),
        ),
      ),
    );
    await tester.tap(find.text('Öffnen'));
    await refresh(tester);
  }

  testWidgets(
    'Aufgabe direkt abschliessen und wieder oeffnen; zukuenftige ohne Eingabe',
    (tester) async {
      await tasks.createTask(
        name: 'Heute',
        beschreibung: '',
        erfassungsmodus: 'checkbox',
        projectId: projectId,
        taskType: 'task',
        recurrence: 'none',
      );
      await tasks.createTask(
        name: 'Morgen',
        beschreibung: '',
        erfassungsmodus: 'checkbox',
        projectId: projectId,
        taskType: 'task',
        recurrence: 'none',
        startDate: calendarAddDays(today, 1),
      );
      await open(tester);
      expect(find.byType(Checkbox), findsOneWidget);
      await tester.tap(find.byType(Checkbox));
      await refresh(tester);
      var rows = await tester.runAsync(
        () => tasks.watchTasksForDate(today, taskType: 'task').first,
      );
      expect(rows!.single.isCompleted, isTrue);
      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);
      await tester.tap(find.byType(Checkbox));
      await refresh(tester);
      rows = await tester.runAsync(
        () => tasks.watchTasksForDate(today, taskType: 'task').first,
      );
      expect(rows!.single.isCompleted, isFalse);
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(const SizedBox.shrink());
      await refresh(tester);
      await tester.pumpAndSettle();
    },
  );

  testWidgets('Habit wertet Nein als Erfolg wenn so konfiguriert', (
    tester,
  ) async {
    await tasks.createTask(
      name: 'Nicht rauchen',
      beschreibung: '',
      erfassungsmodus: 'checkbox',
      projectId: projectId,
      successValue: false,
      questionText: 'Geraucht?',
    );
    await open(tester);
    expect(find.text('Geraucht?'), findsOneWidget);
    await tester.tap(find.text('Nein'));
    await refresh(tester);
    final rows = await tester.runAsync(
      () => tasks.watchTasksForDate(today).first,
    );
    expect(rows!.single.booleanValue, isFalse);
    expect(rows.single.isCompleted, isTrue);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await refresh(tester);
    await tester.pumpAndSettle();
  });

  testWidgets(
    'Werte brauchen Eingabe; Entwurf bleibt beim Tabwechsel und wird beim Verlassen gespeichert',
    (tester) async {
      await tasks.createTask(
        name: 'Gewicht',
        beschreibung: '',
        erfassungsmodus: 'value',
        projectId: projectId,
        valueType: 'number',
      );
      await open(tester);
      expect(find.byType(Checkbox), findsNothing);
      expect(find.byType(ValueTaskInput), findsOneWidget);
      await tester.tap(find.text('Speichern'));
      await refresh(tester);
      var values = await tester.runAsync(
        () => db.select(db.taskEntryValues).get(),
      );
      expect(values, isEmpty);
      await tester.enterText(find.byType(TextField), '72');
      await tester.tap(find.text('Analyse'));
      await refresh(tester);
      await tester.tap(find.text('Uebersicht'));
      await refresh(tester);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        '72',
      );
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Ungespeicherte Eingaben'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Speichern').last);
      await refresh(tester);
      values = await tester.runAsync(() => db.select(db.taskEntryValues).get());
      expect(values!.single.numberValue, 72);
      expect(find.text('Öffnen'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(const SizedBox.shrink());
      await refresh(tester);
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'Ueberfaellige Instanz behaelt Planungstag und fragt Durchfuehrungstag ab',
    (tester) async {
      final yesterday = calendarAddDays(today, -1);
      await tasks.createTask(
        name: 'Offen',
        beschreibung: '',
        erfassungsmodus: 'checkbox',
        projectId: projectId,
        taskType: 'task',
        recurrence: 'none',
        startDate: yesterday,
        missedPolicy: 'carryover',
      );
      await open(tester);
      expect(
        tester
            .widget<ProjectTaskEntryInput>(find.byType(ProjectTaskEntryInput))
            .scheduledDate,
        yesterday,
      );
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      expect(find.text('Wann wurde es durchgeführt?'), findsOneWidget);
      await tester.tap(find.text('Heute'));
      await refresh(tester);
      final entries = await tester.runAsync(
        () => db.select(db.taskEntries).get(),
      );
      expect(entries!.single.scheduledDate, yesterday);
      expect(entries.single.performedOn, today);
      expect(entries.single.status, 'success');
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(const SizedBox.shrink());
      await refresh(tester);
      await tester.pumpAndSettle();
    },
  );
}
