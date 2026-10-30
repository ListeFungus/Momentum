import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/projekte/data/project_repository.dart';
import 'package:momentum/features/aufgaben/presentation/aufgaben_screen.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/value_draft_scope.dart';

void main() {
  testWidgets(
    'Gruppen: exklusiv, fehlender Wert, Teilaktion, Entwurf und Navigation',
    (tester) async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final repo = AufgabenRepository(db);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final drafts = ValueDraftStore();
      addTearDown(drafts.dispose);
      final group = await repo.displayGroups.store.create('Morgen');
      for (final name in ['Messung', 'Abhaken']) {
        await repo.createTask(
          name: name,
          beschreibung: '',
          erfassungsmodus: name == 'Messung' ? 'value' : 'checkbox',
          projectId: null,
          recurrence: 'daily',
          startDate: today,
          valueType: name == 'Messung' ? 'number' : 'none',
          valueCommitment: name == 'Messung' ? 'pure_tracking' : 'none',
        );
        final task = (await db.select(db.aufgaben).get()).firstWhere(
          (t) => t.name == name,
        );
        await repo.displayGroups.store.assign(task.id, group);
      }
      await tester.pumpWidget(
        MaterialApp(
          home: ValueDraftScope(
            store: drafts,
            child: Scaffold(
              body: AufgabenScreen(
                aufgabenRepository: repo,
                projectRepository: ProjectRepository(db),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Messung'), findsNothing);
      await tester.tap(find.text('Gruppen'));
      await tester.pumpAndSettle();
      expect(find.text('Messung'), findsOneWidget);
      await tester.tap(find.text('Gruppe abschließen'));
      await tester.pumpAndSettle();
      expect(find.text('Nur abhakbare Einträge erledigen'), findsOneWidget);
      await tester.enterText(find.byType(TextField).first, '1..2');
      await tester.ensureVisible(find.text('Gruppe abschließen'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Gruppe abschließen'));
      await tester.pumpAndSettle();
      expect(await db.select(db.taskEntryValues).get(), isEmpty);
      expect(drafts.errors.values.join(), contains('gültige'));
      await tester.enterText(find.byType(TextField).first, '12');
      await tester.ensureVisible(find.text('Nur abhakbare Einträge erledigen'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Nur abhakbare Einträge erledigen'));
      await tester.pumpAndSettle();
      expect(drafts.drafts.values.single.text, '12');
      expect(await db.select(db.taskEntryValues).get(), isEmpty);
      await tester.tap(find.text('Habits'));
      await tester.pumpAndSettle();
      expect(find.text('Ungespeicherte Eingaben'), findsOneWidget);
      await tester.tap(find.text('Abbrechen'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Gruppe abschließen'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Gruppe abschließen'));
      await tester.pumpAndSettle();
      expect((await db.select(db.taskEntryValues).getSingle()).numberValue, 12);
      expect(drafts.drafts, isEmpty);
      expect(find.textContaining('2 von 2 bearbeitet'), findsOneWidget);
      tester.view.physicalSize = const Size(360, 1000);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.8;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
      final closing = db.close();
      await tester.pump(const Duration(seconds: 1));
      await closing;
    },
  );
}
