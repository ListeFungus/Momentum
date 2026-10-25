import 'package:flutter/material.dart';
import '../../data/task_type_change_service.dart';

class TaskTypeChangeDialog extends StatefulWidget {
  const TaskTypeChangeDialog({super.key, required this.preview});
  final TaskTypeChangePreview preview;
  @override
  State<TaskTypeChangeDialog> createState() => _TaskTypeChangeDialogState();
}

class _TaskTypeChangeDialogState extends State<TaskTypeChangeDialog> {
  TaskTypeChangeScope? selected;
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      'In ${widget.preview.targetType == 'habit' ? 'Habit' : 'Aufgabe'} umwandeln',
    ),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${widget.preview.entryCount} bisherige Einträge. Rhythmus, Werte, Termine und Frage/Anzeigetext bleiben gleich.',
          ),
          if (widget.preview.entryCount == 0)
            const Text('Es sind noch keine Einträge betroffen.'),
          if (widget.preview.hasTodayEntry)
            const Text(
              'Bei „Ab jetzt für neue Einträge“ bleibt auch der heutige bestehende Eintrag im bisherigen Reiter.',
            ),
          for (final scope in TaskTypeChangeScope.values)
            RadioListTile<TaskTypeChangeScope>(
              title: Text(
                scope == TaskTypeChangeScope.newEntries
                    ? 'Ab jetzt für neue Einträge'
                    : 'Auch bisherige Einträge umordnen',
              ),
              subtitle: Text(
                widget.preview.reason(scope) ??
                    (scope == TaskTypeChangeScope.newEntries
                        ? 'Vorhandene Einträge und Nachträge für frühere Tage behalten ihre damalige Art.'
                        : 'Bewusste Korrektur der gesamten bisherigen Artzuordnung. Kein automatisches Undo.'),
              ),
              value: scope,
              groupValue: selected,
              onChanged:
                  widget.preview.reason(scope) != null
                      ? null
                      : (value) => setState(() => selected = value),
            ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Abbrechen'),
      ),
      FilledButton(
        onPressed:
            selected == null ? null : () => Navigator.pop(context, selected),
        child: const Text('Art ändern'),
      ),
    ],
  );
}
