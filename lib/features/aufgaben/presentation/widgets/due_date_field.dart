import 'package:flutter/material.dart';

class DueDateField extends StatelessWidget {
  const DueDateField({
    required this.dueDate,
    required this.onChanged,
    this.enabled = true,
    this.helperText,
    super.key,
  });

  final DateTime? dueDate;
  final ValueChanged<DateTime?> onChanged;
  final bool enabled;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return DateSelectionField(
      labelText: 'Fälligkeitsdatum',
      helperText:
          helperText ??
          'Optional – bestimmt die Position unter „Dringlichkeit“.',
      selectedDate: dueDate,
      emptyText: 'Ohne Zeitdruck',
      displayText: enabled ? null : 'Keine Auswahl möglich',
      clearTooltip: 'Fälligkeitsdatum entfernen',
      pickerTooltip: 'Fälligkeitsdatum auswählen',
      enabled: enabled,
      onChanged: onChanged,
    );
  }
}

class StartDateField extends StatelessWidget {
  const StartDateField({
    required this.startDate,
    required this.onChanged,
    this.enabled = true,
    super.key,
  });

  final DateTime startDate;
  final ValueChanged<DateTime> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final today = _dateOnly(DateTime.now());
    final selectedDate = _dateOnly(startDate);
    final isToday = selectedDate == today;

    return DateSelectionField(
      labelText: 'Startdatum',
      helperText: 'Ab diesem Datum wird es angezeigt.',
      selectedDate: selectedDate,
      emptyText: 'Heute',
      clearTooltip: 'Auf Heute zurücksetzen',
      pickerTooltip: 'Startdatum auswählen',
      enabled: enabled,
      showClearButton: !isToday,
      displayText: isToday ? 'Heute' : _formatDate(selectedDate),
      onChanged: (date) => onChanged(date ?? today),
      onClear: () => onChanged(today),
    );
  }
}

class DateSelectionField extends StatelessWidget {
  const DateSelectionField({
    required this.labelText,
    required this.helperText,
    required this.selectedDate,
    required this.emptyText,
    required this.clearTooltip,
    required this.pickerTooltip,
    required this.onChanged,
    this.enabled = true,
    this.showClearButton,
    this.displayText,
    this.onClear,
    super.key,
  });

  final String labelText;
  final String helperText;
  final DateTime? selectedDate;
  final String emptyText;
  final String clearTooltip;
  final String pickerTooltip;
  final ValueChanged<DateTime?> onChanged;
  final bool enabled;
  final bool? showClearButton;
  final String? displayText;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: labelText,
        helperText: helperText,
        border: const OutlineInputBorder(),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              displayText ??
                  (selectedDate == null
                      ? emptyText
                      : _formatDate(selectedDate!)),
            ),
          ),
          if (showClearButton ?? selectedDate != null)
            IconButton(
              onPressed:
                  enabled
                      ? () {
                        if (onClear != null) {
                          onClear!();
                        } else {
                          onChanged(null);
                        }
                      }
                      : null,
              tooltip: clearTooltip,
              icon: const Icon(Icons.close),
            ),
          IconButton(
            onPressed:
                enabled
                    ? () async {
                      final now = DateTime.now();
                      final selected = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? now,
                        firstDate: DateTime(now.year - 1),
                        lastDate: DateTime(now.year + 10),
                      );

                      if (selected != null) {
                        onChanged(selected);
                      }
                    }
                    : null,
            tooltip: pickerTooltip,
            icon: const Icon(Icons.calendar_today_outlined),
          ),
        ],
      ),
    );
  }
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}.'
      '${date.month.toString().padLeft(2, '0')}.'
      '${date.year}';
}
