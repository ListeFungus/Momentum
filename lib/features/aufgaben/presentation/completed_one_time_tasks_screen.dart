import 'package:flutter/material.dart';
import 'package:momentum/core/settings/card_display_scope.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/task_capture_mode.dart';
import 'package:momentum/features/aufgaben/data/task_for_date.dart';
import 'package:momentum/features/aufgaben/presentation/task_detail_screen.dart';
import 'package:momentum/features/aufgaben/presentation/task_edit_screen.dart';
import 'package:momentum/features/aufgaben/presentation/task_value_bundle_create_screen.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_card.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_card_metric_selection_sheet.dart';
import 'package:momentum/features/projekte/data/project_repository.dart';

class CompletedOneTimeTasksScreen extends StatelessWidget {
  const CompletedOneTimeTasksScreen({
    required this.repository,
    required this.projectRepository,
    super.key,
  });

  final AufgabenRepository repository;
  final ProjectRepository projectRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Abgeschlossene Aufgaben')),
      body: SafeArea(
        child: StreamBuilder<List<TaskForDate>>(
          stream: repository.watchCompletedOneTimeTasks(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const _MessageState(
                message:
                    'Die abgeschlossenen Aufgaben konnten nicht geladen werden.',
                isError: true,
              );
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final tasks = snapshot.data!;
            if (tasks.isEmpty) {
              return const _MessageState(
                message:
                    'Noch keine abgeschlossenen einmaligen Aufgaben vorhanden.',
              );
            }

            return CardDisplaySession(
              cards: [
                for (final task in tasks)
                  DisplayCardIdentity.task(
                    task.task.id,
                    task.entry?.scheduledDate ?? task.task.startDate,
                  ),
              ],
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                itemCount: tasks.length,
                separatorBuilder:
                    (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  final scheduledDate =
                      task.entry?.scheduledDate ?? task.task.startDate;

                  return TaskCard(
                    key: ValueKey('task:${task.task.id}:$scheduledDate'),
                    task: task,
                    scheduledDate: scheduledDate,
                    metaLabel: _statusLabel(task),
                    onCompletedChanged: (isCompleted) {
                      repository.setTaskCompleted(
                        taskId: task.task.id,
                        scheduledDate: scheduledDate,
                        isCompleted: isCompleted,
                      );
                    },
                    onBooleanValueChanged: (value) {
                      repository.setBooleanHabitValue(
                        task: task.task,
                        scheduledDate: scheduledDate,
                        value: value,
                      );
                    },
                    onValueSaved: (value) {
                      repository.setTaskEntryValue(
                        task: task.task,
                        scheduledDate: scheduledDate,
                        valueType: task.task.valueType,
                        numberValue: value.numberValue,
                        durationSeconds: value.durationSeconds,
                        timeMinutes: value.timeMinutes,
                        dayOffset: value.dayOffset,
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
                        task.task.erfassungsmodus == TaskCaptureMode.value
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
                  );
                },
              ),
            );
          },
        ),
      ),
    );
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
          hintText: 'Optionale Notiz zu diesem Eintrag',
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

String? _statusLabel(TaskForDate task) {
  final date = task.entry?.scheduledDate;
  if (date == null) {
    return null;
  }

  return '${date.day.toString().padLeft(2, '0')}.'
      '${date.month.toString().padLeft(2, '0')}.'
      '${date.year}';
}

Future<void> _confirmDeleteTask({
  required BuildContext context,
  required AufgabenRepository repository,
  required TaskForDate task,
}) async {
  final preview = await repository.previewTaskDeletion(task.task.id);
  if (!context.mounted) return;
  final shouldDelete = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Aufgabe in Papierkorb?'),
        content: Text(
          '„${task.task.name}“ und ihre gespeicherten Einträge verschwinden '
          'aus regulären Auswertungen. Sie bleiben sieben Tage '
          'wiederherstellbar.',
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
