import 'package:flutter/material.dart';
import 'package:momentum/features/aufgaben/data/task_card_metric.dart';

class CardMetricChip extends StatelessWidget {
  const CardMetricChip({required this.metric, super.key});

  final TaskCardMetric metric;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final colors = _metricColors(colorScheme, metric.tone);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.foreground.withValues(alpha: 0.22)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 6,
              runSpacing: 2,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  metric.label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.foreground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  metric.value,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colors.foreground,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            if (metric.detail != null) ...[
              const SizedBox(height: 3),
              Text(
                metric.detail!,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.foreground.withValues(alpha: 0.82),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

_MetricColors _metricColors(ColorScheme colorScheme, String tone) {
  return switch (tone) {
    TaskCardMetricTone.good => _MetricColors(
      background: colorScheme.primaryContainer.withValues(alpha: 0.58),
      foreground: colorScheme.onPrimaryContainer,
    ),
    TaskCardMetricTone.warning => _MetricColors(
      background: colorScheme.tertiaryContainer.withValues(alpha: 0.64),
      foreground: colorScheme.onTertiaryContainer,
    ),
    TaskCardMetricTone.bad => _MetricColors(
      background: colorScheme.errorContainer.withValues(alpha: 0.58),
      foreground: colorScheme.onErrorContainer,
    ),
    _ => _MetricColors(
      background: colorScheme.surfaceContainerHighest.withValues(alpha: 0.76),
      foreground: colorScheme.onSurfaceVariant,
    ),
  };
}

class _MetricColors {
  const _MetricColors({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}
