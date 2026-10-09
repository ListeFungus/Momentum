import 'package:momentum/features/aufgaben/data/habit_recurrence.dart';
import 'package:momentum/features/aufgaben/data/missed_policy.dart';
import 'package:momentum/features/aufgaben/data/task_capture_mode.dart';
import 'package:momentum/features/aufgaben/data/task_goal.dart';
import 'package:momentum/features/aufgaben/data/task_types.dart';
import 'package:momentum/features/aufgaben/data/task_value_commitment.dart';
import 'package:momentum/features/aufgaben/data/task_value_type.dart';
import 'package:momentum/features/aufgaben/data/task_value_unit.dart';

class TaskConfiguration {
  const TaskConfiguration({
    required this.taskType,
    required this.captureMode,
    required this.recurrence,
    required this.startDate,
    this.dueDate,
    this.activeDays = const {1, 2, 3, 4, 5, 6, 7},
    this.missedPolicy = MissedPolicy.none,
    this.missedConsequence = MissedConsequence.markAsNotDone,
    this.bufferDays = 1,
    this.postBufferBehavior,
    this.maxCarryoverCount = 3,
    this.goalType = TaskGoalType.none,
    this.goalValue = 1,
    this.goalWindowDays,
    this.goalPeriod = GoalPeriod.week,
    this.goalPeriodAlignment = GoalPeriodAlignment.calendar,
    this.valueType = TaskValueType.none,
    this.valueCommitment = TaskValueCommitment.none,
    this.valueUnitKey = TaskValueUnitKey.none,
    this.valueUnitLabel = '',
  });

  factory TaskConfiguration.defaults({
    String taskType = TaskTypes.task,
    String captureMode = TaskCaptureMode.checkbox,
    DateTime? startDate,
  }) {
    return TaskConfiguration(
      taskType: taskType,
      captureMode: captureMode,
      recurrence: HabitRecurrence.none,
      startDate: startDate ?? DateTime.now(),
    );
  }

  final String taskType;
  final String captureMode;
  final String recurrence;
  final DateTime startDate;
  final DateTime? dueDate;
  final Set<int> activeDays;
  final String missedPolicy;
  final String missedConsequence;
  final int bufferDays;
  final String? postBufferBehavior;
  final int maxCarryoverCount;
  final String goalType;
  final int goalValue;
  final int? goalWindowDays;
  final String goalPeriod;
  final String goalPeriodAlignment;
  final String valueType;
  final String valueCommitment;
  final String valueUnitKey;
  final String valueUnitLabel;

  bool get isRecurring => recurrence != HabitRecurrence.none;

  bool get isCalendarBased =>
      recurrence == HabitRecurrence.daily ||
      recurrence == HabitRecurrence.weeklyFixedDays ||
      recurrence == HabitRecurrence.monthlyFixedDays;

  bool get isCompletionBased =>
      recurrence == HabitRecurrence.weeklyAfterCompletion ||
      HabitRecurrence.isCustomAfterCompletion(recurrence);

  bool get usesValueCapture => captureMode == TaskCaptureMode.value;
}
