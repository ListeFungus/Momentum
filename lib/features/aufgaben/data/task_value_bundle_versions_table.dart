import 'package:drift/drift.dart';
import 'package:momentum/features/aufgaben/data/task_goal.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundles_table.dart';

@DataClassName('TaskValueBundleVersion')
class TaskValueBundleVersions extends Table {
  TextColumn get id => text()();

  TextColumn get bundleId =>
      text().references(TaskValueBundles, #id, onDelete: KeyAction.cascade)();

  IntColumn get versionNumber => integer()();

  TextColumn get previousVersionId => text().nullable()();

  DateTimeColumn get validFrom => dateTime()();

  DateTimeColumn get validTo => dateTime().nullable()();

  DateTimeColumn get cancelledAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  TextColumn get name => text().withDefault(const Constant(''))();

  TextColumn get description => text().withDefault(const Constant(''))();

  TextColumn get bundleType => text()();

  TextColumn get firstTaskId => text()();

  TextColumn get secondTaskId => text()();

  TextColumn get firstRoleLabel => text().withDefault(const Constant(''))();

  TextColumn get secondRoleLabel => text().withDefault(const Constant(''))();

  TextColumn get resultLabel => text().withDefault(const Constant(''))();

  TextColumn get direction =>
      text().withDefault(const Constant('first_minus_second'))();

  TextColumn get displayMode =>
      text().withDefault(const Constant('combined_card'))();

  TextColumn get goalType =>
      text().withDefault(const Constant(TaskGoalType.none))();

  IntColumn get goalValue => integer().withDefault(const Constant(1))();

  IntColumn get goalWindowDays => integer().nullable()();

  IntColumn get firstTaskDayOffset =>
      integer().withDefault(const Constant(0))();

  IntColumn get secondTaskDayOffset =>
      integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {bundleId, versionNumber},
  ];

  @override
  List<String> get customConstraints => [
    "CHECK (bundle_type IN ('time_interval', 'difference', 'sum'))",
    "CHECK (direction IN ('first_minus_second', 'second_minus_first'))",
    "CHECK (display_mode IN ('combined_card', 'linked_cards'))",
    "CHECK (goal_type IN ('none', 'value_sum_min', 'value_average_min', "
        "'value_average_max'))",
    "CHECK (goal_value >= 1)",
    "CHECK (goal_window_days IS NULL OR goal_window_days >= 1)",
    'CHECK (first_task_day_offset IN (-1, 0))',
    'CHECK (second_task_day_offset = 0)',
    "CHECK ((first_task_day_offset = 0 AND second_task_day_offset = 0) "
        "OR (bundle_type = 'time_interval' "
        "AND first_task_day_offset = -1 "
        "AND second_task_day_offset = 0 "
        "AND display_mode = 'linked_cards'))",
    'CHECK (first_task_id <> second_task_id)',
    'CHECK (valid_to IS NULL OR valid_to > valid_from)',
  ];
}
