import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/task_for_date.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle.dart';
import 'package:momentum/features/aufgaben/data/task_value_type.dart';

abstract final class TaskValueBundleDisplayStatus {
  static const empty = 'empty';
  static const partial = 'partial';
  static const complete = 'complete';
  static const notCalculable = 'not_calculable';
}

class TaskValueBundleCalculation {
  const TaskValueBundleCalculation({
    required this.valueType,
    this.numberValue,
    this.durationSeconds,
    this.unitLabel = '',
  });

  final String valueType;
  final double? numberValue;
  final int? durationSeconds;
  final String unitLabel;
}

TaskValueBundleCalculation? calculateTaskValueBundle({
  required TaskValueBundleVersion version,
  required TaskForDate firstTask,
  required TaskForDate secondTask,
}) {
  final firstValue = firstTask.entryValue;
  final secondValue = secondTask.entryValue;

  if (firstValue == null || secondValue == null) {
    return null;
  }

  return switch (version.bundleType) {
    TaskValueBundleType.timeInterval => _calculateTimeInterval(
      firstTask,
      secondTask,
    ),
    TaskValueBundleType.difference => _calculateDifference(
      version,
      firstTask,
      secondTask,
    ),
    TaskValueBundleType.sum => _calculateSum(firstTask, secondTask),
    _ => null,
  };
}

TaskValueBundleCalculation? _calculateTimeInterval(
  TaskForDate firstTask,
  TaskForDate secondTask,
) {
  final firstMinutes = firstTask.timeMinutes;
  final secondMinutes = secondTask.timeMinutes;

  if (firstMinutes == null || secondMinutes == null) {
    return null;
  }

  final start = firstMinutes + firstTask.timeDayOffset * 24 * 60;
  var end = secondMinutes + secondTask.timeDayOffset * 24 * 60;

  if (end <= start) {
    end += 24 * 60;
  }

  return TaskValueBundleCalculation(
    valueType: TaskValueType.duration,
    durationSeconds: (end - start) * 60,
    unitLabel: 'Dauer',
  );
}

TaskValueBundleCalculation? _calculateDifference(
  TaskValueBundleVersion version,
  TaskForDate firstTask,
  TaskForDate secondTask,
) {
  if (firstTask.task.valueType == TaskValueType.duration &&
      secondTask.task.valueType == TaskValueType.duration) {
    final first = firstTask.durationSeconds;
    final second = secondTask.durationSeconds;

    if (first == null || second == null) {
      return null;
    }

    final value =
        version.direction == TaskValueBundleDirection.secondMinusFirst
            ? second - first
            : first - second;

    return TaskValueBundleCalculation(
      valueType: TaskValueType.duration,
      durationSeconds: value,
      unitLabel: 'Dauer',
    );
  }

  final first = _numberValueForCalculation(firstTask);
  final second = _numberValueForCalculation(secondTask);

  if (first == null || second == null) {
    return null;
  }

  final value =
      version.direction == TaskValueBundleDirection.secondMinusFirst
          ? second - first
          : first - second;

  return TaskValueBundleCalculation(
    valueType: TaskValueType.number,
    numberValue: value,
    unitLabel: firstTask.entryValue?.unitLabel ?? firstTask.task.valueUnitLabel,
  );
}

TaskValueBundleCalculation? _calculateSum(
  TaskForDate firstTask,
  TaskForDate secondTask,
) {
  if (firstTask.task.valueType == TaskValueType.duration &&
      secondTask.task.valueType == TaskValueType.duration) {
    final first = firstTask.durationSeconds;
    final second = secondTask.durationSeconds;

    if (first == null || second == null) {
      return null;
    }

    return TaskValueBundleCalculation(
      valueType: TaskValueType.duration,
      durationSeconds: first + second,
      unitLabel: 'Dauer',
    );
  }

  final first = _numberValueForCalculation(firstTask);
  final second = _numberValueForCalculation(secondTask);

  if (first == null || second == null) {
    return null;
  }

  return TaskValueBundleCalculation(
    valueType: TaskValueType.number,
    numberValue: first + second,
    unitLabel: firstTask.entryValue?.unitLabel ?? firstTask.task.valueUnitLabel,
  );
}

double? _numberValueForCalculation(TaskForDate task) {
  return task.entryValue?.normalizedNumberValue ?? task.entryValue?.numberValue;
}
