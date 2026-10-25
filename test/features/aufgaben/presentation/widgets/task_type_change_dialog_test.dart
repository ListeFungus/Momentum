import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/task_type_change_service.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_type_change_dialog.dart';
import 'package:momentum/features/aufgaben/presentation/task_edit_screen.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_type_field.dart';
import 'package:momentum/features/projekte/data/project_repository.dart';

void main() {
  testWidgets('#013 Dialog verlangt expliziten Umfang und zeigt Sperren', (
    tester,
  ) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = AufgabenRepository(db);
    await repo.createTask(
      name: 'Tracker',
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      valueType: 'number',
      valueCommitment: 'pure_tracking',
    );
    final task = await db.select(db.aufgaben).getSingle();
    final preview = await repo.taskTypeChanges.preview(task.id);
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: TaskTypeChangeDialog(preview: preview))),
    );
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Art ändern'))
          .onPressed,
      isNull,
    );
    await tester.tap(find.text('Ab jetzt für neue Einträge'));
    await tester.pump();
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Art ändern'))
          .onPressed,
      isNotNull,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskTypeChangeDialog(
            key: const ValueKey('blocked'),
            preview: TaskTypeChangePreview(
              task: task,
              token: 'x',
              entryCount: 1,
              hasTodayEntry: true,
              newEntriesReason: null,
              allHistoryReason: 'Früheres Bündel',
            ),
          ),
        ),
      ),
    );
    expect(find.textContaining('heutige bestehende'), findsOneWidget);
    expect(find.text('Früheres Bündel'), findsOneWidget);
    final blocked = tester.widget<RadioListTile<TaskTypeChangeScope>>(
      find.widgetWithText(
        RadioListTile<TaskTypeChangeScope>,
        'Auch bisherige Einträge umordnen',
      ),
    );
    expect(blocked.onChanged, isNull);
  });
  testWidgets(
    '#013 aktueller Editor, Abbrechen, ungespeichert, Wechsel und Neuladen',
    (tester) async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final repo = AufgabenRepository(db);
      await repo.createTask(
        name: 'Tracker',
        beschreibung: '',
        erfassungsmodus: 'value',
        projectId: null,
        taskType: 'task',
        valueType: 'number',
        valueCommitment: 'pure_tracking',
        questionText: 'Frage bleibt',
      );
      final historical = await db.select(db.aufgaben).getSingle();
      final p = await repo.taskTypeChanges.preview(historical.id);
      await repo.taskTypeChanges.change(
        taskId: historical.id,
        targetType: 'habit',
        scope: TaskTypeChangeScope.newEntries,
        expectedRevision: p.token,
      );
      final nav = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: nav,
          home: const Scaffold(body: Text('Home')),
        ),
      );
      nav.currentState!.push(
        MaterialPageRoute<void>(
          builder:
              (_) => TaskEditScreen(
                task: historical,
                repository: repo,
                projectRepository: ProjectRepository(db),
              ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TaskTypeField>(find.byType(TaskTypeField))
            .selectedTaskType,
        'habit',
      );
      await tester.ensureVisible(find.text('Art ändern'));
      await tester.tap(find.text('Art ändern'));
      await tester.pumpAndSettle();
      expect(find.byType(TaskTypeChangeDialog), findsOneWidget);
      await tester.tap(find.text('Abbrechen'));
      await tester.pumpAndSettle();
      expect(await db.select(db.taskTypeChanges).get(), hasLength(1));
      await tester.ensureVisible(find.byType(TextFormField).first);
      await tester.enterText(find.byType(TextFormField).first, 'Ungespeichert');
      await tester.ensureVisible(find.text('Art ändern'));
      await tester.tap(find.text('Art ändern'));
      await tester.pumpAndSettle();
      expect(find.byType(TaskTypeChangeDialog), findsNothing);
      expect(
        find.textContaining('ungespeicherten Formularänderungen'),
        findsOneWidget,
      );
      await tester.ensureVisible(find.byType(TextFormField).first);
      await tester.enterText(find.byType(TextFormField).first, 'Tracker');
      await tester.ensureVisible(find.text('Art ändern'));
      await tester.tap(find.text('Art ändern'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Auch bisherige Einträge umordnen'));
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Art ändern'));
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TaskTypeField>(find.byType(TaskTypeField))
            .selectedTaskType,
        'task',
      );
      expect(
        (await repo.currentTask(historical.id)).questionText,
        'Frage bleibt',
      );
      nav.currentState!.pop();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
    },
  );
}
