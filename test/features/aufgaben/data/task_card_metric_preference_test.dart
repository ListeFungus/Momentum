import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/features/aufgaben/data/task_analytics_period.dart';
import 'package:momentum/features/aufgaben/data/task_card_metric_preference.dart';

void main() {
  test('Kartenanzeige speichert geordnete Kennzahlen stabil', () {
    const config = TaskCardMetricPreferenceConfig(
      items: [
        TaskCardMetricPreferenceItem(
          metric: TaskCardMetricKey.average,
          period: TaskAnalyticsPeriod.last7Days,
        ),
      ],
    );

    final decoded = TaskCardMetricPreferenceConfig.decode(config.encode());

    expect(decoded.isAvailable, isTrue);
    expect(decoded.config, config);
  });

  test('leere Kartenanzeige bleibt von Standard unterscheidbar', () {
    final decoded = TaskCardMetricPreferenceConfig.decode(
      TaskCardMetricPreferenceConfig.hidden.encode(),
    );

    expect(decoded.isAvailable, isTrue);
    expect(decoded.config!.items, isEmpty);
  });

  test(
    'unbekannte oder beschädigte Kartenanzeige bleibt unverändert lesbar',
    () {
      final unknown = TaskCardMetricPreferenceConfig.decode(
        '{"version":2,"items":[]}',
      );
      final damaged = TaskCardMetricPreferenceConfig.decode('{nicht-json');

      expect(unknown.isAvailable, isFalse);
      expect(damaged.isAvailable, isFalse);
    },
  );
}
