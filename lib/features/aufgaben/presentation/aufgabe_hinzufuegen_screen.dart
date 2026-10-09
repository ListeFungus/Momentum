import 'package:flutter/material.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
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
import 'package:momentum/features/aufgaben/presentation/task_creation_mode.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/due_date_field.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/habit_rhythm_field.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/missed_policy_field.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/project_dropdown_field.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_goal_field.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_type_field.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_value_configuration_field.dart';
import 'package:momentum/features/projekte/data/project_repository.dart';

class AufgabeHinzufuegenScreen extends StatefulWidget {
  const AufgabeHinzufuegenScreen({
    required this.aufgabenRepository,
    required this.projectRepository,
    this.creationMode = TaskCreationMode.task,
    this.template,
    this.initialProjectId,
    super.key,
  });

  final AufgabenRepository aufgabenRepository;
  final ProjectRepository projectRepository;
  final TaskCreationMode creationMode;
  final Aufgabe? template;
  final String? initialProjectId;

  @override
  State<AufgabeHinzufuegenScreen> createState() =>
      _AufgabeHinzufuegenScreenState();
}

class _AufgabeHinzufuegenScreenState extends State<AufgabeHinzufuegenScreen> {
  static const _captureModes = {
    TaskCaptureMode.checkbox: 'Erledigt / Offen',
    TaskCaptureMode.threeState: 'Ja / Nein',
    TaskCaptureMode.value: 'Wert erfassen',
  };
  static const _dailyWeekdays = {1, 2, 3, 4, 5, 6, 7};

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _questionController = TextEditingController();

  String _selectedCaptureMode = _captureModes.keys.first;
  late String _selectedTaskType;
  String _selectedProjectId = '';
  String _selectedRecurrence = HabitRecurrence.daily;
  Set<int> _selectedDays = {..._dailyWeekdays};
  final bool _successValue = true;
  DateTime? _dueDate;
  late DateTime _startDate;
  String _selectedMissedPolicy = MissedPolicy.none;
  String _selectedMissedConsequence = MissedConsequence.markAsNotDone;
  int _missedBufferDays = 1;
  String _selectedPostBufferBehavior = PostBufferBehavior.markAsFailure;
  int _maxCarryoverCount = 3;
  String _selectedGoalType = TaskGoalType.none;
  int _goalValue = 1;
  int _goalWindowDays = 7;
  String _selectedGoalPeriod = GoalPeriod.week;
  String _selectedGoalPeriodAlignment = GoalPeriodAlignment.calendar;
  String _selectedValueType = TaskValueType.number;
  String _selectedValueCommitment = TaskValueCommitment.pureTracking;
  String _selectedValueUnitKey = TaskValueUnitKey.liter;
  String _selectedValueUnitLabel = '';
  bool _isSaving = false;

  bool get _isAdvancedMode => widget.creationMode == TaskCreationMode.advanced;

  bool get _isHabit => _selectedTaskType == TaskTypes.habit;

  bool get _showHabitFields => _isHabit;

  bool get _showTaskTypeField => _isAdvancedMode;

  bool get _showRhythmField => _isAdvancedMode || !_isHabit;

  bool get _showDueDateField => _isAdvancedMode || !_isHabit;

  bool get _showStartDateField =>
      _isAdvancedMode ||
      _isHabit ||
      _selectedRecurrence != HabitRecurrence.none;

  bool get _showThreeStateInfo =>
      _selectedCaptureMode == TaskCaptureMode.threeState;

  bool get _usesThreeStateCapture =>
      _selectedCaptureMode == TaskCaptureMode.threeState;

  bool get _usesValueCapture => _selectedCaptureMode == TaskCaptureMode.value;

  bool get _selectedGoalUsesWindow =>
      _selectedGoalType == TaskGoalType.rollingSuccessCount ||
      _selectedGoalType == TaskGoalType.valueSumMin ||
      _selectedGoalType == TaskGoalType.valueAverageMin ||
      _selectedGoalType == TaskGoalType.valueAverageMax;

  TaskConfiguration get _currentConfiguration => TaskConfiguration(
    taskType: _selectedTaskType,
    captureMode: _selectedCaptureMode,
    recurrence: _selectedRecurrence,
    startDate: _startDate,
    dueDate: _dueDate,
    activeDays: _selectedDays,
    missedPolicy: _selectedMissedPolicy,
    missedConsequence: _selectedMissedConsequence,
    bufferDays: _missedBufferDays,
    postBufferBehavior: _selectedPostBufferBehavior,
    maxCarryoverCount: _maxCarryoverCount,
    goalType: _selectedGoalType,
    goalValue: _goalValue,
    goalWindowDays: _selectedGoalUsesWindow ? _goalWindowDays : null,
    goalPeriod: _selectedGoalPeriod,
    goalPeriodAlignment: _selectedGoalPeriodAlignment,
    valueType: _usesValueCapture ? _selectedValueType : TaskValueType.none,
    valueCommitment:
        _usesValueCapture ? _selectedValueCommitment : TaskValueCommitment.none,
    valueUnitKey:
        _usesValueCapture ? _selectedValueUnitKey : TaskValueUnitKey.none,
    valueUnitLabel: _usesValueCapture ? _selectedValueUnitLabel : '',
  );

  TaskConfigurationValidation get _configurationValidation =>
      TaskConfigurationValidator.validate(_currentConfiguration);

  @override
  void initState() {
    super.initState();
    final template = widget.template;
    if (template != null) {
      _nameController.text = '${template.name} – Kopie';
      _descriptionController.text = template.beschreibung;
      _questionController.text = template.questionText;
      _selectedTaskType = template.taskType;
      _selectedProjectId = template.projectId ?? '';
      _selectedRecurrence = template.recurrence;
      _selectedDays =
          template.activeWeekdays
              .split(',')
              .map(int.tryParse)
              .whereType<int>()
              .toSet();
      _selectedCaptureMode = template.erfassungsmodus;
      _selectedMissedPolicy = template.missedPolicy;
      _selectedMissedConsequence = template.missedConsequence;
      _missedBufferDays = template.missedBufferDays;
      _selectedPostBufferBehavior = template.postBufferBehavior;
      _maxCarryoverCount = template.maxCarryoverCount;
      _selectedValueType =
          template.valueType == TaskValueType.none
              ? TaskValueType.number
              : template.valueType;
      _selectedValueCommitment =
          template.valueCommitment == TaskValueCommitment.none
              ? TaskValueCommitment.pureTracking
              : template.valueCommitment;
      _selectedValueUnitKey =
          template.valueUnitKey == TaskValueUnitKey.none
              ? _defaultUnitKeyForValueType(_selectedValueType)
              : template.valueUnitKey;
      _selectedValueUnitLabel = template.valueUnitLabel;
      _selectedGoalType = TaskGoalType.none;
      _goalValue = 1;
      _goalWindowDays = 7;
      _dueDate = null;
      _startDate = _dateOnly(DateTime.now());
      _sanitizeSelections();
      return;
    }
    _selectedTaskType =
        widget.creationMode == TaskCreationMode.habit
            ? TaskTypes.habit
            : TaskTypes.task;
    _selectedProjectId = widget.initialProjectId ?? '';
    _selectedRecurrence =
        _selectedTaskType == TaskTypes.habit
            ? HabitRecurrence.daily
            : HabitRecurrence.none;
    _selectedCaptureMode =
        _selectedTaskType == TaskTypes.habit
            ? TaskCaptureMode.threeState
            : TaskCaptureMode.checkbox;
    _selectedMissedConsequence = MissedConsequence.markAsNotDone;
    _startDate = _dateOnly(DateTime.now());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final configurationValidation = _configurationValidation;
    if (!configurationValidation.canSave) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(configurationValidation.issues.first.message)),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await widget.aufgabenRepository.createTask(
        name: _nameController.text,
        beschreibung: _descriptionController.text,
        erfassungsmodus: _selectedCaptureMode,
        projectId: _selectedProjectId.isEmpty ? null : _selectedProjectId,
        taskType: _selectedTaskType,
        startDate: _startDate,
        dueDate: configurationValidation.configuration.dueDate,
        questionText: _showHabitFields ? _questionController.text : '',
        successValue: _successValue,
        activeWeekdays: _usesSelectedDays ? _selectedDays : _dailyWeekdays,
        recurrence: _selectedRecurrence,
        missedPolicy: _selectedMissedPolicy,
        missedConsequence: _selectedMissedConsequence,
        missedBufferDays: _missedBufferDays,
        postBufferBehavior: _selectedPostBufferBehavior,
        maxCarryoverCount: _maxCarryoverCount,
        goalType: _selectedGoalType,
        goalValue: _goalValue,
        goalWindowDays: _selectedGoalUsesWindow ? _goalWindowDays : null,
        goalPeriod: _selectedGoalPeriod,
        goalPeriodAlignment: _selectedGoalPeriodAlignment,
        valueType: _usesValueCapture ? _selectedValueType : TaskValueType.none,
        valueCommitment:
            _usesValueCapture
                ? _selectedValueCommitment
                : TaskValueCommitment.none,
        valueUnitKey:
            _usesValueCapture ? _selectedValueUnitKey : TaskValueUnitKey.none,
        valueUnitLabel: _usesValueCapture ? _selectedValueUnitLabel : '',
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Die Aufgabe konnte nicht gespeichert werden.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _selectTaskType(String taskType) {
    setState(() {
      _selectedTaskType = taskType;

      if (taskType == TaskTypes.habit) {
        _dueDate = null;
        if (_selectedRecurrence == HabitRecurrence.none) {
          _selectedRecurrence = HabitRecurrence.daily;
        }
      }

      _sanitizeSelections();
    });
  }

  bool get _usesSelectedDays =>
      _selectedRecurrence == HabitRecurrence.weeklyFixedDays ||
      _selectedRecurrence == HabitRecurrence.monthlyFixedDays;

  void _sanitizeSelections() {
    final normalized = TaskConfigurationValidator.normalize(
      _currentConfiguration,
    );
    _dueDate = normalized.dueDate;
    _selectedDays = {...normalized.activeDays};
    _selectedMissedPolicy = normalized.missedPolicy;
    _selectedMissedConsequence = normalized.missedConsequence;
    _missedBufferDays = normalized.bufferDays;
    _maxCarryoverCount = normalized.maxCarryoverCount;
    _selectedGoalType = normalized.goalType;
    _goalValue = normalized.goalValue;
    _goalWindowDays = normalized.goalWindowDays ?? 7;
    _selectedGoalPeriod = normalized.goalPeriod;
    _selectedGoalPeriodAlignment = normalized.goalPeriodAlignment;
    if (_usesValueCapture) {
      _selectedValueType =
          normalized.valueType == TaskValueType.none
              ? _selectedValueType
              : normalized.valueType;
      _selectedValueCommitment =
          normalized.valueCommitment == TaskValueCommitment.none
              ? _selectedValueCommitment
              : normalized.valueCommitment;
      _selectedValueUnitKey =
          normalized.valueUnitKey == TaskValueUnitKey.none
              ? _selectedValueUnitKey
              : normalized.valueUnitKey;
      _selectedValueUnitLabel = normalized.valueUnitLabel;
    }
  }

  void _selectCaptureMode(String mode) {
    setState(() {
      _selectedCaptureMode = mode;
      _selectedMissedConsequence = MissedConsequence.markAsNotDone;
      _sanitizeSelections();
    });
  }

  void _selectValueType(String valueType) {
    setState(() {
      _selectedValueType = valueType;
      _selectedValueUnitKey = _defaultUnitKeyForValueType(valueType);
      _selectedValueUnitLabel = '';
    });
  }

  List<Widget> _buildCaptureModeFields(BuildContext context) {
    return [
      DropdownButtonFormField<String>(
        isExpanded: true,
        value: _selectedCaptureMode,
        decoration: const InputDecoration(
          labelText: 'Erfassungsmodus',
          helperText:
              'Ja / Nein speichert nur bewusste Antworten. Keine Auswahl bleibt offen.',
          border: OutlineInputBorder(),
        ),
        items:
            _captureModes.entries
                .map(
                  (mode) => DropdownMenuItem(
                    value: mode.key,
                    child: Text(mode.value),
                  ),
                )
                .toList(),
        onChanged:
            _isSaving
                ? null
                : (mode) {
                  if (mode != null) {
                    _selectCaptureMode(mode);
                  }
                },
      ),
      if (_showThreeStateInfo) ...[
        const SizedBox(height: 20),
        const _ThreeStateInfoBox(),
      ],
      if (_usesValueCapture) ...[
        const SizedBox(height: 20),
        TaskValueConfigurationField(
          valueType: _selectedValueType,
          valueCommitment: _selectedValueCommitment,
          unitKey: _selectedValueUnitKey,
          unitLabel: _selectedValueUnitLabel,
          enabled: !_isSaving,
          onValueTypeChanged: _selectValueType,
          onValueCommitmentChanged: (commitment) {
            setState(() {
              _selectedValueCommitment = commitment;
              _sanitizeSelections();
            });
          },
          onUnitKeyChanged: (unitKey) {
            setState(() {
              _selectedValueUnitKey = unitKey;
              if (unitKey != TaskValueUnitKey.custom) {
                _selectedValueUnitLabel = '';
              }
            });
          },
          onUnitLabelChanged: (label) {
            setState(() {
              _selectedValueUnitLabel = label;
            });
          },
        ),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final configurationValidation = _configurationValidation;
    final rules = configurationValidation.rules;
    final dueDateRule = rules[TaskConfigurationField.dueDate]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.template == null
              ? widget.creationMode.title
              : 'Als neue Aufgabe kopieren',
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<List<Project>>(
          stream: widget.projectRepository.watchProjectChoices(),
          builder: (context, snapshot) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _CreationModeIntro(text: widget.creationMode.introText),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        hintText: 'Was möchtest du erfassen?',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Bitte gib einen Namen ein.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Beschreibung',
                        hintText: 'Optional: kurze Beschreibung',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                      minLines: 4,
                      maxLines: 8,
                    ),
                    const SizedBox(height: 20),
                    ..._buildCaptureModeFields(context),
                    if (_showTaskTypeField) ...[
                      const SizedBox(height: 20),
                      TaskTypeField(
                        selectedTaskType: _selectedTaskType,
                        enabled: !_isSaving,
                        onChanged: _selectTaskType,
                      ),
                    ],
                    if (_showHabitFields) ...[
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _questionController,
                        decoration: const InputDecoration(
                          labelText: 'Frage / Anzeigetext',
                          hintText: 'Zum Beispiel: Heute trainiert?',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                    if (_showDueDateField) ...[
                      const SizedBox(height: 20),
                      DueDateField(
                        dueDate: _dueDate,
                        enabled: !_isSaving && dueDateRule.isEnabled,
                        helperText: dueDateRule.reason,
                        onChanged: (dueDate) {
                          setState(() {
                            _dueDate = dueDate;
                            _sanitizeSelections();
                          });
                        },
                      ),
                    ],
                    if (_showStartDateField) ...[
                      const SizedBox(height: 20),
                      StartDateField(
                        startDate: _startDate,
                        enabled: !_isSaving,
                        onChanged: (startDate) {
                          setState(() {
                            _startDate = startDate;
                            _sanitizeSelections();
                          });
                        },
                      ),
                    ],
                    if (_showRhythmField) ...[
                      const SizedBox(height: 20),
                      HabitRhythmField(
                        recurrence: _selectedRecurrence,
                        selectedDays: _selectedDays,
                        enabled: !_isSaving,
                        includeNone: !_isHabit,
                        onRecurrenceChanged: (recurrence) {
                          setState(() {
                            _selectedRecurrence = recurrence;
                            if (recurrence ==
                                HabitRecurrence.monthlyFixedDays) {
                              _selectedDays = {1};
                            } else if (recurrence ==
                                HabitRecurrence.weeklyFixedDays) {
                              _selectedDays = {..._dailyWeekdays};
                            }
                            _sanitizeSelections();
                          });
                        },
                        onDaysChanged: (days) {
                          setState(() {
                            _selectedDays = days;
                          });
                        },
                      ),
                    ] else ...[
                      const SizedBox(height: 20),
                      const _DailyHabitInfo(),
                    ],
                    const SizedBox(height: 20),
                    MissedPolicyField(
                      selectedPolicy: _selectedMissedPolicy,
                      selectedConsequence: _selectedMissedConsequence,
                      selectedPostBufferBehavior: _selectedPostBufferBehavior,
                      bufferDays: _missedBufferDays,
                      maxCarryoverCount: _maxCarryoverCount,
                      usesThreeStateCapture: _usesThreeStateCapture,
                      policyRule: rules[TaskConfigurationField.missedPolicy]!,
                      consequenceRule:
                          rules[TaskConfigurationField.missedConsequence]!,
                      bufferDaysRule: rules[TaskConfigurationField.bufferDays]!,
                      postBufferBehaviorRule:
                          rules[TaskConfigurationField.postBufferBehavior]!,
                      maxCarryoverCountRule:
                          rules[TaskConfigurationField.maxCarryoverCount]!,
                      enabled: !_isSaving,
                      onPolicyChanged: (policy) {
                        setState(() {
                          _selectedMissedPolicy = policy;
                          _sanitizeSelections();
                        });
                      },
                      onConsequenceChanged: (consequence) {
                        setState(() {
                          _selectedMissedConsequence = consequence;
                        });
                      },
                      onPostBufferBehaviorChanged: (behavior) {
                        setState(() {
                          _selectedPostBufferBehavior = behavior;
                        });
                      },
                      onBufferDaysChanged: (days) {
                        setState(() {
                          _missedBufferDays = days;
                        });
                      },
                      onMaxCarryoverCountChanged: (count) {
                        setState(() {
                          _maxCarryoverCount = count;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TaskGoalField(
                      selectedGoalType: _selectedGoalType,
                      goalValue: _goalValue,
                      goalWindowDays: _goalWindowDays,
                      selectedPeriod: _selectedGoalPeriod,
                      selectedPeriodAlignment: _selectedGoalPeriodAlignment,
                      supportsPeriodGoals:
                          rules[TaskConfigurationField.goalType]!.isEnabled,
                      valueType:
                          _usesValueCapture
                              ? _selectedValueType
                              : TaskValueType.none,
                      enabled: !_isSaving,
                      onGoalTypeChanged: (goalType) {
                        setState(() {
                          _selectedGoalType = goalType;

                          if (goalType == TaskGoalType.percentage) {
                            _goalValue = 80;
                          } else if (goalType == TaskGoalType.maxFailures) {
                            _goalValue = 0;
                          } else if (goalType == TaskGoalType.countPerPeriod) {
                            _goalValue = 1;
                          } else if (goalType ==
                              TaskGoalType.rollingSuccessCount) {
                            _goalValue = 3;
                            _goalWindowDays = 10;
                          } else if (goalType == TaskGoalType.valueSumMin ||
                              goalType == TaskGoalType.valueAverageMin ||
                              goalType == TaskGoalType.valueAverageMax) {
                            _goalValue = 1;
                            _goalWindowDays = 7;
                          }
                        });
                      },
                      onGoalValueChanged: (value) {
                        setState(() {
                          _goalValue = value;
                        });
                      },
                      onGoalWindowDaysChanged: (value) {
                        setState(() {
                          _goalWindowDays = value;
                        });
                      },
                      onPeriodChanged: (period) {
                        setState(() {
                          _selectedGoalPeriod = period;
                        });
                      },
                      onPeriodAlignmentChanged: (alignment) {
                        setState(() {
                          _selectedGoalPeriodAlignment = alignment;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ProjectDropdownField(
                      projects: snapshot.data ?? const [],
                      selectedProjectId: _selectedProjectId,
                      enabled: !_isSaving,
                      onChanged: (projectId) {
                        setState(() {
                          _selectedProjectId = projectId ?? '';
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      onPressed:
                          _isSaving || !configurationValidation.canSave
                              ? null
                              : _saveTask,
                      icon: const Icon(Icons.save_outlined),
                      label: Text(
                        _isSaving
                            ? 'Wird gespeichert...'
                            : widget.creationMode.saveLabel,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CreationModeIntro extends StatelessWidget {
  const _CreationModeIntro({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _DailyHabitInfo extends StatelessWidget {
  const _DailyHabitInfo();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Rhythmus: Täglich\nTageswechsel aktuell um 00:00 Uhr. Später in den allgemeinen Einstellungen änderbar.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class _ThreeStateInfoBox extends StatelessWidget {
  const _ThreeStateInfoBox();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Text(
          'Ja zählt als Erfolg. Nein zählt als nicht erfolgreich. Ohne Auswahl bleibt der Eintrag offen. Ausnahmen wie Krankheit sollen später bewusst mit Grund eingetragen werden.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

String _defaultUnitKeyForValueType(String valueType) {
  if (valueType == TaskValueType.duration) {
    return TaskValueUnitKey.minute;
  }
  if (valueType == TaskValueType.timeOfDay) {
    return TaskValueUnitKey.timeOfDay;
  }
  return TaskValueUnitKey.liter;
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);
