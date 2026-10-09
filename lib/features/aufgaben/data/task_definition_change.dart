import 'dart:convert';

class TaskScheduleChangePayload {
  const TaskScheduleChangePayload({
    required this.activeWeekdays,
    required this.recurrence,
    required this.missedPolicy,
    required this.missedConsequence,
    required this.missedBufferDays,
    required this.postBufferBehavior,
    required this.maxCarryoverCount,
  });

  final String activeWeekdays;
  final String recurrence;
  final String missedPolicy;
  final String missedConsequence;
  final int missedBufferDays;
  final String postBufferBehavior;
  final int maxCarryoverCount;

  String encode() => jsonEncode({
    'activeWeekdays': activeWeekdays,
    'recurrence': recurrence,
    'missedPolicy': missedPolicy,
    'missedConsequence': missedConsequence,
    'missedBufferDays': missedBufferDays,
    'postBufferBehavior': postBufferBehavior,
    'maxCarryoverCount': maxCarryoverCount,
  });

  static TaskScheduleChangePayload decode(String source) {
    final json = jsonDecode(source) as Map<String, dynamic>;
    return TaskScheduleChangePayload(
      activeWeekdays: json['activeWeekdays'] as String,
      recurrence: json['recurrence'] as String,
      missedPolicy: json['missedPolicy'] as String,
      missedConsequence: json['missedConsequence'] as String,
      missedBufferDays: json['missedBufferDays'] as int,
      postBufferBehavior: json['postBufferBehavior'] as String,
      maxCarryoverCount: json['maxCarryoverCount'] as int,
    );
  }
}

class TaskGoalChangePayload {
  const TaskGoalChangePayload({
    required this.goalType,
    required this.goalValue,
    required this.goalWindowDays,
    required this.goalPeriod,
    required this.goalPeriodAlignment,
  });

  final String goalType;
  final int goalValue;
  final int? goalWindowDays;
  final String goalPeriod;
  final String goalPeriodAlignment;

  String encode() => jsonEncode({
    'goalType': goalType,
    'goalValue': goalValue,
    'goalWindowDays': goalWindowDays,
    'goalPeriod': goalPeriod,
    'goalPeriodAlignment': goalPeriodAlignment,
  });

  static TaskGoalChangePayload decode(String source) {
    final json = jsonDecode(source) as Map<String, dynamic>;
    return TaskGoalChangePayload(
      goalType: json['goalType'] as String,
      goalValue: json['goalValue'] as int,
      goalWindowDays: json['goalWindowDays'] as int?,
      goalPeriod: json['goalPeriod'] as String,
      goalPeriodAlignment: json['goalPeriodAlignment'] as String,
    );
  }
}
