import 'package:flutter/material.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/task_capture_mode.dart';
import 'package:momentum/features/aufgaben/data/task_entry_correction_service.dart';
import 'package:momentum/features/aufgaben/data/task_entry_status.dart';
import 'package:momentum/features/aufgaben/data/task_entry_with_value.dart';
import 'package:momentum/features/aufgaben/data/task_value_commitment.dart';

class TaskEntryCorrectionsScreen extends StatefulWidget {
  const TaskEntryCorrectionsScreen({
    required this.task,
    required this.repository,
    super.key,
  });

  final Aufgabe task;
  final AufgabenRepository repository;

  @override
  State<TaskEntryCorrectionsScreen> createState() =>
      _TaskEntryCorrectionsScreenState();
}

class _TaskEntryCorrectionsScreenState
    extends State<TaskEntryCorrectionsScreen> {
  final Set<String> _selectedEntryIds = {};
  final TextEditingController _reasonController = TextEditingController();
  late String _targetStatus;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _targetStatus = _availableStatuses.first;
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  List<String> get _availableStatuses {
    final pureTracking =
        widget.task.erfassungsmodus == TaskCaptureMode.value &&
        widget.task.valueCommitment == TaskValueCommitment.pureTracking;
    if (pureTracking) {
      return const [TaskEntryStatus.noEntry, TaskEntryStatus.pending];
    }
    if (widget.task.erfassungsmodus == TaskCaptureMode.value) {
      return const [
        TaskEntryStatus.failure,
        TaskEntryStatus.noEntry,
        TaskEntryStatus.pending,
      ];
    }
    return const [
      TaskEntryStatus.success,
      TaskEntryStatus.failure,
      TaskEntryStatus.noEntry,
      TaskEntryStatus.pending,
    ];
  }

  Future<void> _applyBulk() async {
    final preview = await widget.repository.previewBulkStatusCorrection(
      taskId: widget.task.id,
      entryIds: _selectedEntryIds,
      status: _targetStatus,
      checkboxValue:
          _targetStatus == TaskEntryStatus.success
              ? widget.task.successValue
              : _targetStatus == TaskEntryStatus.failure
              ? !widget.task.successValue
              : null,
    );
    if (!mounted) {
      return;
    }
    if (preview.changedCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Keine tatsächliche Änderung ausgewählt.'),
        ),
      );
      return;
    }
    if (_targetStatus == TaskEntryStatus.noEntry &&
        _reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte gib eine Begründung an.')),
      );
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Korrektur bestätigen'),
            content: Text(
              '${preview.changedCount} Einträge werden zu '
              '„${_statusLabel(_targetStatus)}“ geändert.\n\n'
              '${_targetStatus == TaskEntryStatus.success ? 'Jeder Eintrag gilt dabei als am vorgesehenen Tag erledigt und damit rechtzeitig. ' : ''}'
              'Auswertungen werden neu berechnet; nicht ausgewählte Einträge '
              'bleiben unverändert. Leere Tracking-Tage werden nicht verändert.'
              '${preview.excludedValueCount > 0 ? '\n\n${preview.excludedValueCount} Einträge mit Messwert wurden ausgeschlossen.' : ''}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Abbrechen'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Korrigieren'),
              ),
            ],
          ),
    );
    if (confirmed != true) {
      return;
    }
    setState(() => _isSaving = true);
    try {
      await widget.repository.applyStatusCorrections(
        taskId: widget.task.id,
        targets: preview.targets,
        reason: _reasonController.text,
      );
      if (mounted) {
        setState(() => _selectedEntryIds.clear());
      }
    } on TaskCorrectionException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _undo() async {
    try {
      final changed = await widget.repository.undoLatestTaskCorrection(
        widget.task.id,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              changed
                  ? 'Die letzte Korrektur wurde rückgängig gemacht.'
                  : 'Keine rückgängig machbare Korrektur vorhanden.',
            ),
          ),
        );
      }
    } on TaskCorrectionException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    }
  }

  Future<void> _correctSingle(
    TaskEntryWithValue item,
    _SingleCorrectionAction action,
  ) async {
    try {
      if (action == _SingleCorrectionAction.removeValue) {
        await widget.repository.removeTaskEntryValue(
          taskId: widget.task.id,
          entryId: item.entry.id,
          reason: 'Messwert entfernt',
        );
        return;
      }
      DateTime? performedOn;
      String status;
      bool? checkboxValue;
      switch (action) {
        case _SingleCorrectionAction.scheduledSuccess:
          status = TaskEntryStatus.success;
          performedOn = item.entry.scheduledDate;
          checkboxValue = widget.task.successValue;
          break;
        case _SingleCorrectionAction.todaySuccess:
          status = TaskEntryStatus.success;
          performedOn = _dateOnly(DateTime.now());
          checkboxValue = widget.task.successValue;
          break;
        case _SingleCorrectionAction.customSuccess:
          final selected = await showDatePicker(
            context: context,
            initialDate: _dateOnly(DateTime.now()),
            firstDate: _dateOnly(widget.task.startDate),
            lastDate: _dateOnly(DateTime.now()),
            helpText: 'Tatsächlicher Durchführungstag',
          );
          if (selected == null) return;
          status = TaskEntryStatus.success;
          performedOn = selected;
          checkboxValue = widget.task.successValue;
          break;
        case _SingleCorrectionAction.failure:
          status = TaskEntryStatus.failure;
          checkboxValue = !widget.task.successValue;
          break;
        case _SingleCorrectionAction.noEntry:
          status = TaskEntryStatus.noEntry;
          checkboxValue = null;
          break;
        case _SingleCorrectionAction.reopen:
          status = TaskEntryStatus.pending;
          checkboxValue = null;
          break;
        case _SingleCorrectionAction.removeValue:
          return;
      }
      final reason =
          status == TaskEntryStatus.noEntry ? await _askReason() : '';
      if (status == TaskEntryStatus.noEntry && reason == null) {
        return;
      }
      await widget.repository.applyStatusCorrections(
        taskId: widget.task.id,
        targets: [
          TaskStatusCorrectionTarget(
            entryId: item.entry.id,
            status: status,
            checkboxValue: checkboxValue,
            performedOn: performedOn,
            expectedRevision: item.entry.revision,
          ),
        ],
        reason: reason ?? '',
      );
    } on TaskCorrectionException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    }
  }

  Future<String?> _askReason() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Grund für „Kein Eintrag“'),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Begründung',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Abbrechen'),
              ),
              FilledButton(
                onPressed:
                    () => Navigator.of(context).pop(controller.text.trim()),
                child: const Text('Übernehmen'),
              ),
            ],
          ),
    );
    controller.dispose();
    return result?.isEmpty == true ? null : result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einträge korrigieren'),
        actions: [
          IconButton(
            onPressed: _isSaving ? null : _undo,
            tooltip: 'Letzte Korrektur rückgängig',
            icon: const Icon(Icons.undo),
          ),
        ],
      ),
      body: StreamBuilder<List<TaskEntryWithValue>>(
        stream: widget.repository.watchStoredTaskEntries(widget.task.id),
        builder: (context, snapshot) {
          final entries = snapshot.data ?? const [];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _targetStatus,
                      decoration: const InputDecoration(
                        labelText: 'Sammelkorrektur',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          _availableStatuses
                              .map(
                                (status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(_statusLabel(status)),
                                ),
                              )
                              .toList(),
                      onChanged:
                          _isSaving
                              ? null
                              : (value) => setState(
                                () => _targetStatus = value ?? _targetStatus,
                              ),
                    ),
                    if (_targetStatus == TaskEntryStatus.noEntry) ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: _reasonController,
                        decoration: const InputDecoration(
                          labelText: 'Gemeinsame Begründung',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed:
                          _isSaving || _selectedEntryIds.isEmpty
                              ? null
                              : _applyBulk,
                      icon: const Icon(Icons.fact_check_outlined),
                      label: const Text('Auswahl prüfen und korrigieren'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final item = entries[index];
                    final hasValue = item.entryValue != null;
                    return CheckboxListTile(
                      value: _selectedEntryIds.contains(item.entry.id),
                      onChanged:
                          hasValue || _isSaving
                              ? null
                              : (selected) => setState(() {
                                if (selected == true) {
                                  _selectedEntryIds.add(item.entry.id);
                                } else {
                                  _selectedEntryIds.remove(item.entry.id);
                                }
                              }),
                      title: Text(_formatDate(item.entry.scheduledDate)),
                      subtitle: Text(
                        '${_statusLabel(item.entry.status)}'
                        '${hasValue ? ' · Messwert vorhanden' : ''}'
                        '${item.entry.performedOn == null ? '' : ' · durchgeführt ${_formatDate(item.entry.performedOn!)}'}',
                      ),
                      secondary: PopupMenuButton<_SingleCorrectionAction>(
                        onSelected: (action) => _correctSingle(item, action),
                        itemBuilder:
                            (context) => [
                              if (!hasValue &&
                                  widget.task.erfassungsmodus !=
                                      TaskCaptureMode.value) ...[
                                const PopupMenuItem(
                                  value:
                                      _SingleCorrectionAction.scheduledSuccess,
                                  child: Text('Am vorgesehenen Tag erledigt'),
                                ),
                                const PopupMenuItem(
                                  value: _SingleCorrectionAction.todaySuccess,
                                  child: Text('Heute erledigt'),
                                ),
                                const PopupMenuItem(
                                  value: _SingleCorrectionAction.customSuccess,
                                  child: Text('Anderes Durchführungsdatum'),
                                ),
                                const PopupMenuItem(
                                  value: _SingleCorrectionAction.failure,
                                  child: Text('Nicht geschafft'),
                                ),
                              ],
                              if (hasValue)
                                const PopupMenuItem(
                                  value: _SingleCorrectionAction.removeValue,
                                  child: Text('Messwert entfernen'),
                                ),
                              const PopupMenuItem(
                                value: _SingleCorrectionAction.noEntry,
                                child: Text('Kein Eintrag'),
                              ),
                              const PopupMenuItem(
                                value: _SingleCorrectionAction.reopen,
                                child: Text('Wieder öffnen'),
                              ),
                            ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

enum _SingleCorrectionAction {
  scheduledSuccess,
  todaySuccess,
  customSuccess,
  failure,
  noEntry,
  reopen,
  removeValue,
}

String _statusLabel(String status) => switch (status) {
  TaskEntryStatus.success => 'Erledigt',
  TaskEntryStatus.failure => 'Nicht geschafft',
  TaskEntryStatus.noEntry => 'Kein Eintrag',
  TaskEntryStatus.recorded => 'Wert erfasst',
  _ => 'Offen',
};

String _formatDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}.'
    '${date.month.toString().padLeft(2, '0')}.'
    '${date.year.toString().padLeft(4, '0')}';

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);
