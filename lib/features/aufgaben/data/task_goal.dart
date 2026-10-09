abstract final class TaskGoalType {
  static const none = 'none';
  static const countPerPeriod = 'count_per_period';
  static const percentage = 'percentage';
  static const maxFailures = 'max_failures';
  static const rollingSuccessCount = 'rolling_success_count';
  static const valueSumMin = 'value_sum_min';
  static const valueAverageMin = 'value_average_min';
  static const valueAverageMax = 'value_average_max';

  static const values = {
    none,
    countPerPeriod,
    percentage,
    maxFailures,
    rollingSuccessCount,
    valueSumMin,
    valueAverageMin,
    valueAverageMax,
  };
}

abstract final class GoalPeriod {
  static const week = 'week';
  static const month = 'month';

  static const values = {week, month};
}

abstract final class GoalPeriodAlignment {
  static const calendar = 'calendar';
  static const fromStartDate = 'from_start_date';

  static const values = {calendar, fromStartDate};
}
