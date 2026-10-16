import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/daily_completion_chart.dart';

void main() {
  testWidgets(
    'compact chart selects a day and another date range without stale data',
    (tester) async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = AufgabenRepository(db);
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [DailyCompletionChart(repository: repository)],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Erledigt in 7 Tagen'), findsOneWidget);
      expect(
        find.text('0 insgesamt · Tag antippen für Details'),
        findsOneWidget,
      );
      final today = DateTime.now();
      await tester.tap(find.text('${today.day}.').last);
      await tester.pump();
      expect(
        find.text('${today.day}.${today.month}.${today.year}: 0 erledigt'),
        findsOneWidget,
      );
      await tester.tap(find.text('Letzte 7 Tage'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '01/15/2026');
      await tester.tap(find.text('Auswählen'));
      await tester.pumpAndSettle();
      expect(find.text('15.1.2026: 0 erledigt'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Heute'));
      await tester.pumpAndSettle();
      expect(find.text('Letzte 7 Tage'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 1));
      await tester.runAsync(db.close);
    },
  );
}
