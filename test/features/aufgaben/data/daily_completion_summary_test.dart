import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/daily_completion_summary.dart';

void main() {
  test(
    'counts instances on performed day, excludes tracking, failure, trash and undone completions',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final end = DateTime(2026, 10, 16);
      final repository = AufgabenRepository(db, now: () => end);
      for (final kind in ['task', 'habit']) {
        await repository.createTask(
          name: kind,
          beschreibung: '',
          erfassungsmodus: 'checkbox',
          projectId: null,
          taskType: kind,
          startDate: DateTime(2026, 10, 1),
        );
      }
      final tasks = await db.select(db.aufgaben).get();
      final task = tasks.first.id;
      final habit = tasks.last.id;
      await repository.setTaskCompleted(
        taskId: task,
        scheduledDate: DateTime(2026, 10, 1),
        performedOn: DateTime(2026, 10, 10),
        isCompleted: true,
      );
      await repository.setTaskCompleted(
        taskId: task,
        scheduledDate: DateTime(2026, 10, 14),
        performedOn: end,
        isCompleted: true,
      );
      await repository.setTaskCompleted(
        taskId: habit,
        scheduledDate: DateTime(2026, 10, 1),
        performedOn: end,
        isCompleted: true,
      );
      await db
          .into(db.taskEntries)
          .insert(
            TaskEntriesCompanion.insert(
              id: 'unknown',
              taskId: task,
              scheduledDate: DateTime(2026, 10, 2),
              updatedAt: end,
              status: const Value('success'),
            ),
          );
      await db
          .into(db.taskEntries)
          .insert(
            TaskEntriesCompanion.insert(
              id: 'failed',
              taskId: task,
              scheduledDate: DateTime(2026, 10, 3),
              updatedAt: end,
              performedOn: Value(end),
              status: const Value('failure'),
            ),
          );
      await db
          .into(db.taskEntries)
          .insert(
            TaskEntriesCompanion.insert(
              id: 'outside',
              taskId: task,
              scheduledDate: DateTime(2026, 10, 4),
              updatedAt: end,
              performedOn: Value(DateTime(2026, 10, 9)),
              status: const Value('success'),
            ),
          );
      var summary = await watchDailyCompletions(db, endingOn: end).first;
      expect(summary.days.map((d) => d.count), [1, 0, 0, 0, 0, 0, 2]);
      expect(summary.unknownDateCount, 1);
      await repository.setTaskCompleted(
        taskId: task,
        scheduledDate: DateTime(2026, 10, 14),
        isCompleted: false,
      );
      summary = await watchDailyCompletions(db, endingOn: end).first;
      expect(summary.days.last.count, 1);
      await db.customStatement(
        'UPDATE aufgaben SET trashed_at = 1, purge_at = 2100000000 WHERE id = ?',
        [habit],
      );
      db.markTablesUpdated(db.allTables.toSet());
      expect((await watchDailyCompletions(db, endingOn: end).first).total, 1);
      // Preserve historical commitment: changing the current task must not
      // reinterpret an already completed entry with a definition version.
      await db.customStatement(
        "UPDATE aufgaben SET value_commitment = 'pure_tracking' WHERE id = ?",
        [task],
      );
      db.markTablesUpdated(db.allTables.toSet());
      expect((await watchDailyCompletions(db, endingOn: end).first).total, 1);
      await db.customStatement(
        "UPDATE task_definition_versions SET value_commitment = 'pure_tracking' WHERE task_id = ?",
        [task],
      );
      db.markTablesUpdated(db.allTables.toSet());
      expect((await watchDailyCompletions(db, endingOn: end).first).total, 0);
    },
  );

  test(
    'seven local calendar days include month and daylight saving boundaries',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final summary =
          await watchDailyCompletions(
            db,
            endingOn: DateTime(2026, 11, 1),
          ).first;
      expect(summary.days.map((d) => '${d.date.month}/${d.date.day}'), [
        '10/26',
        '10/27',
        '10/28',
        '10/29',
        '10/30',
        '10/31',
        '11/1',
      ]);
      expect(summary.total, 0);
    },
  );
}
