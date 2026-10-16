import 'package:drift/drift.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_tabelle.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundles_table.dart';

class CardDisplaySettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get mode => text().withDefault(const Constant('compact'))();
  BoolColumn get singleOpen => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'CHECK (id = 1)',
    "CHECK (mode IN ('compact', 'expanded', 'remember'))",
  ];
}

class CardExpansionPreferences extends Table {
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
  IntColumn get openedOrder => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {taskId},
    {bundleId},
  ];

  @override
  List<String> get customConstraints => [
    "CHECK ((task_id IS NOT NULL AND bundle_id IS NULL AND id = 'task:' || task_id) OR "
        "(bundle_id IS NOT NULL AND task_id IS NULL AND id = 'bundle:' || bundle_id))",
    'CHECK (opened_order > 0)',
  ];
}
