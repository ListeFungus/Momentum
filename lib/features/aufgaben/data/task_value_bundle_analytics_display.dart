import 'package:momentum/features/aufgaben/data/task_analytics_display.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle_analytics_summary.dart';
import 'package:momentum/features/aufgaben/data/task_value_type.dart';

class TaskValueBundleAnalyticsDisplay {
  const TaskValueBundleAnalyticsDisplay({
    required this.complete,
    required this.partial,
    required this.missing,
    required this.notCalculable,
    required this.sum,
    required this.average,
    required this.minimum,
    required this.maximum,
  });

  factory TaskValueBundleAnalyticsDisplay.fromSummary(
    TaskValueBundleAnalyticsSummary summary,
  ) {
    final canSum =
        summary.version.bundleType != TaskValueBundleType.timeInterval;

    return TaskValueBundleAnalyticsDisplay(
      complete: TaskAnalyticsMetricDisplay(
        label: 'Vollständig',
        value: summary.completeCount.toString(),
        infoText:
            'Zählt Tage, an denen beide Teilwerte vorhanden waren und daraus '
            'ein Bündelwert berechnet werden konnte.',
      ),
      partial: TaskAnalyticsMetricDisplay(
        label: 'Teilweise',
        value: summary.partialCount.toString(),
        infoText:
            'Zählt Tage, an denen genau einer der beiden Teilwerte vorhanden '
            'war. Diese Tage gehen nicht in Durchschnitt oder Summe ein.',
      ),
      missing: TaskAnalyticsMetricDisplay(
        label: 'Fehlend',
        value: summary.missingCount.toString(),
        infoText:
            'Zählt relevante Tage, an denen keiner der beiden Teilwerte '
            'vorhanden war.',
      ),
      notCalculable: TaskAnalyticsMetricDisplay(
        label: 'Nicht berechenbar',
        value: summary.notCalculableCount.toString(),
        infoText:
            'Zählt Tage, an denen die vorhandenen Teilwerte nicht zu einem '
            'gültigen Bündelergebnis kombiniert werden konnten.',
      ),
      sum: TaskAnalyticsMetricDisplay(
        label: 'Summe',
        value:
            canSum
                ? _formatBundleValue(summary.sum, summary)
                : 'Nicht verfügbar',
        infoText:
            'Addiert alle vollständig berechenbaren Bündelwerte im Zeitraum. '
            'Teilweise oder fehlende Tage zählen nicht als 0.',
        isAvailable: canSum && summary.sum != null,
        unavailableReason:
            canSum
                ? 'Noch keine vollständig berechenbaren Bündelwerte.'
                : 'Zeitintervalle werden nicht summiert.',
      ),
      average: TaskAnalyticsMetricDisplay(
        label: 'Durchschnitt',
        value: _formatBundleValue(summary.average, summary),
        infoText:
            'Berechnet den Mittelwert nur aus vollständig berechenbaren '
            'Bündelwerten.',
        isAvailable: summary.average != null,
        unavailableReason: 'Noch keine vollständig berechenbaren Bündelwerte.',
      ),
      minimum: TaskAnalyticsMetricDisplay(
        label: 'Minimum',
        value: _formatBundleValue(summary.minimum, summary),
        infoText:
            'Zeigt den kleinsten vollständig berechenbaren Bündelwert im '
            'Zeitraum.',
        isAvailable: summary.minimum != null,
        unavailableReason: 'Noch keine vollständig berechenbaren Bündelwerte.',
      ),
      maximum: TaskAnalyticsMetricDisplay(
        label: 'Maximum',
        value: _formatBundleValue(summary.maximum, summary),
        infoText:
            'Zeigt den größten vollständig berechenbaren Bündelwert im '
            'Zeitraum.',
        isAvailable: summary.maximum != null,
        unavailableReason: 'Noch keine vollständig berechenbaren Bündelwerte.',
      ),
    );
  }

  final TaskAnalyticsMetricDisplay complete;
  final TaskAnalyticsMetricDisplay partial;
  final TaskAnalyticsMetricDisplay missing;
  final TaskAnalyticsMetricDisplay notCalculable;
  final TaskAnalyticsMetricDisplay sum;
  final TaskAnalyticsMetricDisplay average;
  final TaskAnalyticsMetricDisplay minimum;
  final TaskAnalyticsMetricDisplay maximum;

  List<TaskAnalyticsMetricDisplay> get processingMetrics => [
    complete,
    partial,
    missing,
    notCalculable,
  ];

  List<TaskAnalyticsMetricDisplay> get valueMetrics => [
    sum,
    average,
    minimum,
    maximum,
  ];
}

String _formatBundleValue(
  double? value,
  TaskValueBundleAnalyticsSummary summary,
) {
  if (value == null) {
    return '–';
  }

  TaskValueBundleCalculationView? firstCalculation;
  for (final point in summary.points) {
    final calculation = point.bundleForDate.calculation;
    if (calculation != null) {
      firstCalculation = TaskValueBundleCalculationView(
        valueType: calculation.valueType,
        unitLabel: calculation.unitLabel,
      );
      break;
    }
  }
  final valueType = firstCalculation?.valueType;

  if (valueType == TaskValueType.duration) {
    return _formatDuration(value.round());
  }

  final formatted = value.toStringAsFixed(1).replaceAll('.', ',');
  final trimmed =
      formatted.endsWith(',0')
          ? formatted.substring(0, formatted.length - 2)
          : formatted;
  final unit = firstCalculation?.unitLabel.toString().trim() ?? '';
  return unit.isEmpty ? trimmed : '$trimmed $unit';
}

class TaskValueBundleCalculationView {
  const TaskValueBundleCalculationView({
    required this.valueType,
    required this.unitLabel,
  });

  final String valueType;
  final String unitLabel;
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
