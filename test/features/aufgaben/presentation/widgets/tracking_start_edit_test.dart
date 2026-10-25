import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/projekte/data/project_repository.dart';
import 'package:momentum/features/aufgaben/presentation/task_edit_screen.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/due_date_field.dart';

void main() {
  for (final pure in [true, false]) {
    testWidgets(
      '#002 Formular ${pure ? "Tracking speichern/abbrechen" : "Terminserie gesperrt"}',
      (tester) async {
        final db = AppDatabase.forTesting(NativeDatabase.memory());
        addTearDown(db.close);
        final repo = AufgabenRepository(db);
        final old = DateTime(2026, 10, 1);
        await repo.createTask(
          name: 'Gewicht',
          beschreibung: '',
          erfassungsmodus: pure ? 'value' : 'checkbox',
          projectId: null,
          startDate: old,
          valueType: pure ? 'number' : 'none',
          valueCommitment: pure ? 'pure_tracking' : 'none',
          valueUnitKey: pure ? 'custom' : 'none',
          valueUnitLabel: pure ? 'kg' : '',
        );
        final task = await db.select(db.aufgaben).getSingle();
        final nav = GlobalKey<NavigatorState>();
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: nav,
            home: const Scaffold(body: Text('Start')),
          ),
        );
        void open() => nav.currentState!.push(
          MaterialPageRoute<void>(
            builder:
                (_) => TaskEditScreen(
                  task: task,
                  repository: repo,
                  projectRepository: ProjectRepository(db),
                ),
          ),
        );
        open();
        await tester.pumpAndSettle();
        await tester.runAsync(() async {
          await repo.startDateBlockedReason(task.id);
        });
        await tester.pumpAndSettle();
        final field = tester.widget<StartDateField>(
          find.byType(StartDateField),
        );
        expect(field.enabled, pure);
        if (!pure) {
          expect(find.textContaining('ohne Missed-Policy'), findsOneWidget);
          nav.currentState!.pop();
          await tester.pumpAndSettle();
          await tester.pump(const Duration(seconds: 1));
          return;
        }
        field.onChanged(DateTime(2026, 9, 1));
        await tester.pump();
        nav.currentState!.pop();
        await tester.pumpAndSettle();
        expect((await db.select(db.aufgaben).getSingle()).startDate, old);
        open();
        await tester.pumpAndSettle();
        tester
            .widget<StartDateField>(find.byType(StartDateField))
            .onChanged(DateTime(2026, 9, 1));
        await tester.pump();
        await tester.ensureVisible(find.text('Änderungen speichern'));
        await tester.tap(find.text('Änderungen speichern'));
        await tester.runAsync(() async {
          await Future<void>.delayed(const Duration(milliseconds: 100));
        });
        await tester.pumpAndSettle();
        expect(
          (await db.select(db.aufgaben).getSingle()).startDate,
          DateTime(2026, 9, 1),
        );
      },
    );
  }
}
