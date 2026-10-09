import 'package:momentum/features/aufgaben/data/task_analytics_summary.dart';

class TaskAnalyticsMetricDisplay {
  const TaskAnalyticsMetricDisplay({
    required this.label,
    required this.value,
    required this.infoText,
    this.detail,
    this.isAvailable = true,
    this.unavailableReason,
  });

  final String label;
  final String value;
  final String? detail;
  final String infoText;
  final bool isAvailable;
  final String? unavailableReason;
}

class TaskAnalyticsDisplay {
  const TaskAnalyticsDisplay({
    required this.successRate,
    required this.successes,
    required this.failures,
    required this.noEntries,
    required this.pending,
    required this.completionRate,
    required this.valuedSuccessRate,
    required this.answeredCount,
    required this.resolvedCount,
    required this.dueCount,
    required this.totalInstanceCount,
    required this.overdueEntries,
    required this.overdueDays,
    required this.averageOverdueDays,
    required this.bufferUsage,
    required this.manualVsAutomatic,
  });

  factory TaskAnalyticsDisplay.fromSummary(
    TaskAnalyticsSummary summary, {
    bool noEntryAvailable = true,
    bool overdueAvailable = true,
    bool bufferAvailable = true,
    bool automaticResolutionAvailable = true,
  }) {
    final successRate = TaskAnalyticsMetricDisplay(
      label: 'Erfolgsquote',
      value: _formatRate(
        summary.strictSuccessRate,
        emptyValue: 'Noch keine fälligen Einträge',
      ),
      detail: _formatRatio(summary.successCount, summary.dueCount),
      infoText:
          'Zeigt, wie viele fällige Einträge in diesem Zeitraum erfolgreich waren. '
          'Misserfolge und Kein-Eintrag-Fälle zählen nicht als Erfolg. '
          'Offene Einträge werden separat angezeigt.',
    );
    final successes = TaskAnalyticsMetricDisplay(
      label: 'Erfolge',
      value: summary.successCount.toString(),
      infoText:
          'Alle Einträge, die in diesem Zeitraum erfolgreich abgeschlossen wurden.',
    );
    final failures = TaskAnalyticsMetricDisplay(
      label: 'Misserfolge',
      value: summary.failureCount.toString(),
      infoText:
          'Alle Einträge, die aktiv mit Nein oder automatisch als nicht erfolgreich abgeschlossen wurden.',
    );
    final noEntries = TaskAnalyticsMetricDisplay(
      label: 'Kein Eintrag',
      value:
          noEntryAvailable
              ? summary.noEntryCount.toString()
              : 'Nicht verfügbar',
      infoText:
          'Einträge, die abgeschlossen wurden, aber ohne Ja-/Nein-Antwort. '
          'Sie zählen nicht als Erfolg, bleiben aber sichtbar.',
      isAvailable: noEntryAvailable,
      unavailableReason:
          noEntryAvailable
              ? null
              : 'Diese Aufgabe kann keine Kein-Eintrag-Fälle erzeugen.',
    );
    final pending = TaskAnalyticsMetricDisplay(
      label: 'Offen',
      value: summary.pendingCount.toString(),
      infoText:
          'Einträge, die noch nicht beantwortet oder automatisch verarbeitet wurden. '
          'Sie fließen noch nicht in die Erfolgsquote ein.',
    );
    final completionRate = TaskAnalyticsMetricDisplay(
      label: 'Fortschritt',
      value: _formatRate(
        summary.completionRate,
        emptyValue: 'Noch keine Einträge',
      ),
      detail: _formatRatio(summary.resolvedCount, summary.totalInstanceCount),
      infoText:
          'Zeigt, welcher Anteil aller Einträge im gewählten Zeitraum bereits verarbeitet wurde.',
    );
    final valuedSuccessRate = TaskAnalyticsMetricDisplay(
      label: 'Wertende Erfolgsquote',
      value: _formatRate(summary.valuedSuccessRate),
      detail: _formatRatio(summary.successCount, summary.answeredCount),
      infoText:
          'Zeigt den Erfolgsanteil nur unter den Ja-/Nein-Antworten. '
          'Kein Eintrag und offene Einträge werden hierbei nicht mitgezählt.',
    );
    final answeredCount = TaskAnalyticsMetricDisplay(
      label: 'Beantwortete Instanzen',
      value: summary.answeredCount.toString(),
      infoText:
          'Zählt alle aktiven Ja-/Nein-Antworten. Kein Eintrag und offene '
          'Einträge zählen hier bewusst nicht mit.',
    );
    final resolvedCount = TaskAnalyticsMetricDisplay(
      label: 'Abgeschlossene Instanzen',
      value: summary.resolvedCount.toString(),
      infoText:
          'Zählt alle nicht mehr offenen Einträge: Erfolge, Misserfolge und '
          'Kein-Eintrag-Fälle.',
    );
    final dueCount = TaskAnalyticsMetricDisplay(
      label: 'Fällige Instanzen',
      value: summary.dueCount.toString(),
      infoText:
          'Alle fälligen oder vergangenen abgeschlossenen Einträge im Zeitraum. '
          'Dieser Wert ist die Grundlage der strengen Erfolgsquote.',
    );
    final totalInstanceCount = TaskAnalyticsMetricDisplay(
      label: 'Alle Instanzen',
      value: summary.totalInstanceCount.toString(),
      infoText:
          'Alle erzeugten Einträge im gewählten Zeitraum, inklusive offener '
          'Einträge.',
    );
    final overdueEntries = TaskAnalyticsMetricDisplay(
      label: 'Überfällige Einträge',
      value:
          overdueAvailable
              ? summary.overdueEntryCount.toString()
              : 'Nicht verfügbar',
      infoText:
          'Offene Einträge, deren regulärer Tag bereits vorbei ist. Das ist '
          'besonders bei Puffer und Carryover relevant.',
      isAvailable: overdueAvailable,
      unavailableReason:
          overdueAvailable
              ? null
              : 'Diese Aufgabe kann nicht überfällig offen bleiben.',
    );
    final overdueDays = TaskAnalyticsMetricDisplay(
      label: 'Überfälligkeitstage',
      value:
          overdueAvailable ? summary.overdueDays.toString() : 'Nicht verfügbar',
      infoText: 'Summe der Tage, die offene Einträge aktuell überfällig sind.',
      isAvailable: overdueAvailable,
      unavailableReason:
          overdueAvailable
              ? null
              : 'Diese Aufgabe kann nicht überfällig offen bleiben.',
    );
    final averageOverdueDays = TaskAnalyticsMetricDisplay(
      label: 'Durchschnittliche Überfälligkeit',
      value:
          overdueAvailable
              ? _formatDays(summary.averageOverdueDays)
              : 'Nicht verfügbar',
      infoText:
          'Zeigt, wie lange überfällige offene Einträge im Schnitt bereits '
          'überfällig sind.',
      isAvailable: overdueAvailable,
      unavailableReason:
          overdueAvailable
              ? null
              : 'Diese Aufgabe kann nicht überfällig offen bleiben.',
    );
    final bufferUsage = TaskAnalyticsMetricDisplay(
      label: 'Puffer-Nutzung',
      value:
          bufferAvailable
              ? summary.bufferCompletionCount.toString()
              : 'Nicht verfügbar',
      infoText: 'Zeigt, wie oft Einträge noch im Puffer abgeschlossen wurden.',
      isAvailable: bufferAvailable,
      unavailableReason:
          bufferAvailable
              ? null
              : 'Für diese Aufgabe ist kein Puffer eingestellt.',
    );
    final manualVsAutomatic = TaskAnalyticsMetricDisplay(
      label: 'Manuell vs. automatisch',
      value:
          automaticResolutionAvailable
              ? '${summary.manualResolutionCount} / ${summary.automaticResolutionCount}'
              : 'Nicht verfügbar',
      detail: automaticResolutionAvailable ? 'manuell / automatisch' : null,
      infoText:
          'Vergleicht manuelle Abschlüsse mit automatischen Abschlüssen durch '
          'eine Missed Policy.',
      isAvailable: automaticResolutionAvailable,
      unavailableReason:
          automaticResolutionAvailable
              ? null
              : 'Diese Aufgabe hat keine automatische Abschlussregel.',
    );

    return TaskAnalyticsDisplay(
      successRate: successRate,
      successes: successes,
      failures: failures,
      noEntries: noEntries,
      pending: pending,
      completionRate: completionRate,
      valuedSuccessRate: valuedSuccessRate,
      answeredCount: answeredCount,
      resolvedCount: resolvedCount,
      dueCount: dueCount,
      totalInstanceCount: totalInstanceCount,
      overdueEntries: overdueEntries,
      overdueDays: overdueDays,
      averageOverdueDays: averageOverdueDays,
      bufferUsage: bufferUsage,
      manualVsAutomatic: manualVsAutomatic,
    );
  }

  final TaskAnalyticsMetricDisplay successRate;
  final TaskAnalyticsMetricDisplay successes;
  final TaskAnalyticsMetricDisplay failures;
  final TaskAnalyticsMetricDisplay noEntries;
  final TaskAnalyticsMetricDisplay pending;
  final TaskAnalyticsMetricDisplay completionRate;
  final TaskAnalyticsMetricDisplay valuedSuccessRate;
  final TaskAnalyticsMetricDisplay answeredCount;
  final TaskAnalyticsMetricDisplay resolvedCount;
  final TaskAnalyticsMetricDisplay dueCount;
  final TaskAnalyticsMetricDisplay totalInstanceCount;
  final TaskAnalyticsMetricDisplay overdueEntries;
  final TaskAnalyticsMetricDisplay overdueDays;
  final TaskAnalyticsMetricDisplay averageOverdueDays;
  final TaskAnalyticsMetricDisplay bufferUsage;
  final TaskAnalyticsMetricDisplay manualVsAutomatic;

  List<TaskAnalyticsMetricDisplay> get recurringTaskMetrics => [
    successRate,
    valuedSuccessRate,
    successes,
    failures,
    noEntries,
    pending,
    answeredCount,
    resolvedCount,
    completionRate,
    dueCount,
    totalInstanceCount,
    overdueEntries,
    overdueDays,
    averageOverdueDays,
    bufferUsage,
    manualVsAutomatic,
  ];
}

String _formatRate(double? rate, {String emptyValue = '–'}) {
  if (rate == null) {
    return emptyValue;
  }

  final formattedValue = (rate * 100).toStringAsFixed(1).replaceAll('.', ',');

  return '$formattedValue %';
}

String? _formatRatio(int value, int total) {
  if (total == 0) {
    return null;
  }

  return '$value von $total';
}

String _formatDays(double? days) {
  if (days == null) {
    return 'Keine Überfälligkeit';
  }

  final formattedValue = days.toStringAsFixed(1).replaceAll('.', ',');
  return '$formattedValue Tage';
}
