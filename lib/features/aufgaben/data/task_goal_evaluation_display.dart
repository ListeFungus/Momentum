import 'package:momentum/features/aufgaben/data/task_analytics_display.dart';
import 'package:momentum/features/aufgaben/data/task_goal.dart';
import 'package:momentum/features/aufgaben/data/task_goal_evaluation_summary.dart';
import 'package:momentum/features/aufgaben/data/task_value_type.dart';

class TaskGoalEvaluationDisplay {
  const TaskGoalEvaluationDisplay({
    required this.status,
    required this.progress,
    required this.period,
    required this.openEntries,
    required this.dataQuality,
  });

  factory TaskGoalEvaluationDisplay.fromSummary(
    TaskGoalEvaluationSummary summary,
  ) {
    return TaskGoalEvaluationDisplay(
      status: TaskAnalyticsMetricDisplay(
        label: 'Zielstatus',
        value: _stateLabel(summary),
        detail:
            summary.requiredSuccessCount > 0
                ? '${summary.successCount} von ${summary.requiredSuccessCount} Erfolgen'
                : null,
        infoText:
            'Zeigt, ob das Ziel im aktuellen Zielzeitraum erreicht ist. '
            'Gezählt werden nur Erfolge. Kein Eintrag und Misserfolge zählen '
            'nicht als Erfolg; offene Einträge können das Ziel noch erreichbar '
            'machen.',
        isAvailable: summary.hasGoal && summary.isSupported && summary.hasData,
        unavailableReason: _unavailableReason(summary),
      ),
      progress: TaskAnalyticsMetricDisplay(
        label: 'Zielfortschritt',
        value: _formatRate(summary.successProgress),
        detail:
            summary.requiredSuccessCount > 0
                ? '${summary.successCount} von ${summary.requiredSuccessCount}'
                : null,
        infoText:
            'Vergleicht die erreichten Erfolge mit der benötigten Anzahl für '
            'dieses Ziel. Der Wert kann 100 % erreichen, auch wenn zusätzlich '
            'Misserfolge oder Kein-Eintrag-Fälle sichtbar bleiben.',
        isAvailable: summary.hasGoal && summary.isSupported && summary.hasData,
        unavailableReason: _unavailableReason(summary),
      ),
      period: TaskAnalyticsMetricDisplay(
        label: 'Zielzeitraum',
        value: '${summary.windowDays} Tage',
        detail:
            '${_formatDate(summary.periodStart)} bis '
            '${_formatDate(summary.periodEnd)}',
        infoText:
            'Die erste Zielbewertung schaut rollierend rückwärts auf diesen '
            'Zeitraum inklusive heute.',
        isAvailable: summary.hasGoal,
        unavailableReason:
            summary.hasGoal ? null : 'Diese Aufgabe hat kein Ziel.',
      ),
      openEntries: TaskAnalyticsMetricDisplay(
        label: 'Noch offen',
        value: summary.pendingCount.toString(),
        infoText:
            'Offene Einträge sind noch nicht endgültig bewertet. Sie zählen '
            'nicht als Erfolg, können das Ziel aber noch erreichbar machen.',
        isAvailable: summary.hasGoal && summary.isSupported,
        unavailableReason: _unavailableReason(summary),
      ),
      dataQuality: TaskAnalyticsMetricDisplay(
        label: 'Datenhinweis',
        value:
            summary.hasDataQualityWarning
                ? '${summary.failureCount + summary.noEntryCount} auffällig'
                : 'Unauffällig',
        detail:
            summary.hasDataQualityWarning
                ? '${summary.failureCount} Misserfolge, '
                    '${summary.noEntryCount} Kein Eintrag'
                : null,
        infoText:
            'Misserfolge und Kein-Eintrag-Fälle werden neben dem Zielstatus '
            'sichtbar gehalten. So wirkt ein erreichtes Ziel nicht sauberer, '
            'als die Daten tatsächlich sind.',
        isAvailable: summary.hasGoal && summary.isSupported && summary.hasData,
        unavailableReason: _unavailableReason(summary),
      ),
    );
  }

  final TaskAnalyticsMetricDisplay status;
  final TaskAnalyticsMetricDisplay progress;
  final TaskAnalyticsMetricDisplay period;
  final TaskAnalyticsMetricDisplay openEntries;
  final TaskAnalyticsMetricDisplay dataQuality;

  List<TaskAnalyticsMetricDisplay> get metrics => [
    status,
    progress,
    period,
    openEntries,
    dataQuality,
  ];
}

class TaskGoalHistoryDisplay {
  const TaskGoalHistoryDisplay({required this.summary, required this.blocks});

  factory TaskGoalHistoryDisplay.fromSummary(TaskGoalHistorySummary summary) {
    return TaskGoalHistoryDisplay(
      summary: TaskAnalyticsMetricDisplay(
        label: 'Zielquote',
        value: _formatRate(summary.achievedRate),
        detail:
            summary.evaluatedBlockCount > 0
                ? '${summary.achievedBlockCount} von '
                    '${summary.evaluatedBlockCount} Zielblöcken'
                : null,
        infoText:
            'Zeigt, wie viele abgeschlossene und bewertbare Zielblöcke '
            'erreicht wurden. Nicht bewertbare Blöcke, zum Beispiel mit '
            'offenen Einträgen, werden sichtbar gelistet, aber nicht in die '
            'Quote gerechnet.',
        isAvailable:
            summary.hasGoal &&
            summary.isSupported &&
            summary.evaluatedBlockCount > 0,
        unavailableReason:
            summary.blocks.isEmpty
                ? 'Es gibt noch keine abgeschlossenen Zielblöcke.'
                : 'Es gibt noch keine bewertbaren Zielblöcke.',
      ),
      blocks:
          summary.blocks.map((block) {
            return TaskGoalHistoryBlockDisplay(
              period:
                  '${_formatDate(block.periodStart)} bis '
                  '${_formatDate(block.periodEnd)}',
              status: _historyStateLabel(block),
              detail:
                  '${block.successCount} von '
                  '${block.requiredSuccessCount} Erfolgen',
              message: block.message,
              isEvaluated: block.isEvaluated,
            );
          }).toList(),
    );
  }

  final TaskAnalyticsMetricDisplay summary;
  final List<TaskGoalHistoryBlockDisplay> blocks;
}

class TaskGoalHistoryBlockDisplay {
  const TaskGoalHistoryBlockDisplay({
    required this.period,
    required this.status,
    required this.detail,
    required this.message,
    required this.isEvaluated,
  });

  final String period;
  final String status;
  final String detail;
  final String message;
  final bool isEvaluated;
}

class TaskValueGoalEvaluationDisplay {
  const TaskValueGoalEvaluationDisplay({
    required this.status,
    required this.result,
    required this.period,
    required this.dataBasis,
  });

  factory TaskValueGoalEvaluationDisplay.fromSummary(
    TaskValueGoalEvaluationSummary summary,
  ) {
    return TaskValueGoalEvaluationDisplay(
      status: TaskAnalyticsMetricDisplay(
        label: 'Zielstatus',
        value: _valueGoalStateLabel(summary),
        detail: summary.message,
        infoText:
            'Zeigt, ob das Wertziel im aktuellen Zielzeitraum rechnerisch '
            'erreicht wurde. Fehlende Werte zählen nicht als 0, sondern werden '
            'separat als Datenbasis-Hinweis gezeigt.',
        isAvailable: summary.hasGoal && summary.isSupported && summary.hasData,
        unavailableReason: _valueGoalUnavailableReason(summary),
      ),
      result: TaskAnalyticsMetricDisplay(
        label: _valueGoalResultLabel(summary),
        value: _formatValueGoalValue(summary.actualValue, summary),
        detail:
            summary.actualValue == null
                ? null
                : 'Ziel: ${_formatValueGoalValue(summary.targetValue, summary)}',
        infoText:
            'Vergleicht Summe oder Durchschnitt echter erfasster Werte mit '
            'dem Zielwert. Offene, fehlende oder verpasste Einträge fließen '
            'nicht als Ersatzwert ein.',
        isAvailable: summary.hasGoal && summary.isSupported && summary.hasData,
        unavailableReason: _valueGoalUnavailableReason(summary),
      ),
      period: TaskAnalyticsMetricDisplay(
        label: 'Zielzeitraum',
        value: '${summary.windowDays} Tage',
        detail:
            '${_formatDate(summary.periodStart)} bis '
            '${_formatDate(summary.periodEnd)}',
        infoText:
            'Wertziele nutzen dieselbe feste Zielspanne wie Statusziele und '
            'schauen live rückwärts inklusive heute.',
        isAvailable: summary.hasGoal,
        unavailableReason:
            summary.hasGoal ? null : 'Diese Aufgabe hat kein Wertziel.',
      ),
      dataBasis: TaskAnalyticsMetricDisplay(
        label: 'Datenbasis',
        value: '${summary.recordedCount} Werte',
        detail:
            summary.hasDataQualityWarning
                ? '${summary.missingOrOpenCount} fehlend/offen'
                : 'vollständig',
        infoText:
            'Zeigt, wie viele echte Werte in die Zielbewertung eingeflossen '
            'sind. Fehlende oder offene Einträge werden nicht als 0 gerechnet.',
        isAvailable: summary.hasGoal && summary.isSupported,
        unavailableReason: _valueGoalUnavailableReason(summary),
      ),
    );
  }

  final TaskAnalyticsMetricDisplay status;
  final TaskAnalyticsMetricDisplay result;
  final TaskAnalyticsMetricDisplay period;
  final TaskAnalyticsMetricDisplay dataBasis;

  List<TaskAnalyticsMetricDisplay> get metrics => [
    status,
    result,
    period,
    dataBasis,
  ];
}

String _stateLabel(TaskGoalEvaluationSummary summary) {
  return switch (summary.state) {
    TaskGoalEvaluationState.noGoal => 'Kein Ziel',
    TaskGoalEvaluationState.unsupported => 'Noch nicht unterstützt',
    TaskGoalEvaluationState.noData => 'Keine Daten',
    TaskGoalEvaluationState.notEvaluated => 'Nicht gewertet',
    TaskGoalEvaluationState.achieved => 'Erreicht',
    TaskGoalEvaluationState.reachable => 'Auf Kurs',
    TaskGoalEvaluationState.missed => 'Nicht erreichbar',
    _ => 'Unklar',
  };
}

String _formatRate(double? rate) {
  if (rate == null) {
    return 'Nicht verfügbar';
  }

  final formatted = (rate * 100).toStringAsFixed(1).replaceAll('.', ',');
  return '$formatted %';
}

String? _unavailableReason(TaskGoalEvaluationSummary summary) {
  if (!summary.hasGoal) {
    return 'Diese Aufgabe hat kein Ziel.';
  }

  if (!summary.isSupported) {
    return summary.message;
  }

  if (!summary.hasData) {
    return summary.message;
  }

  return null;
}

String _historyStateLabel(TaskGoalHistoryBlock block) {
  return switch (block.state) {
    TaskGoalEvaluationState.achieved => 'Erreicht',
    TaskGoalEvaluationState.missed => 'Nicht erreicht',
    TaskGoalEvaluationState.notEvaluated => 'Nicht gewertet',
    TaskGoalEvaluationState.noData => 'Keine Daten',
    _ => 'Unklar',
  };
}

String _valueGoalStateLabel(TaskValueGoalEvaluationSummary summary) {
  return switch (summary.state) {
    TaskGoalEvaluationState.noGoal => 'Kein Ziel',
    TaskGoalEvaluationState.unsupported => 'Noch nicht unterstützt',
    TaskGoalEvaluationState.noData => 'Keine Daten',
    TaskGoalEvaluationState.achieved => 'Erreicht',
    TaskGoalEvaluationState.reachable => 'Erreicht mit Datenlücke',
    TaskGoalEvaluationState.missed => 'Nicht erreicht',
    _ => 'Unklar',
  };
}

String _valueGoalResultLabel(TaskValueGoalEvaluationSummary summary) {
  return switch (summary.goalType) {
    TaskGoalType.valueSumMin => 'Summe',
    TaskGoalType.valueAverageMin ||
    TaskGoalType.valueAverageMax => 'Durchschnitt',
    _ => 'Wert',
  };
}

String? _valueGoalUnavailableReason(TaskValueGoalEvaluationSummary summary) {
  if (!summary.hasGoal) {
    return 'Diese Aufgabe hat kein Wertziel.';
  }

  if (!summary.isSupported) {
    return summary.message;
  }

  if (!summary.hasData) {
    return summary.message;
  }

  return null;
}

String _formatValueGoalValue(
  double? value,
  TaskValueGoalEvaluationSummary summary,
) {
  if (value == null) {
    return 'Nicht verfügbar';
  }

  if (summary.valueType == TaskValueType.duration) {
    return _formatDuration(value.round());
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

String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}.'
      '${date.month.toString().padLeft(2, '0')}.'
      '${date.year.toString().padLeft(4, '0')}';
}
