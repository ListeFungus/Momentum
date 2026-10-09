import 'package:drift/drift.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_tabelle.dart';
import 'package:momentum/features/aufgaben/data/task_entries_tabelle.dart';

class TaskCorrectionOperationState {
  static const applied = 'applied';
  static const undone = 'undone';
  static const blocked = 'blocked';
}

class TaskCorrectionOperationType {
  static const answer = 'answer';
  static const value = 'value';
  static const removeValue = 'remove_value';
  static const note = 'note';
  static const reopen = 'reopen';
  static const bulkStatus = 'bulk_status';
  static const projectHistory = 'project_history';
}

@DataClassName('TaskCorrectionOperation')
class TaskCorrectionOperations extends Table {
  TextColumn get id => text()();

  TextColumn get taskId =>
      text().references(Aufgaben, #id, onDelete: KeyAction.cascade)();

  TextColumn get type => text()();

  TextColumn get state =>
      text().withDefault(
        const Constant(TaskCorrectionOperationState.applied),
      )();

  IntColumn get payloadVersion => integer().withDefault(const Constant(1))();

  TextColumn get reason => text().withDefault(const Constant(''))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    "CHECK (state IN ('applied', 'undone', 'blocked'))",
    'CHECK (payload_version >= 1)',
  ];
}

@DataClassName('TaskCorrectionItem')
class TaskCorrectionItems extends Table {
  TextColumn get id => text()();

  TextColumn get operationId =>
      text().references(
        TaskCorrectionOperations,
        #id,
        onDelete: KeyAction.cascade,
      )();

  TextColumn get entryId =>
      text().references(TaskEntries, #id, onDelete: KeyAction.cascade)();

  TextColumn get beforeJson => text()();

  TextColumn get afterJson => text()();

  IntColumn get expectedRevision => integer()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {operationId, entryId},
  ];

  @override
  List<String> get customConstraints => ['CHECK (expected_revision >= 0)'];
}
