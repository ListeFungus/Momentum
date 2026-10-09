import 'dart:math' as math;

import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/task_analytics_summary.dart';
import 'package:momentum/features/aufgaben/data/task_capture_mode.dart';
import 'package:momentum/features/aufgaben/data/task_entry_status.dart';
import 'package:momentum/features/aufgaben/data/task_goal.dart';
import 'package:momentum/features/aufgaben/data/task_value_analytics_summary.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle_analytics_summary.dart';
import 'package:momentum/features/aufgaben/data/task_value_type.dart';

abstract final class TaskGoalEvaluationState {
  static const noGoal = 'no_goal';
  static const unsupported = 'unsupported';
  static const noData = 'no_data';
  static const notEvaluated = 'not_evaluated';
  static const achieved = 'achieved';
  static const reachable = 'reachable';
  static const missed = 'missed';
}

class TaskGoalEvaluationSummary {
  const TaskGoalEvaluationSummary({
    required this.state,
    required this.goalType,
    required this.periodStart,
    required this.periodEnd,
    required this.windowDays,
    required this.requiredSuccessCount,
    required this.successCount,
    required this.failureCount,
    required this.noEntryCount,
    required this.pendingCount,
    required this.totalInstanceCount,
    required this.message,
  });

  factory TaskGoalEvaluationSummary.noGoal({
    required DateTime today,
    required int windowDays,
  }) {
    final periodEnd = _dateOnly(today);
    final periodStart = periodEnd.subtract(Duration(days: windowDays - 1));

    return TaskGoalEvaluationSummary(
      state: TaskGoalEvaluationState.noGoal,
      goalType: TaskGoalType.none,
      periodStart: periodStart,
      periodEnd: periodEnd,
      windowDays: windowDays,
      requiredSuccessCount: 0,
      successCount: 0,
      failureCount: 0,
      noEntryCount: 0,
      pendingCount: 0,
      totalInstanceCount: 0,
      message: 'Diese Aufgabe hat kein aktives Ziel.',
    );
  }

  factory TaskGoalEvaluationSummary.fromStatusSummary({
    required Aufgabe task,
    required TaskAnalyticsSummary summary,
    required DateTime today,
  }) {
    final goalType = task.goalType;
    final windowDays = goalWindowDaysForTask(task);
    final periodEnd = _dateOnly(today);
    final periodStart = periodEnd.subtract(Duration(days: windowDays - 1));

    if (goalType == TaskGoalType.none) {
      return TaskGoalEvaluationSummary.noGoal(
        today: today,
        windowDays: windowDays,
      );
    }

    if (!isSupportedStatusGoalForTask(task)) {
      return TaskGoalEvaluationSummary(
        state: TaskGoalEvaluationState.unsupported,
        goalType: goalType,
        periodStart: periodStart,
        periodEnd: periodEnd,
        windowDays: windowDays,
        requiredSuccessCount: 0,
        successCount: summary.successCount,
        failureCount: summary.failureCount,
        noEntryCount: summary.noEntryCount,
        pendingCount: summary.pendingCount,
        totalInstanceCount: summary.totalInstanceCount,
        message:
            'Dieser Zieltyp ist in der ersten Zielbewertung noch nicht umgesetzt.',
      );
    }

    final requiredSuccessCount = requiredSuccessesForTask(task);
    if (summary.totalInstanceCount == 0) {
      return TaskGoalEvaluationSummary(
        state: TaskGoalEvaluationState.noData,
        goalType: goalType,
        periodStart: periodStart,
        periodEnd: periodEnd,
        windowDays: windowDays,
        requiredSuccessCount: requiredSuccessCount,
        successCount: 0,
        failureCount: 0,
        noEntryCount: 0,
        pendingCount: 0,
        totalInstanceCount: 0,
        message: 'Noch keine Einträge im Zielzeitraum.',
      );
    }

    final possibleSuccessCount = summary.successCount + summary.pendingCount;
    final state =
        summary.successCount >= requiredSuccessCount
            ? TaskGoalEvaluationState.achieved
            : possibleSuccessCount >= requiredSuccessCount
            ? TaskGoalEvaluationState.reachable
            : TaskGoalEvaluationState.missed;

    return TaskGoalEvaluationSummary(
      state: state,
      goalType: goalType,
      periodStart: periodStart,
      periodEnd: periodEnd,
      windowDays: windowDays,
      requiredSuccessCount: requiredSuccessCount,
      successCount: summary.successCount,
      failureCount: summary.failureCount,
      noEntryCount: summary.noEntryCount,
      pendingCount: summary.pendingCount,
      totalInstanceCount: summary.totalInstanceCount,
      message: _messageForState(state),
    );
  }

  final String state;
  final String goalType;
  final DateTime periodStart;
  final DateTime periodEnd;
  final int windowDays;
  final int requiredSuccessCount;
  final int successCount;
  final int failureCount;
  final int noEntryCount;
  final int pendingCount;
  final int totalInstanceCount;
  final String message;

  bool get hasGoal => state != TaskGoalEvaluationState.noGoal;

  bool get isSupported => state != TaskGoalEvaluationState.unsupported;

  bool get hasData => state != TaskGoalEvaluationState.noData;

  bool get hasDataQualityWarning => noEntryCount > 0 || failureCount > 0;

  double? get successProgress {
    if (requiredSuccessCount == 0) {
      return null;
    }

    return (successCount / requiredSuccessCount).clamp(0, 1).toDouble();
  }
}

class TaskValueGoalEvaluationSummary {
  const TaskValueGoalEvaluationSummary({
    required this.state,
    required this.goalType,
    required this.periodStart,
    required this.periodEnd,
    required this.windowDays,
    required this.targetValue,
    required this.actualValue,
    required this.recordedCount,
    required this.missingOrOpenCount,
    required this.valueType,
    required this.unitLabel,
    required this.message,
  });

  factory TaskValueGoalEvaluationSummary.fromValueSummary({
    required Aufgabe task,
    required TaskValueAnalyticsSummary summary,
    required DateTime today,
  }) {
    final windowDays = goalWindowDaysForTask(task);
    final periodEnd = _dateOnly(today);
    final periodStart = periodEnd.subtract(Duration(days: windowDays - 1));
    final targetValue = valueGoalTargetForTask(task);

    if (task.goalType == TaskGoalType.none) {
      return TaskValueGoalEvaluationSummary(
        state: TaskGoalEvaluationState.noGoal,
        goalType: task.goalType,
        periodStart: periodStart,
        periodEnd: periodEnd,
        windowDays: windowDays,
        targetValue: targetValue,
        actualValue: null,
        recordedCount: summary.recordedCount,
        missingOrOpenCount: summary.missingOrOpenCount,
        valueType: summary.valueType,
        unitLabel: summary.unitLabel,
        message: 'Diese Aufgabe hat kein aktives Wertziel.',
      );
    }

    if (!isSupportedValueGoalForTask(task)) {
      return TaskValueGoalEvaluationSummary(
        state: TaskGoalEvaluationState.unsupported,
        goalType: task.goalType,
        periodStart: periodStart,
        periodEnd: periodEnd,
        windowDays: windowDays,
        targetValue: targetValue,
        actualValue: null,
        recordedCount: summary.recordedCount,
        missingOrOpenCount: summary.missingOrOpenCount,
        valueType: summary.valueType,
        unitLabel: summary.unitLabel,
        message:
            task.valueType == TaskValueType.timeOfDay
                ? 'Uhrzeiten können in dieser Version nur getrackt werden.'
                : 'Dieser Wertzieltyp wird noch nicht unterstützt.',
      );
    }

    final actualValue = switch (task.goalType) {
      TaskGoalType.valueSumMin => summary.sum,
      TaskGoalType.valueAverageMin ||
      TaskGoalType.valueAverageMax => summary.average,
      _ => null,
    };

    if (actualValue == null || summary.recordedCount == 0) {
      return TaskValueGoalEvaluationSummary(
        state: TaskGoalEvaluationState.noData,
        goalType: task.goalType,
        periodStart: periodStart,
        periodEnd: periodEnd,
        windowDays: windowDays,
        targetValue: targetValue,
        actualValue: actualValue,
        recordedCount: summary.recordedCount,
        missingOrOpenCount: summary.missingOrOpenCount,
        valueType: summary.valueType,
        unitLabel: summary.unitLabel,
        message: 'Noch keine berechenbaren Werte im Zielzeitraum.',
      );
    }

    final achieved = switch (task.goalType) {
      TaskGoalType.valueAverageMax => actualValue <= targetValue,
      _ => actualValue >= targetValue,
    };
    final hasWarning = summary.missingOrOpenCount > 0;
    final state =
        achieved
            ? hasWarning
                ? TaskGoalEvaluationState.reachable
                : TaskGoalEvaluationState.achieved
            : TaskGoalEvaluationState.missed;

    return TaskValueGoalEvaluationSummary(
      state: state,
      goalType: task.goalType,
      periodStart: periodStart,
      periodEnd: periodEnd,
      windowDays: windowDays,
      targetValue: targetValue,
      actualValue: actualValue,
      recordedCount: summary.recordedCount,
      missingOrOpenCount: summary.missingOrOpenCount,
      valueType: summary.valueType,
      unitLabel: summary.unitLabel,
      message: switch (state) {
        TaskGoalEvaluationState.achieved => 'Wertziel erreicht.',
        TaskGoalEvaluationState.reachable =>
          'Wertziel rechnerisch erreicht, aber die Datenbasis ist unvollständig.',
        TaskGoalEvaluationState.missed => 'Wertziel nicht erreicht.',
        _ => 'Keine Wertzielbewertung verfügbar.',
      },
    );
  }

  factory TaskValueGoalEvaluationSummary.fromBundleSummary({
    required TaskValueBundleAnalyticsSummary summary,
    required DateTime today,
  }) {
    final version = summary.version;
    final windowDays = goalWindowDaysForBundle(version);
    final periodEnd = _dateOnly(today);
    final periodStart = periodEnd.subtract(Duration(days: windowDays - 1));
    final targetValue = valueGoalTargetForBundle(version);
    final valueView = _bundleValueView(summary);

    if (version.goalType == TaskGoalType.none) {
      return TaskValueGoalEvaluationSummary(
        state: TaskGoalEvaluationState.noGoal,
        goalType: version.goalType,
        periodStart: periodStart,
        periodEnd: periodEnd,
        windowDays: windowDays,
        targetValue: targetValue,
        actualValue: null,
        recordedCount: summary.completeCount,
        missingOrOpenCount: _bundleMissingOrOpenCount(summary),
        valueType: valueView.valueType,
        unitLabel: valueView.unitLabel,
        message: 'Dieses Bündel hat kein aktives Wertziel.',
      );
    }

    if (!isSupportedValueGoalForBundle(version)) {
      return TaskValueGoalEvaluationSummary(
        state: TaskGoalEvaluationState.unsupported,
        goalType: version.goalType,
        periodStart: periodStart,
        periodEnd: periodEnd,
        windowDays: windowDays,
        targetValue: targetValue,
        actualValue: null,
        recordedCount: summary.completeCount,
        missingOrOpenCount: _bundleMissingOrOpenCount(summary),
        valueType: valueView.valueType,
        unitLabel: valueView.unitLabel,
        message: 'Dieser Bündel-Zieltyp wird nicht unterstützt.',
      );
    }

    final actualValue = switch (version.goalType) {
      TaskGoalType.valueSumMin => summary.sum,
      TaskGoalType.valueAverageMin ||
      TaskGoalType.valueAverageMax => summary.average,
      _ => null,
    };

    if (actualValue == null || summary.completeCount == 0) {
      return TaskValueGoalEvaluationSummary(
        state: TaskGoalEvaluationState.noData,
        goalType: version.goalType,
        periodStart: periodStart,
        periodEnd: periodEnd,
        windowDays: windowDays,
        targetValue: targetValue,
        actualValue: actualValue,
        recordedCount: summary.completeCount,
        missingOrOpenCount: _bundleMissingOrOpenCount(summary),
        valueType: valueView.valueType,
        unitLabel: valueView.unitLabel,
        message: 'Noch keine berechenbaren Bündelwerte im Zielzeitraum.',
      );
    }

    final achieved = switch (version.goalType) {
      TaskGoalType.valueAverageMax => actualValue <= targetValue,
      _ => actualValue >= targetValue,
    };
    final hasWarning = _bundleMissingOrOpenCount(summary) > 0;
    final state =
        achieved
            ? hasWarning
                ? TaskGoalEvaluationState.reachable
                : TaskGoalEvaluationState.achieved
            : TaskGoalEvaluationState.missed;

    return TaskValueGoalEvaluationSummary(
      state: state,
      goalType: version.goalType,
      periodStart: periodStart,
      periodEnd: periodEnd,
      windowDays: windowDays,
      targetValue: targetValue,
      actualValue: actualValue,
      recordedCount: summary.completeCount,
      missingOrOpenCount: _bundleMissingOrOpenCount(summary),
      valueType: valueView.valueType,
      unitLabel: valueView.unitLabel,
      message: switch (state) {
        TaskGoalEvaluationState.achieved => 'Bündel-Wertziel erreicht.',
        TaskGoalEvaluationState.reachable =>
          'Bündel-Wertziel rechnerisch erreicht, aber die Datenbasis ist unvollständig.',
        TaskGoalEvaluationState.missed => 'Bündel-Wertziel nicht erreicht.',
        _ => 'Keine Bündel-Wertzielbewertung verfügbar.',
      },
    );
  }

  final String state;
  final String goalType;
  final DateTime periodStart;
  final DateTime periodEnd;
  final int windowDays;
  final double targetValue;
  final double? actualValue;
  final int recordedCount;
  final int missingOrOpenCount;
  final String valueType;
  final String unitLabel;
  final String message;

  bool get hasGoal => state != TaskGoalEvaluationState.noGoal;

  bool get isSupported => state != TaskGoalEvaluationState.unsupported;

  bool get hasData => state != TaskGoalEvaluationState.noData;

  bool get hasDataQualityWarning => missingOrOpenCount > 0;
}

class TaskGoalPlannedChange {
  const TaskGoalPlannedChange({
    required this.validFrom,
    required this.goalType,
    required this.goalValue,
    required this.goalWindowDays,
    required this.goalPeriod,
    required this.goalPeriodAlignment,
  });

  final DateTime validFrom;
  final String goalType;
  final int goalValue;
  final int? goalWindowDays;
  final String goalPeriod;
  final String goalPeriodAlignment;
}

class TaskGoalHistorySummary {
  const TaskGoalHistorySummary({
    required this.hasGoal,
    required this.isSupported,
    required this.windowDays,
    required this.requiredSuccessCount,
    required this.blocks,
  });

  factory TaskGoalHistorySummary.fromEntries({
    required Aufgabe task,
    required List<TaskEntry> entries,
    required DateTime today,
  }) {
    final windowDays = goalWindowDaysForTask(task);
    final requiredSuccessCount = requiredSuccessesForTask(task);

    if (task.goalType == TaskGoalType.none) {
      return TaskGoalHistorySummary(
        hasGoal: false,
        isSupported: false,
        windowDays: windowDays,
        requiredSuccessCount: requiredSuccessCount,
        blocks: const [],
      );
    }

    if (!isSupportedStatusGoalForTask(task)) {
      return TaskGoalHistorySummary(
        hasGoal: true,
        isSupported: false,
        windowDays: windowDays,
        requiredSuccessCount: requiredSuccessCount,
        blocks: const [],
      );
    }

    final referenceDate = _dateOnly(today);
    var blockStart = _dateOnly(task.startDate);
    final sortedEntries = [...entries]..sort((first, second) {
      return first.scheduledDate.compareTo(second.scheduledDate);
    });
    final blocks = <TaskGoalHistoryBlock>[];

    while (true) {
      final blockEnd = blockStart.add(Duration(days: windowDays - 1));
      if (!blockEnd.isBefore(referenceDate)) {
        break;
      }

      final blockEntries =
          sortedEntries.where((entry) {
            final date = _dateOnly(entry.scheduledDate);
            return !date.isBefore(blockStart) && !date.isAfter(blockEnd);
          }).toList();

      blocks.add(
        TaskGoalHistoryBlock.fromEntries(
          periodStart: blockStart,
          periodEnd: blockEnd,
          requiredSuccessCount: requiredSuccessCount,
          entries: blockEntries,
        ),
      );

      blockStart = blockEnd.add(const Duration(days: 1));
    }

    return TaskGoalHistorySummary(
      hasGoal: true,
      isSupported: true,
      windowDays: windowDays,
      requiredSuccessCount: requiredSuccessCount,
      blocks: blocks.reversed.toList(growable: false),
    );
  }

  final bool hasGoal;
  final bool isSupported;
  final int windowDays;
  final int requiredSuccessCount;
  final List<TaskGoalHistoryBlock> blocks;

  int get evaluatedBlockCount =>
      blocks.where((block) => block.isEvaluated).length;

  int get achievedBlockCount =>
      blocks
          .where((block) => block.state == TaskGoalEvaluationState.achieved)
          .length;

  double? get achievedRate {
    final evaluated = evaluatedBlockCount;
    if (evaluated == 0) {
      return null;
    }

    return achievedBlockCount / evaluated;
  }
}

class TaskGoalHistoryBlock {
  const TaskGoalHistoryBlock({
    required this.state,
    required this.periodStart,
    required this.periodEnd,
    required this.requiredSuccessCount,
    required this.successCount,
    required this.failureCount,
    required this.noEntryCount,
    required this.pendingCount,
    required this.totalInstanceCount,
    required this.message,
  });

  factory TaskGoalHistoryBlock.fromEntries({
    required DateTime periodStart,
    required DateTime periodEnd,
    required int requiredSuccessCount,
    required List<TaskEntry> entries,
    bool forceNotEvaluated = false,
    String? notEvaluatedMessage,
  }) {
    var successCount = 0;
    var failureCount = 0;
    var noEntryCount = 0;
    var pendingCount = 0;

    for (final entry in entries) {
      switch (entry.status) {
        case TaskEntryStatus.success:
          successCount++;
          break;
        case TaskEntryStatus.failure:
          failureCount++;
          break;
        case TaskEntryStatus.noEntry:
          noEntryCount++;
          break;
        case TaskEntryStatus.pending:
          pendingCount++;
          break;
        case TaskEntryStatus.recorded:
          break;
      }
    }

    if (forceNotEvaluated) {
      return TaskGoalHistoryBlock(
        state: TaskGoalEvaluationState.notEvaluated,
        periodStart: periodStart,
        periodEnd: periodEnd,
        requiredSuccessCount: requiredSuccessCount,
        successCount: successCount,
        failureCount: failureCount,
        noEntryCount: noEntryCount,
        pendingCount: pendingCount,
        totalInstanceCount: entries.length,
        message:
            notEvaluatedMessage ??
            'Nicht gewertet, weil der Zielblock nicht eindeutig bewertbar ist.',
      );
    }

    if (entries.isEmpty) {
      return TaskGoalHistoryBlock(
        state: TaskGoalEvaluationState.noData,
        periodStart: periodStart,
        periodEnd: periodEnd,
        requiredSuccessCount: requiredSuccessCount,
        successCount: 0,
        failureCount: 0,
        noEntryCount: 0,
        pendingCount: 0,
        totalInstanceCount: 0,
        message: 'Nicht gewertet, weil im Zielblock keine Einträge liegen.',
      );
    }

    if (pendingCount > 0) {
      return TaskGoalHistoryBlock(
        state: TaskGoalEvaluationState.notEvaluated,
        periodStart: periodStart,
        periodEnd: periodEnd,
        requiredSuccessCount: requiredSuccessCount,
        successCount: successCount,
        failureCount: failureCount,
        noEntryCount: noEntryCount,
        pendingCount: pendingCount,
        totalInstanceCount: entries.length,
        message:
            'Nicht gewertet, weil im abgeschlossenen Zielblock noch offene '
            'Einträge liegen.',
      );
    }

    final state =
        successCount >= requiredSuccessCount
            ? TaskGoalEvaluationState.achieved
            : TaskGoalEvaluationState.missed;

    return TaskGoalHistoryBlock(
      state: state,
      periodStart: periodStart,
      periodEnd: periodEnd,
      requiredSuccessCount: requiredSuccessCount,
      successCount: successCount,
      failureCount: failureCount,
      noEntryCount: noEntryCount,
      pendingCount: pendingCount,
      totalInstanceCount: entries.length,
      message:
          state == TaskGoalEvaluationState.achieved
              ? 'Zielblock erreicht.'
              : 'Zielblock nicht erreicht.',
    );
  }

  final String state;
  final DateTime periodStart;
  final DateTime periodEnd;
  final int requiredSuccessCount;
  final int successCount;
  final int failureCount;
  final int noEntryCount;
  final int pendingCount;
  final int totalInstanceCount;
  final String message;

  bool get isEvaluated =>
      state == TaskGoalEvaluationState.achieved ||
      state == TaskGoalEvaluationState.missed;
}

int goalWindowDaysForTask(Aufgabe task) {
  if (task.goalType == TaskGoalType.rollingSuccessCount ||
      isValueGoalType(task.goalType)) {
    return (task.goalWindowDays == null || task.goalWindowDays! < 1)
        ? 7
        : task.goalWindowDays!;
  }

  if (task.goalType == TaskGoalType.countPerPeriod ||
      task.goalType == TaskGoalType.percentage) {
    return task.goalPeriod == GoalPeriod.month ? 30 : 7;
  }

  return 7;
}

int goalWindowDaysForBundle(TaskValueBundleVersion version) {
  if (!isValueGoalType(version.goalType)) {
    return 7;
  }

  return math.max(1, version.goalWindowDays ?? 7);
}

int requiredSuccessesForTask(Aufgabe task) {
  final windowDays = goalWindowDaysForTask(task);

  if (task.goalType == TaskGoalType.percentage) {
    return math.max(1, (windowDays * task.goalValue / 100).ceil());
  }

  return math.max(1, task.goalValue);
}

double valueGoalTargetForTask(Aufgabe task) {
  if (task.valueType == TaskValueType.duration) {
    return task.goalValue * 60;
  }

  return task.goalValue.toDouble();
}

double valueGoalTargetForBundle(TaskValueBundleVersion version) {
  if (version.bundleType == TaskValueBundleType.timeInterval) {
    return version.goalValue * 60;
  }

  return version.goalValue.toDouble();
}

bool isValueGoalType(String goalType) {
  return goalType == TaskGoalType.valueSumMin ||
      goalType == TaskGoalType.valueAverageMin ||
      goalType == TaskGoalType.valueAverageMax;
}

DateTime currentGoalBlockStartForTask(Aufgabe task, DateTime date) {
  final windowDays = goalWindowDaysForTask(task);
  final startDate = _dateOnly(task.startDate);
  final referenceDate = _dateOnly(date);

  if (!referenceDate.isAfter(startDate)) {
    return startDate;
  }

  final elapsedDays = referenceDate.difference(startDate).inDays;
  final blockOffset = elapsedDays ~/ windowDays;
  return startDate.add(Duration(days: blockOffset * windowDays));
}

DateTime nextGoalBlockStartForTask(Aufgabe task, DateTime date) {
  final windowDays = goalWindowDaysForTask(task);
  return currentGoalBlockStartForTask(
    task,
    date,
  ).add(Duration(days: windowDays));
}

bool isSupportedStatusGoalForTask(Aufgabe task) {
  if (task.erfassungsmodus == TaskCaptureMode.value &&
      task.valueType != TaskValueType.none) {
    return false;
  }

  return task.goalType == TaskGoalType.rollingSuccessCount ||
      task.goalType == TaskGoalType.countPerPeriod ||
      task.goalType == TaskGoalType.percentage;
}

bool isSupportedValueGoalForTask(Aufgabe task) {
  if (!isValueGoalType(task.goalType)) {
    return false;
  }

  return task.erfassungsmodus == TaskCaptureMode.value &&
      (task.valueType == TaskValueType.number ||
          task.valueType == TaskValueType.duration);
}

bool isSupportedValueGoalForBundle(TaskValueBundleVersion version) {
  if (!isValueGoalType(version.goalType)) {
    return false;
  }

  if (version.goalType == TaskGoalType.valueSumMin &&
      version.bundleType == TaskValueBundleType.timeInterval) {
    return false;
  }

  return version.bundleType == TaskValueBundleType.timeInterval ||
      version.bundleType == TaskValueBundleType.difference ||
      version.bundleType == TaskValueBundleType.sum;
}

int _bundleMissingOrOpenCount(TaskValueBundleAnalyticsSummary summary) {
  return summary.partialCount +
      summary.missingCount +
      summary.notCalculableCount;
}

_BundleValueView _bundleValueView(TaskValueBundleAnalyticsSummary summary) {
  for (final point in summary.points) {
    final calculation = point.bundleForDate.calculation;
    if (calculation != null) {
      return _BundleValueView(
        valueType: calculation.valueType,
        unitLabel: calculation.unitLabel,
      );
    }
  }

  if (summary.version.bundleType == TaskValueBundleType.timeInterval) {
    return const _BundleValueView(valueType: TaskValueType.duration);
  }

  return const _BundleValueView(valueType: TaskValueType.number);
}

class _BundleValueView {
  const _BundleValueView({required this.valueType, this.unitLabel = ''});

  final String valueType;
  final String unitLabel;
}

String _messageForState(String state) {
  return switch (state) {
    TaskGoalEvaluationState.achieved => 'Ziel im aktuellen Fenster erreicht.',
    TaskGoalEvaluationState.reachable =>
      'Ziel noch nicht erreicht, aber offene Einträge können es noch erreichen.',
    TaskGoalEvaluationState.missed =>
      'Ziel im aktuellen Fenster nicht mehr erreichbar.',
    _ => 'Keine Zielbewertung verfügbar.',
  };
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);
