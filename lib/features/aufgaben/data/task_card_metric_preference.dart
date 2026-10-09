import 'dart:convert';

import 'package:momentum/features/aufgaben/data/task_analytics_period.dart';

abstract final class TaskCardMetricKey {
  static const goal = 'goal';
  static const strictSuccessRate = 'strict_success_rate';
  static const successCount = 'success_count';
  static const average = 'average';
  static const sum = 'sum';
  static const entryValue = 'entry_value';
  static const entryStatus = 'entry_status';
  static const bundleResult = 'bundle_result';

  static const values = {
    goal,
    strictSuccessRate,
    successCount,
    average,
    sum,
    entryValue,
    entryStatus,
    bundleResult,
  };
}

class TaskCardMetricPreferenceItem {
  const TaskCardMetricPreferenceItem({required this.metric, this.period});

  final String metric;
  final TaskAnalyticsPeriod? period;

  Map<String, Object> toJson() => {
    'metric': metric,
    if (period != null) 'period': period!.name,
  };

  static TaskCardMetricPreferenceItem? tryParse(Object? value) {
    if (value is! Map<String, dynamic>) {
      return null;
    }

    final metric = value['metric'];
    if (metric is! String || !TaskCardMetricKey.values.contains(metric)) {
      return null;
    }

    final periodName = value['period'];
    TaskAnalyticsPeriod? period;
    if (periodName != null) {
      if (periodName is! String) {
        return null;
      }
      period =
          TaskAnalyticsPeriod.values
              .where((candidate) => candidate.name == periodName)
              .firstOrNull;
      if (period == null) {
        return null;
      }
    }

    final needsPeriod = switch (metric) {
      TaskCardMetricKey.strictSuccessRate ||
      TaskCardMetricKey.successCount ||
      TaskCardMetricKey.average ||
      TaskCardMetricKey.sum => true,
      _ => false,
    };
    if (needsPeriod != (period != null)) {
      return null;
    }

    return TaskCardMetricPreferenceItem(metric: metric, period: period);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskCardMetricPreferenceItem &&
        other.metric == metric &&
        other.period == period;
  }

  @override
  int get hashCode => Object.hash(metric, period);
}

class TaskCardMetricPreferenceConfig {
  const TaskCardMetricPreferenceConfig({required this.items});

  static const version = 1;
  static const hidden = TaskCardMetricPreferenceConfig(items: []);

  final List<TaskCardMetricPreferenceItem> items;

  String encode() => jsonEncode({
    'version': version,
    'items': items.map((item) => item.toJson()).toList(growable: false),
  });

  static TaskCardMetricPreferenceDecodeResult decode(String source) {
    try {
      final value = jsonDecode(source);
      if (value is! Map<String, dynamic> || value['version'] != version) {
        return const TaskCardMetricPreferenceDecodeResult.unavailable();
      }

      final rawItems = value['items'];
      if (rawItems is! List) {
        return const TaskCardMetricPreferenceDecodeResult.unavailable();
      }

      final items = <TaskCardMetricPreferenceItem>[];
      for (final rawItem in rawItems) {
        final item = TaskCardMetricPreferenceItem.tryParse(rawItem);
        if (item == null) {
          return const TaskCardMetricPreferenceDecodeResult.unavailable();
        }
        items.add(item);
      }

      return TaskCardMetricPreferenceDecodeResult.available(
        TaskCardMetricPreferenceConfig(items: List.unmodifiable(items)),
      );
    } on FormatException {
      return const TaskCardMetricPreferenceDecodeResult.unavailable();
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is! TaskCardMetricPreferenceConfig ||
        other.items.length != items.length) {
      return false;
    }
    for (var index = 0; index < items.length; index++) {
      if (other.items[index] != items[index]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(items);
}

class TaskCardMetricPreferenceDecodeResult {
  const TaskCardMetricPreferenceDecodeResult.available(this.config)
    : isAvailable = true;

  const TaskCardMetricPreferenceDecodeResult.unavailable()
    : config = null,
      isAvailable = false;

  final TaskCardMetricPreferenceConfig? config;
  final bool isAvailable;
}

class TaskCardMetricPreferenceSelection {
  const TaskCardMetricPreferenceSelection.defaultValue()
    : config = null,
      isStored = false,
      isUnavailable = false;

  const TaskCardMetricPreferenceSelection.stored(
    TaskCardMetricPreferenceConfig value,
  ) : config = value,
      isStored = true,
      isUnavailable = false;

  const TaskCardMetricPreferenceSelection.unavailable()
    : config = null,
      isStored = true,
      isUnavailable = true;

  final TaskCardMetricPreferenceConfig? config;
  final bool isStored;
  final bool isUnavailable;

  bool get usesDefault => !isStored;
  bool get isHidden =>
      isStored && !isUnavailable && (config?.items.isEmpty ?? false);
}
