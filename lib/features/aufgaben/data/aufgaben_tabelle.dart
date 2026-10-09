import 'package:drift/drift.dart';
import 'package:momentum/features/aufgaben/data/missed_policy.dart';
import 'package:momentum/features/aufgaben/data/post_buffer_behavior.dart';
import 'package:momentum/features/aufgaben/data/task_goal.dart';
import 'package:momentum/features/projekte/data/projects_table.dart';

@DataClassName('Aufgabe')
class Aufgaben extends Table {
  TextColumn get id => text()();

  TextColumn get projectId =>
      text().nullable().references(
        Projects,
        #id,
        onDelete: KeyAction.setNull,
      )();

  TextColumn get name => text()();

  TextColumn get beschreibung => text().withDefault(const Constant(''))();

  TextColumn get erfassungsmodus => text()();

  TextColumn get taskType => text().withDefault(const Constant('habit'))();

  TextColumn get questionText => text().withDefault(const Constant(''))();

  BoolColumn get successValue => boolean().withDefault(const Constant(true))();

  TextColumn get activeWeekdays =>
      text().withDefault(const Constant('1,2,3,4,5,6,7'))();

  TextColumn get recurrence => text().withDefault(const Constant('daily'))();

  DateTimeColumn get startDate => dateTime()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  DateTimeColumn get endDate => dateTime().nullable()();

  DateTimeColumn get dueDate => dateTime().nullable()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get trashedAt => dateTime().nullable()();

  DateTimeColumn get purgeAt => dateTime().nullable()();

  IntColumn get lifecycleRevision => integer().withDefault(const Constant(0))();

  DateTimeColumn get lifecycleUpdatedAt => dateTime().nullable()();

  TextColumn get missedPolicy =>
      text().withDefault(const Constant(MissedPolicy.none))();

  TextColumn get missedConsequence =>
      text().withDefault(const Constant(MissedConsequence.markAsNotDone))();

  IntColumn get missedBufferDays => integer().withDefault(const Constant(1))();

  TextColumn get postBufferBehavior =>
      text().withDefault(const Constant(PostBufferBehavior.markAsFailure))();

  IntColumn get maxCarryoverCount => integer().withDefault(const Constant(3))();

  TextColumn get goalType =>
      text().withDefault(const Constant(TaskGoalType.none))();

  IntColumn get goalValue => integer().withDefault(const Constant(1))();

  IntColumn get goalWindowDays => integer().nullable()();

  TextColumn get goalPeriod =>
      text().withDefault(const Constant(GoalPeriod.week))();

  TextColumn get goalPeriodAlignment =>
      text().withDefault(const Constant(GoalPeriodAlignment.calendar))();

  TextColumn get valueType => text().withDefault(const Constant('none'))();

  TextColumn get valueCommitment =>
      text().withDefault(const Constant('none'))();

  TextColumn get valueUnitKey => text().withDefault(const Constant('none'))();

  TextColumn get valueUnitLabel => text().withDefault(const Constant(''))();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'CHECK ((trashed_at IS NULL AND purge_at IS NULL) OR '
        '(trashed_at IS NOT NULL AND purge_at IS NOT NULL))',
    'CHECK (lifecycle_revision >= 0)',
  ];
}
