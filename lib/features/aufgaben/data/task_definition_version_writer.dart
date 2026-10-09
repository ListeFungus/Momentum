import 'package:drift/drift.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:uuid/uuid.dart';

class TaskDefinitionVersionWriter {
  TaskDefinitionVersionWriter(this._database);

  final AppDatabase _database;
  final Uuid _uuid = const Uuid();

  Future<String> currentVersionId(String taskId) async {
    final endExclusive = _nextLocalDay(DateTime.now());
    final version =
        await (_database.select(_database.taskDefinitionVersions)
              ..where(
                (candidate) =>
                    candidate.taskId.equals(taskId) &
                    candidate.supersededAt.isNull() &
                    candidate.validFrom.isSmallerThanValue(endExclusive),
              )
              ..orderBy([
                (candidate) => OrderingTerm.desc(candidate.validFrom),
                (candidate) => OrderingTerm.desc(candidate.versionNumber),
              ])
              ..limit(1))
            .getSingleOrNull();
    if (version == null) {
      throw StateError('Für die Aufgabe fehlt eine Definitionsversion.');
    }
    return version.id;
  }

  Future<String> versionIdForScheduledDate(
    String taskId,
    DateTime scheduledDate,
  ) async {
    final nextScheduledDay = DateTime(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
    ).add(const Duration(days: 1));
    final version =
        await (_database.select(_database.taskDefinitionVersions)
              ..where(
                (version) =>
                    version.taskId.equals(taskId) &
                    version.supersededAt.isNull() &
                    version.validFrom.isSmallerThanValue(nextScheduledDay),
              )
              ..orderBy([
                (version) => OrderingTerm.desc(version.validFrom),
                (version) => OrderingTerm.desc(version.versionNumber),
              ])
              ..limit(1))
            .getSingleOrNull();

    if (version != null) {
      return version.id;
    }

    return currentVersionId(taskId);
  }

  Future<String> createVersion(
    Aufgabe task, {
    DateTime? validFrom,
    DateTime? createdAt,
  }) async {
    final latestVersion = await _latestVersion(task.id);
    final versionId = _uuid.v4();
    final now = createdAt ?? DateTime.now();

    await _database
        .into(_database.taskDefinitionVersions)
        .insert(
          TaskDefinitionVersionsCompanion.insert(
            id: versionId,
            taskId: task.id,
            versionNumber: (latestVersion?.versionNumber ?? 0) + 1,
            previousVersionId: Value(latestVersion?.id),
            validFrom: validFrom ?? now,
            createdAt: now,
            name: Value(task.name),
            description: Value(task.beschreibung),
            questionText: Value(task.questionText),
            projectId: Value(task.projectId),
            taskType: task.taskType,
            captureMode: task.erfassungsmodus,
            successValue: Value(task.successValue),
            activeWeekdays: task.activeWeekdays,
            recurrence: task.recurrence,
            startDate: task.startDate,
            endDate: Value(task.endDate),
            dueDate: Value(task.dueDate),
            missedPolicy: Value(task.missedPolicy),
            missedConsequence: Value(task.missedConsequence),
            missedBufferDays: Value(task.missedBufferDays),
            postBufferBehavior: Value(task.postBufferBehavior),
            maxCarryoverCount: Value(task.maxCarryoverCount),
            goalType: Value(task.goalType),
            goalValue: Value(task.goalValue),
            goalWindowDays: Value(task.goalWindowDays),
            goalPeriod: Value(task.goalPeriod),
            goalPeriodAlignment: Value(task.goalPeriodAlignment),
            valueType: Value(task.valueType),
            valueCommitment: Value(task.valueCommitment),
            valueUnitKey: Value(task.valueUnitKey),
            valueUnitLabel: Value(task.valueUnitLabel),
          ),
        );

    return versionId;
  }

  Future<void> createVersionIfChanged(
    Aufgabe previousTask,
    Aufgabe updatedTask, {
    DateTime? validFrom,
  }) async {
    if (!hasSameSnapshot(previousTask, updatedTask)) {
      await createVersion(updatedTask, validFrom: validFrom);
    }
  }

  Future<String> createGoalVersion(
    Aufgabe task, {
    required DateTime validFrom,
    required String goalType,
    required int goalValue,
    required int? goalWindowDays,
    required String goalPeriod,
    required String goalPeriodAlignment,
  }) {
    return createVersion(
      task.copyWith(
        goalType: goalType,
        goalValue: goalValue,
        goalWindowDays: Value(goalWindowDays),
        goalPeriod: goalPeriod,
        goalPeriodAlignment: goalPeriodAlignment,
      ),
      validFrom: validFrom,
    );
  }

  bool hasSameSnapshot(Aufgabe first, Aufgabe second) {
    return first.name == second.name &&
        first.beschreibung == second.beschreibung &&
        first.questionText == second.questionText &&
        first.projectId == second.projectId &&
        first.taskType == second.taskType &&
        first.erfassungsmodus == second.erfassungsmodus &&
        first.successValue == second.successValue &&
        first.activeWeekdays == second.activeWeekdays &&
        first.recurrence == second.recurrence &&
        first.startDate == second.startDate &&
        first.endDate == second.endDate &&
        first.dueDate == second.dueDate &&
        first.missedPolicy == second.missedPolicy &&
        first.missedConsequence == second.missedConsequence &&
        first.missedBufferDays == second.missedBufferDays &&
        first.postBufferBehavior == second.postBufferBehavior &&
        first.maxCarryoverCount == second.maxCarryoverCount &&
        first.goalType == second.goalType &&
        first.goalValue == second.goalValue &&
        first.goalWindowDays == second.goalWindowDays &&
        first.goalPeriod == second.goalPeriod &&
        first.goalPeriodAlignment == second.goalPeriodAlignment &&
        first.valueType == second.valueType &&
        first.valueCommitment == second.valueCommitment &&
        first.valueUnitKey == second.valueUnitKey &&
        first.valueUnitLabel == second.valueUnitLabel;
  }

  Future<TaskDefinitionVersion?> _latestVersion(String taskId) {
    return (_database.select(_database.taskDefinitionVersions)
          ..where((version) => version.taskId.equals(taskId))
          ..orderBy([(version) => OrderingTerm.desc(version.versionNumber)])
          ..limit(1))
        .getSingleOrNull();
  }
}

DateTime _nextLocalDay(DateTime date) =>
    DateTime(date.year, date.month, date.day + 1);
