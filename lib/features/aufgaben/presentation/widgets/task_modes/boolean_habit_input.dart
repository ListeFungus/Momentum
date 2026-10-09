import 'package:flutter/material.dart';

enum BooleanHabitSelection { no, yes }

class BooleanHabitInput extends StatelessWidget {
  const BooleanHabitInput({
    required this.value,
    required this.successValue,
    required this.onChanged,
    required this.onEditNote,
    required this.hasNote,
    this.accentColor,
    super.key,
  });

  final bool? value;
  final bool successValue;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onEditNote;
  final bool hasNote;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final selection =
        value == null
            ? <BooleanHabitSelection>{}
            : {value! ? BooleanHabitSelection.yes : BooleanHabitSelection.no};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<BooleanHabitSelection>(
            segments: const [
              ButtonSegment(
                value: BooleanHabitSelection.no,
                label: Text('Nein'),
                icon: Icon(Icons.close, size: 18),
              ),
              ButtonSegment(
                value: BooleanHabitSelection.yes,
                label: Text('Ja'),
                icon: Icon(Icons.check, size: 18),
              ),
            ],
            selected: selection,
            emptySelectionAllowed: true,
            showSelectedIcon: false,
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
              backgroundColor:
                  accentColor == null
                      ? null
                      : WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return accentColor!.withValues(alpha: 0.22);
                        }
                        return null;
                      }),
            ),
            onSelectionChanged: (selected) {
              if (selected.isEmpty) {
                onChanged(null);
                return;
              }

              onChanged(switch (selected.single) {
                BooleanHabitSelection.no => false,
                BooleanHabitSelection.yes => true,
              });
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                _statusText(value, successValue),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: onEditNote,
              icon: Icon(
                hasNote ? Icons.sticky_note_2 : Icons.note_add_outlined,
                size: 18,
              ),
              label: Text(hasNote ? 'Notiz bearbeiten' : 'Notiz'),
            ),
          ],
        ),
      ],
    );
  }
}

String _statusText(bool? value, bool successValue) {
  if (value == null) {
    return 'Noch offen';
  }

  return value == successValue ? 'Als Erfolg gewertet' : 'Nicht erfolgreich';
}
