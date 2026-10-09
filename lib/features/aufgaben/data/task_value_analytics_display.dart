import 'package:momentum/features/aufgaben/data/task_analytics_display.dart';
import 'package:momentum/features/aufgaben/data/task_value_analytics_summary.dart';
import 'package:momentum/features/aufgaben/data/task_value_type.dart';

class TaskValueAnalyticsDisplay {
  const TaskValueAnalyticsDisplay({
    required this.recorded,
    required this.virtualMissing,
    required this.pending,
    required this.noEntries,
    required this.failures,
    required this.sum,
    required this.average,
    required this.minimum,
    required this.maximum,
  });

  factory TaskValueAnalyticsDisplay.fromSummary(
    TaskValueAnalyticsSummary summary,
  ) {
    final isTimeOfDay = summary.valueType == TaskValueType.timeOfDay;
    final aggregateUnavailableReason =
        summary.aggregateUnavailableReason ??
        'Noch keine erfassten Werte im Zeitraum.';

    return TaskValueAnalyticsDisplay(
      recorded: TaskAnalyticsMetricDisplay(
        label: 'Erfasst',
        value: summary.recordedCount.toString(),
        infoText:
            'Zählt alle Einträge im Zeitraum, bei denen ein echter Wert '
            'gespeichert wurde.',
      ),
      virtualMissing: TaskAnalyticsMetricDisplay(
        label: 'Fehlende Tracking-Tage',
        value: summary.virtualMissingCount.toString(),
        infoText:
            'Zählt erwartbare reine Tracking-Tage ohne gespeicherten Wert. '
            'Diese Lücken werden nur berechnet und nicht in die Datenbank '
            'geschrieben.',
      ),
      pending: TaskAnalyticsMetricDisplay(
        label: 'Offen',
        value: summary.pendingCount.toString(),
        infoText:
            'Zählt verbindliche Wert-Einträge, die noch offen sind und noch '
            'keinen gespeicherten Wert haben.',
      ),
      noEntries: TaskAnalyticsMetricDisplay(
        label: 'Kein Eintrag',
        value: summary.noEntryCount.toString(),
        infoText:
            'Zählt Einträge, die ohne verwertbaren Wert neutral abgeschlossen '
            'wurden.',
      ),
      failures: TaskAnalyticsMetricDisplay(
        label: 'Verpasst',
        value: summary.failureCount.toString(),
        infoText:
            'Zählt verbindliche Wert-Einträge, die als verpasst abgeschlossen '
            'wurden. Das ist kein schlechter Messwert, sondern ein fehlender '
            'Pflichtwert.',
      ),
      sum: TaskAnalyticsMetricDisplay(
        label: 'Summe',
        value:
            isTimeOfDay
                ? 'Nicht verfügbar'
                : _formatValue(summary.sum, summary),
        infoText:
            'Addiert alle echten erfassten Werte im Zeitraum. Fehlende Werte '
            'zählen nicht als 0.',
        isAvailable:
            summary.isAggregateAvailable && !isTimeOfDay && summary.sum != null,
        unavailableReason:
            !summary.isAggregateAvailable
                ? aggregateUnavailableReason
                : isTimeOfDay
                ? 'Uhrzeiten werden nicht addiert.'
                : 'Noch keine erfassten Werte im Zeitraum.',
      ),
      average: TaskAnalyticsMetricDisplay(
        label: 'Durchschnitt',
        value: _formatValue(summary.average, summary),
        infoText:
            'Berechnet den Mittelwert nur aus echten erfassten Werten. '
            'Fehlende Werte verbessern den Durchschnitt nicht künstlich.',
        isAvailable: summary.isAggregateAvailable && summary.average != null,
        unavailableReason: aggregateUnavailableReason,
      ),
      minimum: TaskAnalyticsMetricDisplay(
        label: isTimeOfDay ? 'Früheste Uhrzeit' : 'Minimum',
        value: _formatValue(summary.minimum, summary),
        infoText:
            isTimeOfDay
                ? 'Zeigt die früheste erfasste Uhrzeit im Zeitraum. Der '
                    'Folgetag-Bezug wird in der Berechnung berücksichtigt.'
                : 'Zeigt den kleinsten echten erfassten Wert im Zeitraum.',
        isAvailable: summary.isAggregateAvailable && summary.minimum != null,
        unavailableReason: aggregateUnavailableReason,
      ),
      maximum: TaskAnalyticsMetricDisplay(
        label: isTimeOfDay ? 'Späteste Uhrzeit' : 'Maximum',
        value: _formatValue(summary.maximum, summary),
        infoText:
            isTimeOfDay
                ? 'Zeigt die späteste erfasste Uhrzeit im Zeitraum. Der '
                    'Folgetag-Bezug wird in der Berechnung berücksichtigt.'
                : 'Zeigt den größten echten erfassten Wert im Zeitraum.',
        isAvailable: summary.isAggregateAvailable && summary.maximum != null,
        unavailableReason: aggregateUnavailableReason,
      ),
    );
  }

  final TaskAnalyticsMetricDisplay recorded;
  final TaskAnalyticsMetricDisplay virtualMissing;
  final TaskAnalyticsMetricDisplay pending;
  final TaskAnalyticsMetricDisplay noEntries;
  final TaskAnalyticsMetricDisplay failures;
  final TaskAnalyticsMetricDisplay sum;
  final TaskAnalyticsMetricDisplay average;
  final TaskAnalyticsMetricDisplay minimum;
  final TaskAnalyticsMetricDisplay maximum;

  List<TaskAnalyticsMetricDisplay> get processingMetrics => [
    recorded,
    virtualMissing,
    pending,
    noEntries,
    failures,
  ];

  List<TaskAnalyticsMetricDisplay> get valueMetrics => [
    sum,
    average,
    minimum,
    maximum,
  ];
}

String _formatValue(double? value, TaskValueAnalyticsSummary summary) {
  if (value == null) {
    return '–';
  }

  if (summary.valueType == TaskValueType.duration) {
    return _formatDuration(value.round());
  }

  if (summary.valueType == TaskValueType.timeOfDay) {
    return _formatTimeWithDayOffset(value.round());
  }

  final formatted = value.toStringAsFixed(1).replaceAll('.', ',');
  final trimmed =
      formatted.endsWith(',0')
          ? formatted.substring(0, formatted.length - 2)
          : formatted;
  final unit = summary.unitLabel.trim();
  return unit.isEmpty ? trimmed : '$trimmed $unit';
}

String _formatDuration(int seconds) {
  final sign = seconds < 0 ? '-' : '';
  final absoluteSeconds = seconds.abs();
  final hours = absoluteSeconds ~/ 3600;
  final minutes = (absoluteSeconds % 3600) ~/ 60;
  final remainingSeconds = absoluteSeconds % 60;

  if (hours > 0) {
    return '$sign$hours h ${minutes.toString().padLeft(2, '0')} min';
  }

  if (minutes > 0) {
    return '$sign$minutes min';
  }

  return '$sign$remainingSeconds s';
}

String _formatTimeWithDayOffset(int totalMinutes) {
  final dayOffset = totalMinutes ~/ (24 * 60);
  final minutesOfDay = totalMinutes % (24 * 60);
  final hour = (minutesOfDay ~/ 60).toString().padLeft(2, '0');
  final minute = (minutesOfDay % 60).toString().padLeft(2, '0');
  final suffix = dayOffset > 0 ? ' +$dayOffset Tag' : '';
  return '$hour:$minute Uhr$suffix';
}
