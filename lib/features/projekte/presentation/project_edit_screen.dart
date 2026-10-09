import 'package:flutter/material.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/projekte/data/project_repository.dart';
import 'package:momentum/features/projekte/presentation/widgets/project_color_picker.dart';

class ProjectEditScreen extends StatefulWidget {
  const ProjectEditScreen({
    required this.project,
    required this.repository,
    super.key,
  });

  final Project project;
  final ProjectRepository repository;

  @override
  State<ProjectEditScreen> createState() => _ProjectEditScreenState();
}

class _ProjectEditScreenState extends State<ProjectEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  late String _selectedColorHex;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project.name);
    _descriptionController = TextEditingController(
      text: widget.project.description,
    );
    _selectedColorHex = widget.project.colorHex;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateProject() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await widget.repository.updateProject(
        projectId: widget.project.id,
        name: _nameController.text,
        description: _descriptionController.text,
        colorHex: _selectedColorHex,
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Das Projekt konnte nicht aktualisiert werden.'),
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
      appBar: AppBar(title: const Text('Projekt bearbeiten')),
      body: SafeArea(
        child: SingleChildScrollView(
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
                              ?.where(
                                (project) => project.id != widget.project.id,
                              )
                              .map((project) => project.colorHex)
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
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: _isSaving ? null : _updateProject,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(
                    _isSaving ? 'Wird gespeichert...' : 'Änderungen speichern',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
