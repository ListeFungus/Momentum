import 'package:drift/drift.dart';
import 'package:momentum/core/database/app_database.dart';

enum CardDisplayMode { compact, expanded, remember }

class CardDisplayPreferences {
  const CardDisplayPreferences({
    this.mode = CardDisplayMode.compact,
    this.singleOpen = false,
    this.opened = const {},
  });

  final CardDisplayMode mode;
  final bool singleOpen;
  final Map<String, int> opened;
  bool get restrictToOne => singleOpen && mode != CardDisplayMode.expanded;
}

/// Stores display preferences independently of task definitions and answers.
class CardDisplayRepository {
  CardDisplayRepository(this.database);
  final AppDatabase database;

  Stream<CardDisplayPreferences> watch() => database
      .customSelect(
        'SELECT 1',
        readsFrom: {
          database.cardDisplaySettings,
          database.cardExpansionPreferences,
        },
      )
      .watch()
      .asyncMap((_) => load());

  Future<CardDisplayPreferences> load() => database.transaction(() async {
    final settings =
        await database.select(database.cardDisplaySettings).getSingleOrNull();
    final entries =
        await database.select(database.cardExpansionPreferences).get();
    return CardDisplayPreferences(
      mode: CardDisplayMode.values.byName(settings?.mode ?? 'compact'),
      singleOpen: settings?.singleOpen ?? false,
      opened: Map.unmodifiable({
        for (final entry in entries) entry.id: entry.openedOrder,
      }),
    );
  });

  Future<void> configure({CardDisplayMode? mode, bool? singleOpen}) =>
      database.transaction(() async {
        final previous = await load();
        final nextMode = mode ?? previous.mode;
        final nextSingle = singleOpen ?? previous.singleOpen;
        await database
            .into(database.cardDisplaySettings)
            .insertOnConflictUpdate(
              CardDisplaySettingsCompanion.insert(
                id: const Value(1),
                mode: Value(nextMode.name),
                singleOpen: Value(nextSingle),
              ),
            );
        if (nextSingle && nextMode != CardDisplayMode.expanded) {
          final ordered =
              previous.opened.entries.toList()..sort((a, b) {
                final order = b.value.compareTo(a.value);
                return order != 0 ? order : a.key.compareTo(b.key);
              });
          for (final entry in ordered.skip(1)) {
            await (database.delete(database.cardExpansionPreferences)
              ..where((row) => row.id.equals(entry.key))).go();
          }
        }
      });

  Future<void> remember({required String entityKey, required bool expanded}) =>
      database.transaction(() async {
        final settings = await load();
        if (settings.mode != CardDisplayMode.remember) return;
        final table = database.cardExpansionPreferences;
        final nextOrder =
            settings.opened.values.fold<int>(0, (a, b) => a > b ? a : b) + 1;
        if (expanded && settings.restrictToOne) {
          await database.delete(table).go();
        } else {
          await (database.delete(table)
            ..where((row) => row.id.equals(entityKey))).go();
        }
        if (!expanded) return;
        final isTask = entityKey.startsWith('task:');
        if (!isTask && !entityKey.startsWith('bundle:')) {
          throw ArgumentError.value(entityKey, 'entityKey');
        }
        final entityId = entityKey.substring(entityKey.indexOf(':') + 1);
        await database
            .into(table)
            .insert(
              CardExpansionPreferencesCompanion.insert(
                id: entityKey,
                taskId: Value(isTask ? entityId : null),
                bundleId: Value(isTask ? null : entityId),
                openedOrder: nextOrder,
              ),
            );
      });
}
