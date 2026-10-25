import 'calendar_planning.dart';

DateTime calendarDay(DateTime value) =>
    DateTime(value.year, value.month, value.day);
DateTime calendarAddDays(DateTime value, int days) =>
    DateTime(value.year, value.month, value.day + days);

/// Injectable wall-time resolver. Both endpoints must have exactly one instant.
class CalendarClock {
  CalendarClock({
    DateTime Function()? now,
    bool Function(DateTime, int)? uniqueMinute,
  }) : now = now ?? DateTime.now,
       uniqueMinute = uniqueMinute ?? _uniqueLocalMinute;
  final DateTime Function() now;
  final bool Function(DateTime, int) uniqueMinute;

  bool accepts(DateTime day, CalendarPlanning planning) {
    planning.validate();
    final start = planning.startMinute;
    return start == null ||
        (uniqueMinute(day, start) &&
            uniqueMinute(day, start + planning.durationMinutes!));
  }

  void validate(DateTime day, CalendarPlanning planning) {
    if (!accepts(day, planning)) {
      throw StateError(
        'Diese Uhrzeit ist durch die Zeitumstellung nicht eindeutig oder existiert nicht. Bitte eine andere Uhrzeit wählen.',
      );
    }
  }
}

bool _uniqueLocalMinute(DateTime day, int minute) {
  final local = DateTime(
    day.year,
    day.month,
    day.day,
    minute ~/ 60,
    minute % 60,
  );
  final expected = DateTime.utc(
    day.year,
    day.month,
    day.day,
    minute ~/ 60,
    minute % 60,
  );
  bool matches(DateTime value) =>
      value.year == expected.year &&
      value.month == expected.month &&
      value.day == expected.day &&
      value.hour == expected.hour &&
      value.minute == expected.minute;
  if (!matches(local)) return false;
  // Search both sides of the selected instant for an ambiguous repeated minute.
  for (var offset = -180; offset <= 180; offset++) {
    if (offset != 0 && matches(local.add(Duration(minutes: offset)))) {
      return false;
    }
  }
  return true;
}
