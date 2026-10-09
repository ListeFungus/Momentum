import 'package:flutter/material.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/task_analytics_period.dart';
import 'package:momentum/features/aufgaben/data/task_analytics_summary.dart';

class OneTimeTaskCollectionAnalyticsScreen extends StatefulWidget {
  const OneTimeTaskCollectionAnalyticsScreen({
    required this.repository,
    super.key,
  });

  final AufgabenRepository repository;

  @override
  State<OneTimeTaskCollectionAnalyticsScreen> createState() =>
      _OneTimeTaskCollectionAnalyticsScreenState();
}

class _OneTimeTaskCollectionAnalyticsScreenState
    extends State<OneTimeTaskCollectionAnalyticsScreen> {
  TaskAnalyticsPeriod _selectedPeriod = TaskAnalyticsPeriod.last30Days;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Einmalige Aufgaben')),
      body: StreamBuilder<OneTimeTaskAnalyticsSummary>(
        stream: widget.repository.watchOneTimeTaskAnalyticsSummaryForPeriod(
          period: _selectedPeriod,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const _MessageState(
              message: 'Die Auswertung konnte nicht geladen werden.',
              isError: true,
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return _OneTimeTaskCollectionAnalyticsContent(
            summary: snapshot.data!,
            selectedPeriod: _selectedPeriod,
            onPeriodChanged: (period) {
              setState(() {
                _selectedPeriod = period;
              });
            },
          );
        },
      ),
    );
  }
}

class _OneTimeTaskCollectionAnalyticsContent extends StatelessWidget {
  const _OneTimeTaskCollectionAnalyticsContent({
    required this.summary,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  final OneTimeTaskAnalyticsSummary summary;
  final TaskAnalyticsPeriod selectedPeriod;
  final ValueChanged<TaskAnalyticsPeriod> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    final metrics = _metricsFor(summary);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: [
        Text(
          'Sammelauswertung',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          'Diese Ansicht fasst einmalige Aufgaben zusammen. Für diese erste '
          'Version zählt der gewählte Zeitraum nach Erstellungsdatum.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Zeitraum',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              TaskAnalyticsPeriod.values.map((period) {
                return ChoiceChip(
                  label: Text(period.label),
                  selected: period == selectedPeriod,
                  onSelected: (_) => onPeriodChanged(period),
                );
              }).toList(),
        ),
        const SizedBox(height: 22),
        _SectionTitle(
          title: 'Auswertungen',
          subtitle:
              'Ausgegraute Werte passen zu den vorhandenen Daten im Zeitraum '
              'noch nicht.',
        ),
        const SizedBox(height: 10),
        _MetricGrid(metrics: metrics),
      ],
    );
  }
}

List<_MetricDisplay> _metricsFor(OneTimeTaskAnalyticsSummary summary) {
  final hasCompleted = summary.resolvedCount > 0;
  final hasDueDateCompletions = summary.completedWithDueDateCount > 0;
  final hasCurrentOverdue = summary.currentOverdueCount > 0;

  return [
    _MetricDisplay(
      label: 'Anzahl aller Aufgaben',
      value: summary.totalCount.toString(),
      infoText:
          'Alle einmaligen Aufgaben, die im gewählten Zeitraum erstellt wurden.',
    ),
    _MetricDisplay(
      label: 'Erledigt',
      value: summary.successCount.toString(),
      infoText: 'Einmalige Aufgaben, die erfolgreich abgeschlossen wurden.',
    ),
    _MetricDisplay(
      label: 'Misserfolg',
      value: summary.failureCount.toString(),
      infoText:
          'Einmalige Aufgaben, die als nicht erfolgreich abgeschlossen wurden.',
    ),
    _MetricDisplay(
      label: 'Kein Eintrag',
      value: summary.noEntryCount.toString(),
      infoText:
          'Einmalige Aufgaben, die abgeschlossen wurden, aber ohne wertende Antwort.',
    ),
    _MetricDisplay(
      label: 'Offen',
      value: summary.pendingCount.toString(),
      infoText: 'Einmalige Aufgaben, die noch nicht abgeschlossen sind.',
    ),
    _MetricDisplay(
      label: 'Rechtzeitig erledigt',
      value:
          hasDueDateCompletions
              ? _formatRate(summary.onTimeRate)
              : 'Nicht verfügbar',
      detail:
          hasDueDateCompletions
              ? '${summary.onTimeCount} von ${summary.completedWithDueDateCount}'
              : null,
      infoText:
          'Anteil der abgeschlossenen Aufgaben mit Fälligkeitsdatum, die '
          'spätestens am Fälligkeitstag erledigt wurden.',
      isAvailable: hasDueDateCompletions,
      unavailableReason:
          'Im Zeitraum gibt es keine abgeschlossene Aufgabe mit Fälligkeitsdatum.',
    ),
    _MetricDisplay(
      label: 'Vor Fälligkeit erledigt',
      value:
          hasDueDateCompletions
              ? summary.beforeDueCount.toString()
              : 'Nicht verfügbar',
      infoText: 'Aufgaben, die vor dem Fälligkeitstag abgeschlossen wurden.',
      isAvailable: hasDueDateCompletions,
      unavailableReason:
          'Im Zeitraum gibt es keine abgeschlossene Aufgabe mit Fälligkeitsdatum.',
    ),
    _MetricDisplay(
      label: 'Am Fälligkeitstag erledigt',
      value:
          hasDueDateCompletions
              ? summary.onDueCount.toString()
              : 'Nicht verfügbar',
      infoText: 'Aufgaben, die genau am Fälligkeitstag abgeschlossen wurden.',
      isAvailable: hasDueDateCompletions,
      unavailableReason:
          'Im Zeitraum gibt es keine abgeschlossene Aufgabe mit Fälligkeitsdatum.',
    ),
    _MetricDisplay(
      label: 'Nach Fälligkeit erledigt',
      value:
          hasDueDateCompletions
              ? summary.afterDueCount.toString()
              : 'Nicht verfügbar',
      infoText: 'Aufgaben, die nach dem Fälligkeitstag abgeschlossen wurden.',
      isAvailable: hasDueDateCompletions,
      unavailableReason:
          'Im Zeitraum gibt es keine abgeschlossene Aufgabe mit Fälligkeitsdatum.',
    ),
    _MetricDisplay(
      label: 'Ø Zeit bis Erledigung',
      value:
          hasCompleted
              ? _formatDays(summary.averageDaysToCompletion)
              : 'Nicht verfügbar',
      infoText: 'Durchschnittliche Zeit vom Startdatum bis zum Abschluss.',
      isAvailable: hasCompleted,
      unavailableReason: 'Im Zeitraum wurde noch keine Aufgabe abgeschlossen.',
    ),
    _MetricDisplay(
      label: 'Ø Abweichung vom Fälligkeitstag',
      value:
          hasDueDateCompletions
              ? _formatSignedDays(summary.averageDueDeviationDays)
              : 'Nicht verfügbar',
      infoText:
          'Durchschnittliche Verfrühung oder Verspätung bei abgeschlossenen '
          'Aufgaben mit Fälligkeit.',
      isAvailable: hasDueDateCompletions,
      unavailableReason:
          'Im Zeitraum gibt es keine abgeschlossene Aufgabe mit Fälligkeitsdatum.',
    ),
    _MetricDisplay(
      label: 'Ø überfällige Tage offener Aufgaben',
      value:
          hasCurrentOverdue
              ? _formatDays(summary.averageCurrentOverdueDays)
              : 'Nicht verfügbar',
      infoText: 'Durchschnittliche aktuelle Überfälligkeit offener Aufgaben.',
      isAvailable: hasCurrentOverdue,
      unavailableReason:
          'Aktuell ist keine Aufgabe im Zeitraum überfällig offen.',
    ),
    _MetricDisplay(
      label: 'Manuell vs. automatisch',
      value:
          '${summary.manualResolutionCount} / ${summary.automaticResolutionCount}',
      detail: 'manuell / automatisch',
      infoText:
          'Vergleicht manuelle Abschlüsse mit automatischen Abschlüssen durch '
          'eine Missed Policy.',
    ),
  ];
}

class _MetricDisplay {
  const _MetricDisplay({
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

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.metrics});

  final List<_MetricDisplay> metrics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 10) / 2;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children:
              metrics.map((metric) {
                return SizedBox(
                  width: itemWidth,
                  child: _MetricCard(metric: metric),
                );
              }).toList(),
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final _MetricDisplay metric;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final contentColor =
        metric.isAvailable
            ? colorScheme.onSurface
            : colorScheme.onSurfaceVariant.withValues(alpha: 0.7);

    return DecoratedBox(
      decoration: BoxDecoration(
        color:
            metric.isAvailable
                ? colorScheme.surface
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    metric.label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Berechnung erklären',
                  icon: const Icon(Icons.info_outline),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _showMetricInfo(context, metric),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              metric.value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: contentColor,
              ),
            ),
            if (!metric.isAvailable && metric.unavailableReason != null) ...[
              const SizedBox(height: 4),
              Text(
                metric.unavailableReason!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (metric.detail != null) ...[
              const SizedBox(height: 4),
              Text(
                metric.detail!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({required this.message, this.isError = false});

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color:
                isError
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

void _showMetricInfo(BuildContext context, _MetricDisplay metric) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(metric.label),
        content: Text(metric.infoText),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Verstanden'),
          ),
        ],
      );
    },
  );
}

String _formatRate(double? rate) {
  if (rate == null) {
    return 'Nicht verfügbar';
  }

  final formattedValue = (rate * 100).toStringAsFixed(1).replaceAll('.', ',');
  return '$formattedValue %';
}

String _formatDays(double? days) {
  if (days == null) {
    return 'Nicht verfügbar';
  }

  final formattedValue = days.toStringAsFixed(1).replaceAll('.', ',');
  return '$formattedValue Tage';
}

String _formatSignedDays(double? days) {
  if (days == null) {
    return 'Nicht verfügbar';
  }

  final formattedValue = days.toStringAsFixed(1).replaceAll('.', ',');
  if (days > 0) {
    return '+$formattedValue Tage';
  }

  return '$formattedValue Tage';
}
