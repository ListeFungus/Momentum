import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/task_project_assignment_service.dart';
import 'package:momentum/features/projekte/data/project_repository.dart';

void main() {
  test('Aufgabe und Bündel besitzen unabhängige Projektzuordnungen', () async {
    final today = DateTime(2026, 10, 6);
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final tasks = AufgabenRepository(database, now: () => today);
    final projects = ProjectRepository(database);
    final assignments = TaskProjectAssignmentService(
      database,
      now: () => today,
    );
    addTearDown(database.close);

    await tasks.createTask(
      name: 'Quelle',
      beschreibung: '',
      erfassungsmodus: 'checkbox',
      projectId: null,
    );
    final task = await database.select(database.aufgaben).getSingle();
    await projects.createProject(
      name: 'Projekt',
      description: '',
      colorHex: '#5B67D6',
      taskIds: const {},
    );
    final project = await database.select(database.projects).getSingle();
    await database
        .into(database.taskValueBundles)
        .insert(
          TaskValueBundlesCompanion.insert(id: 'bundle', updatedAt: today),
        );

    await assignments.assignFromDate(
      taskId: task.id,
      targetProjectId: project.id,
      effectiveDate: today,
    );
    await assignments.assignBundleFromDate(
      bundleId: 'bundle',
      targetProjectId: project.id,
      effectiveDate: today,
    );
    await assignments.assignBundleFromDate(
      bundleId: 'bundle',
      targetProjectId: null,
      effectiveDate: today,
    );

    expect(
      (await database.select(database.aufgaben).getSingle()).projectId,
      project.id,
    );
    expect(
      (await database.select(database.taskValueBundles).getSingle()).projectId,
      isNull,
    );
    final events =
        await database.select(database.taskProjectAssignmentChanges).get();
    expect(events.where((event) => event.taskId != null), hasLength(1));
    expect(events.where((event) => event.bundleId != null), hasLength(2));
  });

  test(
    'zukünftige Vorschau schreibt heutige Zuordnung nicht vorzeitig',
    () async {
      final today = DateTime(2026, 10, 6);
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final tasks = AufgabenRepository(database, now: () => today);
      final projects = ProjectRepository(database);
      final assignments = TaskProjectAssignmentService(
        database,
        now: () => today,
      );
      addTearDown(database.close);

      await tasks.createTask(
        name: 'Plan',
        beschreibung: '',
        erfassungsmodus: 'checkbox',
        projectId: null,
      );
      await projects.createProject(
        name: 'Später',
        description: '',
        colorHex: '#5B67D6',
        taskIds: const {},
      );
      final task = await database.select(database.aufgaben).getSingle();
      final project = await database.select(database.projects).getSingle();
      final future = today.add(const Duration(days: 3));

      await assignments.assignFromDate(
        taskId: task.id,
        targetProjectId: project.id,
        effectiveDate: future,
      );
      expect(
        (await database.select(database.aufgaben).getSingle()).projectId,
        isNull,
      );
      expect(
        await assignments.projectIdForDate(
          taskId: task.id,
          date: future,
          snapshotProjectId: null,
        ),
        project.id,
      );
      await assignments.applyDueChanges(future);
      expect(
        (await database.select(database.aufgaben).getSingle()).projectId,
        isNull,
      );
    },
  );
}
