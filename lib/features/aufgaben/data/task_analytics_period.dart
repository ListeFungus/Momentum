enum TaskAnalyticsPeriod {
  last7Days(days: 7, label: 'Letzte 7 Tage'),
  last20Days(days: 20, label: 'Letzte 20 Tage'),
  last30Days(days: 30, label: 'Letzte 30 Tage'),
  sinceStart(days: null, label: 'Seit Beginn');

  const TaskAnalyticsPeriod({required this.days, required this.label});

  final int? days;
  final String label;

  DateTime rangeStart({
    required DateTime taskStartDate,
    required DateTime today,
  }) {
    final normalizedToday = _dateOnly(today);
    final normalizedTaskStart = _dateOnly(taskStartDate);
    final days = this.days;

    if (days == null) {
      return normalizedTaskStart;
    }

    final rollingStart = normalizedToday.subtract(Duration(days: days - 1));
    if (rollingStart.isBefore(normalizedTaskStart)) {
      return normalizedTaskStart;
    }

    return rollingStart;
  }

  DateTime rangeEnd(DateTime today) => _dateOnly(today);
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);
