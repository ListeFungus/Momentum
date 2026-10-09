import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:momentum/features/aufgaben/data/task_for_date.dart';
import 'package:momentum/features/aufgaben/data/task_value_type.dart';
import 'package:momentum/features/aufgaben/data/task_value_unit.dart';

class ValueTaskInput extends StatefulWidget {
  const ValueTaskInput({
    required this.task,
    required this.scheduledDate,
    required this.onSave,
    super.key,
  });

  final TaskForDate task;
  final DateTime scheduledDate;
  final ValueChanged<TaskValueInput> onSave;

  @override
  State<ValueTaskInput> createState() => _ValueTaskInputState();
}

class _ValueTaskInputState extends State<ValueTaskInput> {
  late final TextEditingController _controller;
  String? _errorText;
  late _ValueInputIdentity _lastIdentity;
  late int _dayOffset;

  @override
  void initState() {
    super.initState();
    _lastIdentity = _identityFor(widget);
    _controller = TextEditingController(text: _initialText());
    _dayOffset = widget.task.timeDayOffset;
  }

  @override
  void didUpdateWidget(covariant ValueTaskInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    final nextIdentity = _identityFor(widget);
    if (nextIdentity == _lastIdentity) {
      return;
    }

    _lastIdentity = nextIdentity;
    _controller.text = _initialText();
    _dayOffset = widget.task.timeDayOffset;
    _errorText = null;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task.task;
    final valueType = task.valueType;
    final unitLabel = _unitLabel();

    final input = TextField(
      controller: _controller,
      keyboardType:
          valueType == TaskValueType.timeOfDay
              ? TextInputType.datetime
              : const TextInputType.numberWithOptions(decimal: true),
      inputFormatters:
          valueType == TaskValueType.timeOfDay
              ? const []
              : [FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]'))],
      decoration: InputDecoration(
        labelText: _labelFor(valueType),
        suffixText: unitLabel.isEmpty ? null : unitLabel,
        errorText: _errorText,
        border: const OutlineInputBorder(),
      ),
      onSubmitted: (_) => _save(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (valueType == TaskValueType.timeOfDay) ...[
          input,
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            value: _dayOffset,
            decoration: InputDecoration(
              labelText: 'Datum der Uhrzeit',
              border: const OutlineInputBorder(),
              helperText:
                  'Das Datum zeigt, auf welchen Kalendertag sich die Uhrzeit bezieht.',
              suffixText: _formatOffsetDate(widget.scheduledDate, _dayOffset),
            ),
            items: const [
              DropdownMenuItem(value: -1, child: Text('Vortag')),
              DropdownMenuItem(value: 0, child: Text('Gleicher Tag')),
              DropdownMenuItem(value: 1, child: Text('Folgetag')),
            ],
            onChanged: (value) {
              if (value == null) {
                return;
              }
              setState(() => _dayOffset = value);
            },
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: _save,
              child: Text(
                widget.task.entryValue == null ? 'Speichern' : 'Ändern',
              ),
            ),
          ),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: input),
              const SizedBox(width: 10),
              FilledButton(
                onPressed: _save,
                child: Text(
                  widget.task.entryValue == null ? 'Speichern' : 'Ändern',
                ),
              ),
            ],
          ),
      ],
    );
  }

  void _save() {
    final parsed = _parseInput();
    if (parsed == null) {
      return;
    }

    widget.onSave(parsed);
    FocusScope.of(context).unfocus();
  }

  TaskValueInput? _parseInput() {
    final raw = _controller.text.trim();
    if (raw.isEmpty) {
      setState(() {
        _errorText = 'Bitte gib einen Wert ein.';
      });
      return null;
    }

    final valueType = widget.task.task.valueType;
    if (valueType == TaskValueType.timeOfDay) {
      final parsedTime = _parseTime(raw);
      if (parsedTime == null) {
        setState(() {
          _errorText = 'Bitte im Format HH:MM eingeben.';
        });
        return null;
      }

      setState(() {
        _errorText = null;
      });
      return TaskValueInput.time(minutes: parsedTime, dayOffset: _dayOffset);
    }

    final number = double.tryParse(raw.replaceAll(',', '.'));
    if (number == null) {
      setState(() {
        _errorText = 'Bitte gib eine gültige Zahl ein.';
      });
      return null;
    }

    setState(() {
      _errorText = null;
    });

    if (valueType == TaskValueType.duration) {
      final unit = TaskValueUnits.byKey(widget.task.task.valueUnitKey);
      final seconds = (number * (unit?.factorToBaseUnit ?? 60)).round();
      return TaskValueInput.duration(
        numberValue: number,
        durationSeconds: seconds,
      );
    }

    return TaskValueInput.number(number);
  }

  String _initialText() {
    final task = widget.task.task;
    if (task.valueType == TaskValueType.timeOfDay) {
      final minutes = widget.task.timeMinutes;
      if (minutes == null) {
        return '';
      }
      final hour = minutes ~/ 60;
      final minute = minutes % 60;
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    }

    final number = widget.task.numberValue;
    if (number == null) {
      return '';
    }

    return number.toString().replaceAll('.', ',');
  }

  String _unitLabel() {
    final task = widget.task.task;
    if (task.valueUnitKey == TaskValueUnitKey.custom) {
      return task.valueUnitLabel;
    }

    return TaskValueUnits.byKey(task.valueUnitKey)?.label ?? '';
  }

  String _labelFor(String valueType) {
    if (valueType == TaskValueType.duration) {
      return 'Dauer';
    }
    if (valueType == TaskValueType.timeOfDay) {
      return 'Uhrzeit';
    }
    return 'Wert';
  }
}

String _formatOffsetDate(DateTime scheduledDate, int dayOffset) {
  final date = _dateOnly(scheduledDate).add(Duration(days: dayOffset));
  return '${date.day.toString().padLeft(2, '0')}.'
      '${date.month.toString().padLeft(2, '0')}.';
}

class _ValueInputIdentity {
  const _ValueInputIdentity({
    required this.taskId,
    required this.scheduledDate,
    required this.entryId,
    required this.entryValueId,
    required this.valueType,
  });

  final String taskId;
  final DateTime scheduledDate;
  final String? entryId;
  final String? entryValueId;
  final String valueType;

  @override
  bool operator ==(Object other) {
    return other is _ValueInputIdentity &&
        other.taskId == taskId &&
        other.scheduledDate == scheduledDate &&
        other.entryId == entryId &&
        other.entryValueId == entryValueId &&
        other.valueType == valueType;
  }

  @override
  int get hashCode =>
      Object.hash(taskId, scheduledDate, entryId, entryValueId, valueType);
}

_ValueInputIdentity _identityFor(ValueTaskInput widget) {
  return _ValueInputIdentity(
    taskId: widget.task.task.id,
    scheduledDate: _dateOnly(widget.scheduledDate),
    entryId: widget.task.entry?.id,
    entryValueId: widget.task.entryValue?.id,
    valueType: widget.task.task.valueType,
  );
}

DateTime _dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

class TaskValueInput {
  const TaskValueInput._({
    this.numberValue,
    this.durationSeconds,
    this.timeMinutes,
    this.dayOffset = 0,
  });

  factory TaskValueInput.number(double numberValue) {
    return TaskValueInput._(numberValue: numberValue);
  }

  factory TaskValueInput.duration({
    required double numberValue,
    required int durationSeconds,
  }) {
    return TaskValueInput._(
      numberValue: numberValue,
      durationSeconds: durationSeconds,
    );
  }

  factory TaskValueInput.time({required int minutes, int dayOffset = 0}) {
    return TaskValueInput._(timeMinutes: minutes, dayOffset: dayOffset);
  }

  final double? numberValue;
  final int? durationSeconds;
  final int? timeMinutes;
  final int dayOffset;
}

int? _parseTime(String raw) {
  final parts = raw.split(':');
  if (parts.length != 2) {
    return null;
  }

  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) {
    return null;
  }
  if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
    return null;
  }

  return hour * 60 + minute;
}
