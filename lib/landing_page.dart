import 'package:flutter/material.dart';
import 'package:momentum/core/backup/backup_service.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/projekte/data/project_repository.dart';
import 'package:momentum/hauptseiten/hauptseite.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Semantics(
            button: true,
            label: 'Hauptseite öffnen',
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder:
                        (context) => Hauptseite(
                          aufgabenRepository: aufgabenRepository,
                          projectRepository: projectRepository,
                          backupService: backupService,
                          onRestore: onRestore,
                        ),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Text.rich(
                  TextSpan(
                    text: 'Willkommen bei ',
                    children: [
                      TextSpan(
                        text: 'Momentum',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF263B47),
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
