import 'package:momentum/core/database/app_database.dart';
import 'task_value_unit.dart';

/// Shared parsing for individual fields and atomic group submissions.
class TaskValueDraft {
  const TaskValueDraft(this.text, {this.dayOffset = 0});
  final String text;
  final int dayOffset;
  ParsedTaskValue parse(Aufgabe task) {
    final raw = text.trim();
    if (raw.isEmpty) throw const FormatException('Bitte gib einen Wert ein.');
    if (task.valueType == 'time_of_day') {
      final parts = raw.split(':');
      final h = parts.length == 2 ? int.tryParse(parts[0]) : null;
      final m = parts.length == 2 ? int.tryParse(parts[1]) : null;
      if (h == null ||
          m == null ||
          h < 0 ||
          h > 23 ||
          m < 0 ||
          m > 59 ||
          dayOffset < -1 ||
          dayOffset > 1) {
        throw const FormatException('Bitte im Format HH:MM eingeben.');
      }
      return ParsedTaskValue(timeMinutes: h * 60 + m, dayOffset: dayOffset);
    }
    final n = double.tryParse(raw.replaceAll(',', '.'));
    if (n == null || !n.isFinite || n < 0) {
      throw const FormatException(
        'Bitte gib eine gültige, nicht negative Zahl ein.',
      );
    }
    if (task.valueType == 'duration') {
      final seconds =
          n * (TaskValueUnits.byKey(task.valueUnitKey)?.factorToBaseUnit ?? 60);
      if (!seconds.isFinite || seconds > 9007199254740991) {
        throw const FormatException('Die Dauer ist zu groß.');
      }
      return ParsedTaskValue(numberValue: n, durationSeconds: seconds.round());
    }
    if (task.valueType != 'number') {
      throw const FormatException('Unbekannter Werttyp.');
    }
    return ParsedTaskValue(numberValue: n);
  }
}

class ParsedTaskValue {
  const ParsedTaskValue({
    this.numberValue,
    this.durationSeconds,
    this.timeMinutes,
    this.dayOffset = 0,
  });
  final double? numberValue;
  final int? durationSeconds, timeMinutes;
  final int dayOffset;
}
