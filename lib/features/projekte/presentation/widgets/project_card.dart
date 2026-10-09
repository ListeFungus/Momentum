import 'package:flutter/material.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/core/theme/hex_color.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    required this.project,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
    this.onArchive,
    this.archiveLabel = 'Projekt archivieren',
    super.key,
  });

  final Project project;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onArchive;
  final String archiveLabel;

  @override
  Widget build(BuildContext context) {
    final hasDescription = project.description.trim().isNotEmpty;
    final projectColor = colorFromHex(project.colorHex);
    final foregroundColor =
        projectColor.computeLuminance() > 0.48
            ? const Color(0xFF172126)
            : Colors.white;

    return Semantics(
      button: true,
      label: 'Projekt ${project.name} oeffnen',
      child: GestureDetector(
        onTap: onOpen,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: projectColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: projectColor.withValues(alpha: 0.8)),
            boxShadow: [
              BoxShadow(
                color: projectColor.withValues(alpha: 0.24),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        project.name,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: foregroundColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    PopupMenuButton<_ProjectAction>(
                      tooltip: 'Projektoptionen',
                      onSelected: (action) {
                        switch (action) {
                          case _ProjectAction.edit:
                            onEdit();
                          case _ProjectAction.delete:
                            onDelete();
                          case _ProjectAction.archive:
                            onArchive?.call();
                        }
                      },
                      itemBuilder:
                          (context) => [
                            PopupMenuItem(
                              value: _ProjectAction.archive,
                              child: Row(
                                children: [
                                  Icon(Icons.archive_outlined),
                                  SizedBox(width: 12),
                                  Text(archiveLabel),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: _ProjectAction.edit,
                              child: Row(
                                children: [
                                  Icon(Icons.edit_outlined),
                                  SizedBox(width: 12),
                                  Text('Projekt bearbeiten'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: _ProjectAction.delete,
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline),
                                  SizedBox(width: 12),
                                  Text('Projekt loeschen'),
                                ],
                              ),
                            ),
                          ],
                      icon: Icon(Icons.more_vert, color: foregroundColor),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                if (hasDescription) ...[
                  const SizedBox(height: 8),
                  Text(
                    project.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: foregroundColor.withValues(alpha: 0.82),
                      height: 1.45,
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                Row(
                  children: [
                    Icon(Icons.folder_open, color: foregroundColor, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Projekt oeffnen',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: foregroundColor.withValues(alpha: 0.88),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _ProjectAction { edit, archive, delete }
