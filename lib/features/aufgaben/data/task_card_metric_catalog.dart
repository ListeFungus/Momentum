import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/habit_recurrence.dart';
import 'package:momentum/features/aufgaben/data/task_capture_mode.dart';
import 'package:momentum/features/aufgaben/data/task_card_metric_preference.dart';
import 'package:momentum/features/aufgaben/data/task_goal_evaluation_summary.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle.dart';
import 'package:momentum/features/aufgaben/data/task_value_type.dart';

class TaskCardMetricCatalogOption {
  const TaskCardMetricCatalogOption({
    required this.key,
    required this.label,
    required this.description,
    required this.usesPeriod,
  });

  final String key;
  final String label;
  final String description;
  final bool usesPeriod;
}

abstract final class TaskCardMetricCatalog {
  static const _options = <String, TaskCardMetricCatalogOption>{
    TaskCardMetricKey.goal: TaskCardMetricCatalogOption(
      key: TaskCardMetricKey.goal,
      label: 'Passend zum Ziel',
      description:
          'Zeigt Ergebnis, Zielgrenze und Datenbasis des gültigen Ziels.',
      usesPeriod: false,
    ),
    TaskCardMetricKey.strictSuccessRate: TaskCardMetricCatalogOption(
      key: TaskCardMetricKey.strictSuccessRate,
      label: 'Strenge Erfolgsquote',
      description: 'Erfolge im Verhältnis zu allen fälligen Einträgen.',
      usesPeriod: true,
    ),
    TaskCardMetricKey.successCount: TaskCardMetricCatalogOption(
      key: TaskCardMetricKey.successCount,
      label: 'Anzahl Erfolge',
      description: 'Zählt erfolgreiche Einträge im gewählten Zeitraum.',
      usesPeriod: true,
    ),
    TaskCardMetricKey.average: TaskCardMetricCatalogOption(
      key: TaskCardMetricKey.average,
      label: 'Durchschnitt',
      description:
          'Durchschnitt aus echten erfassten und berechenbaren Werten.',
      usesPeriod: true,
    ),
    TaskCardMetricKey.sum: TaskCardMetricCatalogOption(
      key: TaskCardMetricKey.sum,
      label: 'Summe',
      description: 'Summe aus echten erfassten und berechenbaren Werten.',
      usesPeriod: true,
    ),
    TaskCardMetricKey.entryValue: TaskCardMetricCatalogOption(
      key: TaskCardMetricKey.entryValue,
      label: 'Wert dieses Eintrags',
      description: 'Zeigt ausschließlich den Wert der dargestellten Instanz.',
      usesPeriod: false,
    ),
    TaskCardMetricKey.entryStatus: TaskCardMetricCatalogOption(
      key: TaskCardMetricKey.entryStatus,
      label: 'Status dieses Eintrags',
      description: 'Zeigt ausschließlich den Status der dargestellten Instanz.',
      usesPeriod: false,
    ),
    TaskCardMetricKey.bundleResult: TaskCardMetricCatalogOption(
      key: TaskCardMetricKey.bundleResult,
      label: 'Bündelergebnis dieses Tages',
      description:
          'Zeigt das Ergebnis des vollständigen Wertepaares dieses Tages.',
      usesPeriod: false,
    ),
  };

  static TaskCardMetricCatalogOption option(String key) => _options[key]!;

  static List<TaskCardMetricCatalogOption> forTask(Aufgabe task) {
    final isValue = task.erfassungsmodus == TaskCaptureMode.value;
    final isRecurring = task.recurrence != HabitRecurrence.none;
    final keys = <String>[];

    if (isRecurring &&
        (isSupportedStatusGoalForTask(task) ||
            isSupportedValueGoalForTask(task))) {
      keys.add(TaskCardMetricKey.goal);
    }
    if (isRecurring && !isValue) {
      keys.addAll([
        TaskCardMetricKey.strictSuccessRate,
        TaskCardMetricKey.successCount,
      ]);
    }
    if (isRecurring && isValue) {
      keys.add(TaskCardMetricKey.average);
      if (task.valueType == TaskValueType.number ||
          task.valueType == TaskValueType.duration) {
        keys.add(TaskCardMetricKey.sum);
      }
    }
    if (isValue) {
      keys.add(TaskCardMetricKey.entryValue);
    }
    keys.add(TaskCardMetricKey.entryStatus);

    return keys.map(option).toList(growable: false);
  }

  static List<TaskCardMetricCatalogOption> forBundle(
    TaskValueBundleVersion version,
  ) {
    final keys = <String>[];
    if (isSupportedValueGoalForBundle(version)) {
      keys.add(TaskCardMetricKey.goal);
    }
    keys.add(TaskCardMetricKey.average);
    if (version.bundleType != TaskValueBundleType.timeInterval) {
      keys.add(TaskCardMetricKey.sum);
    }
    keys.add(TaskCardMetricKey.bundleResult);
    return keys.map(option).toList(growable: false);
  }
}
