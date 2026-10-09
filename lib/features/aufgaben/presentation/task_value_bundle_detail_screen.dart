import 'package:flutter/material.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/task_analytics_display.dart';
import 'package:momentum/features/aufgaben/data/task_analytics_period.dart';
import 'package:momentum/features/aufgaben/data/task_goal.dart';
import 'package:momentum/features/aufgaben/data/task_goal_evaluation_display.dart';
import 'package:momentum/features/aufgaben/data/task_goal_evaluation_summary.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle_analytics_display.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle_analytics_summary.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle_calculation.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle_for_date.dart';
import 'package:momentum/features/aufgaben/data/task_value_type.dart';
import 'package:momentum/features/aufgaben/presentation/task_detail_screen.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_card_metric_selection_sheet.dart';

class TaskValueBundleDetailScreen extends StatefulWidget {
  const TaskValueBundleDetailScreen({
    required this.bundle,
    required this.repository,
    super.key,
  });

  final TaskValueBundleForDate bundle;
  final AufgabenRepository repository;

  @override
  State<TaskValueBundleDetailScreen> createState() =>
      _TaskValueBundleDetailScreenState();
}

class _TaskValueBundleDetailScreenState
    extends State<TaskValueBundleDetailScreen> {
  TaskAnalyticsPeriod _selectedPeriod = TaskAnalyticsPeriod.last7Days;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bundle.version.name),
        actions: [
          if (widget.bundle.bundle.isActive)
            IconButton(
              tooltip: 'Name und Beschreibung bearbeiten',
              icon: const Icon(Icons.edit_outlined),
              onPressed: _editMetadata,
            ),
          IconButton(
            tooltip: 'Kartenanzeige',
            icon: const Icon(Icons.dashboard_customize_outlined),
            onPressed: () {
              showBundleCardMetricSelectionSheet(
                context: context,
                repository: widget.repository,
                bundle: widget.bundle.bundle,
                version: widget.bundle.version,
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<TaskValueBundleAnalyticsSummary>(
        stream: widget.repository.watchTaskValueBundleAnalyticsSummaryForPeriod(
          version: widget.bundle.version,
          period: _selectedPeriod,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const _MessageState(
              message: 'Die Bündel-Auswertung konnte nicht geladen werden.',
              isError: true,
            );
          }

          final summary = snapshot.data;
          if (summary == null) {
            return const _MessageState(
              message: 'Für dieses Bündel liegen noch keine Daten vor.',
            );
          }

          if (!summary.isAvailable) {
            return _MessageState(
              message:
                  summary.unavailableReason ??
                  'Dieses Bündel ist derzeit nicht berechenbar.',
            );
          }

          return _BundleDetailContent(
            bundle: widget.bundle,
            summary: summary,
            selectedPeriod: _selectedPeriod,
            repository: widget.repository,
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

  Future<void> _editMetadata() async {
    final nameController = TextEditingController(
      text: widget.bundle.version.name,
    );
    final descriptionController = TextEditingController(
      text: widget.bundle.version.description,
    );
    final save = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Bündel bearbeiten'),
            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Beschreibung',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Die Berechnung bleibt unverändert. Vergangene Tage '
                    'behalten ihre damalige Bezeichnung.',
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Abbrechen'),
              ),
              FilledButton(
                onPressed:
                    nameController.text.trim().isEmpty
                        ? null
                        : () => Navigator.of(context).pop(true),
                child: const Text('Speichern'),
              ),
            ],
          ),
    );
    if (save != true || !mounted) {
      nameController.dispose();
      descriptionController.dispose();
      return;
    }
    await widget.repository.updateValueBundleMetadata(
      bundleId: widget.bundle.bundle.id,
      name: nameController.text,
      description: descriptionController.text,
    );
    nameController.dispose();
    descriptionController.dispose();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}

class _BundleDetailContent extends StatelessWidget {
  const _BundleDetailContent({
    required this.bundle,
    required this.summary,
    required this.selectedPeriod,
    required this.repository,
    required this.onPeriodChanged,
  });

  final TaskValueBundleForDate bundle;
  final TaskValueBundleAnalyticsSummary summary;
  final TaskAnalyticsPeriod selectedPeriod;
  final AufgabenRepository repository;
  final ValueChanged<TaskAnalyticsPeriod> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    final display = TaskValueBundleAnalyticsDisplay.fromSummary(summary);
    final description = bundle.version.description.trim();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: [
        Text(
          bundle.version.name,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        if (description.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
        ],
        const SizedBox(height: 18),
        _PartTaskLinks(bundle: bundle, repository: repository),
        if (bundle.version.goalType != TaskGoalType.none) ...[
          const SizedBox(height: 22),
          _BundleGoalSection(version: bundle.version, repository: repository),
        ],
        const SizedBox(height: 22),
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
        const _SectionTitle(
          title: 'Verarbeitung',
          subtitle:
              'Zeigt, ob die beiden Teilwerte im gewählten Zeitraum vollständig, '
              'teilweise oder gar nicht vorhanden waren.',
        ),
        const SizedBox(height: 10),
        _MetricGrid(metrics: display.processingMetrics),
        const SizedBox(height: 22),
        const _SectionTitle(
          title: 'Werte',
          subtitle:
              'Nur vollständige und berechenbare Bündel gehen in diese Werte '
              'ein.',
        ),
        const SizedBox(height: 10),
        _MetricGrid(metrics: display.valueMetrics),
        const SizedBox(height: 22),
        const _SectionTitle(
          title: 'Tagesliste',
          subtitle:
              'Einfache Übersicht der Bündel-Ergebnisse im Zeitraum. Diagramme '
              'kommen später.',
        ),
        const SizedBox(height: 10),
        if (summary.points.isEmpty)
          const _InlineHint(
            message: 'In diesem Zeitraum gibt es keine Bündeltage.',
          )
        else
          ...summary.points.reversed.map(
            (point) => _InfoTile(
              label: _formatDate(point.scheduledDate),
              value:
                  point.bundleForDate.calculation == null
                      ? _statusLabel(point.status)
                      : _formatCalculation(point.bundleForDate.calculation!),
              infoText:
                  'Ein Bündelwert wird nur berechnet, wenn beide Teilwerte für '
                  'diesen Tag vorhanden und kompatibel sind.',
            ),
          ),
      ],
    );
  }
}

class _BundleGoalSection extends StatelessWidget {
  const _BundleGoalSection({required this.version, required this.repository});

  final TaskValueBundleVersion version;
  final AufgabenRepository repository;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TaskValueGoalEvaluationSummary>(
      stream: repository.watchTaskValueBundleGoalEvaluationSummary(
        version: version,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _InlineHint(message: 'Zielbewertung wird geladen.');
        }

        if (snapshot.hasError || snapshot.data == null) {
          return const _InlineHint(
            message: 'Die Bündel-Zielbewertung konnte nicht geladen werden.',
          );
        }

        final display = TaskValueGoalEvaluationDisplay.fromSummary(
          snapshot.data!,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _SectionTitle(
              title: 'Ziel',
              subtitle:
                  'Bewertet das Bündel über die aktuelle rollierende Zielspanne. '
                  'Nur vollständig berechenbare Bündelwerte zählen.',
            ),
            const SizedBox(height: 10),
            _MetricGrid(metrics: display.metrics),
          ],
        );
      },
    );
  }
}

class _PartTaskLinks extends StatelessWidget {
  const _PartTaskLinks({required this.bundle, required this.repository});

  final TaskValueBundleForDate bundle;
  final AufgabenRepository repository;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder:
                      (context) => TaskDetailScreen(
                        task: bundle.firstTask.task,
                        repository: repository,
                        project: bundle.firstTask.project,
                      ),
                ),
              );
            },
            icon: const Icon(Icons.open_in_new),
            label: Text(
              _roleLabel(
                bundle.version.firstRoleLabel,
                bundle.firstTask.task.name,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder:
                      (context) => TaskDetailScreen(
                        task: bundle.secondTask.task,
                        repository: repository,
                        project: bundle.secondTask.project,
                      ),
                ),
              );
            },
            icon: const Icon(Icons.open_in_new),
            label: Text(
              _roleLabel(
                bundle.version.secondRoleLabel,
                bundle.secondTask.task.name,
              ),
            ),
          ),
        ),
      ],
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

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.metrics});

  final List<TaskAnalyticsMetricDisplay> metrics;

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

  final TaskAnalyticsMetricDisplay metric;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final contentColor =
        metric.isAvailable
            ? colorScheme.onSurface
            : colorScheme.onSurfaceVariant.withValues(alpha: 0.7);
    final backgroundColor =
        !metric.isAvailable
            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.45)
            : colorScheme.surface;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color:
              !metric.isAvailable
                  ? colorScheme.outlineVariant.withValues(alpha: 0.55)
                  : colorScheme.outlineVariant,
        ),
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
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.label,
    required this.value,
    required this.infoText,
  });

  final String label;
  final String value;
  final String infoText;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Bedeutung erklären',
                icon: const Icon(Icons.info_outline),
                visualDensity: VisualDensity.compact,
                onPressed:
                    () => showDialog<void>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: Text(label),
                            content: Text(infoText),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Verstanden'),
                              ),
                            ],
                          ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InlineHint extends StatelessWidget {
  const _InlineHint({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
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

String _roleLabel(String roleLabel, String taskName) {
  return roleLabel.trim().isEmpty ? taskName : roleLabel.trim();
}

String _statusLabel(String status) {
  return switch (status) {
    TaskValueBundleDisplayStatus.empty => 'Fehlend',
    TaskValueBundleDisplayStatus.partial => 'Teilweise',
    TaskValueBundleDisplayStatus.complete => 'Vollständig',
    TaskValueBundleDisplayStatus.notCalculable => 'Nicht berechenbar',
    _ => 'Bündel',
  };
}

String _formatCalculation(TaskValueBundleCalculation calculation) {
  if (calculation.valueType == TaskValueType.duration) {
    final seconds = calculation.durationSeconds;
    if (seconds == null) {
      return 'Noch kein Ergebnis';
    }
    return _formatDuration(seconds);
  }

  final value = calculation.numberValue;
  if (value == null) {
    return 'Noch kein Ergebnis';
  }

  final formatted = value.toStringAsFixed(1).replaceAll('.', ',');
  final trimmed =
      formatted.endsWith(',0')
          ? formatted.substring(0, formatted.length - 2)
          : formatted;
  final unit = calculation.unitLabel.trim();
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

void _showMetricInfo(BuildContext context, TaskAnalyticsMetricDisplay metric) {
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
