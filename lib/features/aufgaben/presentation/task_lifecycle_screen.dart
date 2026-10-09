import 'package:flutter/material.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/task_capture_mode.dart';
import 'package:momentum/features/aufgaben/data/task_for_date.dart';
import 'package:momentum/features/aufgaben/data/task_lifecycle_service.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_modes/boolean_habit_input.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_modes/checkbox_task_input.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_modes/value_task_input.dart';
import 'package:momentum/features/projekte/data/project_repository.dart';

class TaskLifecycleScreen extends StatelessWidget {
  const TaskLifecycleScreen({
    required this.repository,
    required this.projectRepository,
    super.key,
  });

  final AufgabenRepository repository;
  final ProjectRepository projectRepository;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Planung & Papierkorb'),
          actions: [
            IconButton(
              tooltip: 'Papierkorb leeren',
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed:
                  () => _emptyTrash(context, repository, projectRepository),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pausiert'),
              Tab(text: 'Aufgaben'),
              Tab(text: 'Bündel'),
              Tab(text: 'Projekte'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _TaskList(
              stream: repository.watchPausedTasks(),
              emptyMessage: 'Keine pausierten Aufgaben oder Habits.',
              actionLabel: 'Fortsetzen',
              action: repository.resumeTask,
              onOpen:
                  (task) => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder:
                          (context) => _VoluntaryPauseEntryScreen(
                            repository: repository,
                            task: task,
                          ),
                    ),
                  ),
            ),
            _TaskList(
              stream: repository.watchTrashedTasks(),
              emptyMessage: 'Der Aufgaben-Papierkorb ist leer.',
              actionLabel: 'Wiederherstellen',
              action: repository.restoreTask,
              destructiveAction: repository.permanentlyDeleteTask,
            ),
            _BundleTrashList(repository: repository),
            _ProjectTrashList(repository: projectRepository),
          ],
        ),
      ),
    );
  }
}

class _ProjectTrashList extends StatelessWidget {
  const _ProjectTrashList({required this.repository});
  final ProjectRepository repository;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Project>>(
      stream: repository.watchTrashedProjects(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final projects = snapshot.data!;
        if (projects.isEmpty) {
          return const Center(child: Text('Keine Projekte im Papierkorb.'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: projects.length,
          separatorBuilder: (_, _) => const Divider(),
          itemBuilder: (context, index) {
            final project = projects[index];
            return ListTile(
              title: Text(project.name),
              subtitle: Text(
                'Im Papierkorb bis ${_formatDateTime(project.purgeAt!)}',
              ),
              trailing: TextButton(
                onPressed: () async {
                  final preview = await repository.previewProjectRestore(
                    project.id,
                  );
                  await repository.restoreProject(
                    preview,
                    includeContents: false,
                  );
                },
                child: const Text('Projekt wiederherstellen'),
              ),
            );
          },
        );
      },
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({
    required this.stream,
    required this.emptyMessage,
    required this.actionLabel,
    required this.action,
    this.destructiveAction,
    this.onOpen,
  });

  final Stream<List<Aufgabe>> stream;
  final String emptyMessage;
  final String actionLabel;
  final Future<void> Function(String id) action;
  final Future<void> Function(String id)? destructiveAction;
  final ValueChanged<Aufgabe>? onOpen;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Aufgabe>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Die Liste konnte nicht geladen werden.'),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final tasks = snapshot.data!;
        if (tasks.isEmpty) return Center(child: Text(emptyMessage));
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: tasks.length,
          separatorBuilder: (_, _) => const Divider(),
          itemBuilder: (context, index) {
            final task = tasks[index];
            return ListTile(
              onTap: onOpen == null ? null : () => onOpen!(task),
              title: Text(task.name),
              subtitle:
                  task.purgeAt == null
                      ? const Text(
                        'Vorhandene Einträge bleiben sichtbar und bearbeitbar.',
                      )
                      : Text(
                        'Endgültige Löschung: ${_formatDateTime(task.purgeAt!)}',
                      ),
              trailing: Wrap(
                spacing: 4,
                children: [
                  TextButton(
                    onPressed: () => action(task.id),
                    child: Text(actionLabel),
                  ),
                  if (destructiveAction != null)
                    IconButton(
                      tooltip: 'Endgültig löschen',
                      icon: const Icon(Icons.delete_forever_outlined),
                      onPressed:
                          () => _confirmPermanentDelete(
                            context,
                            name: task.name,
                            delete: () => destructiveAction!(task.id),
                          ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _VoluntaryPauseEntryScreen extends StatefulWidget {
  const _VoluntaryPauseEntryScreen({
    required this.repository,
    required this.task,
  });

  final AufgabenRepository repository;
  final Aufgabe task;

  @override
  State<_VoluntaryPauseEntryScreen> createState() =>
      _VoluntaryPauseEntryScreenState();
}

class _VoluntaryPauseEntryScreenState
    extends State<_VoluntaryPauseEntryScreen> {
  late Future<TaskForDate?> _task;

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _task = widget.repository.taskForDateIncludingPause(
      taskId: widget.task.id,
      date: _today,
    );
  }

  Future<void> _save(Future<void> operation) async {
    await operation;
    if (!mounted) return;
    setState(_reload);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Freiwilliger Eintrag gespeichert.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task.name)),
      body: FutureBuilder<TaskForDate?>(
        future: _task,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const Center(child: Text('Aufgabe nicht verfügbar.'));
            }
            return const Center(child: CircularProgressIndicator());
          }
          final task = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Die Planung bleibt pausiert. Dieser Eintrag zählt nur als '
                'freiwillig erfasster Wert für heute.',
              ),
              const SizedBox(height: 20),
              if (task.task.erfassungsmodus == TaskCaptureMode.value)
                ValueTaskInput(
                  task: task,
                  scheduledDate: _today,
                  onSave:
                      (value) => _save(
                        widget.repository.setTaskEntryValue(
                          task: task.task,
                          scheduledDate: _today,
                          valueType: task.task.valueType,
                          numberValue: value.numberValue,
                          durationSeconds: value.durationSeconds,
                          timeMinutes: value.timeMinutes,
                          dayOffset: value.dayOffset,
                        ),
                      ),
                )
              else if (task.task.erfassungsmodus == TaskCaptureMode.threeState)
                BooleanHabitInput(
                  value: task.booleanValue,
                  successValue: task.task.successValue,
                  hasNote: task.note.isNotEmpty,
                  onEditNote: () {},
                  onChanged:
                      (value) => _save(
                        widget.repository.setBooleanHabitValue(
                          task: task.task,
                          scheduledDate: _today,
                          value: value,
                        ),
                      ),
                )
              else
                CheckboxTaskInput(
                  isCompleted: task.isCompleted,
                  onChanged:
                      (value) => _save(
                        widget.repository.setTaskCompleted(
                          taskId: task.task.id,
                          scheduledDate: _today,
                          isCompleted: value,
                        ),
                      ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _BundleTrashList extends StatelessWidget {
  const _BundleTrashList({required this.repository});

  final AufgabenRepository repository;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TaskValueBundleLifecycleItem>>(
      stream: repository.watchBundleLifecycleItems(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Die Bündel konnten nicht geladen werden.'),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final items = snapshot.data!;
        if (items.isEmpty) {
          return const Center(child: Text('Keine Bündel vorhanden.'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (_, _) => const Divider(),
          itemBuilder: (context, index) {
            final item = items[index];
            final bundle = item.bundle;
            final inTrash = bundle.trashedAt != null;
            return ListTile(
              title: Text(item.version.name),
              subtitle: Text(
                [
                  if (inTrash)
                    'Im Papierkorb bis ${_formatDateTime(bundle.purgeAt!)}'
                  else if (!bundle.isActive)
                    'Aufgelöst'
                  else
                    'Aktiv',
                  if (item.unavailableReason != null) item.unavailableReason!,
                ].join('\n'),
              ),
              trailing:
                  !inTrash
                      ? null
                      : Wrap(
                        children: [
                          TextButton(
                            onPressed:
                                () => repository.restoreBundle(bundle.id),
                            child: const Text('Wiederherstellen'),
                          ),
                          IconButton(
                            tooltip: 'Endgültig löschen',
                            icon: const Icon(Icons.delete_forever_outlined),
                            onPressed:
                                () => _confirmPermanentDelete(
                                  context,
                                  name: item.version.name,
                                  delete:
                                      () => repository.permanentlyDeleteBundle(
                                        bundle.id,
                                      ),
                                ),
                          ),
                        ],
                      ),
            );
          },
        );
      },
    );
  }
}

Future<void> _emptyTrash(
  BuildContext context,
  AufgabenRepository repository,
  ProjectRepository projectRepository,
) async {
  final preview = await repository.previewEmptyTrash();
  final projects = await projectRepository.watchTrashedProjects().first;
  if (!context.mounted) return;
  if (preview.isEmpty && projects.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Der Papierkorb ist bereits leer.')),
    );
    return;
  }
  final names = [
    ...preview.tasks.map((item) => 'Aufgabe: ${item.name}'),
    ...preview.bundles.map((item) => 'Bündel: ${item.name}'),
    ...projects.map((item) => 'Projekt: ${item.name}'),
  ];
  final confirmed = await showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Papierkorb endgültig leeren?'),
          content: SingleChildScrollView(
            child: Text(
              '${names.join('\n')}\n\n'
              'Diese Daten werden dauerhaft entfernt und können nicht '
              'wiederhergestellt werden.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Abbrechen'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Endgültig leeren'),
            ),
          ],
        ),
  );
  if (confirmed == true) {
    await repository.emptyTrash(preview);
    for (final project in projects) {
      await projectRepository.purgeProject(project.id);
    }
  }
}

Future<void> _confirmPermanentDelete(
  BuildContext context, {
  required String name,
  required Future<void> Function() delete,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Endgültig löschen?'),
          content: Text(
            '„$name“ wird dauerhaft entfernt und kann nicht wiederhergestellt werden.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Abbrechen'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Endgültig löschen'),
            ),
          ],
        ),
  );
  if (confirmed == true) await delete();
}

String _formatDateTime(DateTime value) {
  final local = value.toLocal();
  return '${local.day.toString().padLeft(2, '0')}.'
      '${local.month.toString().padLeft(2, '0')}.${local.year} '
      '${local.hour.toString().padLeft(2, '0')}:'
      '${local.minute.toString().padLeft(2, '0')}';
}
