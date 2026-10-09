import 'package:flutter/material.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/presentation/aufgabe_hinzufuegen_screen.dart';
import 'package:momentum/features/aufgaben/presentation/aufgaben_screen.dart';
import 'package:momentum/features/aufgaben/presentation/task_creation_mode.dart';
import 'package:momentum/features/projekte/data/project_repository.dart';
import 'package:momentum/features/projekte/presentation/project_create_screen.dart';
import 'package:momentum/features/projekte/presentation/projects_screen.dart';
import 'package:momentum/widgets/expandable_floating_action_button.dart';

class Hauptseite extends StatefulWidget {
  const Hauptseite({
    required this.aufgabenRepository,
    required this.projectRepository,
    super.key,
  });

  final AufgabenRepository aufgabenRepository;
  final ProjectRepository projectRepository;

  @override
  State<Hauptseite> createState() => _HauptseiteState();
}

class _HauptseiteState extends State<Hauptseite> {
  int _selectedIndex = 0;

  void _openTaskCreateScreen() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder:
            (context) => AufgabeHinzufuegenScreen(
              aufgabenRepository: widget.aufgabenRepository,
              projectRepository: widget.projectRepository,
              creationMode: TaskCreationMode.advanced,
            ),
      ),
    );
  }

  void _openProjectCreateScreen() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder:
            (context) =>
                ProjectCreateScreen(repository: widget.projectRepository),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTaskPage = _selectedIndex == 0;
    final pages = [
      AufgabenScreen(
        aufgabenRepository: widget.aufgabenRepository,
        projectRepository: widget.projectRepository,
      ),
      ProjectsScreen(
        repository: widget.projectRepository,
        aufgabenRepository: widget.aufgabenRepository,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: pages),
      ),
      floatingActionButton: ExpandableFloatingActionButton(
        key: ValueKey(_selectedIndex),
        options:
            isTaskPage
                ? [
                  FloatingActionOption(
                    label: 'Freie Erstellung',
                    icon: Icons.tune,
                    onPressed: _openTaskCreateScreen,
                  ),
                ]
                : [
                  FloatingActionOption(
                    label: 'Projekt hinzufügen',
                    icon: Icons.create_new_folder,
                    onPressed: _openProjectCreateScreen,
                  ),
                ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            selectedIcon: Icon(Icons.check_circle),
            label: 'Aufgaben',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder),
            label: 'Projekte',
          ),
        ],
      ),
    );
  }
}
