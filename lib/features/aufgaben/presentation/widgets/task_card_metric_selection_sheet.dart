import 'package:flutter/material.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/task_analytics_period.dart';
import 'package:momentum/features/aufgaben/data/task_card_metric_catalog.dart';
import 'package:momentum/features/aufgaben/data/task_card_metric_preference.dart';

Future<void> showTaskCardMetricSelectionSheet({
  required BuildContext context,
  required AufgabenRepository repository,
  required Aufgabe task,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder:
        (context) =>
            _TaskCardMetricSelectionSheet(repository: repository, task: task),
  );
}

Future<void> showBundleCardMetricSelectionSheet({
  required BuildContext context,
  required AufgabenRepository repository,
  required TaskValueBundle bundle,
  required TaskValueBundleVersion version,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder:
        (context) => _TaskCardMetricSelectionSheet(
          repository: repository,
          bundle: bundle,
          bundleVersion: version,
        ),
  );
}

enum _SelectionMode { standard, custom, hidden }

class _TaskCardMetricSelectionSheet extends StatefulWidget {
  const _TaskCardMetricSelectionSheet({
    required this.repository,
    this.task,
    this.bundle,
    this.bundleVersion,
  });

  final AufgabenRepository repository;
  final Aufgabe? task;
  final TaskValueBundle? bundle;
  final TaskValueBundleVersion? bundleVersion;

  @override
  State<_TaskCardMetricSelectionSheet> createState() =>
      _TaskCardMetricSelectionSheetState();
}

class _TaskCardMetricSelectionSheetState
    extends State<_TaskCardMetricSelectionSheet> {
  _SelectionMode _mode = _SelectionMode.standard;
  String? _metric;
  TaskAnalyticsPeriod _period = TaskAnalyticsPeriod.last7Days;
  bool _loading = true;
  bool _saving = false;
  bool _storedConfigUnavailable = false;

  List<TaskCardMetricCatalogOption> get _options {
    final base =
        widget.task != null
            ? TaskCardMetricCatalog.forTask(widget.task!)
            : TaskCardMetricCatalog.forBundle(widget.bundleVersion!);
    if (_metric != null && !base.any((option) => option.key == _metric)) {
      final stored = TaskCardMetricCatalog.option(_metric!);
      return [
        TaskCardMetricCatalogOption(
          key: stored.key,
          label: '${stored.label} (hier nicht verfügbar)',
          description:
              'Diese gespeicherte Kennzahl passt nicht mehr zur aktuellen '
              'Konfiguration. Wähle eine andere Kennzahl oder Standard.',
          usesPeriod: stored.usesPeriod,
        ),
        ...base,
      ];
    }
    return base;
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final selection =
        widget.task != null
            ? await widget.repository.getTaskCardMetricPreference(
              widget.task!.id,
            )
            : await widget.repository.getBundleCardMetricPreference(
              widget.bundle!.id,
            );
    if (!mounted) {
      return;
    }
    final item = selection.config?.items.firstOrNull;
    setState(() {
      _loading = false;
      _storedConfigUnavailable = selection.isUnavailable;
      _mode =
          selection.usesDefault
              ? _SelectionMode.standard
              : selection.isHidden
              ? _SelectionMode.hidden
              : _SelectionMode.custom;
      _metric = item?.metric ?? _options.firstOrNull?.key;
      _period = item?.period ?? TaskAnalyticsPeriod.last7Days;
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      if (_mode == _SelectionMode.standard) {
        if (widget.task != null) {
          await widget.repository.resetTaskCardMetricPreference(
            widget.task!.id,
          );
        } else {
          await widget.repository.resetBundleCardMetricPreference(
            widget.bundle!.id,
          );
        }
      } else {
        final config =
            _mode == _SelectionMode.hidden
                ? TaskCardMetricPreferenceConfig.hidden
                : TaskCardMetricPreferenceConfig(
                  items: [
                    TaskCardMetricPreferenceItem(
                      metric: _metric!,
                      period:
                          TaskCardMetricCatalog.option(_metric!).usesPeriod
                              ? _period
                              : null,
                    ),
                  ],
                );
        if (widget.task != null) {
          await widget.repository.setTaskCardMetricPreference(
            taskId: widget.task!.id,
            config: config,
          );
        } else {
          await widget.repository.setBundleCardMetricPreference(
            bundleId: widget.bundle!.id,
            config: config,
          );
        }
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          18,
          20,
          20 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child:
            _loading
                ? const SizedBox(
                  height: 180,
                  child: Center(child: CircularProgressIndicator()),
                )
                : SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Kartenanzeige',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Diese Einstellung ändert nur die kompakte Anzeige. '
                        'Einträge, Ziele und die Detailauswertung bleiben unverändert.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (_storedConfigUnavailable) ...[
                        const SizedBox(height: 12),
                        const _WarningBox(
                          text:
                              'Die gespeicherte Anzeigeeinstellung kann nicht '
                              'gelesen werden. Sie bleibt erhalten, bis du hier '
                              'eine neue Auswahl speicherst oder zurücksetzt.',
                        ),
                      ],
                      const SizedBox(height: 16),
                      SegmentedButton<_SelectionMode>(
                        segments: const [
                          ButtonSegment(
                            value: _SelectionMode.standard,
                            label: Text('Standard'),
                          ),
                          ButtonSegment(
                            value: _SelectionMode.custom,
                            label: Text('Auswahl'),
                          ),
                          ButtonSegment(
                            value: _SelectionMode.hidden,
                            label: Text('Keine'),
                          ),
                        ],
                        selected: {_mode},
                        showSelectedIcon: false,
                        onSelectionChanged:
                            (selection) =>
                                setState(() => _mode = selection.single),
                      ),
                      if (_mode == _SelectionMode.custom) ...[
                        const SizedBox(height: 18),
                        DropdownButtonFormField<String>(
                          value: _metric,
                          decoration: const InputDecoration(
                            labelText: 'Kennzahl',
                            border: OutlineInputBorder(),
                          ),
                          items: _options
                              .map(
                                (option) => DropdownMenuItem(
                                  value: option.key,
                                  child: Text(option.label),
                                ),
                              )
                              .toList(growable: false),
                          onChanged: (value) => setState(() => _metric = value),
                        ),
                        if (_metric != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            TaskCardMetricCatalog.option(_metric!).description,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                        if (_metric != null &&
                            TaskCardMetricCatalog.option(
                              _metric!,
                            ).usesPeriod) ...[
                          const SizedBox(height: 16),
                          DropdownButtonFormField<TaskAnalyticsPeriod>(
                            value: _period,
                            decoration: const InputDecoration(
                              labelText: 'Zeitraum',
                              border: OutlineInputBorder(),
                            ),
                            items: TaskAnalyticsPeriod.values
                                .map(
                                  (period) => DropdownMenuItem(
                                    value: period,
                                    child: Text(period.label),
                                  ),
                                )
                                .toList(growable: false),
                            onChanged:
                                (value) => setState(
                                  () =>
                                      _period =
                                          value ??
                                          TaskAnalyticsPeriod.last7Days,
                                ),
                          ),
                        ],
                      ],
                      const SizedBox(height: 22),
                      FilledButton.icon(
                        onPressed:
                            _saving ||
                                    (_mode == _SelectionMode.custom &&
                                        _metric == null)
                                ? null
                                : _save,
                        icon: const Icon(Icons.save_outlined),
                        label: Text(_saving ? 'Speichert …' : 'Übernehmen'),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}

class _WarningBox extends StatelessWidget {
  const _WarningBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(text, style: TextStyle(color: colors.onErrorContainer)),
      ),
    );
  }
}
