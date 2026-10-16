import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/core/settings/card_display_repository.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test(
    'migration from 22 preserves task data, preferences survive reopen and cascade on purge',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'momentum-display-',
      );
      final file = File('${directory.path}/test.sqlite');
      var db = AppDatabase.forTesting(NativeDatabase(file));
      addTearDown(() async {
        await db.close();
        await directory.delete(recursive: true);
      });
      await AufgabenRepository(db).createTask(
        name: 'Gewicht',
        beschreibung: '',
        erfassungsmodus: 'checkbox',
        projectId: null,
      );
      final task = await db.select(db.aufgaben).getSingle();
      await db.close();
      final raw = sqlite3.open(file.path);
      raw.execute('DROP TABLE card_expansion_preferences');
      raw.execute('DROP TABLE card_display_settings');
      raw.execute('PRAGMA user_version = 22');
      raw.dispose();
      db = AppDatabase.forTesting(NativeDatabase(file));
      var repo = CardDisplayRepository(db);
      expect((await repo.load()).mode, CardDisplayMode.compact);
      expect(
        (await db.select(db.aufgaben).getSingle()).toJson(),
        task.toJson(),
      );
      await repo.configure(mode: CardDisplayMode.remember);
      await repo.remember(entityKey: 'task:${task.id}', expanded: true);
      await db.close();
      db = AppDatabase.forTesting(NativeDatabase(file));
      repo = CardDisplayRepository(db);
      expect((await repo.load()).mode, CardDisplayMode.remember);
      expect((await repo.load()).opened.keys, ['task:${task.id}']);
      await (db.delete(db.aufgaben)
        ..where((row) => row.id.equals(task.id))).go();
      expect((await repo.load()).opened, isEmpty);
    },
  );

  test(
    'single mode remembers automatic closure; expanded mode retains the option',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final tasks = AufgabenRepository(db);
      for (final name in ['A', 'B']) {
        await tasks.createTask(
          name: name,
          beschreibung: '',
          erfassungsmodus: 'checkbox',
          projectId: null,
        );
      }
      final ids =
          (await db.select(db.aufgaben).get())
              .map((t) => 'task:${t.id}')
              .toList();
      final repo = CardDisplayRepository(db);
      await repo.configure(mode: CardDisplayMode.remember);
      for (final id in ids) {
        await repo.remember(entityKey: id, expanded: true);
      }
      await repo.configure(singleOpen: true);
      expect((await repo.load()).opened.keys, [ids.last]);
      await repo.remember(entityKey: ids.first, expanded: true);
      expect((await repo.load()).opened.keys, [ids.first]);
      await repo.configure(mode: CardDisplayMode.expanded);
      expect((await repo.load()).singleOpen, true);
      expect((await repo.load()).restrictToOne, false);
      await repo.configure(mode: CardDisplayMode.remember);
      await repo.remember(entityKey: ids.first, expanded: false);
      expect((await repo.load()).opened, isEmpty);
    },
  );
}
