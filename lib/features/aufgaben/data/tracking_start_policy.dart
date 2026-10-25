import 'package:drift/drift.dart';
import 'package:momentum/core/database/app_database.dart';
import 'task_definition_change.dart';

/// Start is an expectation boundary, not the beginning of recorded history.
abstract final class TrackingStartPolicy {
  static bool isPure(Aufgabe task) =>
      task.erfassungsmodus == 'value' &&
      task.valueCommitment == 'pure_tracking';

  static bool safeSchedule(String recurrence, String missedPolicy) =>
      missedPolicy == 'none' &&
      {
        'none',
        'daily',
        'weekly_fixed_days',
        'monthly_fixed_days',
      }.contains(recurrence);

  static String? configurationReason(Aufgabe task) =>
      isPure(task) && safeSchedule(task.recurrence, task.missedPolicy)
          ? null
          : 'Startänderungen sind nur für reines Tracking ohne Missed-Policy '
              'und ohne abschlussabhängigen Abstand möglich.';

  static Future<String?> blockedReason(AppDatabase db, String taskId) async {
    final task =
        await (db.select(db.aufgaben)
          ..where((t) => t.id.equals(taskId))).getSingle();
    if (task.trashedAt != null) {
      return 'Einträge im Papierkorb sind schreibgeschützt.';
    }
    final reason = configurationReason(task);
    if (reason != null) return reason;
    final versions =
        await (db.select(db.taskDefinitionVersions)
          ..where((v) => v.taskId.equals(taskId))).get();
    if (versions.any(
      (v) =>
          v.captureMode != 'value' ||
          v.valueCommitment != 'pure_tracking' ||
          !safeSchedule(v.recurrence, v.missedPolicy),
    )) {
      return 'Frühere verpflichtende oder abschlussabhängige Planung: Startdatum bleibt gesperrt. Bei Bedarf einen neuen Tracker anlegen.';
    }
    final pending =
        await (db.select(db.taskPendingDefinitionChanges)..where(
          (p) =>
              p.taskId.equals(taskId) &
              p.state.equals('pending') &
              p.groupKey.equals('schedule'),
        )).get();
    for (final change in pending) {
      final payload = TaskScheduleChangePayload.decode(change.payloadJson);
      if (!safeSchedule(payload.recurrence, payload.missedPolicy)) {
        return 'Eine vorgemerkte Terminplanung verhindert die Startänderung.';
      }
    }
    final entries =
        await (db.select(db.taskEntries)
          ..where((e) => e.taskId.equals(taskId))).get();
    if (entries.any(
      (e) =>
          e.status == 'success' ||
          e.status == 'failure' ||
          e.resolutionOrigin == 'automatic' ||
          (e.status == 'pending' && e.note.isEmpty),
    )) {
      return 'Vorhandene Termininstanzen verhindern die Startänderung; Messwerte bleiben unverändert.';
    }
    return null;
  }
}
