import 'package:drift/drift.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/task_entry_status.dart';
import 'package:momentum/features/aufgaben/data/task_value_commitment.dart';

class DailyCompletion {
  const DailyCompletion(this.date, this.count);
  final DateTime date;
  final int count;
}

class DailyCompletionSummary {
  const DailyCompletionSummary(this.days, this.unknownDateCount);
  final List<DailyCompletion> days;
  final int unknownDateCount;
  int get total => days.fold(0, (total, day) => total + day.count);
}

Stream<DailyCompletionSummary> watchDailyCompletions(
  AppDatabase database, {
  required DateTime endingOn,
}) {
  final end = DateTime(endingOn.year, endingOn.month, endingOn.day);
  final dates = List.generate(
    7,
    (i) => DateTime(end.year, end.month, end.day - 6 + i),
  );
  final entries = database.taskEntries;
  final tasks = database.aufgaben;
  final versions = database.taskDefinitionVersions;
  final query = database.select(entries).join([
    innerJoin(tasks, tasks.id.equalsExp(entries.taskId)),
    leftOuterJoin(
      versions,
      versions.id.equalsExp(entries.taskDefinitionVersionId),
    ),
  ])..where(
    tasks.trashedAt.isNull() &
        entries.status.isIn(TaskEntryStatus.positiveCompletionValues) &
        (entries.performedOn.isNull() |
            (entries.performedOn.isBiggerOrEqualValue(dates.first) &
                entries.performedOn.isSmallerThanValue(
                  DateTime(end.year, end.month, end.day + 1),
                ))),
  );
  return query.watch().map((rows) {
    final counts = {for (final date in dates) date: 0};
    var unknown = 0;
    for (final row in rows) {
      final task = row.readTable(tasks);
      final version = row.readTableOrNull(versions);
      if ((version?.valueCommitment ?? task.valueCommitment) ==
          TaskValueCommitment.pureTracking) {
        continue;
      }
      final entry = row.readTable(entries);
      final performed = entry.performedOn;
      if (performed == null) {
        unknown++;
        continue;
      }
      final date = DateTime(performed.year, performed.month, performed.day);
      if (counts.containsKey(date)) counts[date] = counts[date]! + 1;
    }
    return DailyCompletionSummary([
      for (final date in dates) DailyCompletion(date, counts[date]!),
    ], unknown);
  });
}
