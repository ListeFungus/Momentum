import 'package:flutter/material.dart';
import 'package:momentum/core/database/app_database.dart';

class TaskAssignmentSection extends StatelessWidget {
  const TaskAssignmentSection({
    required this.tasks,
    required this.selectedTaskIds,
    required this.onTaskChanged,
    super.key,
  });

  final List<Aufgabe> tasks;
  final Set<String> selectedTaskIds;
  final void Function(String taskId, bool selected) onTaskChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Aufgaben zuordnen',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          'Wähle bestehende Aufgaben und Habits. Eine vorhandene Zuordnung '
          'wird beim Speichern in dieses Projekt verschoben.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        if (tasks.isEmpty)
          const Text('Keine zuordenbaren Aufgaben vorhanden.')
        else
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                for (var index = 0; index < tasks.length; index++) ...[
                  CheckboxListTile(
                    value: selectedTaskIds.contains(tasks[index].id),
                    onChanged: (selected) {
                      onTaskChanged(tasks[index].id, selected ?? false);
                    },
                    title: Text(tasks[index].name),
                    subtitle:
                        tasks[index].beschreibung.trim().isEmpty
                            ? null
                            : Text(
                              tasks[index].beschreibung,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  if (index < tasks.length - 1)
                    const Divider(height: 1, indent: 16, endIndent: 16),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
