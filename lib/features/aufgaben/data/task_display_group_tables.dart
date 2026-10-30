import 'package:drift/drift.dart';
import 'aufgaben_tabelle.dart';

@DataClassName('TaskDisplayGroup')
class TaskDisplayGroups extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get sortOrder => integer()();
  BoolColumn get isCollapsed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get revision => integer().withDefault(const Constant(0))();
  @override
  Set<Column<Object>> get primaryKey => {id};
  @override
  List<String> get customConstraints => [
    'CHECK (length(trim(name)) > 0)',
    'CHECK (sort_order >= 0)',
    'CHECK (revision >= 0)',
  ];
}

@DataClassName('TaskDisplayGroupMember')
class TaskDisplayGroupMembers extends Table {
  TextColumn get taskId =>
      text().references(Aufgaben, #id, onDelete: KeyAction.cascade)();
  TextColumn get groupId =>
      text().references(TaskDisplayGroups, #id, onDelete: KeyAction.cascade)();
  IntColumn get sortOrder => integer()();
  @override
  Set<Column<Object>> get primaryKey => {taskId};
  @override
  List<String> get customConstraints => ['CHECK (sort_order >= 0)'];
}
