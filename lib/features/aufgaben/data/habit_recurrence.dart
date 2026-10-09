abstract final class HabitRecurrence {
  static const none = 'none';
  static const daily = 'daily';
  static const weeklyFixedDays = 'weekly_fixed_days';
  static const weeklyAfterCompletion = 'weekly_after_completion';
  static const monthlyFixedDays = 'monthly_fixed_days';
  static const customAfterCompletionPrefix = 'custom_after_completion:';

  static String customAfterCompletion(int days) {
    return '$customAfterCompletionPrefix$days';
  }

  static bool isCustomAfterCompletion(String recurrence) {
    return recurrence.startsWith(customAfterCompletionPrefix);
  }

  static int customAfterCompletionDays(String recurrence) {
    final rawValue = recurrence.substring(customAfterCompletionPrefix.length);
    return int.tryParse(rawValue) ?? 7;
  }
}
