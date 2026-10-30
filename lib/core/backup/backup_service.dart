import 'dart:convert';
import 'package:momentum/features/calendar/data/calendar_planning.dart';
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
      final schema = content['schemaVersion'];
      if (schema != 22 &&
          schema != 23 &&
          schema != 24 &&
          schema != 25 &&
          schema != scratch.schemaVersion) {
        throw const BackupException(
          'Die Datenversion dieser Sicherung passt nicht zu dieser App-Version. Der aktuelle Bestand bleibt erhalten.',
        );
      }
      final createdAt = DateTime.parse(content['createdAt'] as String);
      final rawTables = content['tables'] as Map<String, dynamic>;
      final expected = scratch.allTables.map((t) => t.actualTableName).toSet();
      final sourceTables = {...expected};
      if (schema < 26) {
        sourceTables.removeAll({
          'task_display_groups',
          'task_display_group_members',
        });
      }
      if (schema < 24) {
        sourceTables.remove('calendar_settings');
      }
      if (schema < 25) sourceTables.remove('task_type_changes');
      if (schema == 22) {
        sourceTables.removeAll({
          'card_display_settings',
          'card_expansion_preferences',
        });
      }
      if (rawTables.length != sourceTables.length ||
          !sourceTables.containsAll(rawTables.keys)) {
        throw const BackupException(
          'Die Sicherung enthält nicht alle benötigten Datenbereiche.',
        );
      }
      // Schema 23 only adds presentation preferences. Empty tables resolve to
      // compact/multiple defaults, including when replacing existing preferences.
      if (schema == 22) {
        rawTables['card_display_settings'] = <dynamic>[];
        rawTables['card_expansion_preferences'] = <dynamic>[];
      }
      final tables = <String, List<Map<String, Object?>>>{};
      if (schema < 26) {
        rawTables['task_display_groups'] = <dynamic>[];
        rawTables['task_display_group_members'] = <dynamic>[];
      }
      if (schema < 25) rawTables['task_type_changes'] = <dynamic>[];
      if (schema < 24) {
        rawTables['calendar_settings'] = <dynamic>[];
      }
      for (final name in expected) {
        final currentColumns =
            await scratch.customSelect('PRAGMA table_info("$name")').get();
        final hasPlanning = {
          'aufgaben',
          'task_entries',
          'task_definition_versions',
        }.contains(name);
        final legacyPlanning = schema < 24 && hasPlanning;
        final columns =
            currentColumns
                .where(
                  (column) =>
                      !legacyPlanning ||
                      !{
                        'planned_start_minute',
                        'planned_duration_minutes',
                      }.contains(column.read<String>('name')),
                )
                .toList();
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
          // Validate the original schema first; only then introduce new nullable fields.
          if (legacyPlanning) {
            row['planned_start_minute'] = null;
            row['planned_duration_minutes'] = null;
          }
          if (hasPlanning) {
            CalendarPlanning(
              startMinute: row['planned_start_minute'] as int?,
              durationMinutes: row['planned_duration_minutes'] as int?,
            ).validate();
          }
          if (name == 'task_pending_definition_changes' &&
              row['group_key'] == 'calendar') {
            if (schema < 24 || row['payload_version'] != 1) {
              throw const BackupException(
                'Ungültige Version einer Kalenderänderung.',
              );
            }
            CalendarPlanning.decode(row['payload_json'] as String);
          }
          tables[name]!.add(row);
        }
      }
      _validateTypeChanges(tables);
      final members =
          tables['task_display_group_members']!
              .map((m) => m['task_id'])
              .toSet();
      if (tables['task_value_bundle_versions']!.any(
        (v) =>
            v['cancelled_at'] == null &&
            (members.contains(v['first_task_id']) ||
                members.contains(v['second_task_id'])),
      )) {
        throw const BackupException(
          'Bündelgebundene Einträge können keiner Gruppe zugeordnet werden.',
        );
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

  void _validateTypeChanges(Map<String, List<Map<String, Object?>>> tables) {
    final versions = {
      for (final v in tables['task_definition_versions']!) v['id']: v,
    };
    for (final change in tables['task_type_changes']!) {
      final version = versions[change['definition_version_id']];
      if (version == null || version['task_id'] != change['task_id']) {
        throw const BackupException(
          'Ungültige Definitionszuordnung im Artenwechsel.',
        );
      }
      final decoded = jsonDecode(change['previous_types_json'] as String);
      if (decoded is! List ||
          (change['scope'] == 'new_entries' && decoded.isNotEmpty)) {
        throw const BackupException('Ungültiges Artenwechsel-Protokoll.');
      }
      final seen = <String>{};
      for (final item in decoded) {
        if (item is! Map ||
            item.length != 2 ||
            item['versionId'] is! String ||
            !{'task', 'habit'}.contains(item['taskType']) ||
            !seen.add(item['versionId'] as String) ||
            versions[item['versionId']]?['task_id'] != change['task_id'] ||
            (versions[item['versionId']]!['version_number'] as int) >=
                (version['version_number'] as int)) {
          throw const BackupException(
            'Ungültige frühere Artzuordnung im Protokoll.',
          );
        }
      }
      if (change['scope'] == 'all_history') {
        final expected =
            versions.values
                .where(
                  (v) =>
                      v['task_id'] == change['task_id'] &&
                      (v['version_number'] as int) <
                          (version['version_number'] as int),
                )
                .map((v) => v['id'])
                .toSet();
        if (seen.length != expected.length || !seen.containsAll(expected)) {
          throw const BackupException(
            'Unvollständige frühere Artzuordnung im Protokoll.',
          );
        }
      }
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
