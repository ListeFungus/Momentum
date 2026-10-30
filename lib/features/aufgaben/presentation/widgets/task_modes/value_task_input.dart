import 'package:flutter/material.dart';
import 'dart:async';
import '../../../data/task_value_draft.dart';
import '../value_draft_scope.dart';
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
  final FutureOr<void> Function(TaskValueInput) onSave;

  @override
  State<ValueTaskInput> createState() => _ValueTaskInputState();
}

class _ValueTaskInputState extends State<ValueTaskInput>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late final TextEditingController _controller;
  String? _errorText;
  late _ValueInputIdentity _lastIdentity;
  late int _dayOffset;
  ValueDraftStore? _store;
  bool _saving = false;
  String get _key =>
      '${widget.task.task.id}:${_dateOnly(widget.scheduledDate).toIso8601String()}';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final store = ValueDraftScope.maybeOf(context);
    if (_store != store) {
      _store?.removeListener(_storeChanged);
      _store = store;
      _store?.addListener(_storeChanged);
    }
    final draft = _store?.drafts[_key];
    if (draft != null) {
      _controller.text = draft.text;
      _dayOffset = draft.dayOffset;
    }
  }

  void _storeChanged() {
    if (!mounted) return;
    if (_store?.drafts[_key] == null && !_saving) {
      _controller.text = _initialText();
      _dayOffset = widget.task.timeDayOffset;
    }
    setState(() {});
  }

  void _changed() {
    final task = widget.task;
    final onSave = widget.onSave;
    final store = _store;
    final key = _key;
    final draft = TaskValueDraft(_controller.text, dayOffset: _dayOffset);
    store?.changed(key, draft, () async {
      final parsed = draft.parse(task.task);
      await onSave(
        TaskValueInput._(
          numberValue: parsed.numberValue,
          durationSeconds: parsed.durationSeconds,
          timeMinutes: parsed.timeMinutes,
          dayOffset: parsed.dayOffset,
        ),
      );
      // A newer edit must not be cleared by a slow earlier save.
      if (identical(store.drafts[key], draft)) store.saved([key]);
    });
  }

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
    if (nextIdentity == _lastIdentity &&
        oldWidget.task.numberValue == widget.task.numberValue &&
        oldWidget.task.timeMinutes == widget.task.timeMinutes &&
        oldWidget.task.timeDayOffset == widget.task.timeDayOffset) {
      return;
    }

    _lastIdentity = nextIdentity;
    _controller.text = _store?.drafts[_key]?.text ?? _initialText();
    _dayOffset = _store?.drafts[_key]?.dayOffset ?? widget.task.timeDayOffset;
    _errorText = null;
  }

  @override
  void dispose() {
    _store?.removeListener(_storeChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final task = widget.task.task;
    final valueType = task.valueType;
    final unitLabel = _unitLabel();

    final input = TextField(
      enabled: !_saving,
      key: _store?.anchor(_key),
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
        errorText: _store?.errors[_key] ?? _errorText,
        border: const OutlineInputBorder(),
      ),
      onSubmitted: (_) => _save(),
      onChanged: (_) => _changed(),
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
              _changed();
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
        ] else if (MediaQuery.sizeOf(context).width < 420 ||
            MediaQuery.textScalerOf(context).scale(14) > 20) ...[
          input,
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: _saving ? null : _save,
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

  Future<void> _save() async {
    if (_saving) return;
    final parsed = _parseInput();
    if (parsed == null) {
      return;
    }

    setState(() => _saving = true);
    try {
      await widget.onSave(parsed);
      _store?.saved([_key]);
      if (mounted) FocusScope.of(context).unfocus();
    } catch (e) {
      if (mounted) setState(() => _errorText = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  TaskValueInput? _parseInput() {
    try {
      final parsed = TaskValueDraft(
        _controller.text,
        dayOffset: _dayOffset,
      ).parse(widget.task.task);
      setState(() => _errorText = null);
      return TaskValueInput._(
        numberValue: parsed.numberValue,
        durationSeconds: parsed.durationSeconds,
        timeMinutes: parsed.timeMinutes,
        dayOffset: parsed.dayOffset,
      );
    } on FormatException catch (e) {
      setState(() => _errorText = e.message);
      _store?.mark({_key: e.message});
      return null;
    }
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
