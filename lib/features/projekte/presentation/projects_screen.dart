import 'package:flutter/material.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/projekte/data/project_repository.dart';
import 'package:momentum/features/projekte/data/project_lifecycle_service.dart';
import 'package:momentum/features/projekte/presentation/project_edit_screen.dart';
import 'package:momentum/features/projekte/presentation/project_detail_screen.dart';
import 'package:momentum/features/projekte/presentation/widgets/project_card.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({
    required this.repository,
    required this.aufgabenRepository,
    super.key,
  });

  final ProjectRepository repository;
  final AufgabenRepository aufgabenRepository;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Aktiv'),
              Tab(text: 'Archiv'),
              Tab(text: 'Papierkorb'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _ProjectList(
                  repository: repository,
                  aufgabenRepository: aufgabenRepository,
                ),
                _ProjectList(
                  repository: repository,
                  aufgabenRepository: aufgabenRepository,
                  archived: true,
                ),
                _ProjectTrash(repository: repository),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectList extends StatelessWidget {
  const _ProjectList({
    required this.repository,
    required this.aufgabenRepository,
    this.archived = false,
  });

  final ProjectRepository repository;
  final AufgabenRepository aufgabenRepository;
  final bool archived;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Project>>(
      stream:
          archived
              ? repository.watchArchivedProjects()
              : repository.watchProjects(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Die Projekte konnten nicht geladen werden.'),
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final projects = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Text(
                'Deine Projekte',
                style: TextStyle(
                  color: Color(0xFF263B47),
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: Text(
                'Zum Sortieren eine Projektkarte gedrückt halten und verschieben.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (projects.isEmpty)
              const Expanded(
                child: Center(child: Text('Noch keine Projekte vorhanden.')),
              )
            else
              Expanded(
                child: ReorderableListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                  buildDefaultDragHandles: false,
                  itemCount: projects.length,
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) {
                      newIndex--;
                    }

                    final reorderedProjects = [...projects];
                    final project = reorderedProjects.removeAt(oldIndex);
                    reorderedProjects.insert(newIndex, project);

                    repository.reorderProjects(
                      reorderedProjects.map((project) => project.id).toList(),
                    );
                  },
                  itemBuilder: (context, index) {
                    final project = projects[index];

                    return Padding(
                      key: ValueKey(project.id),
                      padding: const EdgeInsets.only(bottom: 14),
                      child: ReorderableDelayedDragStartListener(
                        index: index,
                        child: ProjectCard(
                          project: project,
                          onOpen: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder:
                                    (context) => ProjectDetailScreen(
                                      projectId: project.id,
                                      repository: repository,
                                      aufgabenRepository: aufgabenRepository,
                                    ),
                              ),
                            );
                          },
                          onEdit: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder:
                                    (context) => ProjectEditScreen(
                                      project: project,
                                      repository: repository,
                                    ),
                              ),
                            );
                          },
                          onDelete: () {
                            _confirmDeleteProject(
                              context: context,
                              project: project,
                              repository: repository,
                            );
                          },
                          onArchive: () async {
                            if (archived) {
                              await repository.unarchiveProject(project.id);
                            } else {
                              await repository.archiveProject(project.id);
                            }
                          },
                          archiveLabel:
                              archived
                                  ? 'Aus Archiv holen'
                                  : 'Projekt archivieren',
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ProjectTrash extends StatelessWidget {
  const _ProjectTrash({required this.repository});
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
          return const Center(child: Text('Der Projekt-Papierkorb ist leer.'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: projects.length,
          separatorBuilder: (_, _) => const Divider(),
          itemBuilder: (context, index) {
            final project = projects[index];
            return ListTile(
              title: Text(project.name),
              subtitle: Text(
                project.purgeAt == null
                    ? 'Im Papierkorb'
                    : 'Wiederherstellbar bis ${project.purgeAt}',
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (action) async {
                  if (action == 'restore') {
                    final preview = await repository.previewProjectRestore(
                      project.id,
                    );
                    if (!context.mounted) return;
                    var withContents = false;
                    if (preview.restorableTaskIds.isNotEmpty ||
                        preview.restorableBundleIds.isNotEmpty) {
                      final choice = await showDialog<bool>(
                        context: context,
                        builder:
                            (dialogContext) => AlertDialog(
                              title: const Text('Projekt wiederherstellen'),
                              content: Text(
                                '${preview.restorableTaskIds.length} '
                                'Aufgaben/Habits und '
                                '${preview.restorableBundleIds.length} Bündel '
                                'gehören zu diesem Löschvorgang. '
                                '${preview.skippedCount} Inhalte werden '
                                'ausgelassen.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(
                                        dialogContext,
                                      ).pop(false),
                                  child: const Text('Nur Projekt'),
                                ),
                                FilledButton(
                                  onPressed:
                                      () =>
                                          Navigator.of(dialogContext).pop(true),
                                  child: const Text('Projekt und Inhalte'),
                                ),
                              ],
                            ),
                      );
                      if (choice == null) return;
                      withContents = choice;
                    }
                    await repository.restoreProject(
                      preview,
                      includeContents: withContents,
                    );
                  } else {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder:
                          (dialogContext) => AlertDialog(
                            title: const Text('Endgültig löschen?'),
                            content: const Text(
                              'Der Projektname, die Beschreibung und die Farbe '
                              'werden dauerhaft entfernt.',
                            ),
                            actions: [
                              TextButton(
                                onPressed:
                                    () =>
                                        Navigator.of(dialogContext).pop(false),
                                child: const Text('Abbrechen'),
                              ),
                              FilledButton(
                                onPressed:
                                    () => Navigator.of(dialogContext).pop(true),
                                child: const Text('Endgültig löschen'),
                              ),
                            ],
                          ),
                    );
                    if (confirmed != true) return;
                    await repository.purgeProject(project.id);
                  }
                },
                itemBuilder:
                    (_) => const [
                      PopupMenuItem(
                        value: 'restore',
                        child: Text('Wiederherstellen'),
                      ),
                      PopupMenuItem(
                        value: 'purge',
                        child: Text('Endgültig löschen'),
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

Future<void> _confirmDeleteProject({
  required BuildContext context,
  required Project project,
  required ProjectRepository repository,
}) async {
  final preview = await repository.previewProjectDeletion(project.id);
  if (!context.mounted) return;
  final choice = await showDialog<_ProjectDeleteChoice>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('„${project.name}“ löschen?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Was soll mit den zugeordneten Inhalten passieren?'),
            const SizedBox(height: 8),
            Text(
              '${preview.tasks.length} Aufgaben/Habits und '
              '${preview.bundles.length} Bündel sind aktuell zugeordnet. '
              'Wiederherstellbar bis ${preview.purgeAt}.',
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed:
                  () => Navigator.of(
                    context,
                  ).pop(_ProjectDeleteChoice.projectOnly),
              icon: const Icon(Icons.folder_delete_outlined),
              label: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nur Projekt löschen'),
                      SizedBox(height: 2),
                      Text(
                        'Aufgaben, Habits und Bündel bleiben erhalten und sind '
                        'danach ohne Projekt.',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed:
                  () => Navigator.of(
                    context,
                  ).pop(_ProjectDeleteChoice.projectAndTasks),
              icon: const Icon(Icons.delete_forever_outlined),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              label: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Projekt und Inhalte löschen'),
                      SizedBox(height: 2),
                      Text(
                        'Alle aktuell zugeordneten Aufgaben, Habits und Bündel '
                        'kommen ebenfalls in den Papierkorb.',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
        ],
      );
    },
  );

  if (choice != null && context.mounted) {
    await repository.confirmProjectDeletion(
      preview,
      choice == _ProjectDeleteChoice.projectOnly
          ? ProjectDeletionChoice.projectOnly
          : ProjectDeletionChoice.projectAndContents,
    );
  }
}

enum _ProjectDeleteChoice { projectOnly, projectAndTasks }
