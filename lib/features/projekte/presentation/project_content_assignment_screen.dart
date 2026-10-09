import 'package:flutter/material.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/projekte/data/project_repository.dart';

class ProjectContentAssignmentScreen extends StatefulWidget {
  const ProjectContentAssignmentScreen({
    required this.projectId,
    required this.repository,
    super.key,
  });

  final String projectId;
  final ProjectRepository repository;

  @override
  State<ProjectContentAssignmentScreen> createState() =>
      _ProjectContentAssignmentScreenState();
}

class _ProjectContentAssignmentScreenState
    extends State<ProjectContentAssignmentScreen> {
  final Set<String> _taskIds = {};
  final Set<String> _bundleIds = {};
  bool _initializedTasks = false;
  bool _initializedBundles = false;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inhalte zuordnen')),
      body: StreamBuilder<List<Aufgabe>>(
        stream: widget.repository.watchAssignableTasks(),
        builder: (context, taskSnapshot) {
          final tasks = taskSnapshot.data ?? const <Aufgabe>[];
          if (!_initializedTasks && taskSnapshot.hasData) {
            _initializedTasks = true;
            _taskIds.addAll(
              tasks
                  .where((task) => task.projectId == widget.projectId)
                  .map((task) => task.id),
            );
          }
          return StreamBuilder<List<ProjectBundleSummary>>(
            stream: widget.repository.watchAssignableBundles(),
            builder: (context, bundleSnapshot) {
              final bundles =
                  bundleSnapshot.data ?? const <ProjectBundleSummary>[];
              if (!_initializedBundles && bundleSnapshot.hasData) {
                _initializedBundles = true;
                _bundleIds.addAll(
                  bundles
                      .where(
                        (item) => item.bundle.projectId == widget.projectId,
                      )
                      .map((item) => item.bundle.id),
                );
              }
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    'Änderungen gelten ab heute. Inhalte aus anderen Projekten '
                    'werden transparent hierher verschoben.',
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Aufgaben und Habits',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  for (final task in tasks)
                    CheckboxListTile(
                      value: _taskIds.contains(task.id),
                      title: Text(task.name),
                      subtitle:
                          task.projectId == null ||
                                  task.projectId == widget.projectId
                              ? null
                              : const Text(
                                'Aktuell einem anderen Projekt zugeordnet',
                              ),
                      onChanged:
                          _saving
                              ? null
                              : (value) => setState(
                                () =>
                                    value == true
                                        ? _taskIds.add(task.id)
                                        : _taskIds.remove(task.id),
                              ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    'Bündel',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  for (final item in bundles)
                    CheckboxListTile(
                      value: _bundleIds.contains(item.bundle.id),
                      title: Text(item.name),
                      subtitle:
                          item.bundle.projectId == null ||
                                  item.bundle.projectId == widget.projectId
                              ? null
                              : const Text(
                                'Aktuell einem anderen Projekt zugeordnet',
                              ),
                      onChanged:
                          _saving
                              ? null
                              : (value) => setState(
                                () =>
                                    value == true
                                        ? _bundleIds.add(item.bundle.id)
                                        : _bundleIds.remove(item.bundle.id),
                              ),
                    ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Zuordnung speichern'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await widget.repository.replaceCurrentAssignments(
        projectId: widget.projectId,
        taskIds: _taskIds,
        bundleIds: _bundleIds,
      );
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Zuordnung fehlgeschlagen: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
