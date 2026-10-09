import 'package:flutter/material.dart';

class MonthDaySelector extends StatelessWidget {
  const MonthDaySelector({
    required this.selectedMonthDays,
    required this.onChanged,
    this.enabled = true,
    super.key,
  });

  static const lastDayOfMonth = 32;

  final Set<int> selectedMonthDays;
  final ValueChanged<Set<int>> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Feste Tage im Monat',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          '30 und 31 werden über „Letzter Tag“ abgedeckt, damit jeder Monat sauber funktioniert.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 7,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (var day = 1; day <= 29; day++)
              _MonthDayTile(
                label: '$day',
                selected: selectedMonthDays.contains(day),
                enabled: enabled,
                onTap: () => _toggleDay(day),
              ),
          ],
        ),
        const SizedBox(height: 8),
        FilterChip(
          label: const Text('Letzter Tag im Monat'),
          selected: selectedMonthDays.contains(lastDayOfMonth),
          onSelected: enabled ? (_) => _toggleDay(lastDayOfMonth) : null,
        ),
      ],
    );
  }

  void _toggleDay(int day) {
    final updatedDays = {...selectedMonthDays};

    if (updatedDays.contains(day)) {
      if (updatedDays.length > 1) {
        updatedDays.remove(day);
      }
    } else {
      updatedDays.add(day);
    }

    onChanged(updatedDays);
  }
}

class _MonthDayTile extends StatelessWidget {
  const _MonthDayTile({
    required this.label,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected ? colorScheme.primaryContainer : colorScheme.surface,
          border: Border.all(
            color: selected ? colorScheme.primary : colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color:
                  selected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurface,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
