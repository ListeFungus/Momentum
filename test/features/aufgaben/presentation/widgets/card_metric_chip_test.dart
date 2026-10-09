import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/features/aufgaben/data/task_card_metric.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/card_metric_chip.dart';

void main() {
  testWidgets(
    'Kartenkennzahl bricht lange Datenhinweise auf schmaler Karte um',
    (tester) async {
      tester.view.physicalSize = const Size(300, 500);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(24),
              child: CardMetricChip(
                metric: TaskCardMetric(
                  label: 'Durchschnitt',
                  value: '2380 kcal',
                  tone: TaskCardMetricTone.warning,
                  detail:
                      'Ziel: höchstens 2500 kcal · Letzte 7 Tage · '
                      '5 Werte · 2 fehlend/offen',
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('2380 kcal'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
