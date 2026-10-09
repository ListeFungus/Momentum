import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle_for_date.dart';

class TaskValueBundleAnalyticsPoint {
  const TaskValueBundleAnalyticsPoint({
    required this.scheduledDate,
    required this.bundleForDate,
    required this.status,
    this.value,
  });

  final DateTime scheduledDate;
  final TaskValueBundleForDate bundleForDate;
  final String status;
  final double? value;
}

class TaskValueBundleAnalyticsSummary {
  const TaskValueBundleAnalyticsSummary({
    required this.version,
    required this.periodStart,
    required this.periodEnd,
    required this.completeCount,
    required this.partialCount,
    required this.missingCount,
    required this.notCalculableCount,
    required this.sum,
    required this.average,
    required this.minimum,
    required this.maximum,
    required this.points,
    this.isAvailable = true,
    this.unavailableReason,
  });

  final TaskValueBundleVersion version;
  final DateTime periodStart;
  final DateTime periodEnd;
  final int completeCount;
  final int partialCount;
  final int missingCount;
  final int notCalculableCount;
  final double? sum;
  final double? average;
  final double? minimum;
  final double? maximum;
  final List<TaskValueBundleAnalyticsPoint> points;
  final bool isAvailable;
  final String? unavailableReason;

  int get relevantDayCount =>
      completeCount + partialCount + missingCount + notCalculableCount;

  bool get hasCalculatedValues => completeCount > 0;
}
