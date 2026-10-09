import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test(
    'Migration 17 auf 18 erhält Aufgaben und ergänzt Kartenanzeige',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'momentum_card_metric_migration_',
      );
      final file = File('${directory.path}/momentum.sqlite');
      addTearDown(() => directory.delete(recursive: true));

      final setupDatabase = AppDatabase.forTesting(NativeDatabase(file));
      final setupRepository = AufgabenRepository(setupDatabase);
      await setupRepository.createTask(
        name: 'Bleibt erhalten',
        beschreibung: '',
        erfassungsmodus: 'checkbox',
        projectId: null,
      );
      final taskId = await setupDatabase
          .select(setupDatabase.aufgaben)
          .getSingle()
          .then((task) => task.id);
      await setupDatabase.close();

      final sqlite = sqlite3.open(file.path);
      sqlite.execute('DROP TABLE task_card_metric_preferences');
      sqlite.execute('PRAGMA user_version = 17');
      sqlite.dispose();

      final migratedDatabase = AppDatabase.forTesting(NativeDatabase(file));
      final repository = AufgabenRepository(migratedDatabase);
      final task =
          await migratedDatabase.select(migratedDatabase.aufgaben).getSingle();
      final table =
          await migratedDatabase
              .customSelect(
                "SELECT name FROM sqlite_master "
                "WHERE type = 'table' AND name = 'task_card_metric_preferences'",
              )
              .getSingleOrNull();

      expect(task.id, taskId);
      expect(task.name, 'Bleibt erhalten');
      expect(table, isNotNull);
      expect(
        (await repository.getTaskCardMetricPreference(taskId)).usesDefault,
        isTrue,
      );

      await migratedDatabase.close();
    },
  );
}
