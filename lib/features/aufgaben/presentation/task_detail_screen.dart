import 'package:flutter/material.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/habit_recurrence.dart';
import 'package:momentum/features/aufgaben/data/missed_policy.dart';
import 'package:momentum/features/aufgaben/data/post_buffer_behavior.dart';
import 'package:momentum/features/aufgaben/data/task_analytics_display.dart';
import 'package:momentum/features/aufgaben/data/task_analytics_period.dart';
import 'package:momentum/features/aufgaben/data/task_analytics_summary.dart';
import 'package:momentum/features/aufgaben/data/task_capture_mode.dart';
import 'package:momentum/features/aufgaben/data/task_entry_with_value.dart';
import 'package:momentum/features/aufgaben/data/task_entry_status.dart';
import 'package:momentum/features/aufgaben/data/task_types.dart';
import 'package:momentum/features/aufgaben/data/task_goal.dart';
import 'package:momentum/features/aufgaben/data/task_goal_evaluation_display.dart';
import 'package:momentum/features/aufgaben/data/task_goal_evaluation_summary.dart';
import 'package:momentum/features/aufgaben/data/task_pending_definition_changes_table.dart';
import 'package:momentum/features/aufgaben/data/task_project_assignment_changes_table.dart';
import 'package:momentum/features/aufgaben/data/task_value_analytics_display.dart';
import 'package:momentum/features/aufgaben/data/task_value_analytics_summary.dart';
import 'package:momentum/features/aufgaben/data/task_value_type.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_card_metric_selection_sheet.dart';
import 'package:momentum/features/aufgaben/presentation/task_entry_corrections_screen.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({
    required this.task,
    required this.repository,
    this.project,
    super.key,
  });

  final Aufgabe task;
  final AufgabenRepository repository;
  final Project? project;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  TaskAnalyticsPeriod _selectedPeriod = TaskAnalyticsPeriod.last7Days;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.name),
        actions: [
          IconButton(
            tooltip: 'Geplante Änderungen',
            icon: const Icon(Icons.schedule_outlined),
            onPressed: _showPlannedChanges,
          ),
          IconButton(
            tooltip: 'Einträge korrigieren',
            icon: const Icon(Icons.edit_calendar_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder:
                      (context) => TaskEntryCorrectionsScreen(
                        task: widget.task,
                        repository: widget.repository,
                      ),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Kartenanzeige',
            icon: const Icon(Icons.dashboard_customize_outlined),
            onPressed: () {
              showTaskCardMetricSelectionSheet(
                context: context,
                repository: widget.repository,
                task: widget.task,
              );
            },
          ),
        ],
      ),
      body:
          _isOneTimeTask(widget.task)
              ? StreamBuilder<TaskEntryWithValue?>(
                stream: widget.repository.watchLatestTaskEntryWithValue(
                  widget.task.id,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const _DetailMessage(
                      message: 'Die Details konnten nicht geladen werden.',
                      isError: true,
                    );
                  }

                  return _OneTimeTaskDetailContent(
                    task: widget.task,
                    project: widget.project,
                    entry: snapshot.data?.entry,
                    entryValue: snapshot.data?.entryValue,
                  );
                },
              )
              : _isValueTask(widget.task)
              ? StreamBuilder<TaskValueAnalyticsSummary>(
                stream: widget.repository
                    .watchTaskValueAnalyticsSummaryForPeriod(
                      task: widget.task,
                      period: _selectedPeriod,
                    ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const _DetailMessage(
                      message:
                          'Die Wert-Auswertung konnte nicht geladen werden.',
                      isError: true,
                    );
                  }

                  final summary = snapshot.data;
                  if (summary == null) {
                    return const _DetailMessage(
                      message: 'Für diese Aufgabe liegen noch keine Werte vor.',
                    );
                  }

                  return StreamBuilder<TaskValueGoalEvaluationSummary>(
                    stream: widget.repository
                        .watchTaskValueGoalEvaluationSummary(task: widget.task),
                    builder: (context, goalSnapshot) {
                      return _TaskValueDetailContent(
                        task: widget.task,
                        selectedPeriod: _selectedPeriod,
                        summary: summary,
                        goalSummary: goalSnapshot.data,
                        onPeriodChanged: (period) {
                          setState(() {
                            _selectedPeriod = period;
                          });
                        },
                      );
                    },
                  );
                },
              )
              : StreamBuilder<TaskAnalyticsSummary>(
                stream: widget.repository.watchTaskAnalyticsSummaryForPeriod(
                  task: widget.task,
                  period: _selectedPeriod,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const _DetailMessage(
                      message: 'Die Auswertung konnte nicht geladen werden.',
                      isError: true,
                    );
                  }

                  final summary = snapshot.data;
                  if (summary == null) {
                    return const _DetailMessage(
                      message: 'Für diese Aufgabe liegen noch keine Daten vor.',
                    );
                  }

                  return StreamBuilder<TaskGoalEvaluationSummary>(
                    stream: widget.repository.watchTaskGoalEvaluationSummary(
                      task: widget.task,
                    ),
                    builder: (context, goalSnapshot) {
                      return StreamBuilder<TaskGoalHistorySummary>(
                        stream: widget.repository.watchTaskGoalHistorySummary(
                          task: widget.task,
                        ),
                        builder: (context, historySnapshot) {
                          return FutureBuilder<TaskGoalPlannedChange?>(
                            future: widget.repository.getNextPlannedGoalChange(
                              task: widget.task,
                            ),
                            builder: (context, plannedChangeSnapshot) {
                              return _TaskDetailContent(
                                task: widget.task,
                                selectedPeriod: _selectedPeriod,
                                summary: summary,
                                goalSummary: goalSnapshot.data,
                                goalHistorySummary: historySnapshot.data,
                                plannedGoalChange: plannedChangeSnapshot.data,
                                onPeriodChanged: (period) {
                                  setState(() {
                                    _selectedPeriod = period;
                                  });
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
    );
  }

  Future<void> _showPlannedChanges() async {
    final definitionChanges =
        await widget.repository
            .watchPendingDefinitionChanges(widget.task.id)
            .first;
    final projectChanges =
        (await widget.repository
                .watchProjectAssignmentChanges(widget.task.id)
                .first)
            .where(
              (change) => change.state == TaskProjectAssignmentState.pending,
            )
            .toList();
    if (!mounted) {
      return;
    }
    final rows = <Widget>[
      for (final change in definitionChanges)
        ListTile(
          leading: Icon(
            change.groupKey == TaskPendingDefinitionChangeGroup.goal
                ? Icons.flag_outlined
                : Icons.event_repeat_outlined,
          ),
          title: Text(
            change.groupKey == TaskPendingDefinitionChangeGroup.goal
                ? 'Zieländerung'
                : 'Planungsänderung',
          ),
          subtitle: Text('Gilt ab ${_formatDate(change.effectiveDate)}.'),
        ),
      for (final change in projectChanges)
        ListTile(
          leading: const Icon(Icons.folder_outlined),
          title: const Text('Projektwechsel'),
          subtitle: Text('Gilt ab ${_formatDate(change.effectiveDate)}.'),
        ),
    ];
    await showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Geplante Änderungen'),
            content: SizedBox(
              width: 420,
              child:
                  rows.isEmpty
                      ? const Text('Für diese Aufgabe ist nichts vorgemerkt.')
                      : ListView(shrinkWrap: true, children: rows),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Schließen'),
              ),
            ],
          ),
    );
  }
}

bool _isOneTimeTask(Aufgabe task) {
  return task.taskType == TaskTypes.task &&
      task.recurrence == HabitRecurrence.none;
}

bool _isValueTask(Aufgabe task) {
  return task.erfassungsmodus == TaskCaptureMode.value;
}

class _TaskDetailContent extends StatelessWidget {
  const _TaskDetailContent({
    required this.task,
    required this.selectedPeriod,
    required this.summary,
    required this.goalSummary,
    required this.goalHistorySummary,
    required this.plannedGoalChange,
    required this.onPeriodChanged,
  });

  final Aufgabe task;
  final TaskAnalyticsPeriod selectedPeriod;
  final TaskAnalyticsSummary summary;
  final TaskGoalEvaluationSummary? goalSummary;
  final TaskGoalHistorySummary? goalHistorySummary;
  final TaskGoalPlannedChange? plannedGoalChange;
  final ValueChanged<TaskAnalyticsPeriod> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    final display = TaskAnalyticsDisplay.fromSummary(
      summary,
      noEntryAvailable: _canCreateNoEntry(task, summary),
      overdueAvailable: _canBecomeOverdue(task, summary),
      bufferAvailable: task.missedPolicy == MissedPolicy.buffer,
      automaticResolutionAvailable: task.missedPolicy != MissedPolicy.none,
    );
    final description = task.beschreibung.trim();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: [
        Text(
          task.name,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        if (description.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
        ],
        const SizedBox(height: 20),
        Text(
          'Zeitraum',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              TaskAnalyticsPeriod.values.map((period) {
                return ChoiceChip(
                  label: Text(period.label),
                  selected: period == selectedPeriod,
                  onSelected: (_) => onPeriodChanged(period),
                );
              }).toList(),
        ),
        if ((_hasGoal(task) || plannedGoalChange != null) &&
            goalSummary != null) ...[
          const SizedBox(height: 22),
          _SectionTitle(title: 'Ziel', subtitle: goalSummary!.message),
          const SizedBox(height: 10),
          _MetricGrid(
            metrics:
                TaskGoalEvaluationDisplay.fromSummary(goalSummary!).metrics,
          ),
          if (goalHistorySummary != null) ...[
            const SizedBox(height: 10),
            _GoalHistorySection(summary: goalHistorySummary!),
          ],
          if (plannedGoalChange != null) ...[
            const SizedBox(height: 10),
            _InlineHint(
              message:
                  'Neue Zielregel gilt ab '
                  '${_formatDate(plannedGoalChange!.validFrom)}.',
            ),
          ],
        ],
        const SizedBox(height: 22),
        _SectionTitle(
          title: 'Zusammenfassung',
          subtitle: _summaryHint(summary),
        ),
        const SizedBox(height: 10),
        _MetricGrid(metrics: display.recurringTaskMetrics),
        if (_showLegacyAnalyticsSections) ...[
          const SizedBox(height: 22),
          _SectionTitle(
            title: 'Einträge',
            subtitle: 'Was im gewählten Zeitraum passiert ist.',
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 22),
          _SectionTitle(
            title: 'Weitere Werte',
            subtitle:
                'Zusatzwerte für Detailanalyse und spätere Kartenanzeigen. '
                'Sie sind nicht die Hauptbewertung.',
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _TaskValueDetailContent extends StatelessWidget {
  const _TaskValueDetailContent({
    required this.task,
    required this.selectedPeriod,
    required this.summary,
    required this.goalSummary,
    required this.onPeriodChanged,
  });

  final Aufgabe task;
  final TaskAnalyticsPeriod selectedPeriod;
  final TaskValueAnalyticsSummary summary;
  final TaskValueGoalEvaluationSummary? goalSummary;
  final ValueChanged<TaskAnalyticsPeriod> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    final display = TaskValueAnalyticsDisplay.fromSummary(summary);
    final description = task.beschreibung.trim();
    final recordedPoints =
        summary.points
            .where((point) => point.value != null && point.entryValue != null)
            .toList()
          ..sort((first, second) {
            return second.scheduledDate.compareTo(first.scheduledDate);
          });

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: [
        Text(
          task.name,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        if (description.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
        ],
        const SizedBox(height: 20),
        Text(
          'Zeitraum',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              TaskAnalyticsPeriod.values.map((period) {
                return ChoiceChip(
                  label: Text(period.label),
                  selected: period == selectedPeriod,
                  onSelected: (_) => onPeriodChanged(period),
                );
              }).toList(),
        ),
        if (_hasGoal(task) && goalSummary != null) ...[
          const SizedBox(height: 22),
          _SectionTitle(title: 'Ziel', subtitle: goalSummary!.message),
          const SizedBox(height: 10),
          _MetricGrid(
            metrics:
                TaskValueGoalEvaluationDisplay.fromSummary(
                  goalSummary!,
                ).metrics,
          ),
        ],
        const SizedBox(height: 22),
        const _SectionTitle(
          title: 'Verarbeitung',
          subtitle:
              'Zeigt, welche Wert-Einträge im gewählten Zeitraum erfasst, '
              'offen oder fehlend sind.',
        ),
        const SizedBox(height: 10),
        _MetricGrid(metrics: display.processingMetrics),
        const SizedBox(height: 22),
        _SectionTitle(title: 'Werte', subtitle: _valueSummaryHint(summary)),
        const SizedBox(height: 10),
        _MetricGrid(metrics: display.valueMetrics),
        const SizedBox(height: 22),
        const _SectionTitle(
          title: 'Wertliste',
          subtitle:
              'Einfache Liste der echten erfassten Werte im Zeitraum. '
              'Diagramme und Trends kommen später.',
        ),
        const SizedBox(height: 10),
        if (recordedPoints.isEmpty)
          const _InlineHint(
            message: 'In diesem Zeitraum wurden noch keine Werte erfasst.',
          )
        else
          ...recordedPoints.map(
            (point) => _InfoTile(
              label: _formatDate(point.scheduledDate),
              value: _formatEntryValue(task, point.entryValue),
              infoText:
                  'Dieser Wert wurde für den angezeigten Tag erfasst. '
                  'Fehlende oder offene Tage erscheinen nicht in dieser '
                  'Wertliste, sondern oben in der Verarbeitung.',
            ),
          ),
      ],
    );
  }
}

class _GoalHistorySection extends StatelessWidget {
  const _GoalHistorySection({required this.summary});

  final TaskGoalHistorySummary summary;

  @override
  Widget build(BuildContext context) {
    final display = TaskGoalHistoryDisplay.fromSummary(summary);

    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(top: 4),
      title: Text(
        'Zielhistorie',
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
      ),
      subtitle: Text(
        'Abgeschlossene Zielblöcke und Zielquote.',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      children: [
        _MetricGrid(metrics: [display.summary]),
        const SizedBox(height: 10),
        if (display.blocks.isEmpty)
          const _InlineHint(
            message:
                'Es gibt noch keine abgeschlossenen Zielblöcke. Der laufende '
                'Zielzeitraum bleibt oben in der Livebewertung.',
          )
        else
          ...display.blocks.map(
            (block) => _InfoTile(
              label: block.period,
              value: block.status,
              infoText:
                  'Historische Zielblöcke zählen nur, wenn der Zeitraum '
                  'vollständig abgeschlossen und bewertbar ist. Der laufende '
                  'Block wird hier bewusst nicht angezeigt.',
              detail: '${block.detail}\n${block.message}',
            ),
          ),
      ],
    );
  }
}

class _OneTimeTaskDetailContent extends StatelessWidget {
  const _OneTimeTaskDetailContent({
    required this.task,
    required this.project,
    required this.entry,
    required this.entryValue,
  });

  final Aufgabe task;
  final Project? project;
  final TaskEntry? entry;
  final TaskEntryValue? entryValue;

  @override
  Widget build(BuildContext context) {
    final description = task.beschreibung.trim();
    final status = entry?.status ?? TaskEntryStatus.pending;
    final completionTime = _completionTime(entry);
    final dueDeviation = _dueDeviation(task.dueDate, completionTime);
    final durationToCompletion = _durationToCompletion(task, completionTime);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: [
        Text(
          task.name,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        if (description.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
        ],
        const SizedBox(height: 20),
        _SectionTitle(
          title: 'Aufgabendetails',
          subtitle:
              'Einmalige Aufgaben bekommen keine Habit-Quote. Hier stehen die '
              'konkreten Daten dieser Aufgabe.',
        ),
        const SizedBox(height: 10),
        _InfoTile(
          label: 'Status',
          value: _statusLabel(status),
          infoText:
              'Zeigt den aktuellen Zustand dieser einzelnen Aufgabe: offen, '
              'erledigt, nicht erledigt oder Kein Eintrag.',
        ),
        if (_isValueTask(task))
          _InfoTile(
            label: 'Wert',
            value: _formatEntryValue(task, entryValue),
            infoText:
                'Zeigt den gespeicherten Einzelwert dieser Aufgabe. Wenn noch '
                'kein Wert erfasst wurde, bleibt diese Auswertung leer.',
          ),
        _InfoTile(
          label: 'Erstellt am',
          value: _formatDateTime(task.createdAt),
          infoText:
              'Zeitpunkt, an dem die Aufgabendefinition angelegt wurde. Das '
              'ist nicht automatisch derselbe Wert wie der Start der Aufgabe.',
        ),
        _InfoTile(
          label: 'Zählt ab',
          value: _formatDate(task.startDate),
          infoText:
              'Ab diesem Datum zählt oder erscheint die Aufgabe fachlich. Bei '
              'einem späteren Start wird sie vorher nicht bewertet.',
        ),
        _ProjectInfoTile(project: project),
        _InfoTile(
          label: 'Fällig am',
          value:
              task.dueDate == null
                  ? 'Kein Fälligkeitsdatum'
                  : _formatDate(task.dueDate!),
          infoText:
              'Nur Aufgaben mit Fälligkeitsdatum können als vor, am oder nach '
              'dem Fälligkeitstag erledigt ausgewertet werden.',
        ),
        _InfoTile(
          label: 'Abgeschlossen am',
          value:
              completionTime == null
                  ? 'Noch nicht abgeschlossen'
                  : _formatDateTime(completionTime),
          infoText:
              'Zeitpunkt, an dem die Aufgabe fachlich abgeschlossen wurde. '
              'Das kann manuell oder später durch eine Regel passieren.',
        ),
        if (durationToCompletion != null)
          _InfoTile(
            label: 'Dauer bis Abschluss',
            value: durationToCompletion,
            infoText:
                'Zählt vom Startdatum der Aufgabe bis zum Abschluss. Wenn '
                'später ein echtes Startdatum fehlt, wird das Erstellungsdatum '
                'als Ersatz verwendet.',
          ),
        if (dueDeviation != null)
          _InfoTile(
            label: 'Abweichung vom Fälligkeitstag',
            value: dueDeviation,
            infoText:
                'Vergleicht den Abschluss mit dem Fälligkeitstag. Ohne '
                'Fälligkeitsdatum ist diese Auswertung nicht möglich.',
          ),
        _InfoTile(
          label: 'Abschlussart',
          value: _originLabel(entry?.resolutionOrigin),
          infoText:
              'Zeigt, ob der Eintrag manuell, automatisch oder durch eine '
              'Migration entstanden ist. Für spätere Sammelauswertungen kann '
              'daraus z. B. der Anteil manueller Abschlüsse berechnet werden.',
        ),
        if ((entry?.note.trim().isNotEmpty ?? false))
          _InfoTile(
            label: 'Notiz',
            value: entry!.note.trim(),
            infoText:
                'Notizen erklären Sonderfälle und bleiben für spätere '
                'Auswertungen sichtbar.',
          ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.label,
    required this.value,
    required this.infoText,
    this.detail,
  });

  final String label;
  final String value;
  final String infoText;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (detail != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        detail!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Bedeutung erklären',
                icon: const Icon(Icons.info_outline),
                visualDensity: VisualDensity.compact,
                onPressed:
                    () => showDialog<void>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: Text(label),
                            content: Text(infoText),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Verstanden'),
                              ),
                            ],
                          ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectInfoTile extends StatelessWidget {
  const _ProjectInfoTile({required this.project});

  final Project? project;

  @override
  Widget build(BuildContext context) {
    if (project == null) {
      return const _InfoTile(
        label: 'Projekt',
        value: 'Ohne Projekt',
        infoText:
            'Diese Aufgabe ist keinem Projekt zugeordnet. Spätere '
            'Sammelauswertungen können solche Aufgaben separat betrachten.',
      );
    }

    final color = _projectColor(project!.colorHex);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          child: Row(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Projekt',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      project!.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Bedeutung erklären',
                icon: const Icon(Icons.info_outline),
                visualDensity: VisualDensity.compact,
                onPressed:
                    () => showDialog<void>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Projekt'),
                            content: const Text(
                              'Die Projektzuordnung kann später für '
                              'Projekt- und Sammelauswertungen genutzt werden.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Verstanden'),
                              ),
                            ],
                          ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.metrics});

  final List<TaskAnalyticsMetricDisplay> metrics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 10) / 2;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children:
              metrics.map((metric) {
                return SizedBox(
                  width: itemWidth,
                  child: _MetricCard(metric: metric),
                );
              }).toList(),
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final TaskAnalyticsMetricDisplay metric;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final contentColor =
        metric.isAvailable
            ? colorScheme.onSurface
            : colorScheme.onSurfaceVariant.withValues(alpha: 0.7);
    final backgroundColor =
        !metric.isAvailable
            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.45)
            : colorScheme.surface;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color:
              !metric.isAvailable
                  ? colorScheme.outlineVariant.withValues(alpha: 0.55)
                  : colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    metric.label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Berechnung erklären',
                  icon: const Icon(Icons.info_outline),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _showMetricInfo(context, metric),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              metric.value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: contentColor,
              ),
            ),
            if (!metric.isAvailable && metric.unavailableReason != null) ...[
              const SizedBox(height: 4),
              Text(
                metric.unavailableReason!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (metric.detail != null) ...[
              const SizedBox(height: 4),
              Text(
                metric.detail!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailMessage extends StatelessWidget {
  const _DetailMessage({required this.message, this.isError = false});

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color:
                isError
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _InlineHint extends StatelessWidget {
  const _InlineHint({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

String _summaryHint(TaskAnalyticsSummary summary) {
  if (summary.dueCount == 0) {
    return 'Noch keine fälligen Einträge in diesem Zeitraum.';
  }

  return 'Quoten zeigen Prozentwert und Verhältnis, zum Beispiel 2 von 3.';
}

bool _canCreateNoEntry(Aufgabe task, TaskAnalyticsSummary summary) {
  return summary.noEntryCount > 0 ||
      task.missedConsequence == MissedConsequence.keepNeutral ||
      task.postBufferBehavior == PostBufferBehavior.markAsNoEntry;
}

bool _canBecomeOverdue(Aufgabe task, TaskAnalyticsSummary summary) {
  return summary.overdueEntryCount > 0 ||
      task.missedPolicy == MissedPolicy.buffer ||
      task.missedPolicy == MissedPolicy.carryover ||
      task.missedPolicy == MissedPolicy.none;
}

bool _hasGoal(Aufgabe task) => task.goalType != TaskGoalType.none;

bool get _showLegacyAnalyticsSections => false;

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

String _valueSummaryHint(TaskValueAnalyticsSummary summary) {
  if (!summary.hasRecordedValues) {
    return 'Noch keine erfassten Werte im gewählten Zeitraum.';
  }

  if (summary.valueType == TaskValueType.timeOfDay) {
    return 'Uhrzeiten bekommen Durchschnitt, früheste und späteste Uhrzeit. '
        'Eine Summe ist hier nicht sinnvoll.';
  }

  return 'Werte verwenden nur echte Eingaben. Fehlende Einträge zählen nicht '
      'als 0.';
}

String _formatEntryValue(Aufgabe task, TaskEntryValue? entryValue) {
  if (entryValue == null) {
    return 'Noch kein Wert erfasst';
  }

  switch (task.valueType) {
    case TaskValueType.number:
      final number = entryValue.numberValue;
      if (number == null) {
        return 'Noch kein Wert erfasst';
      }
      final unit =
          task.valueUnitLabel.trim().isNotEmpty
              ? task.valueUnitLabel.trim()
              : entryValue.unitLabel.trim();
      final formatted = _formatNumber(number);
      return unit.isEmpty ? formatted : '$formatted $unit';
    case TaskValueType.duration:
      final seconds = entryValue.durationSeconds;
      if (seconds == null) {
        return 'Noch keine Dauer erfasst';
      }
      return _formatDurationSeconds(seconds);
    case TaskValueType.timeOfDay:
      final minutes = entryValue.timeMinutes;
      if (minutes == null) {
        return 'Noch keine Uhrzeit erfasst';
      }
      return _formatTimeOfDayWithOffset(minutes, entryValue.dayOffset);
  }

  return 'Nicht verfügbar';
}

String _formatNumber(double value) {
  final formatted = value.toStringAsFixed(1).replaceAll('.', ',');
  if (formatted.endsWith(',0')) {
    return formatted.substring(0, formatted.length - 2);
  }
  return formatted;
}

String _formatDurationSeconds(int seconds) {
  final sign = seconds < 0 ? '-' : '';
  final absoluteSeconds = seconds.abs();
  final hours = absoluteSeconds ~/ 3600;
  final minutes = (absoluteSeconds % 3600) ~/ 60;
  final remainingSeconds = absoluteSeconds % 60;

  if (hours > 0) {
    return '$sign$hours h ${minutes.toString().padLeft(2, '0')} min';
  }

  if (minutes > 0) {
    return '$sign$minutes min';
  }

  return '$sign$remainingSeconds s';
}

String _formatTimeOfDayWithOffset(int minutes, int dayOffset) {
  final totalMinutes = minutes + dayOffset * 24 * 60;
  final normalizedMinutes = totalMinutes % (24 * 60);
  final hour = (normalizedMinutes ~/ 60).toString().padLeft(2, '0');
  final minute = (normalizedMinutes % 60).toString().padLeft(2, '0');
  final suffix = dayOffset > 0 ? ' +$dayOffset Tag' : '';
  return '$hour:$minute Uhr$suffix';
}

String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}.'
      '${date.month.toString().padLeft(2, '0')}.'
      '${date.year.toString().padLeft(4, '0')}';
}

String _formatDateTime(DateTime date) {
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '${_formatDate(date)} um $hour:$minute Uhr';
}

String _statusLabel(String status) {
  return switch (status) {
    TaskEntryStatus.success => 'Erledigt',
    TaskEntryStatus.recorded => 'Erfasst',
    TaskEntryStatus.failure => 'Nicht erledigt',
    TaskEntryStatus.noEntry => 'Kein Eintrag',
    _ => 'Offen',
  };
}

String _originLabel(String? origin) {
  return switch (origin) {
    TaskEntryResolutionOrigin.manual => 'Manuell',
    TaskEntryResolutionOrigin.automatic => 'Automatisch',
    TaskEntryResolutionOrigin.migration => 'Migration',
    _ => 'Noch offen',
  };
}

DateTime? _completionTime(TaskEntry? entry) {
  if (entry == null || !TaskEntryStatus.isResolved(entry.status)) {
    return null;
  }

  return entry.effectiveAt ?? entry.finalizedAt ?? entry.respondedAt;
}

String? _durationToCompletion(Aufgabe task, DateTime? completionTime) {
  if (completionTime == null) {
    return null;
  }

  final start = _dateOnly(task.startDate);
  final end = _dateOnly(completionTime);
  final days = end.difference(start).inDays;

  if (days == 0) {
    return 'Am selben Tag';
  }

  if (days == 1) {
    return '1 Tag';
  }

  return '$days Tage';
}

String? _dueDeviation(DateTime? dueDate, DateTime? completionTime) {
  if (dueDate == null || completionTime == null) {
    return null;
  }

  final difference =
      _dateOnly(completionTime).difference(_dateOnly(dueDate)).inDays;

  if (difference == 0) {
    return 'Am Fälligkeitstag';
  }

  final absoluteDays = difference.abs();
  final unit = absoluteDays == 1 ? 'Tag' : 'Tage';
  if (difference < 0) {
    return '$absoluteDays $unit vor Fälligkeit';
  }

  return '$absoluteDays $unit nach Fälligkeit';
}

Color _projectColor(String colorHex) {
  final normalized = colorHex.replaceFirst('#', '');
  final colorValue = int.tryParse('FF$normalized', radix: 16);
  return Color(colorValue ?? 0xFF607D8B);
}

void _showMetricInfo(BuildContext context, TaskAnalyticsMetricDisplay metric) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(metric.label),
        content: Text(metric.infoText),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Verstanden'),
          ),
        ],
      );
    },
  );
}
