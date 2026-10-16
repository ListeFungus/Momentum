import 'package:flutter/material.dart';
import 'package:momentum/core/settings/options_screen.dart';
import 'package:momentum/core/backup/backup_service.dart';
import 'package:momentum/core/backup/backup_screen.dart';
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
    required this.backupService,
    required this.onRestore,
    super.key,
  });

  final AufgabenRepository aufgabenRepository;
  final ProjectRepository projectRepository;
  final BackupService backupService;
  final Future<void> Function(PreparedBackup) onRestore;

  @override
  State<Hauptseite> createState() => _HauptseiteState();
}

class _HauptseiteState extends State<Hauptseite> {
  int _selectedIndex = 0;
  bool _backupOpen = false;
  int _taskViewSession = 0;

  void _selectPage(int index) {
    setState(() {
      if (index != _selectedIndex) _taskViewSession++;
      _selectedIndex = index;
    });
  }

  Future<void> _openBackup() async {
    Navigator.pop(context);
    setState(() => _backupOpen = true);
    // Dispose the task views (including pending undo controls) while replacing
    // the data. They are recreated against the restored snapshot afterwards.
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder:
            (_) => BackupScreen(
              service: widget.backupService,
              onRestore: widget.onRestore,
            ),
      ),
    );
    if (mounted) setState(() => _backupOpen = false);
  }

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
        displaySession: _taskViewSession,
        aufgabenRepository: widget.aufgabenRepository,
        projectRepository: widget.projectRepository,
      ),
      ProjectsScreen(
        repository: widget.projectRepository,
        aufgabenRepository: widget.aufgabenRepository,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Momentum'), toolbarHeight: 48),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Momentum',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: const Text('Aufgaben & Habits'),
                onTap: () {
                  Navigator.pop(context);
                  _selectPage(0);
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder_outlined),
                title: const Text('Projekte'),
                onTap: () {
                  Navigator.pop(context);
                  _selectPage(1);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Optionen'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const OptionsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.save_outlined),
                title: const Text('Import & Export'),
                subtitle: const Text('Datensicherung'),
                onTap: _openBackup,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child:
            _backupOpen
                ? const SizedBox.shrink()
                : IndexedStack(index: _selectedIndex, children: pages),
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
        onDestinationSelected: _selectPage,
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
