import 'package:drift/drift.dart';
import 'package:momentum/features/aufgaben/data/task_entries_tabelle.dart';

@DataClassName('TaskEntryValue')
class TaskEntryValues extends Table {
  TextColumn get id => text()();

  TextColumn get entryId =>
      text().references(TaskEntries, #id, onDelete: KeyAction.cascade)();

  TextColumn get valueType => text()();

  RealColumn get numberValue => real().nullable()();

  RealColumn get normalizedNumberValue => real().nullable()();

  TextColumn get unitKey => text().withDefault(const Constant('none'))();

  TextColumn get unitLabel => text().withDefault(const Constant(''))();

  IntColumn get durationSeconds => integer().nullable()();

  IntColumn get timeMinutes => integer().nullable()();

  IntColumn get dayOffset => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {entryId},
  ];

  @override
  List<String> get customConstraints => [
    "CHECK (value_type IN ('number', 'duration', 'time_of_day'))",
  ];
}
