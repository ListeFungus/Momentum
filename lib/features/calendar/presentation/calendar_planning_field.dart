import 'package:flutter/material.dart';
import '../data/calendar_planning.dart';

String calendarTime(int minute) =>
    '${(minute ~/ 60).toString().padLeft(2, '0')}:${(minute % 60).toString().padLeft(2, '0')}';

class CalendarPlanningField extends StatelessWidget {
  const CalendarPlanningField({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.recurring = false,
  });
  final CalendarPlanning value;
  final ValueChanged<CalendarPlanning> onChanged;
  final bool enabled;
  final bool recurring;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      OutlinedButton.icon(
        onPressed:
            !enabled
                ? null
                : () async {
                  final result = await showCalendarPlanningDialog(
                    context,
                    value,
                  );
                  if (result != null) onChanged(result);
                },
        icon: const Icon(Icons.schedule),
        label: Text(
          value.durationMinutes == null
              ? 'Zeitplanung (optional)'
              : value.startMinute == null
              ? '${value.durationMinutes} Minuten · ohne Uhrzeit'
              : '${calendarTime(value.startMinute!)}–${calendarTime(value.startMinute! + value.durationMinutes!)}',
        ),
      ),
      Text(
        recurring
            ? 'Serienänderungen gelten ab morgen. Keine Änderung früherer Einträge.'
            : 'Geplante Zeit, unabhängig von erfassten Messwerten. Keine automatische Platzierung.',
      ),
    ],
  );
}

Future<CalendarPlanning?> showCalendarPlanningDialog(
  BuildContext context,
  CalendarPlanning value,
) async {
  final start = TextEditingController(
    text: value.startMinute == null ? '' : calendarTime(value.startMinute!),
  );
  final duration = TextEditingController(
    text: value.durationMinutes?.toString() ?? '',
  );
  final end = TextEditingController();
  String? error;
  final result = await showDialog<CalendarPlanning>(
    context: context,
    builder:
        (context) => StatefulBuilder(
          builder:
              (context, setState) => AlertDialog(
                title: const Text('Zeitplanung'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: start,
                        decoration: const InputDecoration(
                          labelText: 'Start HH:MM (optional)',
                        ),
                      ),
                      TextField(
                        controller: duration,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Dauer in Minuten',
                        ),
                      ),
                      TextField(
                        controller: end,
                        decoration: const InputDecoration(
                          labelText: 'Oder Ende HH:MM (bis 24:00)',
                        ),
                      ),
                      const Text(
                        'Ohne Start wird nur die Dauer gespeichert. Kein Termin über Mitternacht.',
                      ),
                      if (error != null)
                        Text(
                          error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Abbrechen'),
                  ),
                  TextButton(
                    onPressed:
                        () => Navigator.pop(context, const CalendarPlanning()),
                    child: const Text('Entfernen'),
                  ),
                  FilledButton(
                    onPressed: () {
                      try {
                        int parseTime(String text) {
                          final match = RegExp(
                            r'^(\d{1,2}):(\d{2})$',
                          ).firstMatch(text.trim());
                          if (match == null) {
                            throw const FormatException(
                              'Uhrzeit bitte als HH:MM eingeben.',
                            );
                          }
                          final hour = int.parse(match[1]!);
                          final minute = int.parse(match[2]!);
                          if (minute > 59 ||
                              hour > 24 ||
                              (hour == 24 && minute != 0)) {
                            throw const FormatException('Ungültige Uhrzeit.');
                          }
                          return hour * 60 + minute;
                        }

                        final s =
                            start.text.trim().isEmpty
                                ? null
                                : parseTime(start.text);
                        final d =
                            end.text.trim().isNotEmpty
                                ? (s == null
                                    ? throw const FormatException(
                                      'Für ein Ende ist ein Start erforderlich.',
                                    )
                                    : parseTime(end.text) - s)
                                : duration.text.trim().isEmpty
                                ? null
                                : int.parse(duration.text.trim());
                        final planning = CalendarPlanning(
                          startMinute: s,
                          durationMinutes: d,
                        )..validate();
                        Navigator.pop(context, planning);
                      } catch (e) {
                        setState(() => error = e.toString());
                      }
                    },
                    child: const Text('Übernehmen'),
                  ),
                ],
              ),
        ),
  );
  // Disposal after the route transition avoids controllers used during teardown.
  await Future<void>.delayed(const Duration(milliseconds: 300));
  start.dispose();
  duration.dispose();
  end.dispose();
  return result;
}
