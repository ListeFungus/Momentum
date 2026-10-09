import 'package:flutter/material.dart';
import 'package:momentum/features/aufgaben/data/task_for_date.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle_calculation.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle_for_date.dart';
import 'package:momentum/features/aufgaben/data/task_value_type.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/card_metric_chip.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_modes/value_task_input.dart';

class TaskValueBundleCard extends StatelessWidget {
  const TaskValueBundleCard({
    required this.bundle,
    required this.scheduledDate,
    required this.onValueSaved,
    required this.onOpenDetails,
    required this.onConfigureCardMetric,
    required this.onDissolve,
    required this.onDelete,
    super.key,
  });

  final TaskValueBundleForDate bundle;
  final DateTime scheduledDate;
  final void Function(TaskForDate task, TaskValueInput value) onValueSaved;
  final VoidCallback onOpenDetails;
  final VoidCallback onConfigureCardMetric;
  final VoidCallback onDissolve;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.34),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bundle.version.name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _statusLabel(bundle.status),
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                        if (bundle.cardMetrics.isNotEmpty ||
                            bundle.cardMetric != null) ...[
                          const SizedBox(height: 8),
                          ...(bundle.cardMetrics.isNotEmpty
                                  ? bundle.cardMetrics
                                  : [bundle.cardMetric!])
                              .map(
                                (metric) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: CardMetricChip(metric: metric),
                                ),
                              ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Bündel-Auswertung öffnen',
                    icon: const Icon(Icons.insights_outlined),
                    onPressed: onOpenDetails,
                  ),
                  PopupMenuButton<_BundleAction>(
                    tooltip: 'Bündeloptionen',
                    onSelected: (action) {
                      switch (action) {
                        case _BundleAction.cardMetric:
                          onConfigureCardMetric();
                        case _BundleAction.dissolve:
                          onDissolve();
                        case _BundleAction.delete:
                          onDelete();
                      }
                    },
                    itemBuilder:
                        (context) => const [
                          PopupMenuItem(
                            value: _BundleAction.cardMetric,
                            child: Row(
                              children: [
                                Icon(Icons.dashboard_customize_outlined),
                                SizedBox(width: 12),
                                Text('Kartenanzeige'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: _BundleAction.delete,
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline),
                                SizedBox(width: 12),
                                Text('In Papierkorb'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: _BundleAction.dissolve,
                            child: Row(
                              children: [
                                Icon(Icons.link_off_outlined),
                                SizedBox(width: 12),
                                Text('Bündel auflösen'),
                              ],
                            ),
                          ),
                        ],
                  ),
                ],
              ),
              if (bundle.version.description.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  bundle.version.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 14),
              _BundlePartInput(
                label: bundle.version.firstRoleLabel,
                task: bundle.firstTask,
                scheduledDate: scheduledDate,
                onValueSaved: onValueSaved,
              ),
              const SizedBox(height: 14),
              _BundlePartInput(
                label: bundle.version.secondRoleLabel,
                task: bundle.secondTask,
                scheduledDate: scheduledDate,
                onValueSaved: onValueSaved,
              ),
              const SizedBox(height: 14),
              _DerivedValueBox(bundle: bundle),
            ],
          ),
        ),
      ),
    );
  }
}

class _BundlePartInput extends StatelessWidget {
  const _BundlePartInput({
    required this.label,
    required this.task,
    required this.scheduledDate,
    required this.onValueSaved,
  });

  final String label;
  final TaskForDate task;
  final DateTime scheduledDate;
  final void Function(TaskForDate task, TaskValueInput value) onValueSaved;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.isEmpty ? task.task.name : label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        ValueTaskInput(
          task: task,
          scheduledDate: scheduledDate,
          onSave: (value) => onValueSaved(task, value),
        ),
      ],
    );
  }
}

class _DerivedValueBox extends StatelessWidget {
  const _DerivedValueBox({required this.bundle});

  final TaskValueBundleForDate bundle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final label =
        bundle.version.resultLabel.trim().isEmpty
            ? 'Ergebnis'
            : bundle.version.resultLabel.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            _formatCalculation(bundle),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

String _statusLabel(String status) {
  return switch (status) {
    TaskValueBundleDisplayStatus.empty => 'Noch keine Werte erfasst',
    TaskValueBundleDisplayStatus.partial => 'Teilweise erfasst',
    TaskValueBundleDisplayStatus.complete => 'Vollständig erfasst',
    TaskValueBundleDisplayStatus.notCalculable => 'Nicht berechenbar',
    _ => 'Bündel',
  };
}

String _formatCalculation(TaskValueBundleForDate bundle) {
  final calculation = bundle.calculation;

  if (calculation == null) {
    return bundle.isPartial ? 'Zweiter Wert fehlt noch' : 'Noch kein Ergebnis';
  }

  if (calculation.valueType == TaskValueType.duration) {
    final seconds = calculation.durationSeconds;

    if (seconds == null) {
      return 'Noch kein Ergebnis';
    }

    final absoluteSeconds = seconds.abs();
    final hours = absoluteSeconds ~/ 3600;
    final minutes = (absoluteSeconds % 3600) ~/ 60;
    final prefix = seconds < 0 ? '−' : '';

    if (hours == 0) {
      return '$prefix$minutes min';
    }

    return '$prefix$hours h ${minutes.toString().padLeft(2, '0')} min';
  }

  final value = calculation.numberValue;

  if (value == null) {
    return 'Noch kein Ergebnis';
  }

  final formatted =
      value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(1);
  final unit = calculation.unitLabel.trim();

  return unit.isEmpty ? formatted : '$formatted $unit';
}

enum _BundleAction { cardMetric, dissolve, delete }
