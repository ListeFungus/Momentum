import 'package:drift/drift.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_tabelle.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundles_table.dart';
import 'package:momentum/features/projekte/data/projects_table.dart';

class TaskProjectAssignmentScope {
  static const fromDate = 'from_date';
  static const allHistory = 'all_history';
}

class TaskProjectAssignmentState {
  static const pending = 'pending';
  static const applied = 'applied';
  static const cancelled = 'cancelled';
  static const undone = 'undone';
}

class ProjectAssignmentOrigin {
  static const user = 'user';
  static const projectDeletion = 'project_deletion';
}

@DataClassName('TaskProjectAssignmentChange')
class TaskProjectAssignmentChanges extends Table {
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

  @ReferenceName('targetProjectAssignmentChanges')
  TextColumn get targetProjectId =>
      text().nullable().references(
        Projects,
        #id,
        onDelete: KeyAction.setNull,
      )();

  @ReferenceName('previousProjectAssignmentChanges')
  TextColumn get previousProjectId =>
      text().nullable().references(
        Projects,
        #id,
        onDelete: KeyAction.setNull,
      )();

  TextColumn get scope => text()();

  DateTimeColumn get effectiveDate => dateTime()();

  IntColumn get sequence => integer()();

  TextColumn get state =>
      text().withDefault(const Constant(TaskProjectAssignmentState.pending))();

  TextColumn get origin =>
      text().withDefault(const Constant(ProjectAssignmentOrigin.user))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'CHECK ((task_id IS NOT NULL AND bundle_id IS NULL) OR '
        '(task_id IS NULL AND bundle_id IS NOT NULL))',
    "CHECK (scope IN ('from_date', 'all_history'))",
    "CHECK (state IN ('pending', 'applied', 'cancelled', 'undone'))",
    "CHECK (origin IN ('user', 'project_deletion'))",
    'CHECK (sequence >= 1)',
  ];
}
