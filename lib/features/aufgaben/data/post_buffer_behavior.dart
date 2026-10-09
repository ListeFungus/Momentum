abstract final class PostBufferBehavior {
  static const markAsFailure = 'mark_as_failure';
  static const markAsNoEntry = 'mark_as_no_entry';

  /// Legacy value kept so older databases can still be read.
  ///
  /// New buffer configurations must not use this value. If an entry should
  /// remain open after its deadline, the task should use carryover instead.
  static const keepOpen = 'keep_open';

  static const values = {markAsFailure, markAsNoEntry, keepOpen};
  static const bufferValues = {markAsFailure, markAsNoEntry};
}
