import 'package:flutter/material.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/projekte/data/project_repository.dart';
import 'package:momentum/features/projekte/presentation/widgets/project_color_picker.dart';
import 'package:momentum/features/projekte/presentation/widgets/task_assignment_section.dart';

class ProjectCreateScreen extends StatefulWidget {
  const ProjectCreateScreen({required this.repository, super.key});

  final ProjectRepository repository;

  @override
  State<ProjectCreateScreen> createState() => _ProjectCreateScreenState();
}

class _ProjectCreateScreenState extends State<ProjectCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final Set<String> _selectedTaskIds = {};

  String _selectedColorHex = projectColorOptions.first;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createProject() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await widget.repository.createProject(
        name: _nameController.text,
        description: _descriptionController.text,
        colorHex: _selectedColorHex,
        taskIds: _selectedTaskIds,
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Das Projekt konnte nicht gespeichert werden.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Projekt hinzufügen')),
      body: SafeArea(
        child: StreamBuilder<List<Aufgabe>>(
          stream: widget.repository.watchAssignableTasks(),
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
                        labelText: 'Projektname',
                        hintText: 'Wie heißt dein neues Projekt?',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Bitte gib einen Projektnamen ein.';
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
                    const SizedBox(height: 28),
                    StreamBuilder<List<Project>>(
                      stream: widget.repository.watchProjects(),
                      builder: (context, projectSnapshot) {
                        return ProjectColorPicker(
                          selectedColorHex: _selectedColorHex,
                          usedColorHexes:
                              projectSnapshot.data
                                  ?.map((project) => project.colorHex)
                                  .toSet() ??
                              const {},
                          enabled: !_isSaving,
                          onChanged: (colorHex) {
                            setState(() {
                              _selectedColorHex = colorHex;
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 28),
                    TaskAssignmentSection(
                      tasks: snapshot.data ?? const [],
                      selectedTaskIds: _selectedTaskIds,
                      onTaskChanged: (taskId, selected) {
                        setState(() {
                          selected
                              ? _selectedTaskIds.add(taskId)
                              : _selectedTaskIds.remove(taskId);
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      onPressed: _isSaving ? null : _createProject,
                      icon: const Icon(Icons.save_outlined),
                      label: Text(
                        _isSaving ? 'Wird gespeichert...' : 'Projekt speichern',
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
