abstract final class TaskCardMetricTone {
  static const neutral = 'neutral';
  static const good = 'good';
  static const warning = 'warning';
  static const bad = 'bad';
}

class TaskCardMetric {
  const TaskCardMetric({
    required this.label,
    required this.value,
    required this.tone,
    this.detail,
  });

  final String label;
  final String value;
  final String tone;
  final String? detail;
}
