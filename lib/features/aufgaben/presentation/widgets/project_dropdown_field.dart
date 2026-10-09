import 'package:flutter/material.dart';
import 'package:momentum/core/database/app_database.dart';

class ProjectDropdownField extends StatelessWidget {
  const ProjectDropdownField({
    required this.projects,
    required this.selectedProjectId,
    required this.onChanged,
    required this.enabled,
    super.key,
  });

  final List<Project> projects;
  final String selectedProjectId;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedProjectId,
      decoration: const InputDecoration(
        labelText: 'Projekt zuordnen',
        border: OutlineInputBorder(),
      ),
      items: [
        const DropdownMenuItem(value: '', child: Text('Ohne Projekt')),
        ...projects
            .where(
              (project) =>
                  project.archivedAt == null || project.id == selectedProjectId,
            )
            .map((project) {
              final archived = project.archivedAt != null;
              final isCurrent = project.id == selectedProjectId;
              return DropdownMenuItem(
                value: project.id,
                enabled: !archived || isCurrent,
                child: Text(
                  '${project.name}${archived ? ' (archiviert)' : ''}',
                ),
              );
            }),
      ],
      onChanged: enabled ? onChanged : null,
    );
  }
}
