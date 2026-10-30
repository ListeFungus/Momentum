import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/backup/backup_service.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/calendar/data/calendar_planning.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test(
    'Schema 23 migriert Planungsfelder ohne bestehende Daten zu ändern',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'calendar-migration-',
      );
      final file = File('${directory.path}/db.sqlite');
      var db = AppDatabase.forTesting(NativeDatabase(file));
      addTearDown(() async {
        await db.close();
        await directory.delete(recursive: true);
      });
      await AufgabenRepository(db).createTask(
        name: 'Historie',
        beschreibung: '',
        erfassungsmodus: 'checkbox',
        projectId: null,
      );
      final entry = await db.select(db.taskEntries).getSingle();
      await db.close();
      final raw = sqlite3.open(file.path);
      raw.execute('DROP TABLE calendar_settings');
      raw.execute('DROP TABLE task_type_changes');
      raw.execute('DROP TABLE task_display_group_members');
      raw.execute('DROP TABLE task_display_groups');
      for (final table in [
        'aufgaben',
        'task_entries',
        'task_definition_versions',
      ]) {
        raw.execute('ALTER TABLE $table DROP COLUMN planned_start_minute');
        raw.execute('ALTER TABLE $table DROP COLUMN planned_duration_minutes');
      }
      raw.execute('PRAGMA user_version = 23');
      raw.dispose();
      db = AppDatabase.forTesting(NativeDatabase(file));
      expect(
        (await db.select(db.taskEntries).getSingle()).toJson(),
        entry.toJson(),
      );
      expect(await db.select(db.calendarSettings).get(), isEmpty);
      expect(
        (await db.customSelect('PRAGMA foreign_key_check').get()),
        isEmpty,
      );
    },
  );
  test('Kalender validiert Dauer, Tagesgrenzen und Payload', () {
    for (final planning in [
      const CalendarPlanning(),
      const CalendarPlanning(durationMinutes: 1440),
      const CalendarPlanning(startMinute: 1439, durationMinutes: 1),
    ]) {
      expect(() => CalendarPlanning.decode(planning.encode()), returnsNormally);
    }
    for (final planning in [
      const CalendarPlanning(startMinute: 60),
      const CalendarPlanning(durationMinutes: 0),
      const CalendarPlanning(startMinute: 1439, durationMinutes: 2),
    ]) {
      expect(planning.validate, throwsArgumentError);
    }
    expect(() => CalendarPlanning.decode('{}'), throwsFormatException);
  });

  test(
    'Kalenderplanung wird in Definition, Eintrag und Sicherung erhalten',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final repo = AufgabenRepository(db, now: () => DateTime(2026, 10, 21));
      await repo.createTask(
        name: 'Plan',
        beschreibung: '',
        erfassungsmodus: 'checkbox',
        projectId: null,
        plannedStartMinute: 600,
        plannedDurationMinutes: 45,
      );
      expect(
        (await db.select(db.aufgaben).getSingle()).plannedStartMinute,
        600,
      );
      expect(
        (await db.select(db.taskDefinitionVersions).getSingle())
            .plannedDurationMinutes,
        45,
      );
      expect(
        (await db.select(db.taskEntries).getSingle()).plannedStartMinute,
        600,
      );
      await db
          .into(db.calendarSettings)
          .insert(
            CalendarSettingsCompanion.insert(showHabits: const Value(true)),
          );
      final service = BackupService(db);
      final bytes = await service.export();
      await service.restore(await service.prepare(bytes));
      expect(
        (await db.select(db.calendarSettings).getSingle()).showHabits,
        isTrue,
      );
      expect(
        (await db.select(db.taskEntries).getSingle()).plannedDurationMinutes,
        45,
      );
    },
  );

  test(
    'Schema 23 Sicherung wird vor Kalenderergänzung strikt geprüft',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      await AufgabenRepository(db).createTask(
        name: 'Alt',
        beschreibung: '',
        erfassungsmodus: 'checkbox',
        projectId: null,
      );
      final service = BackupService(db);
      final envelope =
          jsonDecode(utf8.decode(await service.export()))
              as Map<String, dynamic>;
      final content =
          jsonDecode(envelope['payload'] as String) as Map<String, dynamic>;
      content['schemaVersion'] = 23;
      final tables = content['tables'] as Map<String, dynamic>;
      tables.remove('calendar_settings');
      tables.remove('task_type_changes');
      tables.remove('task_display_groups');
      tables.remove('task_display_group_members');
      for (final name in [
        'aufgaben',
        'task_entries',
        'task_definition_versions',
      ]) {
        for (final row in tables[name] as List) {
          (row as Map).remove('planned_start_minute');
          row.remove('planned_duration_minutes');
        }
      }
      Uint8List encoded() {
        envelope['payload'] = jsonEncode(content);
        envelope['sha256'] =
            sha256
                .convert(utf8.encode(envelope['payload'] as String))
                .toString();
        return Uint8List.fromList(utf8.encode(jsonEncode(envelope)));
      }

      await service.restore(await service.prepare(encoded()));
      expect(
        (await db.select(db.aufgaben).getSingle()).plannedStartMinute,
        isNull,
      );
      (tables['aufgaben'][0] as Map).remove('name');
      await expectLater(
        service.prepare(encoded()),
        throwsA(isA<BackupException>()),
      );
      expect((await db.select(db.aufgaben).getSingle()).name, 'Alt');
    },
  );
}
