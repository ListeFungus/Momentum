import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/features/aufgaben/data/habit_recurrence.dart';
import 'package:momentum/features/aufgaben/data/missed_policy.dart';
import 'package:momentum/features/aufgaben/data/post_buffer_behavior.dart';
import 'package:momentum/features/aufgaben/data/task_capture_mode.dart';
import 'package:momentum/features/aufgaben/data/task_configuration.dart';
import 'package:momentum/features/aufgaben/data/task_configuration_validator.dart';
import 'package:momentum/features/aufgaben/data/task_goal.dart';
import 'package:momentum/features/aufgaben/data/task_types.dart';
import 'package:momentum/features/aufgaben/data/task_value_commitment.dart';
import 'package:momentum/features/aufgaben/data/task_value_type.dart';
import 'package:momentum/features/aufgaben/data/task_value_unit.dart';

void main() {
  final today = DateTime(2026, 7, 4);

  TaskConfiguration configuration({
    String recurrence = HabitRecurrence.none,
    DateTime? dueDate,
    Set<int> activeDays = const {1, 2, 3, 4, 5, 6, 7},
    String captureMode = TaskCaptureMode.checkbox,
    String missedPolicy = MissedPolicy.none,
    String missedConsequence = MissedConsequence.markAsNotDone,
    int bufferDays = 1,
    String? postBufferBehavior,
    int maxCarryoverCount = 3,
    String goalType = TaskGoalType.none,
    int goalValue = 1,
    int? goalWindowDays,
    String valueType = TaskValueType.none,
    String valueCommitment = TaskValueCommitment.none,
    String valueUnitKey = TaskValueUnitKey.none,
    String valueUnitLabel = '',
  }) {
    return TaskConfiguration(
      taskType: TaskTypes.task,
      captureMode: captureMode,
      recurrence: recurrence,
      startDate: today,
      dueDate: dueDate,
      activeDays: activeDays,
      missedPolicy: missedPolicy,
      missedConsequence: missedConsequence,
      bufferDays: bufferDays,
      postBufferBehavior: postBufferBehavior,
      maxCarryoverCount: maxCarryoverCount,
      goalType: goalType,
      goalValue: goalValue,
      goalWindowDays: goalWindowDays,
      valueType: valueType,
      valueCommitment: valueCommitment,
      valueUnitKey: valueUnitKey,
      valueUnitLabel: valueUnitLabel,
    );
  }

  group('TaskConfigurationValidator', () {
    test('one-off task without due date only allows no missed policy', () {
      final result = TaskConfigurationValidator.validate(configuration());

      expect(result.canSave, isTrue);
      expect(
        result.ruleFor(TaskConfigurationField.missedPolicy).allowedValues,
        {MissedPolicy.none},
      );
      expect(
        result.ruleFor(TaskConfigurationField.missedPolicy).availability,
        TaskFieldAvailability.automatic,
      );
    });

    test('value capture with known unit can be saved', () {
      final result = TaskConfigurationValidator.validate(
        configuration(
          captureMode: TaskCaptureMode.value,
          valueType: TaskValueType.number,
          valueCommitment: TaskValueCommitment.pureTracking,
          valueUnitKey: TaskValueUnitKey.liter,
        ),
      );

      expect(result.canSave, isTrue);
      expect(result.configuration.valueType, TaskValueType.number);
      expect(
        result.configuration.valueCommitment,
        TaskValueCommitment.pureTracking,
      );
      expect(result.configuration.valueUnitKey, TaskValueUnitKey.liter);
    });

    test('pure tracking only allows no missed policy', () {
      final result = TaskConfigurationValidator.validate(
        configuration(
          captureMode: TaskCaptureMode.value,
          recurrence: HabitRecurrence.daily,
          missedPolicy: MissedPolicy.direct,
          valueType: TaskValueType.number,
          valueCommitment: TaskValueCommitment.pureTracking,
          valueUnitKey: TaskValueUnitKey.liter,
        ),
      );

      expect(result.canSave, isFalse);
      expect(result.configuration.missedPolicy, MissedPolicy.none);
      expect(
        result.ruleFor(TaskConfigurationField.missedPolicy).allowedValues,
        {MissedPolicy.none},
      );
      expect(
        result.ruleFor(TaskConfigurationField.missedPolicy).reason,
        contains('Reines Tracking'),
      );
    });

    test('recurring task with goal requires missed policy', () {
      final result = TaskConfigurationValidator.validate(
        configuration(
          recurrence: HabitRecurrence.daily,
          missedPolicy: MissedPolicy.none,
          goalType: TaskGoalType.rollingSuccessCount,
          goalValue: 3,
          goalWindowDays: 7,
        ),
      );

      expect(result.canSave, isFalse);
      expect(
        result.issues.map((issue) => issue.code),
        contains('goal_requires_missed_policy'),
      );
    });

    test('value capture with custom unit needs label', () {
      final invalid = TaskConfigurationValidator.validate(
        configuration(
          captureMode: TaskCaptureMode.value,
          valueType: TaskValueType.number,
          valueCommitment: TaskValueCommitment.pureTracking,
          valueUnitKey: TaskValueUnitKey.custom,
        ),
      );

      expect(invalid.canSave, isFalse);
      expect(
        invalid.issues.map((issue) => issue.code),
        contains('missing_custom_unit_label'),
      );

      final valid = TaskConfigurationValidator.validate(
        configuration(
          captureMode: TaskCaptureMode.value,
          valueType: TaskValueType.number,
          valueCommitment: TaskValueCommitment.pureTracking,
          valueUnitKey: TaskValueUnitKey.custom,
          valueUnitLabel: 'Schritte',
        ),
      );

      expect(valid.canSave, isTrue);
      expect(valid.configuration.valueUnitLabel, 'Schritte');
    });

    test('recurring task rejects and clears a separate due date', () {
      final result = TaskConfigurationValidator.validate(
        configuration(
          recurrence: HabitRecurrence.daily,
          dueDate: today.add(const Duration(days: 3)),
        ),
      );

      expect(result.canSave, isFalse);
      expect(
        result.issues.map((issue) => issue.code),
        contains('due_date_not_allowed'),
      );
      expect(result.configuration.dueDate, isNull);
    });

    test('completion-based interval does not allow carryover', () {
      final result = TaskConfigurationValidator.validate(
        configuration(
          recurrence: HabitRecurrence.customAfterCompletion(10),
          missedPolicy: MissedPolicy.carryover,
        ),
      );

      expect(result.canSave, isFalse);
      expect(
        result.issues.map((issue) => issue.code),
        contains('invalid_missed_policy'),
      );
      expect(result.configuration.missedPolicy, MissedPolicy.none);
    });

    test('daily calendar rhythm allows a buffer with follow-up behavior', () {
      final result = TaskConfigurationValidator.validate(
        configuration(
          recurrence: HabitRecurrence.daily,
          missedPolicy: MissedPolicy.buffer,
          bufferDays: 2,
          postBufferBehavior: PostBufferBehavior.markAsNoEntry,
        ),
      );

      expect(result.canSave, isTrue);
      expect(
        result.ruleFor(TaskConfigurationField.bufferDays).availability,
        TaskFieldAvailability.required,
      );
      expect(
        result.ruleFor(TaskConfigurationField.postBufferBehavior).availability,
        TaskFieldAvailability.required,
      );
    });

    test('buffer does not allow keep-open as follow-up behavior', () {
      final result = TaskConfigurationValidator.validate(
        configuration(
          recurrence: HabitRecurrence.daily,
          missedPolicy: MissedPolicy.buffer,
          bufferDays: 1,
          postBufferBehavior: PostBufferBehavior.keepOpen,
        ),
      );

      expect(result.canSave, isFalse);
      expect(
        result.issues.map((issue) => issue.code),
        contains('missing_post_buffer_behavior'),
      );
    });

    test('daily buffer can last at most two rhythm intervals', () {
      final result = TaskConfigurationValidator.validate(
        configuration(
          recurrence: HabitRecurrence.daily,
          missedPolicy: MissedPolicy.buffer,
          bufferDays: 3,
          postBufferBehavior: PostBufferBehavior.markAsFailure,
        ),
      );

      expect(result.canSave, isFalse);
      expect(
        result.issues.map((issue) => issue.code),
        contains('buffer_too_long'),
      );
    });

    test('monthly last-day buffer uses the concrete next date distance', () {
      final result = TaskConfigurationValidator.validate(
        TaskConfiguration(
          taskType: TaskTypes.task,
          captureMode: TaskCaptureMode.checkbox,
          recurrence: HabitRecurrence.monthlyFixedDays,
          startDate: DateTime(2026, 1, 31),
          activeDays: const {32},
          missedPolicy: MissedPolicy.buffer,
          bufferDays: 57,
          postBufferBehavior: PostBufferBehavior.markAsFailure,
        ),
      );

      expect(result.canSave, isFalse);
      expect(
        result.issues.map((issue) => issue.code),
        contains('buffer_too_long'),
      );
    });

    test('buffer requires an explicit follow-up behavior', () {
      final result = TaskConfigurationValidator.validate(
        configuration(
          recurrence: HabitRecurrence.weeklyFixedDays,
          activeDays: const {1, 3},
          missedPolicy: MissedPolicy.buffer,
        ),
      );

      expect(result.canSave, isFalse);
      expect(
        result.issues.map((issue) => issue.code),
        contains('missing_post_buffer_behavior'),
      );
    });

    test('allows no-entry as automatic missed consequence', () {
      final result = TaskConfigurationValidator.validate(
        configuration(
          recurrence: HabitRecurrence.daily,
          missedPolicy: MissedPolicy.direct,
          missedConsequence: MissedConsequence.keepNeutral,
        ),
      );

      expect(result.canSave, isTrue);
      expect(
        result.configuration.missedConsequence,
        MissedConsequence.keepNeutral,
      );
    });

    test('rolling goal requires count and window', () {
      final invalid = TaskConfigurationValidator.validate(
        configuration(
          recurrence: HabitRecurrence.daily,
          missedPolicy: MissedPolicy.direct,
          goalType: TaskGoalType.rollingSuccessCount,
          goalValue: 3,
        ),
      );
      final valid = TaskConfigurationValidator.validate(
        configuration(
          recurrence: HabitRecurrence.daily,
          missedPolicy: MissedPolicy.direct,
          goalType: TaskGoalType.rollingSuccessCount,
          goalValue: 3,
          goalWindowDays: 10,
        ),
      );

      expect(invalid.canSave, isFalse);
      expect(
        invalid.issues.map((issue) => issue.code),
        contains('invalid_goal_window'),
      );
      expect(valid.canSave, isTrue);
    });

    test('value goal requires number or duration value capture', () {
      final valid = TaskConfigurationValidator.validate(
        configuration(
          captureMode: TaskCaptureMode.value,
          recurrence: HabitRecurrence.daily,
          missedPolicy: MissedPolicy.direct,
          valueType: TaskValueType.number,
          valueCommitment: TaskValueCommitment.required,
          valueUnitKey: TaskValueUnitKey.custom,
          valueUnitLabel: 'Einheiten',
          goalType: TaskGoalType.valueAverageMin,
          goalValue: 2,
          goalWindowDays: 7,
        ),
      );
      final timeOfDay = TaskConfigurationValidator.validate(
        configuration(
          captureMode: TaskCaptureMode.value,
          recurrence: HabitRecurrence.daily,
          missedPolicy: MissedPolicy.direct,
          valueType: TaskValueType.timeOfDay,
          valueCommitment: TaskValueCommitment.required,
          goalType: TaskGoalType.valueAverageMin,
          goalValue: 2,
          goalWindowDays: 7,
        ),
      );

      expect(valid.canSave, isTrue);
      expect(timeOfDay.configuration.goalType, TaskGoalType.none);
    });

    test(
      'unknown custom interval is rejected instead of silently defaulted',
      () {
        final result = TaskConfigurationValidator.validate(
          configuration(
            recurrence: '${HabitRecurrence.customAfterCompletionPrefix}invalid',
          ),
        );

        expect(result.canSave, isFalse);
        expect(
          result.issues.map((issue) => issue.code),
          contains('unknown_recurrence'),
        );
        expect(result.configuration.recurrence, HabitRecurrence.none);
      },
    );

    test('recurring task without policy exposes backlog warning', () {
      final result = TaskConfigurationValidator.validate(
        configuration(recurrence: HabitRecurrence.daily),
      );

      expect(
        result.ruleFor(TaskConfigurationField.missedPolicy).warning,
        isNotNull,
      );
    });
  });
}
