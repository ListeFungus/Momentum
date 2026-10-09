abstract final class TaskValueUnitFamily {
  static const none = 'none';
  static const volume = 'volume';
  static const distance = 'distance';
  static const duration = 'duration';
  static const time = 'time';
  static const customNumber = 'custom_number';

  static const values = {none, volume, distance, duration, time, customNumber};
}

abstract final class TaskValueUnitKey {
  static const none = 'none';
  static const liter = 'l';
  static const milliliter = 'ml';
  static const kilometer = 'km';
  static const meter = 'm';
  static const centimeter = 'cm';
  static const hour = 'h';
  static const minute = 'min';
  static const second = 's';
  static const timeOfDay = 'time_of_day';
  static const custom = 'custom';

  static const values = {
    none,
    liter,
    milliliter,
    kilometer,
    meter,
    centimeter,
    hour,
    minute,
    second,
    timeOfDay,
    custom,
  };
}

class TaskValueUnitDefinition {
  const TaskValueUnitDefinition({
    required this.key,
    required this.label,
    required this.family,
    required this.factorToBaseUnit,
  });

  final String key;
  final String label;
  final String family;
  final double factorToBaseUnit;
}

abstract final class TaskValueUnits {
  static const definitions = [
    TaskValueUnitDefinition(
      key: TaskValueUnitKey.liter,
      label: 'Liter',
      family: TaskValueUnitFamily.volume,
      factorToBaseUnit: 1000,
    ),
    TaskValueUnitDefinition(
      key: TaskValueUnitKey.milliliter,
      label: 'Milliliter',
      family: TaskValueUnitFamily.volume,
      factorToBaseUnit: 1,
    ),
    TaskValueUnitDefinition(
      key: TaskValueUnitKey.kilometer,
      label: 'Kilometer',
      family: TaskValueUnitFamily.distance,
      factorToBaseUnit: 1000,
    ),
    TaskValueUnitDefinition(
      key: TaskValueUnitKey.meter,
      label: 'Meter',
      family: TaskValueUnitFamily.distance,
      factorToBaseUnit: 1,
    ),
    TaskValueUnitDefinition(
      key: TaskValueUnitKey.centimeter,
      label: 'Zentimeter',
      family: TaskValueUnitFamily.distance,
      factorToBaseUnit: 0.01,
    ),
    TaskValueUnitDefinition(
      key: TaskValueUnitKey.hour,
      label: 'Stunden',
      family: TaskValueUnitFamily.duration,
      factorToBaseUnit: 3600,
    ),
    TaskValueUnitDefinition(
      key: TaskValueUnitKey.minute,
      label: 'Minuten',
      family: TaskValueUnitFamily.duration,
      factorToBaseUnit: 60,
    ),
    TaskValueUnitDefinition(
      key: TaskValueUnitKey.second,
      label: 'Sekunden',
      family: TaskValueUnitFamily.duration,
      factorToBaseUnit: 1,
    ),
    TaskValueUnitDefinition(
      key: TaskValueUnitKey.timeOfDay,
      label: 'Uhrzeit',
      family: TaskValueUnitFamily.time,
      factorToBaseUnit: 1,
    ),
  ];

  static TaskValueUnitDefinition? byKey(String key) {
    for (final definition in definitions) {
      if (definition.key == key) {
        return definition;
      }
    }

    return null;
  }
}
