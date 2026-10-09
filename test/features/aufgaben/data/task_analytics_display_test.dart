import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/features/aufgaben/data/task_analytics_display.dart';
import 'package:momentum/features/aufgaben/data/task_analytics_summary.dart';

void main() {
  test('formatiert Prozentwerte mit einer Nachkommastelle und Verhaeltnis', () {
    const summary = TaskAnalyticsSummary(
      dueCount: 3,
      totalInstanceCount: 5,
      successCount: 2,
      failureCount: 1,
      noEntryCount: 0,
      pendingCount: 2,
    );

    final display = TaskAnalyticsDisplay.fromSummary(summary);

    expect(display.successRate.value, '66,7 %');
    expect(display.successRate.detail, '2 von 3');
    expect(display.completionRate.value, '60,0 %');
    expect(display.completionRate.detail, '3 von 5');
    expect(display.valuedSuccessRate.value, '66,7 %');
    expect(display.valuedSuccessRate.detail, '2 von 3');
  });

  test('zeigt freundliche Hinweise bei fehlender Bezugsmenge', () {
    const summary = TaskAnalyticsSummary(
      dueCount: 0,
      totalInstanceCount: 0,
      successCount: 0,
      failureCount: 0,
      noEntryCount: 0,
      pendingCount: 0,
    );

    final display = TaskAnalyticsDisplay.fromSummary(summary);

    expect(display.successRate.value, 'Noch keine fälligen Einträge');
    expect(display.successRate.detail, isNull);
    expect(display.completionRate.value, 'Noch keine Einträge');
    expect(display.completionRate.detail, isNull);
    expect(display.valuedSuccessRate.value, '–');
    expect(display.valuedSuccessRate.detail, isNull);
  });
}
