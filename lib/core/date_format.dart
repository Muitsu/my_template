import 'package:intl/intl.dart';

class FormatDate {
  static String formatTo({required String date, required String format}) {
    DateTime stringToDate = DateTime.parse(date);
    final DateFormat formatter1 = DateFormat(format);
    final String formatDate1 = formatter1.format(stringToDate);
    return formatDate1;
  }
}
