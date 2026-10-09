import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/task_card_metric.dart';
import 'package:momentum/features/aufgaben/data/task_for_date.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle_calculation.dart';

class TaskValueBundleForDate {
  const TaskValueBundleForDate({
    required this.scheduledDate,
    required this.bundle,
    required this.version,
    required this.firstTask,
    required this.secondTask,
    required this.calculation,
    required this.status,
    this.cardMetrics = const [],
  });

  final DateTime scheduledDate;
  final TaskValueBundle bundle;
  final TaskValueBundleVersion version;
  final TaskForDate firstTask;
  final TaskForDate secondTask;
  final TaskValueBundleCalculation? calculation;
  final String status;
  final List<TaskCardMetric> cardMetrics;
  TaskCardMetric? get cardMetric => cardMetrics.firstOrNull;

  Set<String> get taskIds => {firstTask.task.id, secondTask.task.id};

  bool get isPartial => status == TaskValueBundleDisplayStatus.partial;
}

class TaskListForDate {
  const TaskListForDate({required this.tasks, required this.valueBundles});

  final List<TaskForDate> tasks;
  final List<TaskValueBundleForDate> valueBundles;
}
