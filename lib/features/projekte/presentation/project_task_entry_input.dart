import 'package:flutter/material.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/task_for_date.dart';
import 'package:momentum/features/aufgaben/data/task_types.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_entry_dialogs.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_modes/boolean_habit_input.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_modes/checkbox_task_input.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_modes/value_task_input.dart';

/// Uses the same inputs and write paths as the daily task view.
class ProjectTaskEntryInput extends StatefulWidget {
  const ProjectTaskEntryInput({
    required this.task,
    required this.scheduledDate,
    required this.repository,
    required this.accentColor,
    super.key,
  });

  final TaskForDate task;
  final DateTime scheduledDate;
  final AufgabenRepository repository;
  final Color accentColor;

  @override
  State<ProjectTaskEntryInput> createState() => _ProjectTaskEntryInputState();
}

class _ProjectTaskEntryInputState extends State<ProjectTaskEntryInput> {
  bool _saving = false;

  Future<void> _write(Future<void> Function() action) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await action();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Eintrag konnte nicht gespeichert werden: $error'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final date = widget.scheduledDate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          'Eintrag für ${date.day}.${date.month}.${date.year}',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        if (task.task.questionText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(task.task.questionText),
          ),
        const SizedBox(height: 6),
        AbsorbPointer(
          absorbing: _saving,
          child:
              task.task.erfassungsmodus == 'value'
                  ? ValueTaskInput(
                    task: task,
                    scheduledDate: date,
                    onSave: (input) async {
                      final performedOn = await selectPerformedOnForPastEntry(
                        context,
                        date,
                      );
                      if (performedOn == null) {
                        throw StateError(
                          'Speichern abgebrochen. Der Entwurf bleibt erhalten.',
                        );
                      }
                      // ValueTaskInput owns async errors and draft retention.
                      await widget.repository.setTaskEntryValue(
                        task: task.task,
                        scheduledDate: date,
                        valueType: task.task.valueType,
                        numberValue: input.numberValue,
                        durationSeconds: input.durationSeconds,
                        timeMinutes: input.timeMinutes,
                        dayOffset: input.dayOffset,
                        performedOn: performedOn,
                      );
                    },
                  )
                  : task.task.erfassungsmodus == 'three_state' ||
                      task.task.taskType == TaskTypes.habit
                  ? BooleanHabitInput(
                    value: task.booleanValue,
                    successValue: task.task.successValue,
                    accentColor: widget.accentColor,
                    hasNote: task.note.isNotEmpty,
                    onEditNote:
                        () => _write(
                          () => editTaskEntryNote(
                            context: context,
                            repository: widget.repository,
                            task: task,
                            scheduledDate: date,
                          ),
                        ),
                    onChanged:
                        (value) => _write(() async {
                          final performedOn =
                              value == task.task.successValue
                                  ? await selectPerformedOnForPastEntry(
                                    context,
                                    date,
                                  )
                                  : null;
                          if (value == task.task.successValue &&
                              performedOn == null) {
                            return;
                          }
                          await widget.repository.setBooleanHabitValue(
                            task: task.task,
                            scheduledDate: date,
                            value: value,
                            performedOn: performedOn,
                          );
                        }),
                  )
                  : CheckboxTaskInput(
                    isCompleted: task.isCompleted,
                    accentColor: widget.accentColor,
                    onChanged:
                        (value) => _write(() async {
                          final performedOn =
                              value
                                  ? await selectPerformedOnForPastEntry(
                                    context,
                                    date,
                                  )
                                  : null;
                          if (value && performedOn == null) return;
                          await widget.repository.setTaskCompleted(
                            taskId: task.task.id,
                            scheduledDate: date,
                            isCompleted: value,
                            performedOn: performedOn,
                          );
                        }),
                  ),
        ),
      ],
    );
  }
}
