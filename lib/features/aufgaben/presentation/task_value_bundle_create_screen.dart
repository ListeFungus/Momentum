import 'package:flutter/material.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/task_goal.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle.dart';
import 'package:momentum/features/aufgaben/data/task_value_type.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_goal_field.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/project_dropdown_field.dart';
import 'package:momentum/features/projekte/data/project_repository.dart';

class TaskValueBundleCreateScreen extends StatefulWidget {
  const TaskValueBundleCreateScreen({
    required this.baseTask,
    required this.repository,
    required this.projectRepository,
    super.key,
  });

  final Aufgabe baseTask;
  final AufgabenRepository repository;
  final ProjectRepository projectRepository;

  @override
  State<TaskValueBundleCreateScreen> createState() =>
      _TaskValueBundleCreateScreenState();
}

class _TaskValueBundleCreateScreenState
    extends State<TaskValueBundleCreateScreen> {
  late String _bundleType;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _firstRoleController = TextEditingController();
  final TextEditingController _secondRoleController = TextEditingController();
  final TextEditingController _resultLabelController = TextEditingController();
  Aufgabe? _selectedSecondTask;
  late DateTime _validFrom;
  String _direction = TaskValueBundleDirection.firstMinusSecond;
  String _displayMode = TaskValueBundleDisplayMode.combinedCard;
  String _goalType = TaskGoalType.none;
  int _goalValue = 1;
  int _goalWindowDays = 7;
  int _firstTaskDayOffset = 0;
  bool _isSaving = false;
  String _selectedProjectId = '';

  @override
  void initState() {
    super.initState();
    _bundleType = _availableBundleTypes(widget.baseTask).first;
    _nameController.text = _defaultBundleName(_bundleType);
    _firstRoleController.text = widget.baseTask.name;
    _resultLabelController.text = _defaultResultLabel(_bundleType);
    _validFrom = _dateOnly(DateTime.now());
    _selectedProjectId = widget.baseTask.projectId ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _firstRoleController.dispose();
    _secondRoleController.dispose();
    _resultLabelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final availableTypes = _availableBundleTypes(widget.baseTask);

    return Scaffold(
      appBar: AppBar(title: const Text('Bündel erstellen')),
      body: FutureBuilder<List<Aufgabe>>(
        future: widget.repository.compatibleTasksForValueBundle(
          baseTask: widget.baseTask,
          bundleType: _bundleType,
          date: _validFrom,
        ),
        builder: (context, snapshot) {
          final candidates = snapshot.data ?? const <Aufgabe>[];
          if (_selectedSecondTask != null &&
              !candidates.any((task) => task.id == _selectedSecondTask!.id)) {
            _selectedSecondTask = null;
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              Text(
                widget.baseTask.name,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                'Dieses Wert-Tracking wird mit einem zweiten passenden '
                'Tracking verbunden. Die Rohdaten bleiben in den beiden '
                'einzelnen Aufgaben.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),
              _ValidFromField(
                validFrom: _validFrom,
                baseTask: widget.baseTask,
                selectedSecondTask: _selectedSecondTask,
                isSaving: _isSaving,
                onChanged: (date) {
                  setState(() {
                    _validFrom = _dateOnly(date);
                    _selectedSecondTask = null;
                  });
                },
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: _bundleType,
                decoration: const InputDecoration(
                  labelText: 'Bündeltyp',
                  border: OutlineInputBorder(),
                ),
                items:
                    availableTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(_bundleTypeLabel(type)),
                      );
                    }).toList(),
                onChanged:
                    _isSaving
                        ? null
                        : (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _bundleType = value;
                            _selectedSecondTask = null;
                            _nameController.text = _defaultBundleName(value);
                            _resultLabelController.text = _defaultResultLabel(
                              value,
                            );
                            _direction =
                                TaskValueBundleDirection.firstMinusSecond;
                            if (value == TaskValueBundleType.timeInterval &&
                                _goalType == TaskGoalType.valueSumMin) {
                              _goalType = TaskGoalType.none;
                            }
                            _firstTaskDayOffset = 0;
                            _displayMode =
                                TaskValueBundleDisplayMode.combinedCard;
                          });
                        },
              ),
              if (_bundleType == TaskValueBundleType.difference) ...[
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: _direction,
                  decoration: const InputDecoration(
                    labelText: 'Rechenrichtung',
                    border: OutlineInputBorder(),
                    helperText:
                        'Legt fest, welcher Wert bei der Differenz abgezogen wird.',
                  ),
                  items:
                      [
                        TaskValueBundleDirection.firstMinusSecond,
                        TaskValueBundleDirection.secondMinusFirst,
                      ].map((direction) {
                        return DropdownMenuItem(
                          value: direction,
                          child: Text(
                            _directionLabel(
                              direction: direction,
                              firstLabel: _firstRoleController.text,
                              secondLabel: _secondRoleController.text,
                              firstFallback: widget.baseTask.name,
                              secondFallback: _selectedSecondTask?.name,
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged:
                      _isSaving
                          ? null
                          : (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() => _direction = value);
                          },
                ),
              ],
              if (_bundleType == TaskValueBundleType.timeInterval) ...[
                const SizedBox(height: 14),
                DropdownButtonFormField<int>(
                  value: _firstTaskDayOffset,
                  decoration: const InputDecoration(
                    labelText: 'Zuordnung der Teilwerte',
                    border: OutlineInputBorder(),
                    helperText:
                        'Für Schlaf kann der erste Wert vom Vortag kommen.',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 0,
                      child: Text('Beide Werte am angezeigten Tag'),
                    ),
                    DropdownMenuItem(
                      value: -1,
                      child: Text('Erster Wert vom Vortag, zweiter am Tag'),
                    ),
                  ],
                  onChanged:
                      _isSaving
                          ? null
                          : (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _firstTaskDayOffset = value;
                              if (value == -1) {
                                _displayMode =
                                    TaskValueBundleDisplayMode.linkedCards;
                              }
                            });
                          },
                ),
                if (_firstTaskDayOffset == -1) ...[
                  const SizedBox(height: 8),
                  _InfoText(
                    text:
                        'Dieses Bündel verbindet den ersten Wert vom Vortag '
                        'mit dem zweiten Wert am angezeigten Tag. Es wird als '
                        'verknüpfte Einzelkarten angezeigt.',
                  ),
                ],
              ],
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: _displayMode,
                decoration: InputDecoration(
                  labelText: 'Anzeigeart',
                  border: const OutlineInputBorder(),
                  helperText:
                      _firstTaskDayOffset == -1
                          ? 'Cross-Day-Bündel nutzen verknüpfte Einzelkarten.'
                          : 'Gemeinsame Karte blendet die Teilkarten aus.',
                ),
                items: const [
                  DropdownMenuItem(
                    value: TaskValueBundleDisplayMode.combinedCard,
                    child: Text('Gemeinsame Bündelkarte'),
                  ),
                  DropdownMenuItem(
                    value: TaskValueBundleDisplayMode.linkedCards,
                    child: Text('Verknüpfte Einzelkarten'),
                  ),
                ],
                onChanged:
                    _isSaving || _firstTaskDayOffset == -1
                        ? null
                        : (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() => _displayMode = value);
                        },
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: _selectedSecondTask?.id,
                decoration: InputDecoration(
                  labelText: 'Zweites Tracking',
                  border: const OutlineInputBorder(),
                  helperText:
                      snapshot.connectionState == ConnectionState.waiting
                          ? 'Passende Trackings werden geladen.'
                          : candidates.isEmpty
                          ? 'Keine passende Wert-Aufgabe verfügbar.'
                          : 'Nur fachlich passende Wert-Trackings werden angezeigt.',
                ),
                items:
                    candidates.map((task) {
                      return DropdownMenuItem(
                        value: task.id,
                        child: Text(task.name),
                      );
                    }).toList(),
                onChanged:
                    _isSaving || candidates.isEmpty
                        ? null
                        : (taskId) {
                          setState(() {
                            _selectedSecondTask = candidates.firstWhere(
                              (task) => task.id == taskId,
                            );
                            _secondRoleController.text =
                                _selectedSecondTask?.name ?? '';
                          });
                        },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                enabled: !_isSaving,
                decoration: const InputDecoration(
                  labelText: 'Name des Bündels',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _firstRoleController,
                enabled: !_isSaving,
                decoration: const InputDecoration(
                  labelText: 'Bezeichnung erster Wert',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _secondRoleController,
                enabled: !_isSaving,
                decoration: const InputDecoration(
                  labelText: 'Bezeichnung zweiter Wert',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _resultLabelController,
                enabled: !_isSaving,
                decoration: const InputDecoration(
                  labelText: 'Bezeichnung Ergebnis',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TaskGoalField(
                selectedGoalType: _goalType,
                goalValue: _goalValue,
                goalWindowDays: _goalWindowDays,
                selectedPeriod: GoalPeriod.week,
                selectedPeriodAlignment: GoalPeriodAlignment.calendar,
                supportsPeriodGoals: true,
                valueType: _bundleGoalValueType(_bundleType, widget.baseTask),
                allowValueSumGoal:
                    _bundleType != TaskValueBundleType.timeInterval,
                valueGoalsOnly: true,
                enabled: !_isSaving,
                onGoalTypeChanged: (value) {
                  setState(() {
                    _goalType = value;
                    if (value != TaskGoalType.none) {
                      _goalValue = 1;
                      _goalWindowDays = 7;
                    }
                  });
                },
                onGoalValueChanged: (value) {
                  setState(() => _goalValue = value);
                },
                onGoalWindowDaysChanged: (value) {
                  setState(() => _goalWindowDays = value);
                },
                onPeriodChanged: (_) {},
                onPeriodAlignmentChanged: (_) {},
              ),
              const SizedBox(height: 24),
              StreamBuilder<List<Project>>(
                stream: widget.projectRepository.watchProjectChoices(),
                builder: (context, snapshot) {
                  return ProjectDropdownField(
                    projects: snapshot.data ?? const [],
                    selectedProjectId: _selectedProjectId,
                    enabled: !_isSaving,
                    onChanged: (value) {
                      setState(() => _selectedProjectId = value ?? '');
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed:
                    _isSaving || _selectedSecondTask == null
                        ? null
                        : () => _save(context),
                icon:
                    _isSaving
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.add_link_outlined),
                label: const Text('Bündel erstellen'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _save(BuildContext context) async {
    final secondTask = _selectedSecondTask;
    if (secondTask == null) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await widget.repository.createValueBundle(
        name:
            _nameController.text.trim().isEmpty
                ? _defaultBundleName(_bundleType)
                : _nameController.text,
        bundleType: _bundleType,
        firstTaskId: widget.baseTask.id,
        secondTaskId: secondTask.id,
        firstRoleLabel: _firstRoleController.text,
        secondRoleLabel: _secondRoleController.text,
        resultLabel: _resultLabelController.text,
        direction: _direction,
        displayMode: _displayMode,
        goalType: _goalType,
        goalValue: _goalValue,
        goalWindowDays: _goalType == TaskGoalType.none ? null : _goalWindowDays,
        firstTaskDayOffset: _firstTaskDayOffset,
        secondTaskDayOffset: 0,
        validFrom: _validFrom,
        projectId: _selectedProjectId.isEmpty ? null : _selectedProjectId,
      );

      if (context.mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Das Bündel konnte nicht erstellt werden. Prüfe bitte die Auswahl.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}

class _ValidFromField extends StatelessWidget {
  const _ValidFromField({
    required this.validFrom,
    required this.baseTask,
    required this.selectedSecondTask,
    required this.isSaving,
    required this.onChanged,
  });

  final DateTime validFrom;
  final Aufgabe baseTask;
  final Aufgabe? selectedSecondTask;
  final bool isSaving;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final secondTask = selectedSecondTask;
    final laterStart =
        secondTask == null
            ? baseTask.startDate
            : baseTask.startDate.isAfter(secondTask.startDate)
            ? baseTask.startDate
            : secondTask.startDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed:
              isSaving
                  ? null
                  : () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: validFrom,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      onChanged(picked);
                    }
                  },
          icon: const Icon(Icons.event_outlined),
          label: Text('Gilt ab: ${_formatDate(validFrom)}'),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ActionChip(
              label: const Text('Heute'),
              onPressed:
                  isSaving ? null : () => onChanged(_dateOnly(DateTime.now())),
            ),
            ActionChip(
              label: const Text('Start erstes Tracking'),
              onPressed: isSaving ? null : () => onChanged(baseTask.startDate),
            ),
            if (secondTask != null)
              ActionChip(
                label: const Text('Start zweites Tracking'),
                onPressed:
                    isSaving ? null : () => onChanged(secondTask.startDate),
              ),
            if (secondTask != null)
              ActionChip(
                label: const Text('Späterer Start'),
                onPressed: isSaving ? null : () => onChanged(laterStart),
              ),
          ],
        ),
        const SizedBox(height: 8),
        const _InfoText(
          text:
              'Rückwirkendes Erstellen erzeugt keine neuen Einträge. Es wertet '
              'nur vorhandene und zukünftige Rohwerte ab diesem Datum als Bündel.',
        ),
      ],
    );
  }
}

class _InfoText extends StatelessWidget {
  const _InfoText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        height: 1.35,
      ),
    );
  }
}

List<String> _availableBundleTypes(Aufgabe task) {
  if (task.valueType == TaskValueType.timeOfDay) {
    return const [TaskValueBundleType.timeInterval];
  }

  if (task.valueType == TaskValueType.number ||
      task.valueType == TaskValueType.duration) {
    return const [TaskValueBundleType.difference, TaskValueBundleType.sum];
  }

  return const [TaskValueBundleType.difference];
}

String _bundleTypeLabel(String type) {
  return switch (type) {
    TaskValueBundleType.timeInterval => 'Zeitintervall',
    TaskValueBundleType.difference => 'Differenz',
    TaskValueBundleType.sum => 'Summe',
    _ => 'Bündel',
  };
}

String _defaultBundleName(String type) {
  return switch (type) {
    TaskValueBundleType.timeInterval => 'Zeitintervall',
    TaskValueBundleType.difference => 'Differenz',
    TaskValueBundleType.sum => 'Summe',
    _ => 'Bündel',
  };
}

String _defaultResultLabel(String type) {
  return switch (type) {
    TaskValueBundleType.timeInterval => 'Dauer',
    TaskValueBundleType.difference => 'Differenz',
    TaskValueBundleType.sum => 'Summe',
    _ => 'Ergebnis',
  };
}

String _directionLabel({
  required String direction,
  required String firstLabel,
  required String secondLabel,
  required String firstFallback,
  required String? secondFallback,
}) {
  final first = firstLabel.trim().isEmpty ? firstFallback : firstLabel.trim();
  final second =
      secondLabel.trim().isEmpty
          ? secondFallback ?? 'zweiter Wert'
          : secondLabel.trim();

  return switch (direction) {
    TaskValueBundleDirection.secondMinusFirst => '$second - $first',
    _ => '$first - $second',
  };
}

String _bundleGoalValueType(String bundleType, Aufgabe baseTask) {
  if (bundleType == TaskValueBundleType.timeInterval) {
    return TaskValueType.duration;
  }

  return baseTask.valueType == TaskValueType.duration
      ? TaskValueType.duration
      : TaskValueType.number;
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}.'
      '${date.month.toString().padLeft(2, '0')}.'
      '${date.year}';
}
