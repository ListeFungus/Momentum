import 'package:flutter/material.dart';
import 'package:momentum/core/date/calendar_days.dart';
import '../../data/aufgaben_repository.dart';
import '../../data/task_for_date.dart';

Future<void> editTaskEntryNote({
  required BuildContext context,
  required AufgabenRepository repository,
  required TaskForDate task,
  required DateTime scheduledDate,
}) async {
  final note = await showDialog<String>(
    context: context,
    builder: (context) => _TaskEntryNoteDialog(initialNote: task.note),
  );

  if (note == null || !context.mounted) {
    return;
  }

  await repository.setTaskEntryNote(
    taskId: task.task.id,
    scheduledDate: scheduledDate,
    note: note,
  );
}

class _TaskEntryNoteDialog extends StatefulWidget {
  const _TaskEntryNoteDialog({required this.initialNote});

  final String initialNote;

  @override
  State<_TaskEntryNoteDialog> createState() => _TaskEntryNoteDialogState();
}

class _TaskEntryNoteDialogState extends State<_TaskEntryNoteDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNote);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tagesnotiz'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        minLines: 3,
        maxLines: 6,
        decoration: const InputDecoration(
          hintText: 'Optionale Notiz zu diesem Tag',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: const Text('Speichern'),
        ),
      ],
    );
  }
}

Future<DateTime?> selectPerformedOnForPastEntry(
  BuildContext context,
  DateTime scheduledDate,
) async {
  final today = calendarDay(DateTime.now());
  final plannedDay = calendarDay(scheduledDate);
  if (!plannedDay.isBefore(today)) {
    return today;
  }
  final selection = await showDialog<String>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Wann wurde es durchgeführt?'),
          content: const Text(
            'Der Durchführungstag beeinflusst, ob der Eintrag rechtzeitig war. '
            'Bestehende Folgetermine werden dadurch nicht verschoben.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop('planned'),
              child: const Text('Am vorgesehenen Tag'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop('custom'),
              child: const Text('Anderes Datum'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop('today'),
              child: const Text('Heute'),
            ),
          ],
        ),
  );
  if (!context.mounted || selection == null) {
    return null;
  }
  if (selection == 'planned') {
    return plannedDay;
  }
  if (selection == 'today') {
    return today;
  }
  return showDatePicker(
    context: context,
    initialDate: plannedDay,
    firstDate: plannedDay,
    lastDate: today,
    helpText: 'Tatsächlicher Durchführungstag',
  );
}
