import 'package:flutter/material.dart';
import 'dart:async';

import 'package:momentum/core/theme/hex_color.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/missed_policy.dart';
import 'package:momentum/features/aufgaben/data/task_capture_mode.dart';
import 'package:momentum/features/aufgaben/data/task_for_date.dart';
import 'package:momentum/features/aufgaben/data/task_types.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle_for_date.dart';
import 'package:momentum/features/aufgaben/data/task_value_commitment.dart';
import 'package:momentum/features/aufgaben/presentation/completed_one_time_tasks_screen.dart';
import 'package:momentum/features/aufgaben/presentation/one_time_task_collection_analytics_screen.dart';
import 'package:momentum/features/aufgaben/presentation/task_detail_screen.dart';
import 'package:momentum/features/aufgaben/presentation/task_lifecycle_screen.dart';
import 'package:momentum/features/aufgaben/presentation/task_edit_screen.dart';
import 'package:momentum/features/aufgaben/presentation/task_value_bundle_create_screen.dart';
import 'package:momentum/features/aufgaben/presentation/task_value_bundle_detail_screen.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_card.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_card_metric_selection_sheet.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_value_bundle_card.dart';
import 'package:momentum/features/projekte/data/project_repository.dart';

enum TaskView { today, habits, urgency }

class AufgabenScreen extends StatefulWidget {
  const AufgabenScreen({
    required this.aufgabenRepository,
    required this.projectRepository,
    super.key,
  });

  final AufgabenRepository aufgabenRepository;
  final ProjectRepository projectRepository;

  @override
  State<AufgabenScreen> createState() => _AufgabenScreenState();
}

class _AufgabenScreenState extends State<AufgabenScreen>
    with WidgetsBindingObserver {
  late DateTime _selectedDate;
  late DateTime _lastObservedToday;
  TaskView _selectedView = TaskView.today;
  Timer? _undoTimer;
  Timer? _dayChangeTimer;
  _UndoAction? _undoAction;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _lastObservedToday = _dateOnly(DateTime.now());
    _selectedDate = _lastObservedToday;
    _dayChangeTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _refreshForDayChange(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshForDayChange();
    }
  }

  void _refreshForDayChange() {
    if (!mounted) {
      return;
    }
    final today = _dateOnly(DateTime.now());
    if (today == _lastObservedToday) {
      return;
    }
    final followedToday = _selectedDate == _lastObservedToday;
    setState(() {
      _lastObservedToday = today;
      if (followedToday) {
        _selectedDate = today;
      }
    });
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _undoTimer?.cancel();
    _dayChangeTimer?.cancel();
    super.dispose();
  }

  void _showUndo(_UndoAction action) {
    _undoTimer?.cancel();

    setState(() {
      _undoAction = action;
    });

    _undoTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted) {
        return;
      }

      setState(() {
        _undoAction = null;
      });
    });
  }

  Future<void> _undoLastAction() async {
    final action = _undoAction;

    if (action == null) {
      return;
    }

    _undoTimer?.cancel();

    setState(() {
      _undoAction = null;
    });

    await action.undo();
  }

  Stream<TaskListForDate> _taskStream() {
    return switch (_selectedView) {
      TaskView.today => widget.aufgabenRepository.watchTaskListForDate(
        _selectedDate,
        taskType: TaskTypes.task,
      ),
      TaskView.habits => widget.aufgabenRepository.watchTaskListForDate(
        _selectedDate,
        taskType: TaskTypes.habit,
      ),
      TaskView.urgency => widget.aufgabenRepository.watchTasksByUrgency().map(
        (tasks) => TaskListForDate(tasks: tasks, valueBundles: const []),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Deine Aufgaben',
                          style: TextStyle(
                            color: Color(0xFF263B47),
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Pausierte & Papierkorb',
                        icon: const Icon(Icons.delete_sweep_outlined),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder:
                                  (context) => TaskLifecycleScreen(
                                    repository: widget.aufgabenRepository,
                                    projectRepository: widget.projectRepository,
                                  ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        tooltip: 'Abgeschlossene Aufgaben',
                        icon: const Icon(Icons.done_all_outlined),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder:
                                  (context) => CompletedOneTimeTasksScreen(
                                    repository: widget.aufgabenRepository,
                                    projectRepository: widget.projectRepository,
                                  ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        tooltip: 'Auswertung einmaliger Aufgaben',
                        icon: const Icon(Icons.insights_outlined),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder:
                                  (context) =>
                                      OneTimeTaskCollectionAnalyticsScreen(
                                        repository: widget.aufgabenRepository,
                                      ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SegmentedButton<TaskView>(
                    segments: const [
                      ButtonSegment(
                        value: TaskView.today,
                        icon: Icon(Icons.today_outlined),
                        label: Text('Heute'),
                      ),
                      ButtonSegment(
                        value: TaskView.habits,
                        icon: Icon(Icons.repeat),
                        label: Text('Habits'),
                      ),
                      ButtonSegment(
                        value: TaskView.urgency,
                        icon: Icon(Icons.priority_high),
                        label: Text('Dringlichkeit'),
                      ),
                    ],
                    selected: {_selectedView},
                    showSelectedIcon: false,
                    onSelectionChanged: (selection) {
                      setState(() {
                        _selectedView = selection.single;
                      });
                    },
                  ),
                  if (_selectedView != TaskView.urgency) ...[
                    const SizedBox(height: 16),
                    _DateNavigation(
                      selectedDate: _selectedDate,
                      onPreviousDay: () => _changeDate(-1),
                      onNextDay: () => _changeDate(1),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<TaskListForDate>(
                stream: _taskStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const _MessageState(
                      message: 'Die Aufgaben konnten nicht geladen werden.',
                      isError: true,
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final taskList = snapshot.data!;
                  final tasks = taskList.tasks;

                  if (_selectedView == TaskView.urgency) {
                    return _UrgencyList(
                      tasks: tasks.where((task) => !task.isAnswered).toList(),
                      repository: widget.aufgabenRepository,
                      projectRepository: widget.projectRepository,
                      onUndoAvailable: _showUndo,
                    );
                  }

                  return _ProjectGroupedTaskList(
                    tasks: tasks,
                    valueBundles: taskList.valueBundles,
                    selectedDate: _selectedDate,
                    groupAnswered: _selectedView == TaskView.habits,
                    repository: widget.aufgabenRepository,
                    projectRepository: widget.projectRepository,
                    onUndoAvailable: _showUndo,
                    emptyMessage:
                        _selectedView == TaskView.habits
                            ? 'Für diesen Tag sind keine Habits vorhanden.'
                            : 'Für diesen Tag sind keine Aufgaben vorhanden.',
                  );
                },
              ),
            ),
          ],
        ),
        Positioned(
          left: 24,
          bottom: 24,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child:
                _undoAction == null
                    ? const SizedBox.shrink()
                    : FilledButton.icon(
                      key: ValueKey(_undoAction),
                      onPressed: _undoLastAction,
                      icon: const Icon(Icons.undo),
                      label: const Text('Rückgängig'),
                    ),
          ),
        ),
      ],
    );
  }
}

class _UndoAction {
  const _UndoAction({required this.undo});

  final Future<void> Function() undo;
}

class _DateNavigation extends StatelessWidget {
  const _DateNavigation({
    required this.selectedDate,
    required this.onPreviousDay,
    required this.onNextDay,
  });

  final DateTime selectedDate;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filledTonal(
          onPressed: onPreviousDay,
          tooltip: 'Vorheriger Tag',
          icon: const Icon(Icons.chevron_left),
        ),
        Expanded(
          child: Text(
            _formatDate(selectedDate),
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        IconButton.filledTonal(
          onPressed: onNextDay,
          tooltip: 'Nächster Tag',
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class _ProjectGroupedTaskList extends StatelessWidget {
  const _ProjectGroupedTaskList({
    required this.tasks,
    required this.valueBundles,
    required this.selectedDate,
    required this.groupAnswered,
    required this.repository,
    required this.projectRepository,
    required this.onUndoAvailable,
    required this.emptyMessage,
  });

  final List<TaskForDate> tasks;
  final List<TaskValueBundleForDate> valueBundles;
  final DateTime selectedDate;
  final bool groupAnswered;
  final AufgabenRepository repository;
  final ProjectRepository projectRepository;
  final ValueChanged<_UndoAction> onUndoAvailable;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty && valueBundles.isEmpty) {
      return _MessageState(message: emptyMessage);
    }

    if (groupAnswered) {
      final trackingTasks = tasks.where(_isPureTrackingTask).toList();
      final regularHabitTasks =
          tasks.where((task) => !_isPureTrackingTask(task)).toList();
      final openTasks =
          regularHabitTasks.where((task) => task.booleanValue == null).toList();
      final answeredTasks =
          regularHabitTasks.where((task) => task.booleanValue != null).toList();
      final sections = <Widget>[];

      if (valueBundles.isNotEmpty) {
        sections.add(
          _ValueBundleSection(
            bundles: valueBundles,
            selectedDate: selectedDate,
            repository: repository,
          ),
        );
      }

      if (trackingTasks.isNotEmpty) {
        sections.add(
          _ProjectGroupedSection(
            title: 'Tracking',
            tasks: trackingTasks,
            selectedDate: selectedDate,
            repository: repository,
            projectRepository: projectRepository,
            onUndoAvailable: onUndoAvailable,
          ),
        );
      }

      if (openTasks.isNotEmpty) {
        sections.add(
          _ProjectGroupedSection(
            title: 'Noch offen',
            tasks: openTasks,
            selectedDate: selectedDate,
            repository: repository,
            projectRepository: projectRepository,
            onUndoAvailable: onUndoAvailable,
          ),
        );
      }

      if (answeredTasks.isNotEmpty) {
        sections.add(
          _ProjectGroupedSection(
            title: 'Bereits beantwortet',
            tasks: answeredTasks,
            selectedDate: selectedDate,
            repository: repository,
            projectRepository: projectRepository,
            onUndoAvailable: onUndoAvailable,
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
        itemCount: sections.length,
        separatorBuilder: (context, index) => const SizedBox(height: 28),
        itemBuilder: (context, index) => sections[index],
      );
    }

    final groups = _groupByProject(tasks);
    final itemOffset = valueBundles.isEmpty ? 0 : 1;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
      itemCount: groups.length + itemOffset,
      separatorBuilder: (context, index) => const SizedBox(height: 22),
      itemBuilder: (context, index) {
        if (valueBundles.isNotEmpty && index == 0) {
          return _ValueBundleSection(
            bundles: valueBundles,
            selectedDate: selectedDate,
            repository: repository,
          );
        }

        final group = groups[index - itemOffset];
        final openTasks =
            group.tasks.where((task) => !task.isAnswered).toList();
        final completedTasks =
            group.tasks.where((task) => task.isAnswered).toList();

        return _TaskGroup(
          title: group.title,
          color: group.color,
          completedTitle: 'Bereits abgeschlossen',
          openTasks: openTasks,
          completedTasks: completedTasks,
          scheduledDateFor: (task) => task.entry?.scheduledDate ?? selectedDate,
          metaLabelFor: (task) => _entryTimingLabel(task, selectedDate),
          repository: repository,
          projectRepository: projectRepository,
          onUndoAvailable: onUndoAvailable,
        );
      },
    );
  }
}

class _ValueBundleSection extends StatelessWidget {
  const _ValueBundleSection({
    required this.bundles,
    required this.selectedDate,
    required this.repository,
  });

  final List<TaskValueBundleForDate> bundles;
  final DateTime selectedDate;
  final AufgabenRepository repository;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Bündel',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        ...bundles.map(
          (bundle) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TaskValueBundleCard(
              bundle: bundle,
              scheduledDate: selectedDate,
              onValueSaved: (task, value) async {
                final performedOn = await _selectPerformedOnForPastEntry(
                  context,
                  selectedDate,
                );
                if (performedOn == null) {
                  return;
                }
                await repository.setTaskEntryValue(
                  task: task.task,
                  scheduledDate: selectedDate,
                  valueType: task.task.valueType,
                  numberValue: value.numberValue,
                  durationSeconds: value.durationSeconds,
                  timeMinutes: value.timeMinutes,
                  dayOffset: value.dayOffset,
                  performedOn: performedOn,
                );
              },
              onOpenDetails: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder:
                        (context) => TaskValueBundleDetailScreen(
                          bundle: bundle,
                          repository: repository,
                        ),
                  ),
                );
              },
              onConfigureCardMetric: () {
                showBundleCardMetricSelectionSheet(
                  context: context,
                  repository: repository,
                  bundle: bundle.bundle,
                  version: bundle.version,
                );
              },
              onDissolve: () {
                repository.dissolveValueBundle(bundleId: bundle.bundle.id);
              },
              onDelete: () async {
                final preview = await repository.previewBundleDeletion(
                  bundle.bundle.id,
                );
                if (!context.mounted) return;
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Bündel in Papierkorb?'),
                        content: Text(
                          '„${preview.name}“ und seine Bündelauswertung werden '
                          'ausgeblendet. Beide Teil-Trackings und ihre Rohwerte '
                          'bleiben erhalten. Wiederherstellung ist bis '
                          '${_formatDateTime(preview.purgeAt)} möglich.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Abbrechen'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('In Papierkorb verschieben'),
                          ),
                        ],
                      ),
                );
                if (confirmed == true) {
                  await repository.moveBundleToTrash(preview);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _ProjectGroupedSection extends StatelessWidget {
  const _ProjectGroupedSection({
    required this.title,
    required this.tasks,
    required this.selectedDate,
    required this.repository,
    required this.projectRepository,
    required this.onUndoAvailable,
  });

  final String title;
  final List<TaskForDate> tasks;
  final DateTime selectedDate;
  final AufgabenRepository repository;
  final ProjectRepository projectRepository;
  final ValueChanged<_UndoAction> onUndoAvailable;

  @override
  Widget build(BuildContext context) {
    final groups = _groupByProject(tasks);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        ...groups.map((group) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _TaskGroup(
              title: group.title,
              color: group.color,
              completedTitle: '',
              openTasks: group.tasks,
              completedTasks: const [],
              scheduledDateFor:
                  (task) => task.entry?.scheduledDate ?? selectedDate,
              metaLabelFor: (task) => _entryTimingLabel(task, selectedDate),
              repository: repository,
              projectRepository: projectRepository,
              onUndoAvailable: onUndoAvailable,
            ),
          );
        }),
      ],
    );
  }
}

class _UrgencyList extends StatelessWidget {
  const _UrgencyList({
    required this.tasks,
    required this.repository,
    required this.projectRepository,
    required this.onUndoAvailable,
  });

  final List<TaskForDate> tasks;
  final AufgabenRepository repository;
  final ProjectRepository projectRepository;
  final ValueChanged<_UndoAction> onUndoAvailable;

  @override
  Widget build(BuildContext context) {
    final today = _dateOnly(DateTime.now());
    final overdue = <TaskForDate>[];
    final dueToday = <TaskForDate>[];
    final future = <TaskForDate>[];
    final withoutDueDate = <TaskForDate>[];

    for (final task in tasks) {
      final dueDate = _urgencyDateFor(task);

      if (dueDate == null) {
        withoutDueDate.add(task);
      } else if (_dateOnly(dueDate).isBefore(today)) {
        overdue.add(task);
      } else if (_dateOnly(dueDate) == today) {
        dueToday.add(task);
      } else {
        future.add(task);
      }
    }

    overdue.sort(_compareDueDates);
    dueToday.sort(_compareDueDates);
    future.sort(_compareDueDates);

    final sections =
        [
          _UrgencySectionData(
            title: 'Überfällig',
            color: const Color(0xFFE57373),
            tasks: overdue,
          ),
          _UrgencySectionData(
            title: 'Heute zu erledigen',
            color: const Color(0xFFF2B66D),
            tasks: dueToday,
          ),
          _UrgencySectionData(
            title: 'Zukünftig zu erledigen',
            color: const Color(0xFFE1C95A),
            tasks: future,
          ),
          _UrgencySectionData(
            title: 'Ohne Fälligkeitsdatum',
            color: const Color(0xFF72C9A5),
            tasks: withoutDueDate,
          ),
        ].where((section) => section.tasks.isNotEmpty).toList();

    if (sections.isEmpty) {
      return const _MessageState(
        message: 'Keine offenen Aufgaben für die Dringlichkeitsansicht.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
      itemCount: sections.length,
      separatorBuilder: (context, index) => const SizedBox(height: 22),
      itemBuilder: (context, index) {
        final section = sections[index];

        return _TaskGroup(
          title: section.title,
          color: section.color,
          completedTitle: 'Bereits erledigt',
          openTasks: section.tasks,
          completedTasks: const [],
          scheduledDateFor:
              (task) => task.entry?.scheduledDate ?? task.task.startDate,
          metaLabelFor: (task) => _entryTimingLabel(task, today),
          repository: repository,
          projectRepository: projectRepository,
          onUndoAvailable: onUndoAvailable,
        );
      },
    );
  }
}

class _TaskGroup extends StatelessWidget {
  const _TaskGroup({
    required this.title,
    required this.color,
    required this.completedTitle,
    required this.openTasks,
    required this.completedTasks,
    required this.scheduledDateFor,
    required this.repository,
    required this.projectRepository,
    required this.onUndoAvailable,
    this.metaLabelFor,
  });

  final String title;
  final Color color;
  final String completedTitle;
  final List<TaskForDate> openTasks;
  final List<TaskForDate> completedTasks;
  final DateTime Function(TaskForDate task) scheduledDateFor;
  final String? Function(TaskForDate task)? metaLabelFor;
  final AufgabenRepository repository;
  final ProjectRepository projectRepository;
  final ValueChanged<_UndoAction> onUndoAvailable;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.22),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Color.alphaBlend(
                Colors.black.withValues(alpha: 0.28),
                color,
              ),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (openTasks.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              'Alles erledigt.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else
          ..._taskCards(context, openTasks),
        if (completedTasks.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(
            completedTitle,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
          ..._taskCards(context, completedTasks),
        ],
      ],
    );
  }

  List<Widget> _taskCards(BuildContext context, List<TaskForDate> tasks) {
    return tasks.map((task) {
      final scheduledDate = scheduledDateFor(task);
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: TaskCard(
          task: task,
          scheduledDate: scheduledDate,
          metaLabel: metaLabelFor?.call(task),
          onCompletedChanged: (isCompleted) async {
            final previousValue = task.isCompleted;
            final performedOn =
                isCompleted
                    ? await _selectPerformedOnForPastEntry(
                      context,
                      scheduledDate,
                    )
                    : null;
            if (isCompleted && performedOn == null) {
              return;
            }
            await repository.setTaskCompleted(
              taskId: task.task.id,
              scheduledDate: scheduledDate,
              isCompleted: isCompleted,
              performedOn: performedOn,
            );
            onUndoAvailable(
              _UndoAction(
                undo:
                    () => repository.setTaskCompleted(
                      taskId: task.task.id,
                      scheduledDate: scheduledDate,
                      isCompleted: previousValue,
                    ),
              ),
            );
          },
          onBooleanValueChanged: (value) async {
            final previousValue = task.booleanValue;
            final isPositive = value == task.task.successValue;
            final performedOn =
                isPositive
                    ? await _selectPerformedOnForPastEntry(
                      context,
                      scheduledDate,
                    )
                    : null;
            if (isPositive && performedOn == null) {
              return;
            }
            await repository.setBooleanHabitValue(
              task: task.task,
              scheduledDate: scheduledDate,
              value: value,
              performedOn: performedOn,
            );
            onUndoAvailable(
              _UndoAction(
                undo:
                    () => repository.setBooleanHabitValue(
                      task: task.task,
                      scheduledDate: scheduledDate,
                      value: previousValue,
                    ),
              ),
            );
          },
          onValueSaved: (value) async {
            final performedOn = await _selectPerformedOnForPastEntry(
              context,
              scheduledDate,
            );
            if (performedOn == null) {
              return;
            }
            await repository.setTaskEntryValue(
              task: task.task,
              scheduledDate: scheduledDate,
              valueType: task.task.valueType,
              numberValue: value.numberValue,
              durationSeconds: value.durationSeconds,
              timeMinutes: value.timeMinutes,
              dayOffset: value.dayOffset,
              performedOn: performedOn,
            );
          },
          onEditNote: () {
            _editTaskEntryNote(
              context: context,
              repository: repository,
              task: task,
              scheduledDate: scheduledDate,
            );
          },
          onOpenDetails: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder:
                    (context) => TaskDetailScreen(
                      task: task.task,
                      repository: repository,
                      project: task.project,
                    ),
              ),
            );
          },
          onConfigureCardMetric: () {
            showTaskCardMetricSelectionSheet(
              context: context,
              repository: repository,
              task: task.task,
            );
          },
          onCreateBundle:
              _canCreateBundleFrom(task)
                  ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder:
                            (context) => TaskValueBundleCreateScreen(
                              baseTask: task.task,
                              repository: repository,
                              projectRepository: projectRepository,
                            ),
                      ),
                    );
                  }
                  : null,
          onOpenLinkedBundleDetails:
              task.linkedValueBundle == null
                  ? null
                  : () {
                    _openLinkedBundleDetails(
                      context: context,
                      task: task,
                      repository: repository,
                    );
                  },
          onPause: () async {
            await repository.pauseTask(task.task.id);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Planung ab morgen pausiert. Vorhandene Einträge bleiben bestehen.',
                  ),
                ),
              );
            }
          },
          onEdit: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder:
                    (context) => TaskEditScreen(
                      task: task.task,
                      repository: repository,
                      projectRepository: projectRepository,
                    ),
              ),
            );
          },
          onDelete: () {
            _confirmDeleteTask(
              context: context,
              repository: repository,
              task: task,
            );
          },
        ),
      );
    }).toList();
  }
}

Future<void> _editTaskEntryNote({
  required BuildContext context,
  required AufgabenRepository repository,
  required TaskForDate task,
  required DateTime scheduledDate,
}) async {
  final note = await showDialog<String>(
    context: context,
    builder: (context) => _TaskEntryNoteDialog(initialNote: task.note),
  );

  if (note == null || !context.mounted) {
    return;
  }

  await repository.setTaskEntryNote(
    taskId: task.task.id,
    scheduledDate: scheduledDate,
    note: note,
  );
}

class _TaskEntryNoteDialog extends StatefulWidget {
  const _TaskEntryNoteDialog({required this.initialNote});

  final String initialNote;

  @override
  State<_TaskEntryNoteDialog> createState() => _TaskEntryNoteDialogState();
}

class _TaskEntryNoteDialogState extends State<_TaskEntryNoteDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNote);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tagesnotiz'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        minLines: 3,
        maxLines: 6,
        decoration: const InputDecoration(
          hintText: 'Optionale Notiz zu diesem Tag',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: const Text('Speichern'),
        ),
      ],
    );
  }
}

class _ProjectGroupData {
  const _ProjectGroupData({
    required this.title,
    required this.color,
    required this.tasks,
  });

  final String title;
  final Color color;
  final List<TaskForDate> tasks;
}

class _UrgencySectionData {
  const _UrgencySectionData({
    required this.title,
    required this.color,
    required this.tasks,
  });

  final String title;
  final Color color;
  final List<TaskForDate> tasks;
}

List<_ProjectGroupData> _groupByProject(List<TaskForDate> tasks) {
  final groupedTasks = <String?, List<TaskForDate>>{};

  for (final task in tasks) {
    groupedTasks.putIfAbsent(task.project?.id, () => []).add(task);
  }

  return groupedTasks.values.map((groupTasks) {
    final project = groupTasks.first.project;

    return _ProjectGroupData(
      title: project?.name ?? 'Ohne Projekt',
      color:
          project == null
              ? const Color(0xFF8A949B)
              : colorFromHex(project.colorHex),
      tasks: groupTasks,
    );
  }).toList();
}

int _compareDueDates(TaskForDate first, TaskForDate second) {
  final firstDate = _urgencyDateFor(first);
  final secondDate = _urgencyDateFor(second);
  if (firstDate == null && secondDate == null) {
    return 0;
  }
  if (firstDate == null) {
    return 1;
  }
  if (secondDate == null) {
    return -1;
  }

  final dueDateComparison = firstDate.compareTo(secondDate);

  if (dueDateComparison != 0) {
    return dueDateComparison;
  }

  final firstProjectOrder = first.project?.sortOrder ?? 1 << 30;
  final secondProjectOrder = second.project?.sortOrder ?? 1 << 30;
  return firstProjectOrder.compareTo(secondProjectOrder);
}

DateTime? _urgencyDateFor(TaskForDate task) {
  if (task.task.dueDate != null) {
    return task.task.dueDate;
  }
  if (task.task.recurrence != 'none') {
    return task.entry?.scheduledDate;
  }
  return null;
}

bool _isPureTrackingTask(TaskForDate task) {
  return task.task.erfassungsmodus == TaskCaptureMode.value &&
      task.task.valueCommitment == TaskValueCommitment.pureTracking;
}

bool _canCreateBundleFrom(TaskForDate task) {
  return task.task.erfassungsmodus == TaskCaptureMode.value;
}

String? _entryTimingLabel(TaskForDate task, DateTime selectedDate) {
  final scheduledDate = task.entry?.scheduledDate;
  if (scheduledDate == null) {
    return null;
  }

  final normalizedSelectedDate = _dateOnly(selectedDate);
  final normalizedScheduledDate = _dateOnly(scheduledDate);
  final daysSinceScheduled =
      normalizedSelectedDate.difference(normalizedScheduledDate).inDays;

  if (task.task.missedPolicy == MissedPolicy.buffer &&
      daysSinceScheduled > 0 &&
      daysSinceScheduled <= task.task.missedBufferDays) {
    return 'Puffer Tag $daysSinceScheduled/${task.task.missedBufferDays}';
  }

  return _urgencyLabel(normalizedScheduledDate, normalizedSelectedDate);
}

String? _urgencyLabel(DateTime? dueDate, DateTime today) {
  if (dueDate == null) {
    return null;
  }

  final difference = _dateOnly(dueDate).difference(today).inDays;

  if (difference == 0) {
    return 'Heute';
  }

  return difference > 0 ? '+$difference Tage' : '$difference Tage';
}

Future<void> _confirmDeleteTask({
  required BuildContext context,
  required AufgabenRepository repository,
  required TaskForDate task,
}) async {
  final preview = await repository.previewTaskDeletion(task.task.id);
  if (!context.mounted) return;
  final bundleNote =
      preview.affectedBundleNames.isEmpty
          ? ''
          : '\n\nBetroffene Bündel: ${preview.affectedBundleNames.join(', ')}. '
              'Sie bleiben bestehen, können diese Quelle aber vorübergehend '
              'nicht berechnen.';
  final shouldDelete = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Aufgabe in Papierkorb?'),
        content: Text(
          '„${task.task.name}“ verschwindet einschließlich ihrer Historie aus '
          'regulären Ansichten und Auswertungen. Die Daten bleiben bis '
          '${_formatDateTime(preview.purgeAt)} wiederherstellbar.$bundleNote',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('In Papierkorb verschieben'),
          ),
        ],
      );
    },
  );

  if (shouldDelete == true) {
    await repository.moveTaskToTrash(preview);
  }
}

Future<void> _openLinkedBundleDetails({
  required BuildContext context,
  required TaskForDate task,
  required AufgabenRepository repository,
}) async {
  final bundles = task.linkedValueBundles;
  final selected =
      bundles.length == 1
          ? bundles.single
          : await showModalBottomSheet<TaskValueBundleForDate>(
            context: context,
            builder:
                (context) => SafeArea(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      const ListTile(title: Text('Bündel auswählen')),
                      ...bundles.map(
                        (bundle) => ListTile(
                          leading: const Icon(Icons.link_outlined),
                          title: Text(bundle.version.name),
                          onTap: () => Navigator.pop(context, bundle),
                        ),
                      ),
                    ],
                  ),
                ),
          );
  if (selected == null || !context.mounted) return;
  await Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder:
          (context) => TaskValueBundleDetailScreen(
            bundle: selected,
            repository: repository,
          ),
    ),
  );
}

String _formatDateTime(DateTime value) {
  final local = value.toLocal();
  return '${local.day.toString().padLeft(2, '0')}.'
      '${local.month.toString().padLeft(2, '0')}.${local.year}, '
      '${local.hour.toString().padLeft(2, '0')}:'
      '${local.minute.toString().padLeft(2, '0')} Uhr';
}

class _MessageState extends StatelessWidget {
  const _MessageState({required this.message, this.isError = false});

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color:
                isError
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

Future<DateTime?> _selectPerformedOnForPastEntry(
  BuildContext context,
  DateTime scheduledDate,
) async {
  final today = _dateOnly(DateTime.now());
  final plannedDay = _dateOnly(scheduledDate);
  if (!plannedDay.isBefore(today)) {
    return today;
  }
  final selection = await showDialog<String>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Wann wurde es durchgeführt?'),
          content: const Text(
            'Der Durchführungstag beeinflusst, ob der Eintrag rechtzeitig war. '
            'Bestehende Folgetermine werden dadurch nicht verschoben.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop('planned'),
              child: const Text('Am vorgesehenen Tag'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop('custom'),
              child: const Text('Anderes Datum'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop('today'),
              child: const Text('Heute'),
            ),
          ],
        ),
  );
  if (!context.mounted || selection == null) {
    return null;
  }
  if (selection == 'planned') {
    return plannedDay;
  }
  if (selection == 'today') {
    return today;
  }
  return showDatePicker(
    context: context,
    initialDate: plannedDay,
    firstDate: plannedDay,
    lastDate: today,
    helpText: 'Tatsächlicher Durchführungstag',
  );
}

String _formatDate(DateTime date) {
  const months = [
    'Januar',
    'Februar',
    'März',
    'April',
    'Mai',
    'Juni',
    'Juli',
    'August',
    'September',
    'Oktober',
    'November',
    'Dezember',
  ];
  final today = _dateOnly(DateTime.now());
  final prefix = date == today ? 'Heute, ' : '';

  return '$prefix${date.day}. ${months[date.month - 1]} ${date.year}';
}
