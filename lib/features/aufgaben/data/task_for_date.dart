import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/task_card_metric.dart';
import 'package:momentum/features/aufgaben/data/task_entry_status.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle_for_date.dart';

class TaskForDate {
  TaskForDate({
    required this.task,
    required this.entry,
    required this.entryValue,
    required this.project,
    this.cardMetrics = const [],
    List<TaskValueBundleForDate> linkedValueBundles = const [],
    TaskValueBundleForDate? linkedValueBundle,
  }) : linkedValueBundles =
           linkedValueBundle == null
               ? linkedValueBundles
               : [...linkedValueBundles, linkedValueBundle];

  final Aufgabe task;
  final TaskEntry? entry;
  final TaskEntryValue? entryValue;
  final Project? project;
  final List<TaskCardMetric> cardMetrics;
  TaskCardMetric? get cardMetric => cardMetrics.firstOrNull;
  final List<TaskValueBundleForDate> linkedValueBundles;
  TaskValueBundleForDate? get linkedValueBundle =>
      linkedValueBundles.firstOrNull;

  bool get isCompleted =>
      entry != null && TaskEntryStatus.isPositiveCompletion(entry!.status);

  bool get isAnswered =>
      entry != null && TaskEntryStatus.isResolved(entry!.status);

  bool? get booleanValue => entry?.checkboxValue;

  double? get numberValue => entryValue?.numberValue;

  int? get durationSeconds => entryValue?.durationSeconds;

  int? get timeMinutes => entryValue?.timeMinutes;

  int get timeDayOffset => entryValue?.dayOffset ?? 0;

  String get note => entry?.note ?? '';
}
