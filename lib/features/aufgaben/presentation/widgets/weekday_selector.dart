import 'package:flutter/material.dart';

class WeekdaySelector extends StatelessWidget {
  const WeekdaySelector({
    required this.selectedWeekdays,
    required this.onChanged,
    this.enabled = true,
    super.key,
  });

  final Set<int> selectedWeekdays;
  final ValueChanged<Set<int>> onChanged;
  final bool enabled;

  static const _weekdays = {
    1: 'Mo',
    2: 'Di',
    3: 'Mi',
    4: 'Do',
    5: 'Fr',
    6: 'Sa',
    7: 'So',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bestimmte Tage',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          'Die Aufgabe wird nur an diesen Wochentagen angezeigt.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              _weekdays.entries.map((weekday) {
                final isSelected = selectedWeekdays.contains(weekday.key);

                return FilterChip(
                  label: Text(weekday.value),
                  selected: isSelected,
                  onSelected:
                      enabled
                          ? (selected) {
                            final updatedWeekdays = {...selectedWeekdays};

                            if (selected) {
                              updatedWeekdays.add(weekday.key);
                            } else if (updatedWeekdays.length > 1) {
                              updatedWeekdays.remove(weekday.key);
                            }

                            onChanged(updatedWeekdays);
                          }
                          : null,
                );
              }).toList(),
        ),
      ],
    );
  }
}
