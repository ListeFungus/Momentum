import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/backup/backup_service.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/core/settings/card_display_repository.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';

Future<void> seed(AppDatabase db) async {
  final repository = AufgabenRepository(db, now: () => DateTime(2026, 10, 16));
  await db.customStatement(
    "INSERT INTO projects (id, name) VALUES ('p', 'Gesundheit 🪴')",
  );
  for (final name in ['Gewicht', 'Ziel']) {
    await repository.createTask(
      name: name,
      beschreibung: 'Notiz mit ä und „Zitat“',
      erfassungsmodus: 'checkbox',
      projectId: 'p',
      startDate: DateTime(2026, 10, 16),
    );
  }
  final tasks = await db.select(db.aufgaben).get();
  final task = tasks.first.id;
  final other = tasks.last.id;
  final display = CardDisplayRepository(db);
  await display.configure(mode: CardDisplayMode.remember, singleOpen: true);
  await display.remember(entityKey: 'task:$task', expanded: true);
  await repository.setTaskCompleted(
    taskId: task,
    scheduledDate: DateTime(2026, 10, 16),
    isCompleted: true,
  );
  final entry = (await db.select(db.taskEntries).get()).first.id;
  await db.customStatement(
    "INSERT INTO task_entry_values (id, entry_id, value_type, number_value, normalized_number_value, updated_at) VALUES ('v', ?, 'number', 72.5, 72.5, 1234)",
    [entry],
  );
  await db.customStatement(
    "INSERT INTO task_value_bundles (id, project_id, updated_at) VALUES ('b', 'p', 1234)",
  );
  await db.customStatement(
    "INSERT INTO task_value_bundle_versions (id, bundle_id, version_number, valid_from, bundle_type, first_task_id, second_task_id) VALUES ('bv', 'b', 1, 1234, 'difference', ?, ?)",
    [task, other],
  );
  await db.customStatement(
    "INSERT INTO task_card_metric_preferences (id, task_id, config_json, is_reset, updated_at) VALUES ('pref', ?, '{\"items\":[]}', 1, 1234)",
    [task],
  );
  await db.customStatement(
    "INSERT INTO task_pending_definition_changes (id, task_id, group_key, effective_date, payload_json) VALUES ('change', ?, 'goal', 2100000000, '{}')",
    [task],
  );
  await db.customStatement(
    "INSERT INTO task_project_assignment_changes (id, task_id, target_project_id, scope, effective_date, sequence) VALUES ('assign', ?, 'p', 'from_date', 2100000000, 1)",
    [task],
  );
  await db.customStatement(
    "INSERT INTO task_correction_operations (id, task_id, type, reason) VALUES ('op', ?, 'note', 'Korrektur')",
    [task],
  );
  await db.customStatement(
    "INSERT INTO task_correction_items (id, operation_id, entry_id, before_json, after_json, expected_revision) VALUES ('ci', 'op', ?, '{}', '{\"note\":\"neu\"}', 1)",
    [entry],
  );
  await db.customStatement(
    "INSERT INTO task_planning_interruptions (id, task_id, reason, from_day) VALUES ('pause', ?, 'pause', '2026-10-16')",
    [task],
  );
  await db.customStatement(
    "INSERT INTO entity_deletion_markers (entity_type, entity_id, deleted_at) VALUES ('task', 'previously-deleted', 1234)",
  );
  await db.customStatement(
    "INSERT INTO project_deletion_batches (id, project_id, mode, deleted_at, project_revision) VALUES ('batch', 'p', 'project_and_contents', 1234, 1)",
  );
  await db.customStatement(
    "INSERT INTO project_deletion_batch_items (batch_id, object_type, object_id, lifecycle_revision, trashed_at) VALUES ('batch', 'task', ?, 1, 1234)",
    [other],
  );
  await db.customStatement(
    'UPDATE aufgaben SET trashed_at = 1234, purge_at = 2100000000 WHERE id = ?',
    [other],
  );
}

Future<Map<String, Object?>> snapshot(AppDatabase db) async => {
  for (final table in db.allTables)
    table.actualTableName:
        (await db
                .customSelect(
                  'SELECT * FROM "${table.actualTableName}" ORDER BY rowid',
                )
                .get())
            .map((r) => r.data)
            .toList(),
};

Uint8List changePayload(
  Uint8List bytes,
  void Function(Map<String, dynamic>) change,
) {
  final envelope = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
  final payload =
      jsonDecode(envelope['payload'] as String) as Map<String, dynamic>;
  change(payload);
  envelope['payload'] = jsonEncode(payload);
  envelope['sha256'] =
      sha256.convert(utf8.encode(envelope['payload'] as String)).toString();
  return Uint8List.fromList(utf8.encode(jsonEncode(envelope)));
}

void main() {
  test('all 18 populated tables survive replacement and reopening', () async {
    final source = AppDatabase.forTesting(NativeDatabase.memory());
    final directory = await Directory.systemTemp.createTemp(
      'momentum-backup-test-',
    );
    final file = File('${directory.path}/restored.sqlite');
    var target = AppDatabase.forTesting(NativeDatabase(file));
    addTearDown(() async {
      await source.close();
      await target.close();
      await directory.delete(recursive: true);
    });
    await seed(source);
    final before = await snapshot(source);
    expect(before.length, 18);
    expect(before.values.every((rows) => (rows as List).isNotEmpty), isTrue);
    await seed(target);
    await target.customStatement(
      "INSERT INTO projects (id, name) VALUES ('extra', 'Must disappear')",
    );
    final service = BackupService(target);
    final bytes = await BackupService(source).export();
    final prepared = await service.prepare(bytes);
    expect(prepared.taskCount, 2);
    await service.restore(prepared);
    expect(await snapshot(target), before);
    await target.close();
    target = AppDatabase.forTesting(NativeDatabase(file));
    expect(await snapshot(target), before);
  });

  test(
    'foreign files, checksum, schema, missing data, invalid types and references leave data intact',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      await seed(db);
      final service = BackupService(db);
      final before = await snapshot(db);
      final bytes = await service.export();
      final corrupt = Uint8List.fromList(bytes)..[bytes.length ~/ 2] ^= 1;
      final invalidFiles = [
        Uint8List.fromList(utf8.encode('{}')),
        corrupt,
        changePayload(bytes, (p) => p['schemaVersion'] = 999),
        changePayload(bytes, (p) => p['tables'].remove('projects')),
        changePayload(
          bytes,
          (p) => p['tables']['projects'][0]['sort_order'] = 'not a number',
        ),
        changePayload(
          bytes,
          (p) => p['tables']['task_entries'][0]['task_id'] = 'missing',
        ),
        changePayload(
          bytes,
          (p) => p['tables']['projects'].add(p['tables']['projects'][0]),
        ),
      ];
      for (final file in invalidFiles) {
        await expectLater(
          service.prepare(file),
          throwsA(isA<BackupException>()),
        );
        expect(await snapshot(db), before);
      }
    },
  );

  test('failure after deletion rolls back to previous data', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await seed(db);
    final service = BackupService(db);
    final prepared = await service.prepare(await service.export());
    await db.customStatement(
      "INSERT INTO projects (id, name) VALUES ('extra', 'Keep this')",
    );
    final before = await snapshot(db);
    await db.customStatement(
      "CREATE TRIGGER fail_restore BEFORE INSERT ON task_entries BEGIN SELECT RAISE(ABORT, 'simulated write failure'); END",
    );
    await expectLater(
      service.restore(prepared),
      throwsA(isA<BackupException>()),
    );
    expect(await snapshot(db), before);
  });

  test('empty backup is valid and replaces existing data', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final service = BackupService(db);
    final empty = await service.prepare(await service.export());
    await seed(db);
    await service.restore(empty);
    expect(
      (await snapshot(db)).values.every((rows) => (rows as List).isEmpty),
      isTrue,
    );
  });

  test(
    'schema 22 backup preserves all old tables and resets display preferences',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      await seed(db);
      final before = await snapshot(db);
      final service = BackupService(db);
      final oldBackup = changePayload(await service.export(), (payload) {
        payload['schemaVersion'] = 22;
        payload['tables'].remove('card_display_settings');
        payload['tables'].remove('card_expansion_preferences');
      });
      await service.restore(await service.prepare(oldBackup));
      final after = await snapshot(db);
      for (final table in before.keys.where(
        (name) => !name.startsWith('card_'),
      )) {
        expect(after[table], before[table], reason: table);
      }
      final preferences = await CardDisplayRepository(db).load();
      expect(preferences.mode, CardDisplayMode.compact);
      expect(preferences.singleOpen, false);
      expect(preferences.opened, isEmpty);
      // Declaring the old schema must not bypass table completeness validation.
      await expectLater(
        service.prepare(
          changePayload(oldBackup, (p) => p['tables'].remove('aufgaben')),
        ),
        throwsA(isA<BackupException>()),
      );
    },
  );
}
