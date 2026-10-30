import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/habit_recurrence.dart';
import 'package:momentum/features/aufgaben/data/task_analytics_period.dart';
import 'package:momentum/features/aufgaben/data/task_entry_status.dart';
import 'package:momentum/features/aufgaben/data/task_goal.dart';
import 'package:momentum/features/aufgaben/data/task_goal_evaluation_summary.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle.dart';
import 'package:momentum/features/aufgaben/data/task_value_commitment.dart';
import 'package:momentum/features/aufgaben/data/task_value_type.dart';
import 'package:momentum/features/aufgaben/data/task_value_unit.dart';

// Fixed civil dates straddle both Europe/Berlin clock changes. On machines
// without DST these still check the same calendar contract, without skipping.
void main() {
  for (final today in [DateTime(2026, 3, 31), DateTime(2026, 10, 28)]) {
    final label = '${today.month}/${today.day}';
    final start = DateTime(today.year, today.month, today.day - 6);
    final tomorrow = DateTime(today.year, today.month, today.day + 1);
    late AppDatabase database;
    late AufgabenRepository repository;

    group(label, () {
      setUp(() {
        database = AppDatabase.forTesting(NativeDatabase.memory());
        repository = AufgabenRepository(database, now: () => today);
      });
      tearDown(() => database.close());

      test(
        'running block and next goal change use calendar midnights',
        () async {
          await repository.createTask(
            name: 'Status goal',
            beschreibung: '',
            erfassungsmodus: 'three_state',
            projectId: null,
            startDate: start,
            goalType: TaskGoalType.rollingSuccessCount,
            goalValue: 2,
            goalWindowDays: 7,
            goalPeriodAlignment: GoalPeriodAlignment.fromStartDate,
          );
          final task = await database.select(database.aufgaben).getSingle();
          final id = task.id;
          for (var i = 0; i < 7; i++) {
            await repository.setBooleanHabitValue(
              task: task,
              scheduledDate: DateTime(start.year, start.month, start.day + i),
              value: true,
            );
          }
          final entriesBefore =
              await database.select(database.taskEntries).get();
          expect(currentGoalBlockStartForTask(task, today), start);
          expect(nextGoalBlockStartForTask(task, today), tomorrow);
          expect(currentGoalBlockStartForTask(task, tomorrow), tomorrow);
          expect(
            TaskGoalHistorySummary.fromEntries(
              task: task,
              entries: entriesBefore,
              today: today,
            ).blocks,
            isEmpty,
          );
          expect(
            (await repository.getTaskGoalHistorySummary(
              task: task,
              today: today,
            )).blocks,
            isEmpty,
          );
          final history = await repository.getTaskGoalHistorySummary(
            task: task,
            today: tomorrow,
          );
          expect(history.blocks.single.periodStart, start);
          expect(history.blocks.single.periodEnd, today);
          expect(history.blocks.single.successCount, 7);
          final live =
              await repository
                  .watchTaskGoalEvaluationSummary(task: task, today: today)
                  .first;
          expect(live.periodStart, start);
          expect(live.successCount, 7);
          await repository.scheduleTaskGoalChangeForNextBlock(
            taskId: id,
            goalType: TaskGoalType.rollingSuccessCount,
            goalValue: 3,
            goalWindowDays: 7,
            goalPeriod: GoalPeriod.week,
            goalPeriodAlignment: GoalPeriodAlignment.fromStartDate,
            today: today,
          );
          expect(
            (await database
                    .select(database.taskPendingDefinitionChanges)
                    .getSingle())
                .effectiveDate,
            tomorrow,
          );
          expect((await repository.currentTask(id)).goalValue, 2);
          expect(
            await database.select(database.taskEntries).get(),
            entriesBefore,
          );
        },
      );

      test(
        'value and bundle windows include exactly seven days without writes',
        () async {
          final beforeStart = DateTime(start.year, start.month, start.day - 1);
          Future<Aufgabe> createTracker(String name) async {
            await repository.createTask(
              name: name,
              beschreibung: '',
              erfassungsmodus: 'value',
              projectId: null,
              startDate: beforeStart,
              recurrence: HabitRecurrence.daily,
              valueType: TaskValueType.number,
              valueCommitment: TaskValueCommitment.pureTracking,
              valueUnitKey: TaskValueUnitKey.custom,
              valueUnitLabel: 'Punkte',
              goalType: TaskGoalType.valueSumMin,
              goalValue: 1,
              goalWindowDays: 7,
            );
            return (database.select(database.aufgaben)
              ..where((t) => t.name.equals(name))).getSingle();
          }

          final first = await createTracker('First');
          final second = await createTracker('Second');
          await repository.createValueBundle(
            name: 'Difference',
            bundleType: TaskValueBundleType.difference,
            firstTaskId: first.id,
            secondTaskId: second.id,
            validFrom: beforeStart,
            goalType: TaskGoalType.valueSumMin,
            goalValue: 1,
            goalWindowDays: 7,
          );
          for (var i = -1; i < 7; i++) {
            final day = DateTime(start.year, start.month, start.day + i);
            await repository.setTaskEntryValue(
              task: first,
              scheduledDate: day,
              valueType: TaskValueType.number,
              numberValue: i < 0 ? 999 : 10,
            );
            await repository.setTaskEntryValue(
              task: second,
              scheduledDate: day,
              valueType: TaskValueType.number,
              numberValue: 4,
            );
          }
          final version =
              await database
                  .select(database.taskValueBundleVersions)
                  .getSingle();
          final entriesBefore =
              await database.select(database.taskEntries).get();
          final valuesBefore =
              await database.select(database.taskEntryValues).get();
          final results = [
            await repository.getTaskValueGoalEvaluationSummary(
              task: first,
              today: today,
            ),
            await repository
                .watchTaskValueGoalEvaluationSummary(task: first, today: today)
                .first,
            await repository.getTaskValueBundleGoalEvaluationSummary(
              version: version,
              today: today,
            ),
            await repository
                .watchTaskValueBundleGoalEvaluationSummary(
                  version: version,
                  today: today,
                )
                .first,
          ];
          for (var i = 0; i < results.length; i++) {
            expect(results[i].periodStart, start);
            expect(results[i].periodEnd, today);
            expect(results[i].recordedCount, 7);
            expect(results[i].actualValue, i < 2 ? 70 : 42);
          }
          expect(
            TaskAnalyticsPeriod.last7Days.rangeStart(
              taskStartDate: beforeStart,
              today: today,
            ),
            start,
          );
          expect(
            await database.select(database.taskEntries).get(),
            entriesBefore,
          );
          expect(
            await database.select(database.taskEntryValues).get(),
            valuesBefore,
          );
        },
      );
    });
  }

  test(
    'multi-year history has contiguous seven-day blocks and preserves entries',
    () async {
      final start = DateTime(2024, 1, 1);
      final today = DateTime(2026, 10, 28);
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      final repository = AufgabenRepository(database, now: () => today);
      await repository.createTask(
        name: 'Long history',
        beschreibung: '',
        erfassungsmodus: 'three_state',
        projectId: null,
        startDate: start,
        goalType: TaskGoalType.rollingSuccessCount,
        goalValue: 7,
        goalWindowDays: 7,
      );
      final task = await database.select(database.aufgaben).getSingle();
      final id = task.id;
      final definition =
          await database.select(database.taskDefinitionVersions).getSingle();
      final days =
          DateTime.utc(
            2026,
            10,
            28,
          ).difference(DateTime.utc(2024, 1, 1)).inDays;
      await (database.update(database.taskEntries)
        ..where((e) => e.taskId.equals(id))).write(
        const TaskEntriesCompanion(
          status: Value(TaskEntryStatus.success),
          checkboxValue: Value(true),
        ),
      );
      await database.batch((batch) {
        batch.insertAll(database.taskEntries, [
          for (var i = 1; i <= days; i++)
            TaskEntriesCompanion.insert(
              id: 'day-$i',
              taskId: id,
              taskDefinitionVersionId: Value(definition.id),
              scheduledDate: DateTime(2024, 1, 1 + i),
              updatedAt: today,
              status: const Value(TaskEntryStatus.success),
              checkboxValue: const Value(true),
            ),
        ]);
      });
      final entriesBefore = await database.select(database.taskEntries).get();
      final summaries = [
        await repository.getTaskGoalHistorySummary(task: task, today: today),
        await repository
            .watchTaskGoalHistorySummary(task: task, today: today)
            .first,
        TaskGoalHistorySummary.fromEntries(
          task: task,
          entries: entriesBefore,
          today: today,
        ),
      ];
      final count = days ~/ 7;
      for (final summary in summaries) {
        expect(summary.blocks.length, count);
        final chronological = summary.blocks.reversed.toList();
        for (var i = 0; i < count; i++) {
          expect(chronological[i].periodStart, DateTime(2024, 1, 1 + i * 7));
          expect(chronological[i].periodEnd, DateTime(2024, 1, 7 + i * 7));
          expect(chronological[i].successCount, 7);
        }
      }
      expect(await database.select(database.taskEntries).get(), entriesBefore);
    },
  );
}
