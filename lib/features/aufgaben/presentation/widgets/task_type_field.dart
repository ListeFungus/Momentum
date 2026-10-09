import 'package:flutter/material.dart';
import 'package:momentum/features/aufgaben/data/task_types.dart';

class TaskTypeField extends StatelessWidget {
  const TaskTypeField({
    required this.selectedTaskType,
    required this.onChanged,
    this.enabled = true,
    super.key,
  });

  final String selectedTaskType;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedTaskType,
      decoration: const InputDecoration(
        labelText: 'Aufgabenart',
        helperText:
            'Habits wiederholen sich täglich und werden separat angezeigt.',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: TaskTypes.task, child: Text('Aufgabe')),
        DropdownMenuItem(value: TaskTypes.habit, child: Text('Habit')),
      ],
      onChanged:
          enabled
              ? (value) {
                if (value != null) {
                  onChanged(value);
                }
              }
              : null,
    );
  }
}
