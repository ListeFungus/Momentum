import 'dart:async';

import 'package:flutter/material.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/projekte/data/project_repository.dart';
import 'package:momentum/landing_page.dart';

void main() {
  runApp(const MomentumApp());
}

class MomentumApp extends StatefulWidget {
  const MomentumApp({super.key});

  @override
  State<MomentumApp> createState() => _MomentumAppState();
}

class _MomentumAppState extends State<MomentumApp> with WidgetsBindingObserver {
  late final AppDatabase _database;
  late final AufgabenRepository _aufgabenRepository;
  late final ProjectRepository _projectRepository;
  Timer? _taskInstanceSchedulerTimer;
  bool _isTaskInstanceSchedulerRunning = false;

  @override
  void initState() {
    super.initState();
    _database = AppDatabase();
    _aufgabenRepository = AufgabenRepository(_database);
    _projectRepository = ProjectRepository(_database);
    WidgetsBinding.instance.addObserver(this);
    unawaited(_runTaskInstanceScheduler());
    _scheduleNextTaskInstanceSchedulerRun();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _taskInstanceSchedulerTimer?.cancel();
    _database.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_runTaskInstanceScheduler());
      _scheduleNextTaskInstanceSchedulerRun();
    }
  }

  Future<void> _runTaskInstanceScheduler() async {
    if (_isTaskInstanceSchedulerRunning) {
      return;
    }

    _isTaskInstanceSchedulerRunning = true;

    try {
      await _projectRepository.purgeExpiredProjects();
      await _aufgabenRepository.ensureTaskInstancesUpToDate();
    } catch (error, stackTrace) {
      debugPrint('TaskInstanceScheduler failed: $error\n$stackTrace');
    } finally {
      _isTaskInstanceSchedulerRunning = false;
    }
  }

  void _scheduleNextTaskInstanceSchedulerRun() {
    _taskInstanceSchedulerTimer?.cancel();

    final now = DateTime.now();
    final nextDay = DateTime(now.year, now.month, now.day + 1);
    final delayUntilNextDay = nextDay.difference(now);

    _taskInstanceSchedulerTimer = Timer(delayUntilNextDay, () {
      unawaited(_runTaskInstanceScheduler());
      _scheduleNextTaskInstanceSchedulerRun();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Momentum',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF607D8B),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F1EC),
        useMaterial3: true,
      ),
      home: WelcomePage(
        aufgabenRepository: _aufgabenRepository,
        projectRepository: _projectRepository,
      ),
    );
  }
}
