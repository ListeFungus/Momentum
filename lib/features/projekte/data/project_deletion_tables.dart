import 'package:drift/drift.dart';
import 'package:momentum/features/projekte/data/projects_table.dart';

class ProjectDeletionMode {
  static const projectOnly = 'project_only';
  static const projectAndContents = 'project_and_contents';
}

class ProjectDeletionObjectType {
  static const task = 'task';
  static const bundle = 'bundle';
}

@DataClassName('ProjectDeletionBatch')
class ProjectDeletionBatches extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().references(Projects, #id)();
  TextColumn get mode => text()();
  DateTimeColumn get deletedAt => dateTime()();
  IntColumn get projectRevision => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    "CHECK (mode IN ('project_only', 'project_and_contents'))",
  ];
}

@DataClassName('ProjectDeletionBatchItem')
class ProjectDeletionBatchItems extends Table {
  TextColumn get batchId =>
      text().references(
        ProjectDeletionBatches,
        #id,
        onDelete: KeyAction.cascade,
      )();
  TextColumn get objectType => text()();
  TextColumn get objectId => text()();
  IntColumn get lifecycleRevision => integer()();
  DateTimeColumn get trashedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {batchId, objectType, objectId};

  @override
  List<String> get customConstraints => [
    "CHECK (object_type IN ('task', 'bundle'))",
  ];
}
