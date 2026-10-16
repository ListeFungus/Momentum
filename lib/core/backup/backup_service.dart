import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:momentum/core/database/app_database.dart';

class BackupException implements Exception {
  const BackupException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// A validated snapshot. Only [BackupService.prepare] can construct one.
class PreparedBackup {
  PreparedBackup._(this.createdAt, this._tables);
  final DateTime createdAt;
  final Map<String, List<Map<String, Object?>>> _tables;
  int get taskCount => _tables['aufgaben']!.length;
  int get entryCount => _tables['task_entries']!.length;
}

class BackupService {
  BackupService(this._database);
  final AppDatabase _database;
  static const maxFileBytes = 50 * 1024 * 1024;

  Future<Uint8List> export() async {
    final tables = await _database.transaction(() async {
      final result = <String, List<Map<String, Object?>>>{};
      for (final table in _database.allTables) {
        final rows =
            await _database
                .customSelect('SELECT * FROM "${table.actualTableName}"')
                .get();
        result[table.actualTableName] = rows.map((row) => row.data).toList();
      }
      return result;
    });
    final payload = jsonEncode({
      'schemaVersion': _database.schemaVersion,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      'tables': tables,
    });
    final bytes = Uint8List.fromList(
      utf8.encode(
        jsonEncode({
          'format': 'momentum-backup',
          'formatVersion': 1,
          'sha256': sha256.convert(utf8.encode(payload)).toString(),
          'payload': payload,
        }),
      ),
    );
    if (bytes.length > maxFileBytes) {
      throw const BackupException(
        'Der Datenbestand überschreitet die derzeit unterstützte Sicherungsgröße von 50 MB.',
      );
    }
    return bytes;
  }

  Future<PreparedBackup> prepare(Uint8List bytes) async {
    if (bytes.length > maxFileBytes) {
      throw const BackupException('Die Sicherungsdatei ist größer als 50 MB.');
    }
    final scratch = AppDatabase.withExecutor(NativeDatabase.memory());
    try {
      final envelope = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
      if (envelope['format'] != 'momentum-backup' ||
          envelope['formatVersion'] != 1) {
        throw const BackupException(
          'Diese Datei ist keine unterstützte Momentum-Sicherung.',
        );
      }
      final payload = envelope['payload'] as String;
      if (sha256.convert(utf8.encode(payload)).toString() !=
          envelope['sha256']) {
        throw const BackupException(
          'Die Sicherungsdatei ist beschädigt oder wurde verändert.',
        );
      }
      final content = jsonDecode(payload) as Map<String, dynamic>;
      // The first backup format starts at schema 22. When the application schema
      // changes, add an explicit backup migration here before accepting it.
      if (content['schemaVersion'] != scratch.schemaVersion) {
        throw const BackupException(
          'Die Datenversion dieser Sicherung passt nicht zu dieser App-Version. Der aktuelle Bestand bleibt erhalten.',
        );
      }
      final createdAt = DateTime.parse(content['createdAt'] as String);
      final rawTables = content['tables'] as Map<String, dynamic>;
      final expected = scratch.allTables.map((t) => t.actualTableName).toSet();
      if (rawTables.length != expected.length ||
          !expected.containsAll(rawTables.keys)) {
        throw const BackupException(
          'Die Sicherung enthält nicht alle benötigten Datenbereiche.',
        );
      }
      final tables = <String, List<Map<String, Object?>>>{};
      for (final name in expected) {
        final columns =
            await scratch.customSelect('PRAGMA table_info("$name")').get();
        final rows = rawTables[name] as List<dynamic>;
        tables[name] = [];
        for (final rawRow in rows) {
          final row = Map<String, Object?>.from(rawRow as Map);
          if (row.length != columns.length) {
            throw const BackupException(
              'Die Sicherung enthält unvollständige Datensätze.',
            );
          }
          for (final column in columns) {
            final key = column.read<String>('name');
            final value = row[key];
            final type = column.read<String>('type').toUpperCase();
            final valid =
                row.containsKey(key) &&
                (value == null
                    ? column.read<int>('notnull') == 0
                    : switch (type) {
                      'TEXT' => value is String,
                      'INTEGER' => value is int,
                      'REAL' => value is num && value.isFinite,
                      _ => false,
                    });
            if (!valid) {
              throw const BackupException(
                'Die Sicherung enthält ungültige Datenfelder.',
              );
            }
          }
          tables[name]!.add(row);
        }
      }
      final backup = PreparedBackup._(createdAt, tables);
      await _replace(scratch, backup);
      return backup;
    } on BackupException {
      rethrow;
    } catch (_) {
      throw const BackupException(
        'Die Datei konnte nicht als vollständige Momentum-Sicherung geprüft werden. Der aktuelle Bestand bleibt erhalten.',
      );
    } finally {
      await scratch.close();
    }
  }

  Future<void> restore(PreparedBackup backup) async {
    try {
      await _replace(_database, backup);
      _database.markTablesUpdated(_database.allTables.toSet());
    } catch (_) {
      throw const BackupException(
        'Wiederherstellung fehlgeschlagen. Der vorherige Datenbestand wurde beibehalten.',
      );
    }
  }

  Future<void> _replace(AppDatabase database, PreparedBackup backup) async {
    await database.transaction(() async {
      await database.customStatement('PRAGMA defer_foreign_keys = ON');
      for (final table in database.allTables.toList().reversed) {
        await database.customStatement(
          'DELETE FROM "${table.actualTableName}"',
        );
      }
      for (final table in database.allTables) {
        final name = table.actualTableName;
        for (final row in backup._tables[name]!) {
          final columns = row.keys.map((key) => '"$key"').join(', ');
          final placeholders = List.filled(row.length, '?').join(', ');
          await database.customStatement(
            'INSERT INTO "$name" ($columns) VALUES ($placeholders)',
            row.values.toList(),
          );
        }
      }
      if ((await database.customSelect('PRAGMA foreign_key_check').get())
          .isNotEmpty) {
        throw const BackupException(
          'Ungültige Verknüpfungen in der Sicherung.',
        );
      }
    });
  }
}
