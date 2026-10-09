import 'package:flutter/material.dart';
import 'package:momentum/core/theme/hex_color.dart';
import 'package:momentum/features/aufgaben/data/task_for_date.dart';
import 'package:momentum/features/aufgaben/data/task_capture_mode.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/card_metric_chip.dart';
import 'package:momentum/features/aufgaben/data/task_types.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_modes/boolean_habit_input.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_modes/checkbox_task_input.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_modes/value_task_input.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    required this.task,
    required this.scheduledDate,
    required this.onCompletedChanged,
    required this.onBooleanValueChanged,
    required this.onValueSaved,
    required this.onEditNote,
    required this.onOpenDetails,
    required this.onEdit,
    required this.onDelete,
    required this.onConfigureCardMetric,
    this.onCreateBundle,
    this.onOpenLinkedBundleDetails,
    this.onPause,
    this.metaLabel,
    super.key,
  });

  final TaskForDate task;
  final DateTime scheduledDate;
  final ValueChanged<bool> onCompletedChanged;
  final ValueChanged<bool?> onBooleanValueChanged;
  final ValueChanged<TaskValueInput> onValueSaved;
  final VoidCallback onEditNote;
  final VoidCallback onOpenDetails;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onConfigureCardMetric;
  final VoidCallback? onCreateBundle;
  final VoidCallback? onOpenLinkedBundleDetails;
  final VoidCallback? onPause;
  final String? metaLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasDescription = task.task.beschreibung.trim().isNotEmpty;
    final hasQuestion = task.task.questionText.trim().isNotEmpty;
    final projectColor =
        task.project == null ? null : colorFromHex(task.project!.colorHex);
    final cardColor =
        projectColor == null
            ? colorScheme.surface
            : Color.alphaBlend(
              projectColor.withValues(alpha: 0.09),
              colorScheme.surface,
            );

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                projectColor?.withValues(alpha: 0.38) ??
                colorScheme.outlineVariant.withValues(alpha: 0.7),
          ),
          boxShadow: [
            BoxShadow(
              color: (projectColor ?? colorScheme.shadow).withValues(
                alpha: projectColor == null ? 0.06 : 0.12,
              ),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (projectColor != null)
                SizedBox(width: 6, child: ColoredBox(color: projectColor)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              task.task.name,
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (metaLabel != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              metaLabel!,
                              style: Theme.of(
                                context,
                              ).textTheme.labelMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                          const SizedBox(width: 8),
                          PopupMenuButton<_TaskAction>(
                            tooltip: 'Aufgabenoptionen',
                            onSelected: (action) {
                              switch (action) {
                                case _TaskAction.details:
                                  onOpenDetails();
                                case _TaskAction.edit:
                                  onEdit();
                                case _TaskAction.cardMetric:
                                  onConfigureCardMetric();
                                case _TaskAction.bundle:
                                  onCreateBundle?.call();
                                case _TaskAction.bundleDetails:
                                  onOpenLinkedBundleDetails?.call();
                                case _TaskAction.pause:
                                  onPause?.call();
                                case _TaskAction.delete:
                                  onDelete();
                              }
                            },
                            itemBuilder:
                                (context) => [
                                  const PopupMenuItem(
                                    value: _TaskAction.details,
                                    child: Row(
                                      children: [
                                        Icon(Icons.insights_outlined),
                                        SizedBox(width: 12),
                                        Text('Details & Auswertung'),
                                      ],
                                    ),
                                  ),
                                  if (onCreateBundle != null)
                                    const PopupMenuItem(
                                      value: _TaskAction.bundle,
                                      child: Row(
                                        children: [
                                          Icon(Icons.add_link_outlined),
                                          SizedBox(width: 12),
                                          Text('Bündeln'),
                                        ],
                                      ),
                                    ),
                                  if (onOpenLinkedBundleDetails != null)
                                    const PopupMenuItem(
                                      value: _TaskAction.bundleDetails,
                                      child: Row(
                                        children: [
                                          Icon(Icons.insights_outlined),
                                          SizedBox(width: 12),
                                          Text('Bündel-Auswertung'),
                                        ],
                                      ),
                                    ),
                                  const PopupMenuItem(
                                    value: _TaskAction.cardMetric,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.dashboard_customize_outlined,
                                        ),
                                        SizedBox(width: 12),
                                        Text('Kartenanzeige'),
                                      ],
                                    ),
                                  ),
                                  if (onPause != null)
                                    const PopupMenuItem(
                                      value: _TaskAction.pause,
                                      child: Row(
                                        children: [
                                          Icon(Icons.pause_circle_outline),
                                          SizedBox(width: 12),
                                          Text('Planung pausieren'),
                                        ],
                                      ),
                                    ),
                                  const PopupMenuItem(
                                    value: _TaskAction.edit,
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit_outlined),
                                        SizedBox(width: 12),
                                        Text('Aufgabe bearbeiten'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: _TaskAction.delete,
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete_outline),
                                        SizedBox(width: 12),
                                        Text('In Papierkorb'),
                                      ],
                                    ),
                                  ),
                                ],
                            icon: const Icon(Icons.more_vert),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      if (hasDescription) ...[
                        const SizedBox(height: 8),
                        Text(
                          task.task.beschreibung,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.45,
                          ),
                        ),
                      ],
                      if (hasQuestion) ...[
                        const SizedBox(height: 8),
                        Text(
                          task.task.questionText,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      if (task.linkedValueBundle != null) ...[
                        const SizedBox(height: 10),
                        _LinkedBundleHint(
                          label:
                              'Teil von ${task.linkedValueBundle!.version.name}',
                        ),
                      ],
                      if (task.cardMetrics.isNotEmpty ||
                          task.cardMetric != null) ...[
                        const SizedBox(height: 10),
                        ...(task.cardMetrics.isNotEmpty
                                ? task.cardMetrics
                                : [task.cardMetric!])
                            .map(
                              (metric) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: CardMetricChip(metric: metric),
                              ),
                            ),
                      ],
                      if (task.task.erfassungsmodus ==
                          TaskCaptureMode.value) ...[
                        const SizedBox(height: 14),
                        ValueTaskInput(
                          task: task,
                          scheduledDate: scheduledDate,
                          onSave: onValueSaved,
                        ),
                      ] else if (task.task.erfassungsmodus == 'three_state' ||
                          task.task.taskType == TaskTypes.habit &&
                              task.task.erfassungsmodus == 'checkbox') ...[
                        const SizedBox(height: 14),
                        BooleanHabitInput(
                          value: task.booleanValue,
                          successValue: task.task.successValue,
                          accentColor: projectColor,
                          hasNote: task.note.isNotEmpty,
                          onChanged: onBooleanValueChanged,
                          onEditNote: onEditNote,
                        ),
                      ] else if (task.task.erfassungsmodus == 'checkbox') ...[
                        const SizedBox(height: 14),
                        CheckboxTaskInput(
                          isCompleted: task.isCompleted,
                          accentColor: projectColor,
                          onChanged: onCompletedChanged,
                        ),
                      ],
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

class _LinkedBundleHint extends StatelessWidget {
  const _LinkedBundleHint({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.link_outlined,
              size: 16,
              color: colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _TaskAction {
  details,
  cardMetric,
  bundle,
  bundleDetails,
  edit,
  pause,
  delete,
}
