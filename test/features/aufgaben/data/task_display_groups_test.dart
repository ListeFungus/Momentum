import 'dart:convert';
import 'dart:io';
import 'package:sqlite3/sqlite3.dart';
import '../../../core/backup/backup_service_test.dart' as backups;
import 'package:momentum/features/aufgaben/data/task_type_change_service.dart';
import 'package:momentum/features/calendar/data/calendar_projection.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/core/backup/backup_service.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/task_display_group_store.dart';
import 'package:momentum/features/aufgaben/data/task_display_group_service.dart';
import 'package:momentum/features/aufgaben/data/task_value_draft.dart';

void main() {
  late AppDatabase db;
  late AufgabenRepository repo;
  late TaskDisplayGroupStore store;
  final today = DateTime(2026, 10, 27);
  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = AufgabenRepository(db, now: () => today);
    store = TaskDisplayGroupStore(db);
  });
  tearDown(() => db.close());
  Future<Aufgabe> task(String name) async {
    await repo.createTask(
      name: name,
      beschreibung: '',
      erfassungsmodus: 'value',
      projectId: null,
      taskType: 'habit',
      recurrence: 'daily',
      startDate: today,
      valueType: 'number',
      valueCommitment: 'pure_tracking',
      valueUnitKey: 'custom',
    );
    return (db.select(db.aufgaben)
      ..where((t) => t.name.equals(name))).getSingle();
  }

  test(
    'G1 Zuordnung, explizites Verschieben, Sortierung, Löschen erhält Daten',
    () async {
      final t = await task('Wert');
      final a = await store.create('Morgen');
      final b = await store.create('Abend');
      await store.assign(t.id, a);
      await expectLater(store.assign(t.id, b), throwsStateError);
      await store.assign(t.id, b, expectedPreviousGroup: a);
      await store.reorder([b, a]);
      await store.update(b, collapsed: true);
      expect((await store.watch().first).first.isCollapsed, true);
      final before = jsonEncode(
        (await db.select(db.aufgaben).get()).map((t) => t.toJson()).toList(),
      );
      await store.delete(b);
      expect(await db.select(db.taskDisplayGroupMembers).get(), isEmpty);
      expect(
        jsonEncode(
          (await db.select(db.aufgaben).get()).map((t) => t.toJson()).toList(),
        ),
        before,
      );
    },
  );
  test(
    'G1 Bündelschutz beidseitig einschließlich historischer Version, Backup',
    () async {
      final a = await task('A');
      final b = await task('B');
      final g = await store.create('Gruppe');
      await store.assign(a.id, g);
      await expectLater(
        repo.createValueBundle(
          name: 'Summe',
          bundleType: 'difference',
          firstTaskId: a.id,
          secondTaskId: b.id,
        ),
        throwsStateError,
      );
      final backup = BackupService(db);
      await backup.restore(await backup.prepare(await backup.export()));
      expect(
        (await db.select(db.taskDisplayGroupMembers).getSingle()).taskId,
        a.id,
      );
      await store.remove(a.id, g);
      final bundle = await repo.createValueBundle(
        name: 'Summe',
        bundleType: 'difference',
        firstTaskId: a.id,
        secondTaskId: b.id,
        validFrom: today.subtract(const Duration(days: 1)),
      );
      await expectLater(store.assign(a.id, g), throwsStateError);
      await repo.dissolveValueBundle(bundleId: bundle, validTo: today);
      await expectLater(store.assign(a.id, g), throwsStateError);
    },
  );
  test(
    'G2 fehlender Wert blockiert atomar, Teilaktion erhält Nein, Null vervollständigt',
    () async {
      final t = await task('Wert');
      final g = await store.create('Morgen');
      await store.assign(t.id, g);
      await repo.createTask(
        name: 'Haken',
        beschreibung: '',
        erfassungsmodus: 'checkbox',
        projectId: null,
        recurrence: 'daily',
        startDate: today,
      );
      final c =
          await (db.select(db.aufgaben)
            ..where((t) => t.name.equals('Haken'))).getSingle();
      await store.assign(c.id, g);
      final service = repo.displayGroups;
      final p = await service.preview(g, today);
      expect(p.errors, isNotEmpty);
      await expectLater(
        service.complete(p),
        throwsA(isA<GroupActionBlocked>()),
      );
      expect(
        (await db.select(db.taskEntries).get()).where(
          (e) => e.status == 'success',
        ),
        isEmpty,
      );
      await service.complete(p, checkableOnly: true);
      expect((await service.readDay(today)).single.complete, false);
      final p2 = await service.preview(g, today);
      final key = groupOccurrenceKey(
        p2.day.items.firstWhere((i) => i.task.id == t.id),
        today,
      );
      final drafts = {key: const TaskValueDraft('0')};
      final p3 = await service.preview(g, today, drafts: drafts);
      await service.complete(p3, drafts: drafts);
      expect((await service.readDay(today)).single.complete, true);
      expect((await db.select(db.taskEntryValues).getSingle()).numberValue, 0);
    },
  );
  test('G2 veraltete Vorschau und Schreibfehler ändern nichts', () async {
    final t = await task('Wert');
    final g = await store.create('Gruppe');
    await store.assign(t.id, g);
    final service = repo.displayGroups;
    final p = await service.preview(g, today);
    await store.update(g, name: 'Anders');
    await expectLater(
      service.complete(p, checkableOnly: true),
      throwsStateError,
    );
    final key = groupOccurrenceKey(
      (await service.readDay(today)).single.items.single,
      today,
    );
    final drafts = {key: const TaskValueDraft('5')};
    final next = await service.preview(g, today, drafts: drafts);
    await db.customStatement(
      "CREATE TRIGGER reject_value BEFORE INSERT ON task_entry_values BEGIN SELECT RAISE(ABORT, 'test'); END",
    );
    await expectLater(
      service.complete(next, drafts: drafts),
      throwsA(anything),
    );
    expect(await db.select(db.taskEntryValues).get(), isEmpty);
    expect(await db.select(db.taskEntries).get(), isEmpty);
  });
  test(
    'G5 Nein und inverse Erfolgsantwort, Rücknahme und gespeicherter Nullwert',
    () async {
      final g = await store.create('Routine');
      for (final name in ['Nein', 'Invers']) {
        await repo.createTask(
          name: name,
          beschreibung: '',
          erfassungsmodus: 'three_state',
          projectId: null,
          taskType: 'habit',
          recurrence: 'daily',
          startDate: today,
          successValue: name != 'Invers',
        );
        final t =
            await (db.select(db.aufgaben)
              ..where((t) => t.name.equals(name))).getSingle();
        await store.assign(t.id, g);
        if (name == 'Nein') {
          await repo.setBooleanHabitValue(
            task: t,
            scheduledDate: today,
            value: false,
          );
        }
      }
      final p = await repo.displayGroups.preview(g, today);
      await repo.displayGroups.complete(p);
      expect((await repo.displayGroups.readDay(today)).single.complete, true);
      final entries = await db.select(db.taskEntries).get();
      expect(entries.every((e) => e.checkboxValue == false), true);
      expect(entries.map((e) => e.status).toSet(), {'success', 'failure'});
      final t =
          await (db.select(db.aufgaben)
            ..where((t) => t.name.equals('Nein'))).getSingle();
      await repo.setBooleanHabitValue(
        task: t,
        scheduledDate: today,
        value: null,
      );
      expect((await repo.displayGroups.readDay(today)).single.complete, false);
    },
  );
  test(
    'G5 Rückstände bleiben einzeln, leere/nicht fällige Gruppen, kein Zukunftsschreiben',
    () async {
      final g = await store.create('Routine');
      final t = await task('Wert');
      await store.assign(t.id, g);
      await db
          .into(db.taskEntries)
          .insert(
            TaskEntriesCompanion.insert(
              id: 'past',
              taskId: t.id,
              scheduledDate: today.subtract(const Duration(days: 1)),
              updatedAt: today,
              status: const Value('pending'),
            ),
          );
      await (db.update(db.aufgaben)..where(
        (x) => x.id.equals(t.id),
      )).write(const AufgabenCompanion(missedPolicy: Value('carryover')));
      // Historical definition also carries the policy for the stored occurrence.
      await (db.update(db.taskDefinitionVersions)
        ..where((v) => v.taskId.equals(t.id))).write(
        const TaskDefinitionVersionsCompanion(missedPolicy: Value('carryover')),
      );
      final p = await repo.displayGroups.preview(g, today);
      expect(p.errors.values.join(), contains('Ältere'));
      await expectLater(
        repo.displayGroups.complete(p),
        throwsA(isA<GroupActionBlocked>()),
      );
      expect((await db.select(db.taskEntries).getSingle()).status, 'pending');
      final empty = await store.create('Leer');
      expect(
        (await repo.displayGroups.readDay(
          today,
        )).firstWhere((d) => d.group.id == empty).complete,
        false,
      );
      final future = await repo.displayGroups.preview(
        g,
        today.add(const Duration(days: 1)),
      );
      await expectLater(
        repo.displayGroups.complete(future, checkableOnly: true),
        throwsA(isA<GroupActionBlocked>()),
      );
    },
  );
  test(
    'G5 Gruppierung verändert weder #013 noch schreibfreien Kalender; Purge kaskadiert',
    () async {
      final t = await task('Wert');
      final g = await store.create('Routine');
      await store.assign(t.id, g);
      final p = await repo.taskTypeChanges.preview(t.id);
      await repo.taskTypeChanges.change(
        taskId: t.id,
        targetType: 'task',
        scope: TaskTypeChangeScope.newEntries,
        expectedRevision: p.token,
      );
      expect(
        (await db.select(db.taskDisplayGroupMembers).getSingle()).groupId,
        g,
      );
      final calendar = await repo.calendarRepository.loadRange(
        today,
        today,
        const CalendarFilter(trackers: true),
      );
      expect(calendar.onDay(today), hasLength(1));
      await (db.delete(db.aufgaben)..where((x) => x.id.equals(t.id))).go();
      expect(await db.select(db.taskDisplayGroupMembers).get(), isEmpty);
      expect(await db.select(db.taskDisplayGroups).get(), hasLength(1));
    },
  );
  test(
    'G5 Backup 25 und ungültige Gruppen/FK/Bündel vor Restore abweisen',
    () async {
      final t = await task('Wert');
      final g = await store.create('Routine');
      await store.assign(t.id, g);
      final service = BackupService(db);
      final bytes = await service.export();
      final before = await backups.snapshot(db);
      for (final change in <void Function(Map<String, dynamic>)>[
        (p) => p['tables']['task_display_groups'][0]['name'] = ' ',
        (p) =>
            p['tables']['task_display_group_members'][0]['group_id'] =
                'missing',
        (p) => p['tables']['task_display_group_members'].add(
          Map<String, dynamic>.from(
            p['tables']['task_display_group_members'][0],
          ),
        ),
      ]) {
        await expectLater(
          service.prepare(backups.changePayload(bytes, change)),
          throwsA(isA<BackupException>()),
        );
        expect(await backups.snapshot(db), before);
      }
      final legacy = backups.changePayload(bytes, (p) {
        p['schemaVersion'] = 25;
        p['tables'].remove('task_display_groups');
        p['tables'].remove('task_display_group_members');
      });
      await service.restore(await service.prepare(legacy));
      expect(await db.select(db.taskDisplayGroups).get(), isEmpty);
      expect(await db.select(db.aufgaben).get(), hasLength(1));
    },
  );
  test(
    'G5 echte Migration 25 auf 26 erhält Werte und Kartenoptionen',
    () async {
      final dir = await Directory.systemTemp.createTemp('groups-migration');
      final file = File('${dir.path}/db.sqlite');
      var disk = AppDatabase.forTesting(NativeDatabase(file));
      await disk.customStatement(
        "INSERT INTO card_display_settings (id) VALUES (1)",
      );
      final diskRepo = AufgabenRepository(disk, now: () => today);
      await diskRepo.createTask(
        name: 'Migration',
        beschreibung: '',
        erfassungsmodus: 'value',
        projectId: null,
        valueType: 'number',
        valueCommitment: 'pure_tracking',
        startDate: today,
        plannedStartMinute: 600,
        plannedDurationMinutes: 30,
      );
      final oldTask = await disk.select(disk.aufgaben).getSingle();
      await diskRepo.setTaskEntryValue(
        task: oldTask,
        scheduledDate: today,
        valueType: 'number',
        numberValue: 7,
      );
      await disk.close();
      final raw = sqlite3.open(file.path);
      raw.execute('DROP TABLE task_display_group_members');
      raw.execute('DROP TABLE task_display_groups');
      raw.execute('PRAGMA user_version=25');
      raw.dispose();
      disk = AppDatabase.forTesting(NativeDatabase(file));
      try {
        expect(await disk.select(disk.cardDisplaySettings).get(), hasLength(1));
        expect(await disk.select(disk.taskDisplayGroups).get(), isEmpty);
        expect(
          (await disk.select(disk.taskEntryValues).getSingle()).numberValue,
          7,
        );
        expect(
          (await disk.select(disk.taskEntries).getSingle()).plannedStartMinute,
          600,
        );
        expect(
          await disk.customSelect('PRAGMA foreign_key_check').get(),
          isEmpty,
        );
      } finally {
        await disk.close();
        await dir.delete(recursive: true);
      }
    },
  );
  test(
    'G5 Bündel-Konflikt auch bei Restore, Metadatenpflege und Import gesperrt',
    () async {
      final a = await task('A');
      final b = await task('B');
      final g = await store.create('Routine');
      final id = await repo.createValueBundle(
        name: 'Bündel',
        bundleType: 'difference',
        firstTaskId: a.id,
        secondTaskId: b.id,
      );
      // Deliberately corrupt a test-only fixture to exercise all defensive paths.
      await db
          .into(db.taskDisplayGroupMembers)
          .insert(
            TaskDisplayGroupMembersCompanion.insert(
              taskId: a.id,
              groupId: g,
              sortOrder: 0,
            ),
          );
      await expectLater(
        repo.updateValueBundleMetadata(
          bundleId: id,
          name: 'Neu',
          description: '',
        ),
        throwsStateError,
      );
      await (db.update(db.taskValueBundles)
        ..where((v) => v.id.equals(id))).write(
        TaskValueBundlesCompanion(
          trashedAt: Value(today),
          purgeAt: Value(today.add(const Duration(days: 30))),
        ),
      );
      await expectLater(repo.restoreBundle(id), throwsStateError);
      final backup = BackupService(db);
      final before = await backups.snapshot(db);
      await expectLater(
        backup.prepare(await backup.export()),
        throwsA(isA<BackupException>()),
      );
      expect(await backups.snapshot(db), before);
    },
  );
  test(
    'G5 automatischer Fehler ohne Pflichtwert und Pause erzeugen keinen Gruppenabschluss',
    () async {
      final t = await task('Pflicht');
      final g = await store.create('Routine');
      await store.assign(t.id, g);
      await db
          .into(db.taskEntries)
          .insert(
            TaskEntriesCompanion.insert(
              id: 'missed',
              taskId: t.id,
              scheduledDate: today,
              updatedAt: today,
              status: const Value('failure'),
            ),
          );
      expect((await repo.displayGroups.readDay(today)).single.complete, false);
      await (db.update(db.aufgaben)..where(
        (x) => x.id.equals(t.id),
      )).write(const AufgabenCompanion(isActive: Value(false)));
      final day = (await repo.displayGroups.readDay(today)).single;
      expect(day.items, isEmpty);
      expect(day.complete, false);
      expect(day.members, hasLength(1));
    },
  );
}
