import 'package:drift/drift.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_tabelle.dart';

class TaskPendingDefinitionChangeGroup {
  static const schedule = 'schedule';
  static const goal = 'goal';
}

class TaskPendingDefinitionChangeState {
  static const pending = 'pending';
  static const applied = 'applied';
  static const cancelled = 'cancelled';
}

@DataClassName('TaskPendingDefinitionChange')
class TaskPendingDefinitionChanges extends Table {
  TextColumn get id => text()();

  TextColumn get taskId =>
      text().references(Aufgaben, #id, onDelete: KeyAction.cascade)();

  TextColumn get groupKey => text()();

  DateTimeColumn get effectiveDate => dateTime()();

  TextColumn get payloadJson => text()();

  IntColumn get payloadVersion => integer().withDefault(const Constant(1))();

  TextColumn get state =>
      text().withDefault(
        const Constant(TaskPendingDefinitionChangeState.pending),
      )();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    "CHECK (group_key IN ('schedule', 'goal'))",
    "CHECK (state IN ('pending', 'applied', 'cancelled'))",
    'CHECK (payload_version >= 1)',
  ];
}
