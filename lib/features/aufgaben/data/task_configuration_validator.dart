import 'package:momentum/features/aufgaben/data/habit_recurrence.dart';
import 'package:momentum/features/aufgaben/data/missed_policy.dart';
import 'package:momentum/features/aufgaben/data/post_buffer_behavior.dart';
import 'package:momentum/features/aufgaben/data/task_capture_mode.dart';
import 'package:momentum/features/aufgaben/data/task_configuration.dart';
import 'package:momentum/features/aufgaben/data/task_goal.dart';
import 'package:momentum/features/aufgaben/data/task_types.dart';
import 'package:momentum/features/aufgaben/data/task_value_commitment.dart';
import 'package:momentum/features/aufgaben/data/task_value_type.dart';
import 'package:momentum/features/aufgaben/data/task_value_unit.dart';

enum TaskConfigurationField {
  dueDate,
  activeDays,
  missedPolicy,
  missedConsequence,
  bufferDays,
  postBufferBehavior,
  maxCarryoverCount,
  goalType,
  goalValue,
  goalWindowDays,
  goalPeriod,
  goalPeriodAlignment,
  valueType,
  valueCommitment,
  valueUnitKey,
  valueUnitLabel,
}

enum TaskFieldAvailability { required, optional, automatic, disabled }

class TaskFieldRule {
  const TaskFieldRule({
    required this.availability,
    this.allowedValues = const {},
    this.reason,
    this.warning,
  });

  final TaskFieldAvailability availability;
  final Set<String> allowedValues;
  final String? reason;
  final String? warning;

  bool get isEnabled =>
      availability == TaskFieldAvailability.required ||
      availability == TaskFieldAvailability.optional;
}

class TaskValidationIssue {
  const TaskValidationIssue({
    required this.code,
    required this.message,
    this.field,
  });

  final String code;
  final String message;
  final TaskConfigurationField? field;
}

class TaskConfigurationValidation {
  const TaskConfigurationValidation({
    required this.configuration,
    required this.rules,
    required this.issues,
  });

  final TaskConfiguration configuration;
  final Map<TaskConfigurationField, TaskFieldRule> rules;
  final List<TaskValidationIssue> issues;

  bool get canSave => issues.isEmpty;

  TaskFieldRule ruleFor(TaskConfigurationField field) => rules[field]!;
}

abstract final class TaskConfigurationValidator {
  static const _allDays = {1, 2, 3, 4, 5, 6, 7};
  static const _monthDays = {
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    32,
  };

  static TaskConfigurationValidation validate(TaskConfiguration input) {
    final normalized = normalize(input);
    final rules = rulesFor(normalized);
    final issues = <TaskValidationIssue>[];

    if (!TaskTypes.values.contains(input.taskType)) {
      issues.add(
        const TaskValidationIssue(
          code: 'unknown_task_type',
          message: 'Der Aufgabentyp ist nicht bekannt.',
        ),
      );
    }

    if (!TaskCaptureMode.values.contains(input.captureMode)) {
      issues.add(
        const TaskValidationIssue(
          code: 'unknown_capture_mode',
          message: 'Der Erfassungsmodus ist nicht bekannt.',
        ),
      );
    }

    if (!_isKnownRecurrence(input.recurrence)) {
      issues.add(
        const TaskValidationIssue(
          code: 'unknown_recurrence',
          message: 'Der Wiederholungsrhythmus ist nicht gültig.',
        ),
      );
    }

    if (input.dueDate != null && input.isRecurring) {
      issues.add(
        const TaskValidationIssue(
          code: 'due_date_not_allowed',
          message:
              'Wiederkehrende Aufgaben haben kein separates Fälligkeitsdatum.',
          field: TaskConfigurationField.dueDate,
        ),
      );
    }

    _validateActiveDays(input, issues);
    _validateMissedPolicy(input, rules, issues);
    _validateGoal(input, issues);
    _validateValueCapture(input, issues);

    return TaskConfigurationValidation(
      configuration: normalized,
      rules: rules,
      issues: issues,
    );
  }

  static TaskConfiguration normalize(TaskConfiguration input) {
    final isKnownRecurrence = _isKnownRecurrence(input.recurrence);
    final recurrence =
        isKnownRecurrence ? input.recurrence : HabitRecurrence.none;
    final isRecurring = isKnownRecurrence && input.isRecurring;
    final captureMode =
        TaskCaptureMode.values.contains(input.captureMode)
            ? input.captureMode
            : TaskCaptureMode.checkbox;
    final usesValueCapture = captureMode == TaskCaptureMode.value;
    final valueType =
        usesValueCapture &&
                TaskValueType.phase12Values.contains(input.valueType)
            ? input.valueType
            : TaskValueType.none;
    final valueCommitment =
        usesValueCapture &&
                TaskValueCommitment.values.contains(input.valueCommitment) &&
                input.valueCommitment != TaskValueCommitment.none
            ? input.valueCommitment
            : usesValueCapture
            ? TaskValueCommitment.pureTracking
            : TaskValueCommitment.none;
    final valueUnitKey =
        usesValueCapture && TaskValueUnitKey.values.contains(input.valueUnitKey)
            ? input.valueUnitKey
            : TaskValueUnitKey.none;
    final isPureTracking =
        usesValueCapture && valueCommitment == TaskValueCommitment.pureTracking;
    final allowedPolicies = _allowedPolicies(
      recurrence: recurrence,
      dueDate: input.dueDate,
      isPureTracking: isPureTracking,
    );
    final missedPolicy =
        allowedPolicies.contains(input.missedPolicy)
            ? input.missedPolicy
            : MissedPolicy.none;
    final allowedConsequences = _allowedConsequences(captureMode);
    final missedConsequence =
        allowedConsequences.contains(input.missedConsequence)
            ? input.missedConsequence
            : MissedConsequence.markAsNotDone;
    final valueGoalAllowed =
        usesValueCapture &&
        (valueType == TaskValueType.number ||
            valueType == TaskValueType.duration);
    final goalType =
        isRecurring &&
                TaskGoalType.values.contains(input.goalType) &&
                (!_isValueGoal(input.goalType) || valueGoalAllowed)
            ? input.goalType
            : TaskGoalType.none;

    return TaskConfiguration(
      taskType:
          TaskTypes.values.contains(input.taskType)
              ? input.taskType
              : TaskTypes.task,
      captureMode: captureMode,
      recurrence: recurrence,
      startDate: _dateOnly(input.startDate),
      dueDate: isRecurring ? null : _dateOnlyOrNull(input.dueDate),
      activeDays: _normalizedActiveDays(input),
      missedPolicy: missedPolicy,
      missedConsequence: missedConsequence,
      bufferDays: input.bufferDays < 1 ? 1 : input.bufferDays,
      postBufferBehavior:
          missedPolicy == MissedPolicy.buffer &&
                  PostBufferBehavior.bufferValues.contains(
                    input.postBufferBehavior,
                  )
              ? input.postBufferBehavior
              : null,
      maxCarryoverCount:
          input.maxCarryoverCount < 1 ? 1 : input.maxCarryoverCount,
      goalType: goalType,
      goalValue: _normalizedGoalValue(goalType, input.goalValue),
      goalWindowDays:
          goalType == TaskGoalType.rollingSuccessCount || _isValueGoal(goalType)
              ? (input.goalWindowDays == null || input.goalWindowDays! < 1
                  ? null
                  : input.goalWindowDays)
              : null,
      goalPeriod:
          GoalPeriod.values.contains(input.goalPeriod)
              ? input.goalPeriod
              : GoalPeriod.week,
      goalPeriodAlignment:
          GoalPeriodAlignment.values.contains(input.goalPeriodAlignment)
              ? input.goalPeriodAlignment
              : GoalPeriodAlignment.calendar,
      valueType: valueType,
      valueCommitment: valueCommitment,
      valueUnitKey: valueUnitKey,
      valueUnitLabel:
          usesValueCapture && valueUnitKey == TaskValueUnitKey.custom
              ? input.valueUnitLabel.trim()
              : '',
    );
  }

  static Map<TaskConfigurationField, TaskFieldRule> rulesFor(
    TaskConfiguration config,
  ) {
    final recurring = config.isRecurring;
    final selectedDays =
        config.recurrence == HabitRecurrence.weeklyFixedDays ||
        config.recurrence == HabitRecurrence.monthlyFixedDays;
    final isPureTracking =
        config.captureMode == TaskCaptureMode.value &&
        config.valueCommitment == TaskValueCommitment.pureTracking;
    final allowedPolicies = _allowedPolicies(
      recurrence: config.recurrence,
      dueDate: config.dueDate,
      isPureTracking: isPureTracking,
    );
    final policyWarning =
        !isPureTracking && config.missedPolicy == MissedPolicy.none && recurring
            ? 'Nicht erledigte Einträge bleiben dauerhaft offen und können einen großen Rückstand erzeugen.'
            : null;
    final policyReason =
        isPureTracking
            ? 'Reines Tracking speichert nur echte Eingaben. Fehlende Tage werden nicht automatisch bewertet.'
            : allowedPolicies.length == 1
            ? 'Ohne Fälligkeitsdatum gibt es keinen automatischen Ablaufzeitpunkt.'
            : config.isCompletionBased
            ? 'Aufstauen ist hier nicht möglich, weil immer nur eine Instanz bis zum Abschluss offen bleibt.'
            : config.recurrence == HabitRecurrence.none
            ? 'Aufstauen ist nur bei wiederkehrenden Instanzen möglich.'
            : null;
    final usesConsequence =
        config.missedPolicy == MissedPolicy.direct ||
        config.missedPolicy == MissedPolicy.carryover;
    final periodGoal =
        config.goalType == TaskGoalType.countPerPeriod ||
        config.goalType == TaskGoalType.percentage ||
        config.goalType == TaskGoalType.maxFailures;
    final valueGoalAllowed =
        config.captureMode == TaskCaptureMode.value &&
        (config.valueType == TaskValueType.number ||
            config.valueType == TaskValueType.duration);
    final allowedGoalTypes =
        recurring
            ? valueGoalAllowed
                ? TaskGoalType.values
                : TaskGoalType.values
                    .where((goalType) => !_isValueGoal(goalType))
                    .toSet()
            : const {TaskGoalType.none};

    return {
      TaskConfigurationField.dueDate: TaskFieldRule(
        availability:
            recurring
                ? TaskFieldAvailability.disabled
                : TaskFieldAvailability.optional,
        reason:
            recurring
                ? 'Wiederkehrende Aufgaben erzeugen eigene datierte Instanzen.'
                : null,
      ),
      TaskConfigurationField.activeDays: TaskFieldRule(
        availability:
            selectedDays
                ? TaskFieldAvailability.required
                : TaskFieldAvailability.disabled,
        reason:
            selectedDays
                ? null
                : 'Dieser Rhythmus benötigt keine Auswahl einzelner Tage.',
      ),
      TaskConfigurationField.missedPolicy: TaskFieldRule(
        availability:
            allowedPolicies.length == 1
                ? TaskFieldAvailability.automatic
                : TaskFieldAvailability.optional,
        allowedValues: allowedPolicies,
        reason: policyReason,
        warning: policyWarning,
      ),
      TaskConfigurationField.missedConsequence: TaskFieldRule(
        availability:
            usesConsequence
                ? TaskFieldAvailability.required
                : TaskFieldAvailability.disabled,
        allowedValues: _allowedConsequences(config.captureMode),
        reason:
            usesConsequence
                ? 'Nach Ablauf kann die Instanz als nicht erfolgreich oder als Kein Eintrag gewertet werden.'
                : 'Die gewählte Missed Policy benötigt hier keine Konsequenz.',
      ),
      TaskConfigurationField.bufferDays: TaskFieldRule(
        availability:
            config.missedPolicy == MissedPolicy.buffer
                ? TaskFieldAvailability.required
                : TaskFieldAvailability.disabled,
        reason:
            config.missedPolicy == MissedPolicy.buffer
                ? null
                : 'Puffertage gelten nur für die Missed Policy Puffer.',
        warning:
            config.missedPolicy == MissedPolicy.buffer && config.isCalendarBased
                ? 'Der Puffer kann sich mit späteren Instanzen überschneiden. Dadurch können mehrere Karten gleichzeitig offen sein.'
                : null,
      ),
      TaskConfigurationField.postBufferBehavior: TaskFieldRule(
        availability:
            config.missedPolicy == MissedPolicy.buffer
                ? TaskFieldAvailability.required
                : TaskFieldAvailability.disabled,
        allowedValues: PostBufferBehavior.bufferValues,
        warning:
            config.missedPolicy == MissedPolicy.buffer &&
                    config.postBufferBehavior ==
                        PostBufferBehavior.markAsNoEntry
                ? 'Kein Eintrag bleibt neutral. Das ist erlaubt, kann aber Auswertungen weniger eindeutig machen.'
                : null,
        reason:
            config.missedPolicy == MissedPolicy.buffer
                ? null
                : 'Ein Verhalten nach dem Puffer wird nur bei einem Puffer benötigt.',
      ),
      TaskConfigurationField.maxCarryoverCount: TaskFieldRule(
        availability:
            config.missedPolicy == MissedPolicy.carryover
                ? TaskFieldAvailability.required
                : TaskFieldAvailability.disabled,
        reason:
            config.missedPolicy == MissedPolicy.carryover
                ? null
                : 'Eine Aufstaugrenze gilt nur für die Missed Policy Aufstauen.',
      ),
      TaskConfigurationField.goalType: TaskFieldRule(
        availability:
            recurring
                ? TaskFieldAvailability.optional
                : TaskFieldAvailability.automatic,
        allowedValues: allowedGoalTypes,
        reason:
            recurring
                ? null
                : 'Zeitraumziele benötigen wiederkehrende Instanzen.',
      ),
      TaskConfigurationField.goalValue: TaskFieldRule(
        availability:
            config.goalType == TaskGoalType.none
                ? TaskFieldAvailability.disabled
                : TaskFieldAvailability.required,
        reason:
            config.goalType == TaskGoalType.none
                ? 'Ohne Ziel wird kein Zielwert benötigt.'
                : null,
      ),
      TaskConfigurationField.goalWindowDays: TaskFieldRule(
        availability:
            config.goalType == TaskGoalType.rollingSuccessCount ||
                    _isValueGoal(config.goalType)
                ? TaskFieldAvailability.required
                : TaskFieldAvailability.disabled,
        reason:
            config.goalType == TaskGoalType.rollingSuccessCount ||
                    _isValueGoal(config.goalType)
                ? null
                : 'Ein rollierendes Fenster gilt nur für rollierende Status- und Wertziele.',
      ),
      TaskConfigurationField.goalPeriod: TaskFieldRule(
        availability:
            periodGoal
                ? TaskFieldAvailability.required
                : TaskFieldAvailability.disabled,
        allowedValues: GoalPeriod.values,
        reason:
            periodGoal
                ? null
                : 'Der gewählte Zieltyp benötigt keinen Kalenderzeitraum.',
      ),
      TaskConfigurationField.goalPeriodAlignment: TaskFieldRule(
        availability:
            periodGoal
                ? TaskFieldAvailability.required
                : TaskFieldAvailability.disabled,
        allowedValues: GoalPeriodAlignment.values,
        reason:
            periodGoal
                ? null
                : 'Der gewählte Zieltyp benötigt keine Zeitraum-Ausrichtung.',
      ),
    };
  }

  static void _validateActiveDays(
    TaskConfiguration input,
    List<TaskValidationIssue> issues,
  ) {
    if (input.recurrence == HabitRecurrence.weeklyFixedDays &&
        (input.activeDays.isEmpty ||
            input.activeDays.any((day) => !_allDays.contains(day)))) {
      issues.add(
        const TaskValidationIssue(
          code: 'invalid_weekdays',
          message: 'Bitte wähle mindestens einen gültigen Wochentag.',
          field: TaskConfigurationField.activeDays,
        ),
      );
    }

    if (input.recurrence == HabitRecurrence.monthlyFixedDays &&
        (input.activeDays.isEmpty ||
            input.activeDays.any((day) => !_monthDays.contains(day)))) {
      issues.add(
        const TaskValidationIssue(
          code: 'invalid_month_days',
          message: 'Bitte wähle mindestens einen gültigen Monatstag.',
          field: TaskConfigurationField.activeDays,
        ),
      );
    }
  }

  static void _validateMissedPolicy(
    TaskConfiguration input,
    Map<TaskConfigurationField, TaskFieldRule> rules,
    List<TaskValidationIssue> issues,
  ) {
    final policyRule = rules[TaskConfigurationField.missedPolicy]!;
    if (!MissedPolicy.values.contains(input.missedPolicy) ||
        !policyRule.allowedValues.contains(input.missedPolicy)) {
      issues.add(
        const TaskValidationIssue(
          code: 'invalid_missed_policy',
          message: 'Die Missed Policy ist für diese Aufgabe nicht zulässig.',
          field: TaskConfigurationField.missedPolicy,
        ),
      );
      return;
    }

    if ((input.missedPolicy == MissedPolicy.direct ||
            input.missedPolicy == MissedPolicy.carryover) &&
        !_allowedConsequences(
          input.captureMode,
        ).contains(input.missedConsequence)) {
      issues.add(
        const TaskValidationIssue(
          code: 'invalid_missed_consequence',
          message: 'Die Konsequenz passt nicht zum Erfassungsmodus.',
          field: TaskConfigurationField.missedConsequence,
        ),
      );
    }

    if (input.missedPolicy == MissedPolicy.buffer) {
      if (input.bufferDays < 1) {
        issues.add(
          const TaskValidationIssue(
            code: 'invalid_buffer_days',
            message: 'Der Puffer muss mindestens einen Tag betragen.',
            field: TaskConfigurationField.bufferDays,
          ),
        );
      }
      final maxBufferDays = _maxBufferDays(input);
      if (maxBufferDays != null && input.bufferDays > maxBufferDays) {
        issues.add(
          TaskValidationIssue(
            code: 'buffer_too_long',
            message:
                'Der Puffer darf bei diesem Rhythmus maximal $maxBufferDays Tage betragen.',
            field: TaskConfigurationField.bufferDays,
          ),
        );
      }
      if (!PostBufferBehavior.bufferValues.contains(input.postBufferBehavior)) {
        issues.add(
          const TaskValidationIssue(
            code: 'missing_post_buffer_behavior',
            message:
                'Bitte waehle Misserfolg oder Kein Eintrag als Folge nach dem Puffer.',
            field: TaskConfigurationField.postBufferBehavior,
          ),
        );
      }
    }

    if (input.missedPolicy == MissedPolicy.carryover &&
        input.maxCarryoverCount < 1) {
      issues.add(
        const TaskValidationIssue(
          code: 'invalid_carryover_count',
          message: 'Die Aufstaugrenze muss mindestens eins betragen.',
          field: TaskConfigurationField.maxCarryoverCount,
        ),
      );
    }
  }

  static void _validateGoal(
    TaskConfiguration input,
    List<TaskValidationIssue> issues,
  ) {
    final valueGoalAllowed =
        input.captureMode == TaskCaptureMode.value &&
        (input.valueType == TaskValueType.number ||
            input.valueType == TaskValueType.duration);
    if (!TaskGoalType.values.contains(input.goalType) ||
        (_isValueGoal(input.goalType) && !valueGoalAllowed) ||
        (!input.isRecurring && input.goalType != TaskGoalType.none)) {
      issues.add(
        const TaskValidationIssue(
          code: 'invalid_goal_type',
          message: 'Der Zieltyp ist für diese Aufgabe nicht zulässig.',
          field: TaskConfigurationField.goalType,
        ),
      );
      return;
    }

    if (input.isRecurring &&
        input.goalType != TaskGoalType.none &&
        input.missedPolicy == MissedPolicy.none) {
      issues.add(
        const TaskValidationIssue(
          code: 'goal_requires_missed_policy',
          message:
              'Ziele brauchen eine Regel für verpasste Einträge, damit sie später sauber bewertet werden können.',
          field: TaskConfigurationField.missedPolicy,
        ),
      );
    }

    if (input.goalType == TaskGoalType.percentage &&
        (input.goalValue < 1 || input.goalValue > 100)) {
      issues.add(
        const TaskValidationIssue(
          code: 'invalid_percentage_goal',
          message: 'Ein Prozentziel muss zwischen 1 und 100 liegen.',
          field: TaskConfigurationField.goalValue,
        ),
      );
    } else if ((input.goalType == TaskGoalType.countPerPeriod ||
            input.goalType == TaskGoalType.rollingSuccessCount) &&
        input.goalValue < 1) {
      issues.add(
        const TaskValidationIssue(
          code: 'invalid_count_goal',
          message: 'Die Zielanzahl muss mindestens eins betragen.',
          field: TaskConfigurationField.goalValue,
        ),
      );
    } else if (_isValueGoal(input.goalType) && input.goalValue < 1) {
      issues.add(
        const TaskValidationIssue(
          code: 'invalid_value_goal',
          message: 'Der Wertzielwert muss mindestens eins betragen.',
          field: TaskConfigurationField.goalValue,
        ),
      );
    } else if (input.goalType == TaskGoalType.maxFailures &&
        input.goalValue < 0) {
      issues.add(
        const TaskValidationIssue(
          code: 'invalid_failure_goal',
          message: 'Die maximale Anzahl Fehlschläge darf nicht negativ sein.',
          field: TaskConfigurationField.goalValue,
        ),
      );
    }

    if ((input.goalType == TaskGoalType.rollingSuccessCount ||
            _isValueGoal(input.goalType)) &&
        (input.goalWindowDays == null || input.goalWindowDays! < 1)) {
      issues.add(
        const TaskValidationIssue(
          code: 'invalid_goal_window',
          message: 'Der Zielzeitraum muss mindestens einen Tag betragen.',
          field: TaskConfigurationField.goalWindowDays,
        ),
      );
    }

    final usesPeriod =
        input.goalType == TaskGoalType.countPerPeriod ||
        input.goalType == TaskGoalType.percentage ||
        input.goalType == TaskGoalType.maxFailures;
    if (usesPeriod && !GoalPeriod.values.contains(input.goalPeriod)) {
      issues.add(
        const TaskValidationIssue(
          code: 'invalid_goal_period',
          message: 'Der Zielzeitraum ist nicht gültig.',
          field: TaskConfigurationField.goalPeriod,
        ),
      );
    }
    if (usesPeriod &&
        !GoalPeriodAlignment.values.contains(input.goalPeriodAlignment)) {
      issues.add(
        const TaskValidationIssue(
          code: 'invalid_goal_alignment',
          message: 'Die Zeitraum-Ausrichtung ist nicht gültig.',
          field: TaskConfigurationField.goalPeriodAlignment,
        ),
      );
    }
  }

  static void _validateValueCapture(
    TaskConfiguration input,
    List<TaskValidationIssue> issues,
  ) {
    if (input.captureMode != TaskCaptureMode.value) {
      return;
    }

    if (!TaskValueType.phase12Values.contains(input.valueType)) {
      issues.add(
        const TaskValidationIssue(
          code: 'invalid_value_type',
          message: 'Der Werttyp ist nicht gültig.',
          field: TaskConfigurationField.valueType,
        ),
      );
    }

    if (!TaskValueCommitment.values.contains(input.valueCommitment) ||
        input.valueCommitment == TaskValueCommitment.none) {
      issues.add(
        const TaskValidationIssue(
          code: 'invalid_value_commitment',
          message:
              'Bitte wähle, ob es reines Tracking oder eine Pflicht-Eingabe ist.',
          field: TaskConfigurationField.valueCommitment,
        ),
      );
    }

    if (!_allowedUnitKeysForValueType(
      input.valueType,
    ).contains(input.valueUnitKey)) {
      issues.add(
        const TaskValidationIssue(
          code: 'invalid_value_unit',
          message: 'Die Einheit passt nicht zum Werttyp.',
          field: TaskConfigurationField.valueUnitKey,
        ),
      );
    }

    if (input.valueUnitKey == TaskValueUnitKey.custom &&
        input.valueUnitLabel.trim().isEmpty) {
      issues.add(
        const TaskValidationIssue(
          code: 'missing_custom_unit_label',
          message: 'Bitte gib eine eigene Beschriftung ein.',
          field: TaskConfigurationField.valueUnitLabel,
        ),
      );
    }
  }

  static Set<String> _allowedPolicies({
    required String recurrence,
    required DateTime? dueDate,
    required bool isPureTracking,
  }) {
    if (isPureTracking) {
      return const {MissedPolicy.none};
    }

    if (recurrence == HabitRecurrence.none) {
      return dueDate == null
          ? const {MissedPolicy.none}
          : const {MissedPolicy.none, MissedPolicy.direct, MissedPolicy.buffer};
    }

    if (recurrence == HabitRecurrence.weeklyAfterCompletion ||
        HabitRecurrence.isCustomAfterCompletion(recurrence)) {
      return const {
        MissedPolicy.none,
        MissedPolicy.direct,
        MissedPolicy.buffer,
      };
    }

    return MissedPolicy.values;
  }

  static Set<String> _allowedConsequences(String captureMode) {
    return MissedConsequence.values;
  }

  static Set<String> _allowedUnitKeysForValueType(String valueType) {
    if (valueType == TaskValueType.duration) {
      return const {
        TaskValueUnitKey.hour,
        TaskValueUnitKey.minute,
        TaskValueUnitKey.second,
      };
    }

    if (valueType == TaskValueType.timeOfDay) {
      return const {TaskValueUnitKey.timeOfDay};
    }

    if (valueType == TaskValueType.number) {
      return const {
        TaskValueUnitKey.liter,
        TaskValueUnitKey.milliliter,
        TaskValueUnitKey.kilometer,
        TaskValueUnitKey.meter,
        TaskValueUnitKey.centimeter,
        TaskValueUnitKey.custom,
      };
    }

    return const {};
  }

  static bool _isKnownRecurrence(String recurrence) {
    if (recurrence == HabitRecurrence.none ||
        recurrence == HabitRecurrence.daily ||
        recurrence == HabitRecurrence.weeklyFixedDays ||
        recurrence == HabitRecurrence.weeklyAfterCompletion ||
        recurrence == HabitRecurrence.monthlyFixedDays) {
      return true;
    }

    if (!HabitRecurrence.isCustomAfterCompletion(recurrence)) {
      return false;
    }

    final rawDays = recurrence.substring(
      HabitRecurrence.customAfterCompletionPrefix.length,
    );
    final days = int.tryParse(rawDays);
    return days != null && days >= 1;
  }

  static Set<int> _normalizedActiveDays(TaskConfiguration input) {
    if (input.recurrence == HabitRecurrence.weeklyFixedDays) {
      final validDays = input.activeDays.where(_allDays.contains).toSet();
      return validDays.isEmpty ? {1} : validDays;
    }
    if (input.recurrence == HabitRecurrence.monthlyFixedDays) {
      final validDays = input.activeDays.where(_monthDays.contains).toSet();
      return validDays.isEmpty ? {1} : validDays;
    }
    return _allDays;
  }

  static int _normalizedGoalValue(String goalType, int value) {
    if (goalType == TaskGoalType.none) {
      return 1;
    }
    if (goalType == TaskGoalType.percentage) {
      return value.clamp(1, 100).toInt();
    }
    if (goalType == TaskGoalType.maxFailures) {
      return value < 0 ? 0 : value;
    }
    if (_isValueGoal(goalType)) {
      return value < 1 ? 1 : value;
    }
    return value < 1 ? 1 : value;
  }

  static bool _isValueGoal(String goalType) {
    return goalType == TaskGoalType.valueSumMin ||
        goalType == TaskGoalType.valueAverageMin ||
        goalType == TaskGoalType.valueAverageMax;
  }

  static int? _maxBufferDays(TaskConfiguration config) {
    if (!config.isCalendarBased) {
      return null;
    }

    final firstDueDate = _firstCalendarDueDateOnOrAfter(
      config,
      _dateOnly(config.startDate),
    );
    if (firstDueDate == null) {
      return null;
    }

    final nextDueDate = _nextCalendarDueDateAfter(config, firstDueDate);
    if (nextDueDate == null) {
      return null;
    }

    final intervalDays = nextDueDate.difference(firstDueDate).inDays;
    if (intervalDays < 1) {
      return null;
    }

    return intervalDays * 2;
  }

  static DateTime? _firstCalendarDueDateOnOrAfter(
    TaskConfiguration config,
    DateTime from,
  ) {
    var date = _dateOnly(from);
    for (var i = 0; i < 800; i++) {
      if (_isCalendarDueOn(config, date)) {
        return date;
      }
      date = date.add(const Duration(days: 1));
    }
    return null;
  }

  static DateTime? _nextCalendarDueDateAfter(
    TaskConfiguration config,
    DateTime after,
  ) {
    var date = _dateOnly(after).add(const Duration(days: 1));
    for (var i = 0; i < 800; i++) {
      if (_isCalendarDueOn(config, date)) {
        return date;
      }
      date = date.add(const Duration(days: 1));
    }
    return null;
  }

  static bool _isCalendarDueOn(TaskConfiguration config, DateTime date) {
    if (date.isBefore(_dateOnly(config.startDate))) {
      return false;
    }

    if (config.recurrence == HabitRecurrence.daily) {
      return true;
    }

    if (config.recurrence == HabitRecurrence.weeklyFixedDays) {
      return config.activeDays.contains(date.weekday);
    }

    if (config.recurrence == HabitRecurrence.monthlyFixedDays) {
      return config.activeDays.contains(date.day) ||
          (config.activeDays.contains(32) && _isLastDayOfMonth(date));
    }

    return false;
  }
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

DateTime? _dateOnlyOrNull(DateTime? date) =>
    date == null ? null : _dateOnly(date);

bool _isLastDayOfMonth(DateTime date) {
  final nextDay = date.add(const Duration(days: 1));
  return nextDay.day == 1;
}
