import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:momentum/features/aufgaben/data/task_goal.dart';
import 'package:momentum/features/aufgaben/data/task_value_type.dart';

class TaskGoalField extends StatelessWidget {
  const TaskGoalField({
    required this.selectedGoalType,
    required this.goalValue,
    required this.goalWindowDays,
    required this.selectedPeriod,
    required this.selectedPeriodAlignment,
    required this.supportsPeriodGoals,
    required this.valueType,
    required this.onGoalTypeChanged,
    required this.onGoalValueChanged,
    required this.onGoalWindowDaysChanged,
    required this.onPeriodChanged,
    required this.onPeriodAlignmentChanged,
    this.enabled = true,
    this.allowValueSumGoal = true,
    this.valueGoalsOnly = false,
    super.key,
  });

  final String selectedGoalType;
  final int goalValue;
  final int goalWindowDays;
  final String selectedPeriod;
  final String selectedPeriodAlignment;
  final bool supportsPeriodGoals;
  final String valueType;
  final ValueChanged<String> onGoalTypeChanged;
  final ValueChanged<int> onGoalValueChanged;
  final ValueChanged<int> onGoalWindowDaysChanged;
  final ValueChanged<String> onPeriodChanged;
  final ValueChanged<String> onPeriodAlignmentChanged;
  final bool enabled;
  final bool allowValueSumGoal;
  final bool valueGoalsOnly;

  bool get _needsValue => _effectiveGoalType != TaskGoalType.none;

  bool get _needsWindow =>
      _effectiveGoalType == TaskGoalType.rollingSuccessCount ||
      _isValueGoal(_effectiveGoalType);

  bool get _needsPeriod =>
      _effectiveGoalType == TaskGoalType.countPerPeriod ||
      _effectiveGoalType == TaskGoalType.percentage ||
      _effectiveGoalType == TaskGoalType.maxFailures;

  bool get _supportsValueGoals =>
      valueType == TaskValueType.number || valueType == TaskValueType.duration;

  bool get _canSelectGoals => supportsPeriodGoals && _goalOptions.length > 1;

  List<DropdownMenuItem<String>> get _goalOptions {
    final options = <DropdownMenuItem<String>>[
      const DropdownMenuItem(
        value: TaskGoalType.none,
        child: Text('Kein Ziel'),
      ),
    ];

    if (!supportsPeriodGoals) {
      return options;
    }

    if (!valueGoalsOnly) {
      options.addAll(const [
        DropdownMenuItem(
          value: TaskGoalType.countPerPeriod,
          child: Text('Anzahl pro Zeitraum'),
        ),
        DropdownMenuItem(
          value: TaskGoalType.percentage,
          child: Text('Prozentziel'),
        ),
        DropdownMenuItem(
          value: TaskGoalType.maxFailures,
          child: Text('Maximal X Fehlschläge'),
        ),
        DropdownMenuItem(
          value: TaskGoalType.rollingSuccessCount,
          child: Text('X Erfolge in den letzten X Tagen'),
        ),
      ]);
    }

    if (_supportsValueGoals) {
      if (allowValueSumGoal) {
        options.add(
          const DropdownMenuItem(
            value: TaskGoalType.valueSumMin,
            child: Text('Mindestens Summe in X Tagen'),
          ),
        );
      }
      options.addAll(const [
        DropdownMenuItem(
          value: TaskGoalType.valueAverageMin,
          child: Text('Mindestens Durchschnitt in X Tagen'),
        ),
        DropdownMenuItem(
          value: TaskGoalType.valueAverageMax,
          child: Text('Höchstens Durchschnitt in X Tagen'),
        ),
      ]);
    }

    return options;
  }

  String get _effectiveGoalType {
    if (!_goalOptions.any((option) => option.value == selectedGoalType)) {
      return TaskGoalType.none;
    }

    if (valueGoalsOnly &&
        selectedGoalType != TaskGoalType.none &&
        !_isValueGoal(selectedGoalType)) {
      return TaskGoalType.none;
    }

    if (supportsPeriodGoals || selectedGoalType == TaskGoalType.none) {
      return selectedGoalType;
    }

    return TaskGoalType.none;
  }

  String get _valueLabel {
    if (_effectiveGoalType == TaskGoalType.percentage) {
      return 'Prozent';
    }

    if (_effectiveGoalType == TaskGoalType.maxFailures) {
      return 'Maximale Fehlschläge';
    }

    if (_effectiveGoalType == TaskGoalType.rollingSuccessCount) {
      return 'Erfolge';
    }

    if (_isValueGoal(_effectiveGoalType)) {
      return valueType == TaskValueType.duration
          ? 'Zielwert in Minuten'
          : 'Zielwert';
    }

    return 'Anzahl';
  }

  String get _valueHelper {
    if (_effectiveGoalType == TaskGoalType.percentage) {
      return '100% bedeutet: alle fälligen Einträge erfolgreich schaffen.';
    }

    if (_effectiveGoalType == TaskGoalType.maxFailures) {
      return 'Wie viele nicht erfolgreiche Einträge im Zeitraum erlaubt sind.';
    }

    if (_effectiveGoalType == TaskGoalType.rollingSuccessCount) {
      return 'Wie viele Erfolge innerhalb des rollierenden Fensters erreicht werden sollen.';
    }

    if (_effectiveGoalType == TaskGoalType.valueSumMin) {
      return 'Welche Summe im Zielzeitraum mindestens erreicht werden soll.';
    }

    if (_effectiveGoalType == TaskGoalType.valueAverageMin) {
      return 'Welcher Durchschnitt im Zielzeitraum mindestens erreicht werden soll.';
    }

    if (_effectiveGoalType == TaskGoalType.valueAverageMax) {
      return 'Welcher Durchschnitt im Zielzeitraum höchstens erreicht werden soll.';
    }

    return 'Wie oft das Ziel im gewählten Zeitraum erreicht werden soll.';
  }

  @override
  Widget build(BuildContext context) {
    final canSelectGoals = _canSelectGoals;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: _effectiveGoalType,
          decoration: const InputDecoration(
            labelText: 'Ziel',
            helperText: 'Optionales Ziel für spätere Auswertungen.',
            border: OutlineInputBorder(),
          ),
          items: _goalOptions,
          onChanged:
              enabled && canSelectGoals
                  ? (value) {
                    if (value != null) {
                      onGoalTypeChanged(value);
                    }
                  }
                  : null,
        ),
        const SizedBox(height: 8),
        _GoalAvailabilityHint(
          supportsPeriodGoals: supportsPeriodGoals,
          valueGoalsOnly: valueGoalsOnly,
          supportsValueGoals: _supportsValueGoals,
          allowValueSumGoal: allowValueSumGoal,
        ),
        if (!supportsPeriodGoals) ...[
          const SizedBox(height: 8),
          const _GoalHint(goalType: TaskGoalType.none),
        ] else ...[
          const SizedBox(height: 8),
          _GoalHint(goalType: _effectiveGoalType),
        ],
        if (_needsValue) const SizedBox(height: 20),
        if (_needsValue)
          _NumberField(
            key: ValueKey(_effectiveGoalType),
            labelText: _valueLabel,
            helperText: _valueHelper,
            value: goalValue,
            minValue: _effectiveGoalType == TaskGoalType.maxFailures ? 0 : 1,
            maxValue:
                _effectiveGoalType == TaskGoalType.percentage ? 100 : null,
            enabled: enabled,
            onChanged: onGoalValueChanged,
          )
        else
          const SizedBox.shrink(),
        if (_needsWindow) const SizedBox(height: 20),
        if (_needsWindow)
          _NumberField(
            key: ValueKey('${TaskGoalType.rollingSuccessCount}_window'),
            labelText: 'Rollierendes Fenster in Tagen',
            helperText:
                'Das Ziel wird für die letzten X Tage inklusive heute berechnet.',
            value: goalWindowDays,
            minValue: 1,
            enabled: enabled,
            onChanged: onGoalWindowDaysChanged,
          )
        else
          const SizedBox.shrink(),
        if (_needsPeriod) ...[
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: selectedPeriod,
            decoration: const InputDecoration(
              labelText: 'Zeitraum',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: GoalPeriod.week,
                child: Text('Pro Woche'),
              ),
              DropdownMenuItem(
                value: GoalPeriod.month,
                child: Text('Pro Monat'),
              ),
            ],
            onChanged:
                enabled
                    ? (value) {
                      if (value != null) {
                        onPeriodChanged(value);
                      }
                    }
                    : null,
          ),
        ],
        if (_needsPeriod) ...[
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: selectedPeriodAlignment,
            decoration: const InputDecoration(
              labelText: 'Zeitraum-Ausrichtung',
              helperText:
                  'Kalenderwoche startet aktuell montags. Später in den allgemeinen Einstellungen änderbar.',
              border: OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem(
                value: GoalPeriodAlignment.calendar,
                child: Text(
                  selectedPeriod == GoalPeriod.week
                      ? 'Wochenbeginn'
                      : 'Monatsbeginn',
                ),
              ),
              const DropdownMenuItem(
                value: GoalPeriodAlignment.fromStartDate,
                child: Text('Ab Startdatum'),
              ),
            ],
            onChanged:
                enabled
                    ? (value) {
                      if (value != null) {
                        onPeriodAlignmentChanged(value);
                      }
                    }
                    : null,
          ),
        ],
      ],
    );
  }
}

class _GoalHint extends StatelessWidget {
  const _GoalHint({required this.goalType});

  final String goalType;

  @override
  Widget build(BuildContext context) {
    final text = _hintText();

    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  String _hintText() {
    if (goalType == TaskGoalType.countPerPeriod) {
      return 'Beispiel: 3x pro Woche Sport machen.';
    }

    if (goalType == TaskGoalType.percentage) {
      return 'Beispiel: 80% der fälligen Einträge erfolgreich schaffen.';
    }

    if (goalType == TaskGoalType.maxFailures) {
      return 'Beispiel: höchstens 2 Fehlschläge pro Monat.';
    }

    if (goalType == TaskGoalType.rollingSuccessCount) {
      return 'Beispiel: 3 Erfolge innerhalb der letzten 10 Tage.';
    }

    if (goalType == TaskGoalType.valueSumMin) {
      return 'Beispiel: mindestens 10 Liter in 7 Tagen.';
    }

    if (goalType == TaskGoalType.valueAverageMin) {
      return 'Beispiel: durchschnittlich mindestens 30 Minuten.';
    }

    if (goalType == TaskGoalType.valueAverageMax) {
      return 'Beispiel: durchschnittlich höchstens 2.000 kcal.';
    }

    return 'Ohne Ziel wird nur der Verlauf gespeichert.';
  }
}

class _GoalAvailabilityHint extends StatelessWidget {
  const _GoalAvailabilityHint({
    required this.supportsPeriodGoals,
    required this.valueGoalsOnly,
    required this.supportsValueGoals,
    required this.allowValueSumGoal,
  });

  final bool supportsPeriodGoals;
  final bool valueGoalsOnly;
  final bool supportsValueGoals;
  final bool allowValueSumGoal;

  @override
  Widget build(BuildContext context) {
    final text = _text;

    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        height: 1.35,
      ),
    );
  }

  String get _text {
    if (!supportsPeriodGoals) {
      return 'Ziele mit Zeitraum sind erst bei wiederkehrenden Einträgen möglich.';
    }

    if (valueGoalsOnly && !allowValueSumGoal) {
      return 'Dieses Bündel nutzt Wertziele. Zeitintervalle unterstützen aktuell Durchschnittsziele, aber keine Summenziele.';
    }

    if (valueGoalsOnly) {
      return 'Dieses Bündel nutzt Wertziele auf Basis vollständig berechenbarer Bündelwerte.';
    }

    if (!supportsValueGoals) {
      return 'Für diese Aufgabe werden Statusziele angeboten. Wertziele erscheinen bei Zahl- oder Dauer-Erfassung.';
    }

    return 'Für diese Aufgabe sind Statusziele und Wertziele möglich.';
  }
}

bool _isValueGoal(String goalType) {
  return goalType == TaskGoalType.valueSumMin ||
      goalType == TaskGoalType.valueAverageMin ||
      goalType == TaskGoalType.valueAverageMax;
}

class _NumberField extends StatefulWidget {
  const _NumberField({
    required this.labelText,
    required this.helperText,
    required this.value,
    required this.minValue,
    required this.enabled,
    required this.onChanged,
    this.maxValue,
    super.key,
  });

  final String labelText;
  final String helperText;
  final int value;
  final int minValue;
  final int? maxValue;
  final bool enabled;
  final ValueChanged<int> onChanged;

  @override
  State<_NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<_NumberField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      enabled: widget.enabled,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: widget.labelText,
        helperText: widget.helperText,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        final parsedValue = int.tryParse(value ?? '');
        if (parsedValue == null || parsedValue < widget.minValue) {
          return 'Bitte gib eine Zahl ab ${widget.minValue} ein.';
        }
        final maxValue = widget.maxValue;
        if (maxValue != null && parsedValue > maxValue) {
          return 'Der Wert darf höchstens $maxValue betragen.';
        }
        return null;
      },
      onChanged: (value) {
        final parsedValue = int.tryParse(value);

        if (parsedValue == null || parsedValue < widget.minValue) {
          return;
        }

        final maxValue = widget.maxValue;
        if (maxValue != null && parsedValue > maxValue) {
          return;
        }

        widget.onChanged(parsedValue);
      },
    );
  }
}
