import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/projekte/data/project_repository.dart';
import 'package:momentum/features/projekte/data/project_lifecycle_service.dart';

void main() {
  test('reorder schreibt nur geänderte aktive Projekte', () async {
    var now = DateTime.utc(2026, 10, 8, 8);
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = ProjectRepository(database, now: () => now);
    addTearDown(database.close);
    for (final name in ['A', 'B']) {
      await repository.createProject(
        name: name,
        description: '',
        colorHex: '#5B67D6',
        taskIds: const {},
      );
    }
    final original = await database.select(database.projects).get();
    final first = original.singleWhere((project) => project.name == 'A');
    final second = original.singleWhere((project) => project.name == 'B');

    now = DateTime.utc(2026, 10, 8, 9);
    await repository.reorderProjects([second.id, first.id]);
    var reordered = await database.select(database.projects).get();
    expect(
      reordered.singleWhere((project) => project.id == second.id).sortOrder,
      0,
    );
    expect(reordered.every((project) => project.revision == 1), isTrue);
    expect(
      reordered.every((project) => project.updatedAt.toUtc() == now),
      isTrue,
    );

    now = DateTime.utc(2026, 10, 8, 10);
    await repository.reorderProjects([second.id, first.id]);
    reordered = await database.select(database.projects).get();
    expect(reordered.every((project) => project.revision == 1), isTrue);
    expect(
      reordered.every(
        (project) => project.updatedAt.toUtc() == DateTime.utc(2026, 10, 8, 9),
      ),
      isTrue,
    );

    await expectLater(
      repository.reorderProjects([first.id, first.id]),
      throwsArgumentError,
    );
    await expectLater(
      repository.reorderProjects([first.id, 'unbekannt']),
      throwsArgumentError,
    );
    final afterInvalid = await database.select(database.projects).get();
    expect(afterInvalid.map((project) => project.revision), everyElement(1));
  });

  test('creates project and assigns selected tasks', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final taskRepository = AufgabenRepository(database);
    final projectRepository = ProjectRepository(database);
    addTearDown(database.close);

    await taskRepository.createTask(
      name: 'Task one',
      beschreibung: '',
      erfassungsmodus: 'checkbox',
      projectId: null,
    );
    await taskRepository.createTask(
      name: 'Task two',
      beschreibung: '',
      erfassungsmodus: 'checkbox',
      projectId: null,
    );

    final tasks = await database.select(database.aufgaben).get();

    await projectRepository.createProject(
      name: 'Health',
      description: 'Healthy habits',
      colorHex: '#3C9B78',
      taskIds: {tasks.first.id},
    );

    final project = await database.select(database.projects).getSingle();
    final updatedTasks = await database.select(database.aufgaben).get();

    expect(project.name, 'Health');
    expect(project.colorHex, '#3C9B78');
    expect(
      updatedTasks.singleWhere((task) => task.id == tasks.first.id).projectId,
      project.id,
    );
    expect(
      updatedTasks.singleWhere((task) => task.id == tasks.last.id).projectId,
      isNull,
    );
    final firstTaskVersions =
        await (database.select(database.taskDefinitionVersions)
          ..where((version) => version.taskId.equals(tasks.first.id))).get();
    final secondTaskVersions =
        await (database.select(database.taskDefinitionVersions)
          ..where((version) => version.taskId.equals(tasks.last.id))).get();
    expect(firstTaskVersions, hasLength(1));
    expect(firstTaskVersions.single.projectId, isNull);
    expect(secondTaskVersions, hasLength(1));
    final assignmentChanges =
        await database.select(database.taskProjectAssignmentChanges).get();
    expect(assignmentChanges, hasLength(1));
    expect(assignmentChanges.single.taskId, tasks.first.id);
    expect(assignmentChanges.single.targetProjectId, project.id);
  });

  test(
    'metadata update leaves assignments untouched and deletion is reversible',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final taskRepository = AufgabenRepository(database);
      final projectRepository = ProjectRepository(database);
      addTearDown(database.close);

      await taskRepository.createTask(
        name: 'Task one',
        beschreibung: '',
        erfassungsmodus: 'checkbox',
        projectId: null,
      );
      await taskRepository.createTask(
        name: 'Task two',
        beschreibung: '',
        erfassungsmodus: 'checkbox',
        projectId: null,
      );

      final tasks = await database.select(database.aufgaben).get();

      await projectRepository.createProject(
        name: 'Old name',
        description: '',
        colorHex: '#5B67D6',
        taskIds: {tasks.first.id},
      );

      final project = await database.select(database.projects).getSingle();

      await projectRepository.updateProject(
        projectId: project.id,
        name: 'New name',
        description: 'Updated',
        colorHex: '#D65B8C',
        taskIds: {tasks.last.id},
      );

      final updatedProject =
          await database.select(database.projects).getSingle();
      final reassignedTasks = await database.select(database.aufgaben).get();

      expect(updatedProject.name, 'New name');
      expect(updatedProject.colorHex, '#D65B8C');
      expect(
        reassignedTasks
            .singleWhere((task) => task.id == tasks.first.id)
            .projectId,
        project.id,
      );
      expect(
        reassignedTasks
            .singleWhere((task) => task.id == tasks.last.id)
            .projectId,
        isNull,
      );
      final versionsAfterReassignment =
          await database.select(database.taskDefinitionVersions).get();
      expect(
        versionsAfterReassignment.where(
          (version) => version.taskId == tasks.first.id,
        ),
        hasLength(1),
      );
      expect(
        versionsAfterReassignment.where(
          (version) => version.taskId == tasks.last.id,
        ),
        hasLength(1),
      );
      final changesAfterReassignment =
          await database.select(database.taskProjectAssignmentChanges).get();
      expect(
        changesAfterReassignment.where(
          (change) => change.taskId == tasks.first.id,
        ),
        hasLength(1),
      );
      expect(
        changesAfterReassignment.where(
          (change) => change.taskId == tasks.last.id,
        ),
        isEmpty,
      );

      await projectRepository.deleteProject(project.id);

      final remainingTasks = await database.select(database.aufgaben).get();
      final remainingProjects = await database.select(database.projects).get();

      expect(remainingProjects, hasLength(1));
      expect(remainingProjects.single.trashedAt, isNotNull);
      expect(remainingTasks, hasLength(2));
      expect(remainingTasks.every((task) => task.projectId == null), isTrue);
      final secondTaskVersions =
          await (database.select(database.taskDefinitionVersions)
            ..where((version) => version.taskId.equals(tasks.last.id))).get();
      expect(secondTaskVersions, hasLength(1));
    },
  );

  test('archives and restores a project without changing its task', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final taskRepository = AufgabenRepository(database);
    final projectRepository = ProjectRepository(database);
    addTearDown(database.close);

    await taskRepository.createTask(
      name: 'Habit',
      beschreibung: '',
      erfassungsmodus: 'checkbox',
      projectId: null,
    );
    final task = await database.select(database.aufgaben).getSingle();
    await projectRepository.createProject(
      name: 'Archiv',
      description: '',
      colorHex: '#5B67D6',
      taskIds: {task.id},
    );
    final project = await database.select(database.projects).getSingle();

    await projectRepository.archiveProject(project.id);
    expect(await projectRepository.watchProjects().first, isEmpty);
    expect(await projectRepository.watchArchivedProjects().first, hasLength(1));
    expect(
      (await database.select(database.aufgaben).getSingle()).projectId,
      project.id,
    );

    await projectRepository.unarchiveProject(project.id);
    expect(await projectRepository.watchProjects().first, hasLength(1));
  });

  test('shared trash restores only unchanged batch members', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final taskRepository = AufgabenRepository(database);
    final projectRepository = ProjectRepository(database);
    addTearDown(database.close);

    await taskRepository.createTask(
      name: 'Task',
      beschreibung: '',
      erfassungsmodus: 'checkbox',
      projectId: null,
    );
    final task = await database.select(database.aufgaben).getSingle();
    await projectRepository.createProject(
      name: 'Batch',
      description: '',
      colorHex: '#5B67D6',
      taskIds: {task.id},
    );
    final project = await database.select(database.projects).getSingle();

    await projectRepository.trashProject(
      project.id,
      ProjectDeletionChoice.projectAndContents,
    );
    final restore = await projectRepository.previewProjectRestore(project.id);
    expect(restore.restorableTaskIds, [task.id]);
    await projectRepository.restoreProject(restore, includeContents: true);

    final restoredProject =
        await database.select(database.projects).getSingle();
    final restoredTask = await database.select(database.aufgaben).getSingle();
    expect(restoredProject.trashedAt, isNull);
    expect(restoredTask.trashedAt, isNull);
    expect(restoredTask.projectId, project.id);
  });

  test(
    'endgültige Löschung bewahrt nur den anonymen Identitätsverweis',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final projectRepository = ProjectRepository(database);
      addTearDown(database.close);

      await projectRepository.createProject(
        name: 'Privater Name',
        description: 'Privater Text',
        colorHex: '#D65B8C',
        taskIds: const {},
      );
      final project = await database.select(database.projects).getSingle();
      await projectRepository.trashProject(
        project.id,
        ProjectDeletionChoice.projectOnly,
      );
      await projectRepository.purgeProject(project.id);

      final marker = await database.select(database.projects).getSingle();
      expect(marker.id, project.id);
      expect(marker.name, isEmpty);
      expect(marker.description, isEmpty);
      expect(marker.colorHex, isEmpty);
      expect(marker.deletedAt, isNotNull);
      expect(await projectRepository.watchProjects().first, isEmpty);
      expect(await projectRepository.watchTrashedProjects().first, isEmpty);
    },
  );

  test('veraltete Löschvorschau führt keine Teilaktion aus', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final tasks = AufgabenRepository(database);
    final projects = ProjectRepository(database);
    final lifecycle = ProjectLifecycleService(database);
    addTearDown(database.close);

    await projects.createProject(
      name: 'Stabil',
      description: '',
      colorHex: '#5B67D6',
      taskIds: const {},
    );
    final project = await database.select(database.projects).getSingle();
    final preview = await lifecycle.previewDeletion(project.id);
    await tasks.createTask(
      name: 'Neu',
      beschreibung: '',
      erfassungsmodus: 'checkbox',
      projectId: project.id,
    );

    await expectLater(
      lifecycle.trash(preview, ProjectDeletionChoice.projectAndContents),
      throwsA(isA<ProjectLifecycleException>()),
    );
    expect(
      (await database.select(database.projects).getSingle()).trashedAt,
      isNull,
    );
    expect(
      (await database.select(database.aufgaben).getSingle()).trashedAt,
      isNull,
    );
  });

  test('Projektanalyse zählt Einträge im Zeitraum nach Status', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final tasks = AufgabenRepository(database);
    final projects = ProjectRepository(database);
    addTearDown(database.close);

    await projects.createProject(
      name: 'Analyse',
      description: '',
      colorHex: '#5B67D6',
      taskIds: const {},
    );
    final project = await database.select(database.projects).getSingle();
    final today = DateTime.now();
    await tasks.createTask(
      name: 'Beitrag',
      beschreibung: '',
      erfassungsmodus: 'checkbox',
      projectId: project.id,
      startDate: today,
    );
    final task = await database.select(database.aufgaben).getSingle();
    await tasks.setTaskCompleted(
      taskId: task.id,
      scheduledDate: today,
      isCompleted: true,
    );

    final summary =
        await projects.watchProjectAnalytics(project.id, days: 7).first;
    expect(summary.taskStatusCounts['success'], 1);
    expect(summary.taskNames, contains('Beitrag'));
    expect(summary.bundleCompleteCount, 0);
  });

  test(
    'einzeln restaurierte Aufgabe bleibt nach Projekt-Restore projektlos',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final tasks = AufgabenRepository(database);
      final projects = ProjectRepository(database);
      addTearDown(database.close);

      await tasks.createTask(
        name: 'Separat',
        beschreibung: '',
        erfassungsmodus: 'checkbox',
        projectId: null,
      );
      final task = await database.select(database.aufgaben).getSingle();
      await projects.createProject(
        name: 'Später zurück',
        description: '',
        colorHex: '#5B67D6',
        taskIds: {task.id},
      );
      final project = await database.select(database.projects).getSingle();
      await projects.trashProject(
        project.id,
        ProjectDeletionChoice.projectAndContents,
      );

      await tasks.restoreTask(task.id);
      expect(
        (await database.select(database.aufgaben).getSingle()).projectId,
        isNull,
      );
      final preview = await projects.previewProjectRestore(project.id);
      expect(preview.restorableTaskIds, isEmpty);
      await projects.restoreProject(preview, includeContents: false);
      expect(
        (await database.select(database.aufgaben).getSingle()).projectId,
        isNull,
      );
    },
  );
}
