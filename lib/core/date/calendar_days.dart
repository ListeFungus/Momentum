/// Local civil dates: adding a day is not adding 24 hours across DST.
DateTime calendarDay(DateTime value) =>
    DateTime(value.year, value.month, value.day);

DateTime calendarAddDays(DateTime value, int days) =>
    DateTime(value.year, value.month, value.day + days);

/// Count date labels, not elapsed local hours. UTC is only used for arithmetic;
/// the original instants are deliberately not converted with toUtc().
int calendarDaysBetween(DateTime start, DateTime end) =>
    DateTime.utc(
      end.year,
      end.month,
      end.day,
    ).difference(DateTime.utc(start.year, start.month, start.day)).inDays;
