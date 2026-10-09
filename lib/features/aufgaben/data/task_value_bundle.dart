abstract final class TaskValueBundleType {
  static const timeInterval = 'time_interval';
  static const difference = 'difference';
  static const sum = 'sum';

  static const values = {timeInterval, difference, sum};
}

abstract final class TaskValueBundleDirection {
  static const firstMinusSecond = 'first_minus_second';
  static const secondMinusFirst = 'second_minus_first';

  static const values = {firstMinusSecond, secondMinusFirst};
}

abstract final class TaskValueBundleDisplayMode {
  static const combinedCard = 'combined_card';
  static const linkedCards = 'linked_cards';

  static const values = {combinedCard, linkedCards};
}
