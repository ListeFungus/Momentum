import 'package:drift/drift.dart';

class CalendarSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  BoolColumn get showTasks => boolean().withDefault(const Constant(true))();
  BoolColumn get showHabits => boolean().withDefault(const Constant(false))();
  BoolColumn get showTrackers => boolean().withDefault(const Constant(false))();
  TextColumn get view => text().withDefault(const Constant('week'))();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'CHECK (id = 1)',
    "CHECK (\"view\" IN ('day', 'week', 'month', 'agenda'))",
  ];
}
