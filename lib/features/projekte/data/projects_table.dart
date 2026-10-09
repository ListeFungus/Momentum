import 'package:drift/drift.dart';

const defaultProjectColorHex = '#5B67D6';

@DataClassName('Project')
class Projects extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get description => text().withDefault(const Constant(''))();

  TextColumn get colorHex =>
      text().withDefault(const Constant(defaultProjectColorHex))();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  DateTimeColumn get archivedAt => dateTime().nullable()();

  DateTimeColumn get trashedAt => dateTime().nullable()();

  DateTimeColumn get purgeAt => dateTime().nullable()();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  IntColumn get revision => integer().withDefault(const Constant(0))();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'CHECK ((trashed_at IS NULL AND purge_at IS NULL) OR '
        '(trashed_at IS NOT NULL AND purge_at IS NOT NULL))',
    'CHECK (revision >= 0)',
  ];
}
