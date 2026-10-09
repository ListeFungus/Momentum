import 'package:flutter/material.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/task_analytics_period.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle_analytics_summary.dart';
import 'package:momentum/features/projekte/data/project_repository.dart';

class ProjectBundleDetailScreen extends StatefulWidget {
  const ProjectBundleDetailScreen({
    required this.bundleId,
    required this.projectRepository,
    required this.aufgabenRepository,
    super.key,
  });

  final String bundleId;
  final ProjectRepository projectRepository;
  final AufgabenRepository aufgabenRepository;

  @override
  State<ProjectBundleDetailScreen> createState() =>
      _ProjectBundleDetailScreenState();
}

class _ProjectBundleDetailScreenState extends State<ProjectBundleDetailScreen> {
  TaskAnalyticsPeriod _period = TaskAnalyticsPeriod.last7Days;
  int? _versionNumber;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProjectBundleIdentity?>(
      stream: widget.projectRepository.watchBundleIdentity(widget.bundleId),
      builder: (context, snapshot) {
        final identity = snapshot.data;
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (identity == null || identity.versions.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('Dieses Bündel ist nicht verfügbar.')),
          );
        }
        final version = identity.versions.firstWhere(
          (item) => item.versionNumber == _versionNumber,
          orElse: () => identity.versions.first,
        );
        return Scaffold(
          appBar: AppBar(title: Text(version.name)),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                _stateLabel(identity.bundle, version),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              if (identity.versions.length > 1) ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: version.versionNumber,
                  decoration: const InputDecoration(
                    labelText: 'Version',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (final item in identity.versions)
                      DropdownMenuItem(
                        value: item.versionNumber,
                        child: Text(
                          'Version ${item.versionNumber} · ${_date(item.validFrom)}',
                        ),
                      ),
                  ],
                  onChanged: (value) => setState(() => _versionNumber = value),
                ),
              ],
              const SizedBox(height: 16),
              SegmentedButton<TaskAnalyticsPeriod>(
                segments: const [
                  ButtonSegment(
                    value: TaskAnalyticsPeriod.last7Days,
                    label: Text('7 Tage'),
                  ),
                  ButtonSegment(
                    value: TaskAnalyticsPeriod.last20Days,
                    label: Text('20 Tage'),
                  ),
                  ButtonSegment(
                    value: TaskAnalyticsPeriod.last30Days,
                    label: Text('30 Tage'),
                  ),
                  ButtonSegment(
                    value: TaskAnalyticsPeriod.sinceStart,
                    label: Text('Seit Beginn'),
                  ),
                ],
                selected: {_period},
                onSelectionChanged:
                    (value) => setState(() => _period = value.single),
              ),
              const SizedBox(height: 16),
              StreamBuilder<TaskValueBundleAnalyticsSummary>(
                stream: widget.aufgabenRepository
                    .watchTaskValueBundleAnalyticsSummaryForPeriod(
                      version: version,
                      period: _period,
                    ),
                builder: (context, analyticsSnapshot) {
                  if (!analyticsSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final summary = analyticsSnapshot.data!;
                  if (!summary.isAvailable) {
                    return Text(
                      summary.unavailableReason ??
                          'Die Auswertung ist nicht verfügbar.',
                    );
                  }
                  return Column(
                    children: [
                      _Count('Vollständig', summary.completeCount),
                      _Count('Teilweise', summary.partialCount),
                      _Count('Fehlend', summary.missingCount),
                      _Count('Nicht berechenbar', summary.notCalculableCount),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              const Text(
                'Diese Ansicht zeigt die vollständige Bündelauswertung, nicht '
                'nur den Anteil des zuvor geöffneten Projekts.',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Count extends StatelessWidget {
  const _Count(this.label, this.value);
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(label),
    trailing: Text(value.toString()),
  );
}

String _stateLabel(TaskValueBundle bundle, TaskValueBundleVersion version) {
  if (bundle.trashedAt != null) return 'Im Papierkorb';
  if (version.validFrom.isAfter(DateTime.now())) {
    return 'Beginnt am ${_date(version.validFrom)}';
  }
  if (version.validTo != null || !bundle.isActive) return 'Aufgelöst';
  return 'Aktiv';
}

String _date(DateTime value) =>
    '${value.day.toString().padLeft(2, '0')}.'
    '${value.month.toString().padLeft(2, '0')}.${value.year}';
