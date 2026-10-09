import 'package:drift/drift.dart';
import 'package:momentum/features/projekte/data/projects_table.dart';

@DataClassName('TaskValueBundle')
class TaskValueBundles extends Table {
  TextColumn get id => text()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime()();

  TextColumn get projectId =>
      text().nullable().references(
        Projects,
        #id,
        onDelete: KeyAction.setNull,
      )();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get trashedAt => dateTime().nullable()();

  DateTimeColumn get purgeAt => dateTime().nullable()();

  IntColumn get lifecycleRevision => integer().withDefault(const Constant(0))();

  DateTimeColumn get lifecycleUpdatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'CHECK ((trashed_at IS NULL AND purge_at IS NULL) OR '
        '(trashed_at IS NOT NULL AND purge_at IS NOT NULL))',
    'CHECK (lifecycle_revision >= 0)',
  ];
}
