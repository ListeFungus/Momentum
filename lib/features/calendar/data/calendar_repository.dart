import 'dart:async';
import 'package:drift/drift.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/task_definition_resolver.dart';
import 'calendar_clock.dart';
import 'calendar_projection.dart';

class CalendarRepository {
  CalendarRepository(this.database, {CalendarClock? clock})
    : clock = clock ?? CalendarClock();
  final AppDatabase database;
  final CalendarClock clock;

  Future<CalendarSetting?> settings() =>
      database.select(database.calendarSettings).getSingleOrNull();
  Future<void> saveSettings(CalendarFilter filter, String view) => database
      .into(database.calendarSettings)
      .insertOnConflictUpdate(
        CalendarSettingsCompanion.insert(
          showTasks: Value(filter.tasks),
          showHabits: Value(filter.habits),
          showTrackers: Value(filter.trackers),
          view: Value(view),
        ),
      );

  Future<CalendarRange> loadRange(
    DateTime from,
    DateTime to,
    CalendarFilter filter,
  ) async {
    from = calendarDay(from);
    to = calendarDay(to);
    if (to.isBefore(from) || to.difference(from).inDays > 42) {
      throw ArgumentError('Kalenderbereich maximal 43 Tage.');
    }
    return database.transaction(() async {
      final tasks =
          await (database.select(database.aufgaben)
            ..where((t) => t.trashedAt.isNull())).get();
      final dependentIds =
          tasks
              .where(
                (t) =>
                    t.recurrence == 'none' ||
                    t.recurrence.contains('after_completion'),
              )
              .map((t) => t.id)
              .toList();
      final entries =
          await (database.select(database.taskEntries)..where(
            (e) =>
                (e.scheduledDate.isBiggerOrEqualValue(from) &
                    e.scheduledDate.isSmallerThanValue(
                      calendarAddDays(to, 1),
                    )) |
                e.status.isIn(['pending', 'no_entry']) |
                e.taskId.isIn(dependentIds),
          )).get();
      final projection = CalendarProjection(
        tasks: tasks,
        entries: entries,
        versions: await database.select(database.taskDefinitionVersions).get(),
        pending:
            await (database.select(database.taskPendingDefinitionChanges)
              ..where((p) => p.state.equals('pending'))).get(),
        interruptions:
            await database.select(database.taskPlanningInterruptions).get(),
        assignments:
            await database.select(database.taskProjectAssignmentChanges).get(),
        bundleVersions:
            await database.select(database.taskValueBundleVersions).get(),
        projects: await database.select(database.projects).get(),
        applyVersion: TaskDefinitionResolver(database).taskFromVersion,
        clock: clock,
      );
      return projection.project(from, to, filter);
    });
  }

  Stream<CalendarRange> watchRange(
    DateTime from,
    DateTime to,
    CalendarFilter filter,
  ) {
    late StreamController<CalendarRange> controller;
    StreamSubscription? updates;
    Timer? midnight;
    var generation = 0;
    var closed = false;
    Future<void> refresh() async {
      final request = ++generation;
      try {
        final result = await loadRange(from, to, filter);
        if (!closed && request == generation) controller.add(result);
      } catch (error, stack) {
        if (!closed && request == generation) controller.addError(error, stack);
      }
    }

    void scheduleMidnight() {
      final now = clock.now();
      midnight = Timer(calendarAddDays(now, 1).difference(now), () {
        refresh();
        scheduleMidnight();
      });
    }

    controller = StreamController<CalendarRange>(
      onListen: () {
        updates = database.tableUpdates().listen((_) => refresh());
        scheduleMidnight();
        refresh();
      },
      onCancel: () async {
        closed = true;
        midnight?.cancel();
        await updates?.cancel();
      },
    );
    return controller.stream;
  }
}
