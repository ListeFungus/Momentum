import 'package:drift/drift.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_tabelle.dart';
import 'package:momentum/features/aufgaben/data/task_definition_versions_table.dart';
import 'package:momentum/features/aufgaben/data/task_entry_status.dart';

@DataClassName('TaskEntry')
class TaskEntries extends Table {
  TextColumn get id => text()();

  TextColumn get taskId =>
      text().references(Aufgaben, #id, onDelete: KeyAction.cascade)();

  TextColumn get taskDefinitionVersionId =>
      text().nullable().references(
        TaskDefinitionVersions,
        #id,
        onDelete: KeyAction.setNull,
      )();

  DateTimeColumn get scheduledDate => dateTime()();

  DateTimeColumn get originalScheduledDate => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  TextColumn get status =>
      text().withDefault(const Constant(TaskEntryStatus.pending))();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get respondedAt => dateTime().nullable()();

  DateTimeColumn get finalizedAt => dateTime().nullable()();

  DateTimeColumn get effectiveAt => dateTime().nullable()();

  DateTimeColumn get performedOn => dateTime().nullable()();

  TextColumn get performedOnSource => text().nullable()();

  IntColumn get revision => integer().withDefault(const Constant(0))();

  TextColumn get planningOrigin =>
      text().withDefault(const Constant(TaskEntryPlanningOrigin.planned))();

  TextColumn get resolutionOrigin => text().nullable()();

  TextColumn get appliedMissedPolicy => text().nullable()();

  TextColumn get appliedMissedConsequence => text().nullable()();

  BoolColumn get checkboxValue => boolean().nullable()();

  RealColumn get numberValue => real().nullable()();

  TextColumn get note => text().withDefault(const Constant(''))();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {taskId, scheduledDate},
  ];

  @override
  List<String> get customConstraints => [
    "CHECK (planning_origin IN ('planned', 'voluntary_pause'))",
  ];
}

abstract final class TaskEntryPlanningOrigin {
  static const planned = 'planned';
  static const voluntaryPause = 'voluntary_pause';
}
