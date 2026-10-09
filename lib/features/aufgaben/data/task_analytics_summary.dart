class TaskAnalyticsSummary {
  const TaskAnalyticsSummary({
    required this.dueCount,
    required this.totalInstanceCount,
    required this.successCount,
    this.recordedCount = 0,
    required this.failureCount,
    required this.noEntryCount,
    required this.pendingCount,
    this.overdueEntryCount = 0,
    this.overdueDays = 0,
    this.bufferCompletionCount = 0,
    this.manualResolutionCount = 0,
    this.automaticResolutionCount = 0,
  });

  final int dueCount;
  final int totalInstanceCount;
  final int successCount;
  final int recordedCount;
  final int failureCount;
  final int noEntryCount;
  final int pendingCount;
  final int overdueEntryCount;
  final int overdueDays;
  final int bufferCompletionCount;
  final int manualResolutionCount;
  final int automaticResolutionCount;

  int get positiveCompletionCount => successCount + recordedCount;

  int get answeredCount => successCount + failureCount;

  int get resolvedCount =>
      successCount + recordedCount + failureCount + noEntryCount;

  double? get strictSuccessRate {
    if (dueCount == 0) {
      return null;
    }

    return successCount / dueCount;
  }

  double? get valuedSuccessRate {
    if (answeredCount == 0) {
      return null;
    }

    return successCount / answeredCount;
  }

  double? get completionRate {
    if (totalInstanceCount == 0) {
      return null;
    }

    return resolvedCount / totalInstanceCount;
  }

  double? get averageOverdueDays {
    if (overdueEntryCount == 0) {
      return null;
    }

    return overdueDays / overdueEntryCount;
  }
}

class OneTimeTaskAnalyticsSummary {
  const OneTimeTaskAnalyticsSummary({
    required this.totalCount,
    required this.successCount,
    this.recordedCount = 0,
    required this.failureCount,
    required this.noEntryCount,
    required this.pendingCount,
    required this.beforeDueCount,
    required this.onDueCount,
    required this.afterDueCount,
    required this.manualResolutionCount,
    required this.automaticResolutionCount,
    required this.totalDaysToCompletion,
    required this.completedWithDurationCount,
    required this.totalDueDeviationDays,
    required this.completedWithDueDateCount,
    required this.totalCurrentOverdueDays,
    required this.currentOverdueCount,
  });

  final int totalCount;
  final int successCount;
  final int recordedCount;
  final int failureCount;
  final int noEntryCount;
  final int pendingCount;
  final int beforeDueCount;
  final int onDueCount;
  final int afterDueCount;
  final int manualResolutionCount;
  final int automaticResolutionCount;
  final int totalDaysToCompletion;
  final int completedWithDurationCount;
  final int totalDueDeviationDays;
  final int completedWithDueDateCount;
  final int totalCurrentOverdueDays;
  final int currentOverdueCount;

  int get resolvedCount =>
      successCount + recordedCount + failureCount + noEntryCount;

  int get onTimeCount => beforeDueCount + onDueCount;

  double? get onTimeRate {
    if (completedWithDueDateCount == 0) {
      return null;
    }

    return onTimeCount / completedWithDueDateCount;
  }

  double? get averageDaysToCompletion {
    if (completedWithDurationCount == 0) {
      return null;
    }

    return totalDaysToCompletion / completedWithDurationCount;
  }

  double? get averageDueDeviationDays {
    if (completedWithDueDateCount == 0) {
      return null;
    }

    return totalDueDeviationDays / completedWithDueDateCount;
  }

  double? get averageCurrentOverdueDays {
    if (currentOverdueCount == 0) {
      return null;
    }

    return totalCurrentOverdueDays / currentOverdueCount;
  }
}
