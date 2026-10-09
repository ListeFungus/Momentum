import 'package:flutter/material.dart';
import 'package:momentum/features/aufgaben/data/task_value_commitment.dart';
import 'package:momentum/features/aufgaben/data/task_value_type.dart';
import 'package:momentum/features/aufgaben/data/task_value_unit.dart';

class TaskValueConfigurationField extends StatelessWidget {
  const TaskValueConfigurationField({
    required this.valueType,
    required this.valueCommitment,
    required this.unitKey,
    required this.unitLabel,
    required this.enabled,
    required this.onValueTypeChanged,
    required this.onValueCommitmentChanged,
    required this.onUnitKeyChanged,
    required this.onUnitLabelChanged,
    super.key,
  });

  final String valueType;
  final String valueCommitment;
  final String unitKey;
  final String unitLabel;
  final bool enabled;
  final ValueChanged<String> onValueTypeChanged;
  final ValueChanged<String> onValueCommitmentChanged;
  final ValueChanged<String> onUnitKeyChanged;
  final ValueChanged<String> onUnitLabelChanged;

  bool get _usesCustomUnit =>
      valueType == TaskValueType.number && unitKey == TaskValueUnitKey.custom;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Wert-Erfassung',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: valueType,
              decoration: const InputDecoration(
                labelText: 'Werttyp',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: TaskValueType.number,
                  child: Text('Zahl'),
                ),
                DropdownMenuItem(
                  value: TaskValueType.duration,
                  child: Text('Dauer'),
                ),
                DropdownMenuItem(
                  value: TaskValueType.timeOfDay,
                  child: Text('Uhrzeit'),
                ),
              ],
              onChanged:
                  enabled
                      ? (value) {
                        if (value != null) {
                          onValueTypeChanged(value);
                        }
                      }
                      : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: valueCommitment,
              decoration: const InputDecoration(
                labelText: 'Verbindlichkeit',
                helperText:
                    'Reines Tracking speichert nur echte Eingaben. Fehlende Tage werden nicht automatisch bewertet.',
                helperMaxLines: 3,
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: TaskValueCommitment.pureTracking,
                  child: Text('Reines Tracking'),
                ),
                DropdownMenuItem(
                  value: TaskValueCommitment.required,
                  child: Text('Verbindliche Eingabe'),
                ),
              ],
              onChanged:
                  enabled
                      ? (value) {
                        if (value != null) {
                          onValueCommitmentChanged(value);
                        }
                      }
                      : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _effectiveUnitKey,
              decoration: const InputDecoration(
                labelText: 'Einheit',
                border: OutlineInputBorder(),
              ),
              items:
                  _unitOptions
                      .map(
                        (option) => DropdownMenuItem(
                          value: option.key,
                          child: Text(option.label),
                        ),
                      )
                      .toList(),
              onChanged:
                  enabled
                      ? (value) {
                        if (value != null) {
                          onUnitKeyChanged(value);
                        }
                      }
                      : null,
            ),
            if (_usesCustomUnit) ...[
              const SizedBox(height: 12),
              TextFormField(
                initialValue: unitLabel,
                enabled: enabled,
                decoration: const InputDecoration(
                  labelText: 'Eigene Beschriftung',
                  hintText: 'z. B. Schritte, Seiten, Wiederholungen',
                  border: OutlineInputBorder(),
                ),
                onChanged: onUnitLabelChanged,
                validator: (value) {
                  if (_usesCustomUnit &&
                      (value == null || value.trim().isEmpty)) {
                    return 'Bitte gib eine Beschriftung ein.';
                  }
                  return null;
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  String get _effectiveUnitKey {
    final allowedKeys = _unitOptions.map((option) => option.key).toSet();
    if (allowedKeys.contains(unitKey)) {
      return unitKey;
    }
    return _unitOptions.first.key;
  }

  List<_UnitOption> get _unitOptions {
    if (valueType == TaskValueType.duration) {
      return const [
        _UnitOption(TaskValueUnitKey.hour, 'Stunden'),
        _UnitOption(TaskValueUnitKey.minute, 'Minuten'),
        _UnitOption(TaskValueUnitKey.second, 'Sekunden'),
      ];
    }

    if (valueType == TaskValueType.timeOfDay) {
      return const [_UnitOption(TaskValueUnitKey.timeOfDay, 'Uhrzeit')];
    }

    return const [
      _UnitOption(TaskValueUnitKey.liter, 'Liter'),
      _UnitOption(TaskValueUnitKey.milliliter, 'Milliliter'),
      _UnitOption(TaskValueUnitKey.kilometer, 'Kilometer'),
      _UnitOption(TaskValueUnitKey.meter, 'Meter'),
      _UnitOption(TaskValueUnitKey.centimeter, 'Zentimeter'),
      _UnitOption(TaskValueUnitKey.custom, 'Eigene Beschriftung'),
    ];
  }
}

class _UnitOption {
  const _UnitOption(this.key, this.label);

  final String key;
  final String label;
}
