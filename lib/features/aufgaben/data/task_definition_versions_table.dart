import 'package:drift/drift.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_tabelle.dart';
import 'package:momentum/features/aufgaben/data/missed_policy.dart';
import 'package:momentum/features/aufgaben/data/post_buffer_behavior.dart';
import 'package:momentum/features/aufgaben/data/task_goal.dart';

@DataClassName('TaskDefinitionVersion')
class TaskDefinitionVersions extends Table {
  TextColumn get id => text()();

  TextColumn get taskId =>
      text().references(Aufgaben, #id, onDelete: KeyAction.cascade)();

  IntColumn get versionNumber => integer()();

  TextColumn get previousVersionId => text().nullable()();

  DateTimeColumn get validFrom => dateTime()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get supersededAt => dateTime().nullable()();

  TextColumn get name => text().withDefault(const Constant(''))();

  TextColumn get description => text().withDefault(const Constant(''))();

  TextColumn get questionText => text().withDefault(const Constant(''))();

  TextColumn get projectId => text().nullable()();

  TextColumn get taskType => text()();

  TextColumn get captureMode => text()();

  BoolColumn get successValue => boolean().withDefault(const Constant(true))();

  TextColumn get activeWeekdays => text()();

  TextColumn get recurrence => text()();

  DateTimeColumn get startDate => dateTime()();

  DateTimeColumn get endDate => dateTime().nullable()();

  DateTimeColumn get dueDate => dateTime().nullable()();

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
  List<Set<Column<Object>>> get uniqueKeys => [
    {taskId, versionNumber},
  ];
}
