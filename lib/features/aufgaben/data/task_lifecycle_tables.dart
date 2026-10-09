import 'package:drift/drift.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_tabelle.dart';

abstract final class TaskPlanningInterruptionReason {
  static const pause = 'pause';
  static const trash = 'trash';
}

abstract final class DeletableEntityType {
  static const task = 'task';
  static const bundle = 'bundle';
}

@DataClassName('TaskPlanningInterruption')
class TaskPlanningInterruptions extends Table {
  TextColumn get id => text()();

  TextColumn get taskId =>
      text().references(Aufgaben, #id, onDelete: KeyAction.cascade)();

  TextColumn get reason => text()();

  TextColumn get fromDay => text()();

  TextColumn get untilDayExclusive => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  IntColumn get revision => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    "CHECK (reason IN ('pause', 'trash'))",
    'CHECK (revision >= 0)',
  ];
}

@DataClassName('EntityDeletionMarker')
class EntityDeletionMarkers extends Table {
  TextColumn get entityType => text()();

  TextColumn get entityId => text()();

  DateTimeColumn get deletedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {entityType, entityId};

  @override
  List<String> get customConstraints => [
    "CHECK (entity_type IN ('task', 'bundle'))",
  ];
}
