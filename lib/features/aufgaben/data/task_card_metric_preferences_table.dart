import 'package:drift/drift.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_tabelle.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundles_table.dart';

@DataClassName('TaskCardMetricPreference')
class TaskCardMetricPreferences extends Table {
  TextColumn get id => text()();

  TextColumn get taskId =>
      text().nullable().references(
        Aufgaben,
        #id,
        onDelete: KeyAction.cascade,
      )();

  TextColumn get bundleId =>
      text().nullable().references(
        TaskValueBundles,
        #id,
        onDelete: KeyAction.cascade,
      )();

  TextColumn get configJson => text()();

  BoolColumn get isReset => boolean().withDefault(const Constant(false))();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {taskId},
    {bundleId},
  ];

  @override
  List<String> get customConstraints => [
    'CHECK ((task_id IS NOT NULL AND bundle_id IS NULL) OR '
        '(task_id IS NULL AND bundle_id IS NOT NULL))',
  ];
}
