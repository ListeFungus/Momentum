import 'package:momentum/core/database/app_database.dart';

abstract final class TaskValueAnalyticsPointStatus {
  static const virtualMissing = 'virtual_missing';
}

class TaskValueAnalyticsPoint {
  const TaskValueAnalyticsPoint({
    required this.scheduledDate,
    required this.status,
    this.value,
    this.entry,
    this.entryValue,
    this.isVirtualMissing = false,
  });

  final DateTime scheduledDate;
  final String status;
  final double? value;
  final TaskEntry? entry;
  final TaskEntryValue? entryValue;
  final bool isVirtualMissing;
}

class TaskValueAnalyticsSummary {
  const TaskValueAnalyticsSummary({
    required this.valueType,
    required this.unitKey,
    required this.unitLabel,
    required this.periodStart,
    required this.periodEnd,
    required this.recordedCount,
    required this.virtualMissingCount,
    required this.pendingCount,
    required this.noEntryCount,
    required this.failureCount,
    required this.notCalculableCount,
    required this.sum,
    required this.average,
    required this.minimum,
    required this.maximum,
    required this.points,
    this.isAggregateAvailable = true,
    this.aggregateUnavailableReason,
  });

  final String valueType;
  final String unitKey;
  final String unitLabel;
  final DateTime periodStart;
  final DateTime periodEnd;
  final int recordedCount;
  final int virtualMissingCount;
  final int pendingCount;
  final int noEntryCount;
  final int failureCount;
  final int notCalculableCount;
  final double? sum;
  final double? average;
  final double? minimum;
  final double? maximum;
  final List<TaskValueAnalyticsPoint> points;
  final bool isAggregateAvailable;
  final String? aggregateUnavailableReason;

  int get missingOrOpenCount =>
      virtualMissingCount + pendingCount + noEntryCount + failureCount;

  bool get hasRecordedValues => recordedCount > 0;
}
