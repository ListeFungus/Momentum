import 'package:flutter/material.dart';

class CheckboxTaskInput extends StatelessWidget {
  const CheckboxTaskInput({
    required this.isCompleted,
    required this.onChanged,
    this.accentColor,
    super.key,
  });

  final bool isCompleted;
  final ValueChanged<bool> onChanged;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => onChanged(!isCompleted),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: isCompleted,
              activeColor: accentColor,
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                }
              },
            ),
            Text(
              isCompleted ? 'Erledigt' : 'Als erledigt markieren',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:
                    isCompleted
                        ? accentColor ?? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
