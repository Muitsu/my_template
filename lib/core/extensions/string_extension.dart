extension StringExtensions on String {
  String formatToTwoDecimals() {
    // Define the regex pattern to match integers and floating point numbers
    RegExp regex = RegExp(r'(\d+(\.\d{0,2})?)');

    // Use the regex to find and format numbers in the input string
    return replaceAllMapped(regex, (Match match) {
      // Get the matched number as a string
      String numberStr = match.group(0)!;

      // Convert the string to a double
      double number = double.parse(numberStr);

      // Format the number to two decimal places
      String formattedNumber = number.toStringAsFixed(2);

      return formattedNumber;
    });
  }
}

extension TimeRangeSorting on List<String> {
  void sortTimeRanges() {
    DateTime parseTime(String time) {
      final now = DateTime.now();
      final format = RegExp(r"(\d{2}):(\d{2})\s(AM|PM)");

      final match = format.firstMatch(time);
      if (match != null) {
        final hour = int.parse(match.group(1)!);
        final minute = int.parse(match.group(2)!);
        final period = match.group(3)!;

        final isPM = period == "PM" && hour != 12;
        final isAM = period == "AM" && hour == 12;

        return DateTime(now.year, now.month, now.day,
            isPM ? hour + 12 : (isAM ? 0 : hour), minute);
      }
      throw const FormatException("Invalid time format");
    }

    // Remove duplicates
    final uniqueTimeRanges = toSet().toList();

    clear();
    addAll(uniqueTimeRanges);

    // Sorting the list based on start time
    sort((a, b) {
      final startTimeA = a.split('-')[0].trim();
      final startTimeB = b.split('-')[0].trim();

      final dateTimeA = parseTime(startTimeA);
      final dateTimeB = parseTime(startTimeB);

      return dateTimeA.compareTo(dateTimeB);
    });
  }
}

extension MiddleEllipsis on String {
  String middleEllipsis(int maxLength) {
    // If the string is already shorter than or equal to maxLength, return it as is.
    if (length <= maxLength) {
      return this;
    }

    // The length of the ellipsis
    const ellipsis = '...';
    const ellipsisLength = ellipsis.length;

    // Calculate the length of the prefix and suffix
    final prefixLength = (maxLength - ellipsisLength) ~/ 2;
    final suffixLength = maxLength - ellipsisLength - prefixLength;

    // Create the truncated string
    final truncatedString = substring(0, prefixLength) +
        ellipsis +
        substring(length - suffixLength);

    return truncatedString;
  }
}

extension StringNumExtensions on String {
  String toTwoDecimalPoints() {
    // Try to parse the string as a double
    double? number = double.tryParse(this);

    // If parsing is successful, return the number formatted to 2 decimal points
    if (number != null) {
      return number.toStringAsFixed(2);
    } else {
      // If parsing fails, return the original string or handle as needed
      return this;
    }
  }
}
