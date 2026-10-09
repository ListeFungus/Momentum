abstract final class MissedPolicy {
  static const none = 'none';
  static const direct = 'direct';
  static const carryover = 'carryover';
  static const buffer = 'buffer';

  static const values = {none, direct, carryover, buffer};
}

abstract final class MissedConsequence {
  static const markAsNotDone = 'mark_as_not_done';
  static const keepNeutral = 'keep_neutral';

  static const values = {markAsNotDone, keepNeutral};
}
