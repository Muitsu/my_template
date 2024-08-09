extension DatetimeExtension on DateTime {
  bool isNextDay() {
    final currDate = this;
    DateTime nextDay = DateTime.now().add(const Duration(days: 1));
    final isUnder24Hour = nextDay.difference(currDate).inDays.isBetween(0, 24);

    return isUnder24Hour ? (currDate.day == nextDay.day) : false;
  }
}

extension NumberComparison on num {
  bool isBetween(int a, int b) {
    int minValue = a < b ? a : b;
    int maxValue = a > b ? a : b;

    return this >= minValue && this <= maxValue;
  }
}
