import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:momentum/core/backup/backup_service.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/core/settings/card_display_repository.dart';
import 'package:momentum/core/settings/card_display_scope.dart';
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
  Future<void>? _schedulerFuture;
  bool _restoring = false;
  int _session = 0;
  late final BackupService _backupService;
  late final CardDisplayRepository _cardDisplayRepository;

  @override
  void initState() {
    super.initState();
    _database = AppDatabase();
    _backupService = BackupService(_database);
    _cardDisplayRepository = CardDisplayRepository(_database);
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

  Future<void> _runTaskInstanceScheduler() {
    if (_restoring || _isTaskInstanceSchedulerRunning) return Future.value();
    return _schedulerFuture = _performTaskInstanceScheduler();
  }

  Future<void> _performTaskInstanceScheduler() async {
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

  Future<void> _restoreBackup(PreparedBackup backup) async {
    _restoring = true;
    try {
      await _schedulerFuture;
      await _backupService.restore(backup);
      if (mounted) setState(() => _session++);
    } finally {
      _restoring = false;
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
      key: ValueKey(_session),
      debugShowCheckedModeBanner: false,
      title: 'Momentum',
      navigatorObservers: [cardDisplayRouteObserver],
      builder:
          (context, child) => CardDisplayHost(
            key: ValueKey(_session),
            repository: _cardDisplayRepository,
            child: child!,
          ),
      locale: const Locale('de'),
      supportedLocales: const [Locale('de')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF607D8B),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F1EC),
        useMaterial3: true,
      ),
      home: WelcomePage(
        backupService: _backupService,
        onRestore: _restoreBackup,
        aufgabenRepository: _aufgabenRepository,
        projectRepository: _projectRepository,
      ),
    );
  }
}
