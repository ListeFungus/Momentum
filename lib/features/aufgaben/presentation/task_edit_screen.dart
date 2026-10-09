import 'package:flutter/material.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/habit_recurrence.dart';
import 'package:momentum/features/aufgaben/data/task_capture_mode.dart';
import 'package:momentum/features/aufgaben/data/task_configuration.dart';
import 'package:momentum/features/aufgaben/data/task_configuration_validator.dart';
import 'package:momentum/features/aufgaben/data/task_goal.dart';
import 'package:momentum/features/aufgaben/data/task_goal_evaluation_summary.dart';
import 'package:momentum/features/aufgaben/data/task_pending_definition_changes_table.dart';
import 'package:momentum/features/aufgaben/data/task_project_assignment_changes_table.dart';
import 'package:momentum/features/aufgaben/data/task_types.dart';
import 'package:momentum/features/aufgaben/data/task_value_commitment.dart';
import 'package:momentum/features/aufgaben/data/task_value_type.dart';
import 'package:momentum/features/aufgaben/data/task_value_unit.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/due_date_field.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/habit_rhythm_field.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/missed_policy_field.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/project_dropdown_field.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_goal_field.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_type_field.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_value_configuration_field.dart';
import 'package:momentum/features/aufgaben/presentation/aufgabe_hinzufuegen_screen.dart';
import 'package:momentum/features/aufgaben/presentation/task_creation_mode.dart';
import 'package:momentum/features/projekte/data/project_repository.dart';

class TaskEditScreen extends StatefulWidget {
  const TaskEditScreen({
    required this.task,
    required this.repository,
    required this.projectRepository,
    super.key,
  });

  final Aufgabe task;
  final AufgabenRepository repository;
  final ProjectRepository projectRepository;

  @override
  State<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  static const _captureModeLabels = {
    TaskCaptureMode.checkbox: 'Erledigt / Offen',
    TaskCaptureMode.threeState: 'Ja / Nein',
    TaskCaptureMode.value: 'Wert erfassen',
  };
  static const _dailyWeekdays = {1, 2, 3, 4, 5, 6, 7};

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _questionController;

  late String _selectedProjectId;
  late String _selectedTaskType;
  late String _selectedRecurrence;
  late Set<int> _selectedDays;
  late DateTime _startDate;
  DateTime? _dueDate;
  late String _selectedMissedPolicy;
  late String _selectedMissedConsequence;
  late int _missedBufferDays;
  late String _selectedPostBufferBehavior;
  late int _maxCarryoverCount;
  late String _selectedGoalType;
  late int _goalValue;
  late int _goalWindowDays;
  late String _selectedGoalPeriod;
  late String _selectedGoalPeriodAlignment;
  late String _selectedValueType;
  late String _selectedValueCommitment;
  late String _selectedValueUnitKey;
  late String _selectedValueUnitLabel;
  bool _isSaving = false;

  bool get _isHabit => _selectedTaskType == TaskTypes.habit;

  bool get _usesThreeStateCapture =>
      widget.task.erfassungsmodus == TaskCaptureMode.threeState;

  bool get _usesValueCapture =>
      widget.task.erfassungsmodus == TaskCaptureMode.value;

  bool get _selectedGoalUsesWindow =>
      _selectedGoalType == TaskGoalType.rollingSuccessCount ||
      _selectedGoalType == TaskGoalType.valueSumMin ||
      _selectedGoalType == TaskGoalType.valueAverageMin ||
      _selectedGoalType == TaskGoalType.valueAverageMax;

  bool get _usesSelectedDays =>
      _selectedRecurrence == HabitRecurrence.weeklyFixedDays ||
      _selectedRecurrence == HabitRecurrence.monthlyFixedDays;

  TaskConfiguration get _currentConfiguration => TaskConfiguration(
    taskType: _selectedTaskType,
    captureMode: widget.task.erfassungsmodus,
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
    _nameController = TextEditingController(text: widget.task.name);
    _descriptionController = TextEditingController(
      text: widget.task.beschreibung,
    );
    _questionController = TextEditingController(text: widget.task.questionText);
    _selectedProjectId = widget.task.projectId ?? '';
    _selectedTaskType = widget.task.taskType;
    _selectedRecurrence = widget.task.recurrence;
    _selectedDays =
        widget.task.activeWeekdays
            .split(',')
            .map(int.tryParse)
            .whereType<int>()
            .toSet();
    _startDate = widget.task.startDate;
    _dueDate = widget.task.dueDate;
    _selectedMissedPolicy = widget.task.missedPolicy;
    _selectedMissedConsequence = widget.task.missedConsequence;
    _missedBufferDays = widget.task.missedBufferDays;
    _selectedPostBufferBehavior = widget.task.postBufferBehavior;
    _maxCarryoverCount = widget.task.maxCarryoverCount;
    _selectedGoalType = widget.task.goalType;
    _goalValue = widget.task.goalValue;
    _goalWindowDays = widget.task.goalWindowDays ?? 7;
    _selectedGoalPeriod = widget.task.goalPeriod;
    _selectedGoalPeriodAlignment = widget.task.goalPeriodAlignment;
    _selectedValueType =
        widget.task.valueType == TaskValueType.none
            ? TaskValueType.number
            : widget.task.valueType;
    _selectedValueCommitment =
        widget.task.valueCommitment == TaskValueCommitment.none
            ? TaskValueCommitment.pureTracking
            : widget.task.valueCommitment;
    _selectedValueUnitKey =
        widget.task.valueUnitKey == TaskValueUnitKey.none
            ? _defaultUnitKeyForValueType(_selectedValueType)
            : widget.task.valueUnitKey;
    _selectedValueUnitLabel = widget.task.valueUnitLabel;
    _sanitizeSelections();
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

    final validation = _configurationValidation;
    if (!validation.canSave) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(validation.issues.first.message)));
      return;
    }

    if (!await _confirmScheduledChanges()) {
      return;
    }
    if (!await _confirmDueDateChange()) {
      return;
    }

    final goalChangeTiming = await _resolveGoalChangeTiming(
      validation.configuration,
    );
    if (goalChangeTiming == null) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final projectPlan = await _resolveProjectChange();
      if (!mounted || (_hasProjectChanged && projectPlan == null)) {
        return;
      }
      if (goalChangeTiming == _GoalChangeTiming.nextBlock) {
        await widget.repository.scheduleTaskGoalChangeForNextBlock(
          taskId: widget.task.id,
          goalType: validation.configuration.goalType,
          goalValue: validation.configuration.goalValue,
          goalWindowDays: validation.configuration.goalWindowDays,
          goalPeriod: validation.configuration.goalPeriod,
          goalPeriodAlignment: validation.configuration.goalPeriodAlignment,
        );
      } else {
        await widget.repository.updateTask(
          taskId: widget.task.id,
          name: _nameController.text,
          description: _descriptionController.text,
          projectId: widget.task.projectId,
          taskType: _selectedTaskType,
          startDate: _startDate,
          dueDate: validation.configuration.dueDate,
          questionText: _isHabit ? _questionController.text : '',
          successValue: true,
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
          valueType:
              _usesValueCapture ? _selectedValueType : TaskValueType.none,
          valueCommitment:
              _usesValueCapture
                  ? _selectedValueCommitment
                  : TaskValueCommitment.none,
          valueUnitKey:
              _usesValueCapture ? _selectedValueUnitKey : TaskValueUnitKey.none,
          valueUnitLabel: _usesValueCapture ? _selectedValueUnitLabel : '',
        );
      }

      if (projectPlan != null) {
        final targetProjectId =
            _selectedProjectId.isEmpty ? null : _selectedProjectId;
        if (projectPlan.scope == _ProjectChangeScope.allHistory) {
          await widget.repository.moveTaskProjectHistory(
            taskId: widget.task.id,
            projectId: targetProjectId,
          );
        } else {
          await widget.repository.assignTaskProjectFromDate(
            taskId: widget.task.id,
            projectId: targetProjectId,
            effectiveDate: projectPlan.effectiveDate!,
          );
        }
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Die Aufgabe konnte nicht aktualisiert werden.'),
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

  bool get _hasProjectChanged =>
      widget.task.projectId !=
      (_selectedProjectId.isEmpty ? null : _selectedProjectId);

  bool get _hasScheduleChanged =>
      widget.task.recurrence != _selectedRecurrence ||
      widget.task.activeWeekdays !=
          _encodeWeekdays(_usesSelectedDays ? _selectedDays : _dailyWeekdays) ||
      widget.task.missedPolicy != _selectedMissedPolicy ||
      widget.task.missedConsequence != _selectedMissedConsequence ||
      widget.task.missedBufferDays != _missedBufferDays ||
      widget.task.postBufferBehavior != _selectedPostBufferBehavior ||
      widget.task.maxCarryoverCount != _maxCarryoverCount;

  bool get _hasDueDateChanged =>
      widget.task.taskType == TaskTypes.task &&
      widget.task.recurrence == HabitRecurrence.none &&
      widget.task.dueDate != _dueDate;

  Future<bool> _confirmDueDateChange() async {
    if (!_hasDueDateChanged) {
      return true;
    }
    final explanation =
        _dueDate == null
            ? 'Die Aufgabe bleibt erhalten, hat danach aber keine automatische '
                'Fristkonsequenz.'
            : 'Der offene Eintrag wird auf ${_formatDate(_dueDate!)} '
                'verschoben. Notizen und vorhandene Eingaben bleiben erhalten.';
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Fälligkeit ändern?'),
                content: Text(explanation),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Abbrechen'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Änderung speichern'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  Future<bool> _confirmScheduledChanges() async {
    if (!_hasScheduleChanged) {
      return true;
    }
    final effectiveDate = _nextLocalDay(DateTime.now());
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Planungsänderung vormerken?'),
                content: Text(
                  'Gilt ab morgen, ${_formatDate(effectiveDate)}. Heutige und '
                  'ältere Einträge behalten ihre bisherigen Regeln. So bleiben '
                  'laufende Fristen und historische Auswertungen nachvollziehbar.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Abbrechen'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Ab morgen speichern'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  Future<_ProjectChangePlan?> _resolveProjectChange() async {
    if (!_hasProjectChanged) {
      return null;
    }
    final scope = await showDialog<_ProjectChangeScope>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Projektzuordnung ändern'),
            content: const Text(
              '„Ab Datum“ erhält die frühere Zuordnung. „Gesamte Historie“ '
              'verschiebt bewusst auch ältere Auswertungen zum neuen Projekt.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Abbrechen'),
              ),
              TextButton(
                onPressed:
                    () =>
                        Navigator.of(context).pop(_ProjectChangeScope.fromDate),
                child: const Text('Ab Datum'),
              ),
              FilledButton(
                onPressed:
                    () => Navigator.of(
                      context,
                    ).pop(_ProjectChangeScope.allHistory),
                child: const Text('Gesamte Historie'),
              ),
            ],
          ),
    );
    if (scope == null) {
      return null;
    }
    if (scope == _ProjectChangeScope.allHistory) {
      return const _ProjectChangePlan(scope: _ProjectChangeScope.allHistory);
    }
    if (!mounted) {
      return null;
    }
    final today = _dateOnly(DateTime.now());
    final date = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: DateTime(today.year + 10, 12, 31),
      helpText: 'Projektzuordnung gilt ab',
    );
    return date == null
        ? null
        : _ProjectChangePlan(
          scope: _ProjectChangeScope.fromDate,
          effectiveDate: _dateOnly(date),
        );
  }

  Future<void> _copyAsNewTask() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder:
            (context) => AufgabeHinzufuegenScreen(
              aufgabenRepository: widget.repository,
              projectRepository: widget.projectRepository,
              creationMode: TaskCreationMode.advanced,
              template: widget.task,
            ),
      ),
    );
  }

  Future<_GoalChangeTiming?> _resolveGoalChangeTiming(
    TaskConfiguration configuration,
  ) async {
    if (!_shouldOfferGoalChangeTiming(configuration)) {
      return _GoalChangeTiming.immediate;
    }

    final nextBlockStart = nextGoalBlockStartForTask(
      widget.task,
      DateTime.now(),
    );

    return showDialog<_GoalChangeTiming>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Zieländerung übernehmen?'),
            content: Text(
              'Du änderst nur das Ziel mitten im aktuellen Zielblock. '
              'Sauberer ist, die neue Zielregel ab dem nächsten Zielblock '
              'gelten zu lassen.\n\n'
              'Nächster Zielblock: ${_formatDate(nextBlockStart)}',
            ),
            actions: [
              TextButton(
                onPressed:
                    () =>
                        Navigator.of(context).pop(_GoalChangeTiming.immediate),
                child: const Text('Sofort anwenden'),
              ),
              FilledButton(
                onPressed:
                    () =>
                        Navigator.of(context).pop(_GoalChangeTiming.nextBlock),
                child: const Text('Ab nächstem Zielblock'),
              ),
            ],
          ),
    );
  }

  bool _shouldOfferGoalChangeTiming(TaskConfiguration configuration) {
    if (!_hasGoalChanged(configuration) ||
        !_hasOnlyGoalChanged(configuration)) {
      return false;
    }

    final today = _dateOnly(DateTime.now());
    return today.isAfter(currentGoalBlockStartForTask(widget.task, today));
  }

  bool _hasGoalChanged(TaskConfiguration configuration) {
    return widget.task.goalType != configuration.goalType ||
        widget.task.goalValue != configuration.goalValue ||
        widget.task.goalWindowDays != configuration.goalWindowDays ||
        widget.task.goalPeriod != configuration.goalPeriod ||
        widget.task.goalPeriodAlignment != configuration.goalPeriodAlignment;
  }

  bool _hasOnlyGoalChanged(TaskConfiguration configuration) {
    final projectId = _selectedProjectId.isEmpty ? null : _selectedProjectId;
    final activeDays = _usesSelectedDays ? _selectedDays : _dailyWeekdays;

    return widget.task.name == _nameController.text.trim() &&
        widget.task.beschreibung == _descriptionController.text.trim() &&
        widget.task.projectId == projectId &&
        widget.task.taskType == _selectedTaskType &&
        _dateOnly(widget.task.startDate) == _dateOnly(_startDate) &&
        widget.task.dueDate == configuration.dueDate &&
        widget.task.questionText ==
            (_isHabit ? _questionController.text : '') &&
        widget.task.activeWeekdays == _encodeWeekdays(activeDays) &&
        widget.task.recurrence == _selectedRecurrence &&
        widget.task.missedPolicy == _selectedMissedPolicy &&
        widget.task.missedConsequence == _selectedMissedConsequence &&
        widget.task.missedBufferDays == _missedBufferDays &&
        widget.task.postBufferBehavior == _selectedPostBufferBehavior &&
        widget.task.maxCarryoverCount == _maxCarryoverCount &&
        widget.task.valueType == configuration.valueType &&
        widget.task.valueCommitment == configuration.valueCommitment &&
        widget.task.valueUnitKey == configuration.valueUnitKey &&
        widget.task.valueUnitLabel == configuration.valueUnitLabel;
  }

  void _sanitizeSelections() {
    final normalized = TaskConfigurationValidator.normalize(
      _currentConfiguration,
    );
    _dueDate = normalized.dueDate;
    _selectedDays = {...normalized.activeDays};
    _selectedMissedPolicy = normalized.missedPolicy;
    _selectedMissedConsequence = normalized.missedConsequence;
    _missedBufferDays = normalized.bufferDays;
    _selectedPostBufferBehavior =
        normalized.postBufferBehavior ?? _selectedPostBufferBehavior;
    _maxCarryoverCount = normalized.maxCarryoverCount;
    _selectedGoalType = normalized.goalType;
    _goalValue = normalized.goalValue;
    _goalWindowDays = normalized.goalWindowDays ?? _goalWindowDays;
    _selectedGoalPeriod = normalized.goalPeriod;
    _selectedGoalPeriodAlignment = normalized.goalPeriodAlignment;
  }

  Future<void> _showPlannedChanges() async {
    final definitionChanges =
        await widget.repository
            .watchPendingDefinitionChanges(widget.task.id)
            .first;
    final projectChanges =
        (await widget.repository
                .watchProjectAssignmentChanges(widget.task.id)
                .first)
            .where(
              (change) => change.state == TaskProjectAssignmentState.pending,
            )
            .toList();
    if (!mounted) {
      return;
    }
    final descriptions = <String>[
      for (final change in definitionChanges)
        '${change.groupKey == TaskPendingDefinitionChangeGroup.goal ? 'Ziel' : 'Planung'} '
            'ab ${_formatDate(change.effectiveDate)}',
      for (final change in projectChanges)
        'Projekt ab ${_formatDate(change.effectiveDate)}',
    ];
    await showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Geplante Änderungen'),
            content: Text(
              descriptions.isEmpty
                  ? 'Für diese Aufgabe ist nichts vorgemerkt.'
                  : descriptions.map((text) => '• $text').join('\n'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Schließen'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final validation = _configurationValidation;
    final rules = validation.rules;
    final dueDateRule = rules[TaskConfigurationField.dueDate]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aufgabe bearbeiten'),
        actions: [
          IconButton(
            onPressed: _isSaving ? null : _showPlannedChanges,
            tooltip: 'Geplante Änderungen',
            icon: const Icon(Icons.schedule_outlined),
          ),
          IconButton(
            onPressed: _isSaving ? null : _copyAsNewTask,
            tooltip: 'Als neue Aufgabe kopieren',
            icon: const Icon(Icons.copy_outlined),
          ),
        ],
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
                    TextFormField(
                      controller: _nameController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Name der Aufgabe',
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
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                      minLines: 4,
                      maxLines: 8,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: widget.task.erfassungsmodus,
                      decoration: const InputDecoration(
                        labelText: 'Erfassungsmodus',
                        helperText:
                            'Der Erfassungsmodus kann bei bestehenden Einträgen nicht geändert werden.',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: widget.task.erfassungsmodus,
                          child: Text(
                            _captureModeLabels[widget.task.erfassungsmodus] ??
                                widget.task.erfassungsmodus,
                          ),
                        ),
                      ],
                      onChanged: null,
                    ),
                    if (_usesThreeStateCapture) ...[
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
                        enabled: false,
                        onValueTypeChanged: (_) {},
                        onValueCommitmentChanged: (_) {},
                        onUnitKeyChanged: (_) {},
                        onUnitLabelChanged: (_) {},
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Messart, Verbindlichkeit und Einheit bleiben für '
                        'bestehende Auswertungen fest. Für eine andere '
                        'Messkonfiguration bitte „Als neue Aufgabe kopieren“.',
                      ),
                    ],
                    const SizedBox(height: 20),
                    TaskTypeField(
                      selectedTaskType: _selectedTaskType,
                      enabled: false,
                      onChanged: (_) {},
                    ),
                    if (_isHabit) ...[
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _questionController,
                        decoration: const InputDecoration(
                          labelText: 'Frage / Anzeigetext',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
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
                    const SizedBox(height: 20),
                    StartDateField(
                      startDate: _startDate,
                      enabled: false,
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Startdatum und Aufgabenart sind nach der Erstellung '
                      'gesperrt. Eine eigenständige Kopie beginnt standardmäßig heute.',
                    ),
                    const SizedBox(height: 20),
                    HabitRhythmField(
                      recurrence: _selectedRecurrence,
                      selectedDays: _selectedDays,
                      enabled: !_isSaving,
                      includeNone: !_isHabit,
                      onRecurrenceChanged: (recurrence) {
                        setState(() {
                          _selectedRecurrence = recurrence;
                          if (recurrence == HabitRecurrence.monthlyFixedDays) {
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
                          _sanitizeSelections();
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
                          _isSaving || !validation.canSave ? null : _saveTask,
                      icon: const Icon(Icons.save_outlined),
                      label: Text(
                        _isSaving
                            ? 'Wird gespeichert...'
                            : 'Änderungen speichern',
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

enum _GoalChangeTiming { immediate, nextBlock }

enum _ProjectChangeScope { fromDate, allHistory }

class _ProjectChangePlan {
  const _ProjectChangePlan({required this.scope, this.effectiveDate});

  final _ProjectChangeScope scope;
  final DateTime? effectiveDate;
}

String _encodeWeekdays(Set<int> weekdays) {
  final sorted = weekdays.toList()..sort();
  return sorted.join(',');
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

DateTime _nextLocalDay(DateTime date) =>
    DateTime(date.year, date.month, date.day + 1);

String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}.'
      '${date.month.toString().padLeft(2, '0')}.'
      '${date.year.toString().padLeft(4, '0')}';
}
