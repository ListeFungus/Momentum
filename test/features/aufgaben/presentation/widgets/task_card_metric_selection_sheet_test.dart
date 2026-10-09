import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/habit_recurrence.dart';
import 'package:momentum/features/aufgaben/data/task_types.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_card_metric_selection_sheet.dart';

void main() {
  testWidgets('Kartenanzeige kann explizit ausgeblendet werden', (
    tester,
  ) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    addTearDown(database.close);
    await repository.createTask(
      name: 'Lesen',
      beschreibung: '',
      erfassungsmodus: 'three_state',
      projectId: null,
      taskType: TaskTypes.habit,
      recurrence: HabitRecurrence.daily,
    );
    final task = await database.select(database.aufgaben).getSingle();

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder:
              (context) => Scaffold(
                body: TextButton(
                  onPressed:
                      () => showTaskCardMetricSelectionSheet(
                        context: context,
                        repository: repository,
                        task: task,
                      ),
                  child: const Text('Öffnen'),
                ),
              ),
        ),
      ),
    );

    await tester.tap(find.text('Öffnen'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keine'));
    await tester.tap(find.text('Übernehmen'));
    await tester.pumpAndSettle();

    expect(
      (await repository.getTaskCardMetricPreference(task.id)).isHidden,
      isTrue,
    );
  });

  testWidgets(
    'Kartenanzeige bleibt bei schmaler Breite und großer Schrift nutzbar',
    (tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = AufgabenRepository(database);
      addTearDown(database.close);
      await repository.createTask(
        name: 'Schmale Karte',
        beschreibung: '',
        erfassungsmodus: 'three_state',
        projectId: null,
        taskType: TaskTypes.habit,
        recurrence: HabitRecurrence.daily,
      );
      final task = await database.select(database.aufgaben).getSingle();

      await tester.pumpWidget(
        MaterialApp(
          builder:
              (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(1.8)),
                child: child!,
              ),
          home: Builder(
            builder:
                (context) => Scaffold(
                  body: TextButton(
                    onPressed:
                        () => showTaskCardMetricSelectionSheet(
                          context: context,
                          repository: repository,
                          task: task,
                        ),
                    child: const Text('Öffnen'),
                  ),
                ),
          ),
        ),
      );

      await tester.tap(find.text('Öffnen'));
      await tester.pumpAndSettle();

      expect(find.text('Kartenanzeige'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
