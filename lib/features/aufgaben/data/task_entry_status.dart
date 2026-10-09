abstract final class TaskEntryStatus {
  static const pending = 'pending';
  static const success = 'success';
  static const failure = 'failure';
  static const noEntry = 'no_entry';
  static const recorded = 'recorded';

  static const values = {pending, success, failure, noEntry, recorded};
  static const finalValues = {success, failure, recorded};
  static const resolvedValues = {success, failure, noEntry, recorded};
  static const positiveCompletionValues = {success, recorded};

  static bool isFinal(String status) => finalValues.contains(status);
  static bool isResolved(String status) => resolvedValues.contains(status);
  static bool isPositiveCompletion(String status) =>
      positiveCompletionValues.contains(status);
}

abstract final class TaskEntryResolutionOrigin {
  static const manual = 'manual';
  static const automatic = 'automatic';
  static const migration = 'migration';

  static const values = {manual, automatic, migration};
}
