import 'package:drift/drift.dart';
import 'aufgaben_tabelle.dart';
import 'task_definition_versions_table.dart';

@DataClassName('TaskTypeChange')
class TaskTypeChanges extends Table {
  TextColumn get id => text()();
  TextColumn get taskId =>
      text().references(Aufgaben, #id, onDelete: KeyAction.cascade)();
  IntColumn get sequence => integer()();
  DateTimeColumn get changedAt => dateTime()();
  TextColumn get previousType => text()();
  TextColumn get targetType => text()();
  TextColumn get scope => text()();
  TextColumn get definitionVersionId =>
      text().references(TaskDefinitionVersions, #id)();
  TextColumn get previousTypesJson =>
      text().withDefault(const Constant('[]'))();
  @override
  Set<Column<Object>> get primaryKey => {id};
  @override
  List<String> get customConstraints => [
    'UNIQUE (task_id, sequence)',
    'CHECK (sequence > 0)',
    "CHECK (previous_type IN ('task', 'habit'))",
    "CHECK (target_type IN ('task', 'habit'))",
    'CHECK (previous_type <> target_type)',
    "CHECK (scope IN ('new_entries', 'all_history'))",
  ];
}
