abstract final class TaskValueType {
  static const none = 'none';
  static const number = 'number';
  static const duration = 'duration';
  static const timeOfDay = 'time_of_day';

  static const values = {none, number, duration, timeOfDay};
  static const phase12Values = {number, duration, timeOfDay};
}
