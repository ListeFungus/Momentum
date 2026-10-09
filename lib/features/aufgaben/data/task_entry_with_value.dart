import 'package:momentum/core/database/app_database.dart';

class TaskEntryWithValue {
  const TaskEntryWithValue({required this.entry, required this.entryValue});

  final TaskEntry entry;
  final TaskEntryValue? entryValue;
}
