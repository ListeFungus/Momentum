import 'dart:convert';

/// Local wall-clock planning, deliberately independent of captured values.
class CalendarPlanning {
  const CalendarPlanning({this.startMinute, this.durationMinutes});

  final int? startMinute;
  final int? durationMinutes;

  void validate() {
    final start = startMinute;
    final duration = durationMinutes;
    if (duration != null && (duration < 1 || duration > 1440)) {
      throw ArgumentError(
        'Die geplante Dauer muss 1 bis 1440 Minuten betragen.',
      );
    }
    if (start != null &&
        (start < 0 ||
            start > 1439 ||
            duration == null ||
            start + duration > 1440)) {
      throw ArgumentError(
        'Start und Ende müssen innerhalb desselben Tages liegen.',
      );
    }
  }

  String encode() {
    validate();
    return jsonEncode({
      'plannedStartMinute': startMinute,
      'plannedDurationMinutes': durationMinutes,
    });
  }

  factory CalendarPlanning.decode(String json) {
    final value = jsonDecode(json);
    if (value is! Map<String, dynamic> ||
        value.length != 2 ||
        !value.containsKey('plannedStartMinute') ||
        !value.containsKey('plannedDurationMinutes')) {
      throw const FormatException('Ungültige Kalenderänderung.');
    }
    final result = CalendarPlanning(
      startMinute: value['plannedStartMinute'] as int?,
      durationMinutes: value['plannedDurationMinutes'] as int?,
    );
    result.validate();
    return result;
  }
}
