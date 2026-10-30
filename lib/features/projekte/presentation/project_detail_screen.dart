import 'dart:async';
import 'package:flutter/material.dart';
import 'package:momentum/core/theme/hex_color.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/core/date/calendar_days.dart';
import 'package:momentum/features/aufgaben/data/task_for_date.dart';
import 'project_task_entry_input.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/value_draft_scope.dart';
import 'package:momentum/features/aufgaben/presentation/aufgabe_hinzufuegen_screen.dart';
import 'package:momentum/features/aufgaben/presentation/task_detail_screen.dart';
import 'package:momentum/features/aufgaben/data/task_types.dart';
import 'package:momentum/features/projekte/data/project_repository.dart';
import 'package:momentum/features/projekte/presentation/project_content_assignment_screen.dart';
import 'package:momentum/features/projekte/presentation/project_bundle_detail_screen.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({
    required this.projectId,
    required this.repository,
    required this.aufgabenRepository,
    super.key,
  });

  final String projectId;
  final ProjectRepository repository;
  final AufgabenRepository aufgabenRepository;

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  final _drafts = ValueDraftStore();
  late final _detail = widget.repository.watchProjectDetail(widget.projectId);
  String get projectId => widget.projectId;
  ProjectRepository get repository => widget.repository;
  AufgabenRepository get aufgabenRepository => widget.aufgabenRepository;

  @override
  void dispose() {
    _drafts.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueDraftScope(
      store: _drafts,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          if (await _drafts.confirm(context) && context.mounted) {
            Navigator.of(context).pop(result);
          }
        },
        child: StreamBuilder<ProjectDetail?>(
          stream: _detail,
          builder: (context, snapshot) {
            final detail = snapshot.data;

            return DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(detail?.project.name ?? 'Projekt'),
                  bottom: const TabBar(
                    tabs: [Tab(text: 'Uebersicht'), Tab(text: 'Analyse')],
                  ),
                ),
                body: _ProjectDetailBody(
                  snapshot: snapshot,
                  repository: repository,
                  aufgabenRepository: aufgabenRepository,
                  projectId: projectId,
                ),
                floatingActionButton:
                    detail == null ||
                            detail.project.archivedAt != null ||
                            detail.project.trashedAt != null
                        ? null
                        : FloatingActionButton.extended(
                          onPressed: () => _showAddContent(context),
                          icon: const Icon(Icons.add),
                          label: const Text('Inhalt hinzufügen'),
                        ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showAddContent(BuildContext context) async {
    if (!await _drafts.confirm(context) || !context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder:
          (sheetContext) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.add_task),
                  title: const Text('Aufgabe oder Habit erstellen'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder:
                            (_) => AufgabeHinzufuegenScreen(
                              aufgabenRepository: aufgabenRepository,
                              projectRepository: repository,
                              initialProjectId: projectId,
                            ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.playlist_add),
                  title: const Text('Vorhandene Inhalte zuordnen'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder:
                            (_) => ProjectContentAssignmentScreen(
                              projectId: projectId,
                              repository: repository,
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
    );
  }
}

class _ProjectDetailBody extends StatelessWidget {
  const _ProjectDetailBody({
    required this.snapshot,
    required this.repository,
    required this.aufgabenRepository,
    required this.projectId,
  });

  final AsyncSnapshot<ProjectDetail?> snapshot;
  final ProjectRepository repository;
  final AufgabenRepository aufgabenRepository;
  final String projectId;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasError) {
      return const Center(
        child: Text('Das Projekt konnte nicht geladen werden.'),
      );
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    final detail = snapshot.data;
    if (detail == null) {
      return const Center(child: Text('Dieses Projekt existiert nicht mehr.'));
    }

    return TabBarView(
      children: [
        _ProjectOverviewTab(
          detail: detail,
          repository: repository,
          aufgabenRepository: aufgabenRepository,
        ),
        _ProjectAnalysisTab(repository: repository, projectId: projectId),
      ],
    );
  }
}

class _ProjectOverviewTab extends StatefulWidget {
  const _ProjectOverviewTab({
    required this.detail,
    required this.repository,
    required this.aufgabenRepository,
  });

  final ProjectDetail detail;
  final ProjectRepository repository;
  final AufgabenRepository aufgabenRepository;

  @override
  State<_ProjectOverviewTab> createState() => _ProjectOverviewTabState();
}

class _ProjectOverviewTabState extends State<_ProjectOverviewTab>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  late DateTime _day = calendarDay(DateTime.now());
  late Stream<List<TaskForDate>> _entries = widget.aufgabenRepository
      .watchProjectDayTasks(widget.detail.project.id, _day);
  Timer? _dayTimer;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _dayTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _refreshDay(),
    );
  }

  void _refreshDay() {
    final today = calendarDay(DateTime.now());
    if (!mounted ||
        today == _day ||
        (ValueDraftScope.maybeOf(context)?.drafts.isNotEmpty ?? false)) {
      return;
    }
    setState(() {
      _day = today;
      _entries = aufgabenRepository.watchProjectDayTasks(
        detail.project.id,
        _day,
      );
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshDay();
  }

  @override
  void dispose() {
    _dayTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  ProjectDetail get detail => widget.detail;
  ProjectRepository get repository => widget.repository;
  AufgabenRepository get aufgabenRepository => widget.aufgabenRepository;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List<TaskForDate>>(
      stream: _entries,
      builder: (context, snapshot) => _buildOverview(context, snapshot),
    );
  }

  Widget _buildOverview(
    BuildContext context,
    AsyncSnapshot<List<TaskForDate>> snapshot,
  ) {
    final habits =
        detail.tasks
            .where((item) => item.task.taskType == TaskTypes.habit)
            .toList();
    final tasks =
        detail.tasks
            .where((item) => item.task.taskType == TaskTypes.task)
            .toList();
    final projectColor = colorFromHex(detail.project.colorHex);
    if (tasks.isEmpty && habits.isEmpty && detail.bundles.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _ProjectHeader(detail: detail, projectColor: projectColor),
          const SizedBox(height: 48),
          const Center(child: Text('Noch keine Inhalte zugeordnet.')),
        ],
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 96),
      children: [
        _ProjectHeader(detail: detail, projectColor: projectColor),
        if (snapshot.hasError)
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text('Die Tageseinträge konnten nicht geladen werden.'),
          ),
        _ContentGroup(
          title: 'Aufgaben',
          children: [
            for (final task in tasks)
              _ProjectTaskTile(
                summary: task,
                accentColor: projectColor,
                inputs: _inputsFor(task, snapshot, projectColor),
                onTap:
                    () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder:
                            (_) => TaskDetailScreen(
                              task: task.task,
                              repository: aufgabenRepository,
                              project: detail.project,
                            ),
                      ),
                    ),
              ),
          ],
        ),
        _ContentGroup(
          title: 'Habits',
          children: [
            for (final habit in habits)
              _ProjectTaskTile(
                summary: habit,
                accentColor: projectColor,
                inputs: _inputsFor(habit, snapshot, projectColor),
                onTap:
                    () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder:
                            (_) => TaskDetailScreen(
                              task: habit.task,
                              repository: aufgabenRepository,
                              project: detail.project,
                            ),
                      ),
                    ),
              ),
          ],
        ),
        _ContentGroup(
          title: 'Bündel',
          children: [
            for (final bundle in detail.bundles)
              ListTile(
                onTap:
                    () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder:
                            (_) => ProjectBundleDetailScreen(
                              bundleId: bundle.bundle.id,
                              projectRepository: repository,
                              aufgabenRepository: aufgabenRepository,
                            ),
                      ),
                    ),
                leading: const Icon(Icons.link_outlined),
                title: Text(bundle.name),
                subtitle: Text(bundle.isResolved ? 'Aufgelöst' : 'Aktiv'),
              ),
          ],
        ),
      ],
    );
  }

  List<Widget> _inputsFor(
    ProjectTaskSummary summary,
    AsyncSnapshot<List<TaskForDate>> snapshot,
    Color color,
  ) {
    if (!snapshot.hasData ||
        snapshot.hasError ||
        detail.project.trashedAt != null) {
      return const [];
    }
    final entries =
        snapshot.data!.where((item) => item.task.id == summary.task.id).toList()
          ..sort(
            (a, b) => (a.entry?.scheduledDate ?? _day).compareTo(
              b.entry?.scheduledDate ?? _day,
            ),
          );
    if (entries.isEmpty) {
      return const [
        Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text(
            'Heute kein bearbeitbarer Eintrag. Frühere Einträge findest du in den Details.',
          ),
        ),
      ];
    }
    return [
      for (final entry in entries)
        ProjectTaskEntryInput(
          key: ValueKey(
            '${entry.task.id}:${entry.entry?.scheduledDate ?? _day}',
          ),
          task: entry,
          scheduledDate: entry.entry?.scheduledDate ?? _day,
          repository: aufgabenRepository,
          accentColor: color,
        ),
    ];
  }
}

class _ContentGroup extends StatelessWidget {
  const _ContentGroup({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...children.expand((child) => [child, const SizedBox(height: 10)]),
        ],
      ),
    );
  }
}

class _ProjectHeader extends StatelessWidget {
  const _ProjectHeader({required this.detail, required this.projectColor});

  final ProjectDetail detail;
  final Color projectColor;

  @override
  Widget build(BuildContext context) {
    final description = detail.project.description.trim();
    final nextDueDate = detail.nextDueDate;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          projectColor.withValues(alpha: 0.08),
          Theme.of(context).colorScheme.surface,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: projectColor.withValues(alpha: 0.28)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(width: 7, child: ColoredBox(color: projectColor)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail.project.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ],
                    if (nextDueDate != null) ...[
                      const SizedBox(height: 12),
                      _InfoPill(
                        icon: Icons.event_outlined,
                        label:
                            'Naechste Faelligkeit: ${_formatDate(nextDueDate)}',
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectAnalysisTab extends StatefulWidget {
  const _ProjectAnalysisTab({
    required this.repository,
    required this.projectId,
  });

  final ProjectRepository repository;
  final String projectId;

  @override
  State<_ProjectAnalysisTab> createState() => _ProjectAnalysisTabState();
}

class _ProjectAnalysisTabState extends State<_ProjectAnalysisTab> {
  int? _days = 7;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProjectAnalyticsSummary>(
      stream: widget.repository.watchProjectAnalytics(
        widget.projectId,
        days: _days,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final summary = snapshot.data!;
        return ListView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          children: [
            SegmentedButton<int?>(
              segments: const [
                ButtonSegment(value: 7, label: Text('7 Tage')),
                ButtonSegment(value: 20, label: Text('20 Tage')),
                ButtonSegment(value: 30, label: Text('30 Tage')),
                ButtonSegment(value: null, label: Text('Seit Beginn')),
              ],
              selected: {_days},
              onSelectionChanged:
                  (value) => setState(() => _days = value.single),
            ),
            const SizedBox(height: 16),
            _StatusSection(
              title: 'Aufgaben und Habits',
              values: summary.taskStatusCounts,
            ),
            const SizedBox(height: 14),
            _StatusSection(
              title: 'Bündel',
              values: {
                'Vollständig': summary.bundleCompleteCount,
                'Teilweise': summary.bundlePartialCount,
                'Fehlend': summary.bundleMissingCount,
                'Nicht berechenbar': summary.bundleNotCalculableCount,
              },
              warning:
                  summary.hasUnavailableBundle
                      ? 'Nicht alle Bündel auswertbar.'
                      : null,
            ),
            const SizedBox(height: 14),
            _StatusSection(
              title: 'Inhalte im Zeitraum',
              values: {
                for (final name in summary.taskNames) 'Aufgabe: $name': 1,
                for (final name in summary.bundleNames) 'Bündel: $name': 1,
              },
              hideValues: true,
            ),
          ],
        );
      },
    );
  }
}

class _StatusSection extends StatelessWidget {
  const _StatusSection({
    required this.title,
    required this.values,
    this.warning,
    this.hideValues = false,
  });
  final String title;
  final Map<String, int> values;
  final String? warning;
  final bool hideValues;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            if (warning != null) ...[
              const SizedBox(height: 6),
              Text(
                warning!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            if (values.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text('Keine Einträge im Zeitraum.'),
              )
            else
              ...values.entries.map(
                (entry) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(entry.key),
                  trailing: hideValues ? null : Text(entry.value.toString()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProjectTaskTile extends StatelessWidget {
  const _ProjectTaskTile({
    required this.summary,
    required this.accentColor,
    required this.onTap,
    required this.inputs,
  });

  final ProjectTaskSummary summary;
  final Color accentColor;
  final VoidCallback onTap;
  final List<Widget> inputs;

  @override
  Widget build(BuildContext context) {
    final dueDate = summary.task.dueDate;
    final isHabit = summary.task.taskType == TaskTypes.habit;

    return InkWell(
      onTap: () async {
        if (await ValueDraftScope.confirm(context) && context.mounted) onTap();
      },
      borderRadius: BorderRadius.circular(14),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      summary.task.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _StatusChip(
                    label:
                        isHabit
                            ? 'Habit'
                            : summary.isResolved
                            ? 'Abgeschlossen'
                            : 'Offen',
                    color:
                        summary.isResolved
                            ? const Color(0xFF3C9B78)
                            : accentColor,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _InfoPill(
                    icon: isHabit ? Icons.repeat : Icons.checklist,
                    label: isHabit ? 'Habit' : 'Aufgabe',
                  ),
                  _InfoPill(
                    icon: Icons.timeline,
                    label:
                        '${summary.completedEntryCount}/${summary.plannedEntryCount} Eintraege',
                  ),
                  if (dueDate != null)
                    _InfoPill(
                      icon: Icons.event_outlined,
                      label: _formatDate(dueDate),
                    ),
                ],
              ),
              ...inputs,
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Color.alphaBlend(
              Colors.black.withValues(alpha: 0.24),
              color,
            ),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}.'
      '${date.month.toString().padLeft(2, '0')}.'
      '${date.year}';
}
