import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:momentum/features/aufgaben/data/habit_recurrence.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/month_day_selector.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/weekday_selector.dart';

class HabitRhythmField extends StatefulWidget {
  const HabitRhythmField({
    required this.recurrence,
    required this.selectedDays,
    required this.onRecurrenceChanged,
    required this.onDaysChanged,
    this.enabled = true,
    this.includeNone = false,
    super.key,
  });

  final String recurrence;
  final Set<int> selectedDays;
  final ValueChanged<String> onRecurrenceChanged;
  final ValueChanged<Set<int>> onDaysChanged;
  final bool enabled;
  final bool includeNone;

  @override
  State<HabitRhythmField> createState() => _HabitRhythmFieldState();
}

class _HabitRhythmFieldState extends State<HabitRhythmField> {
  late final TextEditingController _customDaysController;

  @override
  void initState() {
    super.initState();
    _customDaysController = TextEditingController(
      text:
          HabitRecurrence.isCustomAfterCompletion(widget.recurrence)
              ? HabitRecurrence.customAfterCompletionDays(
                widget.recurrence,
              ).toString()
              : '7',
    );
  }

  @override
  void dispose() {
    _customDaysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mainRhythm = _mainRhythmValue(widget.recurrence);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          value: mainRhythm,
          decoration: InputDecoration(
            labelText: 'Rhythmus',
            helperText:
                widget.includeNone
                    ? 'Rhythmus bestimmt, ob und wann es wiederholt angezeigt wird.'
                    : 'Rhythmus bestimmt, wann es angezeigt wird.',
            border: const OutlineInputBorder(),
          ),
          items: [
            if (widget.includeNone)
              const DropdownMenuItem(
                value: HabitRecurrence.none,
                child: Text('Kein / Einmalig'),
              ),
            const DropdownMenuItem(
              value: HabitRecurrence.daily,
              child: Text('Täglich'),
            ),
            const DropdownMenuItem(
              value: HabitRecurrence.weeklyFixedDays,
              child: Text('Wöchentlich'),
            ),
            const DropdownMenuItem(
              value: HabitRecurrence.monthlyFixedDays,
              child: Text('Monatlich'),
            ),
            const DropdownMenuItem(
              value: _customRhythmValue,
              child: Text('Benutzerdefiniert'),
            ),
          ],
          onChanged:
              widget.enabled
                  ? (value) {
                    if (value == null) {
                      return;
                    }

                    widget.onRecurrenceChanged(_defaultRecurrenceFor(value));
                  }
                  : null,
        ),
        if (widget.recurrence == HabitRecurrence.none) ...[
          const SizedBox(height: 8),
          _HelperText(
            text:
                'Ohne Wiederholung erscheint die Aufgabe über ihr Fälligkeitsdatum oder in „Ohne Zeitdruck“.',
          ),
        ],
        if (widget.recurrence == HabitRecurrence.daily) ...[
          const SizedBox(height: 8),
          _HelperText(
            text:
                'Tageswechsel aktuell um 00:00 Uhr. Später in den allgemeinen Einstellungen änderbar.',
          ),
        ],
        if (_isWeekly(widget.recurrence)) ...[
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: widget.recurrence,
            decoration: const InputDecoration(
              labelText: 'Wochenrhythmus',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: HabitRecurrence.weeklyFixedDays,
                child: Text('Bestimmte Tage'),
              ),
              DropdownMenuItem(
                value: HabitRecurrence.weeklyAfterCompletion,
                child: Text('Alle 7 Tage nach Erledigung'),
              ),
            ],
            onChanged:
                widget.enabled
                    ? (value) {
                      if (value != null) {
                        widget.onRecurrenceChanged(value);
                      }
                    }
                    : null,
          ),
        ],
        if (widget.recurrence == HabitRecurrence.weeklyFixedDays) ...[
          const SizedBox(height: 20),
          WeekdaySelector(
            selectedWeekdays: widget.selectedDays,
            enabled: widget.enabled,
            onChanged: widget.onDaysChanged,
          ),
        ],
        if (widget.recurrence == HabitRecurrence.weeklyAfterCompletion) ...[
          const SizedBox(height: 8),
          const _HelperText(
            text:
                'Nach erfolgreicher Antwort wird es nach 7 Tagen wieder angezeigt.',
          ),
        ],
        if (widget.recurrence == HabitRecurrence.monthlyFixedDays) ...[
          const SizedBox(height: 20),
          MonthDaySelector(
            selectedMonthDays: widget.selectedDays,
            enabled: widget.enabled,
            onChanged: widget.onDaysChanged,
          ),
        ],
        if (HabitRecurrence.isCustomAfterCompletion(widget.recurrence)) ...[
          const SizedBox(height: 20),
          TextFormField(
            controller: _customDaysController,
            enabled: widget.enabled,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Tage nach Erledigung',
              helperText:
                  'Nach erfolgreicher Antwort wird es nach X Tagen wieder angezeigt.',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              final days = int.tryParse(value);

              if (days == null || days < 1) {
                return;
              }

              widget.onRecurrenceChanged(
                HabitRecurrence.customAfterCompletion(days),
              );
            },
          ),
        ],
      ],
    );
  }

  static const _customRhythmValue = 'custom';

  String _mainRhythmValue(String recurrence) {
    if (_isWeekly(recurrence)) {
      return HabitRecurrence.weeklyFixedDays;
    }

    if (HabitRecurrence.isCustomAfterCompletion(recurrence)) {
      return _customRhythmValue;
    }

    return recurrence;
  }

  String _defaultRecurrenceFor(String rhythm) {
    if (rhythm == _customRhythmValue) {
      final days = int.tryParse(_customDaysController.text) ?? 7;
      return HabitRecurrence.customAfterCompletion(days < 1 ? 7 : days);
    }

    return rhythm;
  }

  bool _isWeekly(String recurrence) {
    return recurrence == HabitRecurrence.weeklyFixedDays ||
        recurrence == HabitRecurrence.weeklyAfterCompletion;
  }
}

class _HelperText extends StatelessWidget {
  const _HelperText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
