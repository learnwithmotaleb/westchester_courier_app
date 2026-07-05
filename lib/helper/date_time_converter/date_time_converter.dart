import 'package:intl/intl.dart';

class DateTimeHelper {
  /// Convert ISO string to DateTime
  static DateTime _parse(String isoTime) {
    return DateTime.parse(isoTime).toLocal();
  }

  /// Only time (04:08 AM)
  static String time(String isoTime) {
    return DateFormat('hh:mm a').format(_parse(isoTime));
  }

  /// Only date (26 Jan 2026)
  static String date(String isoTime) {
    return DateFormat('dd MMM yyyy').format(_parse(isoTime));
  }

  /// Date + time (26 Jan 2026, 04:08 AM)
  static String dateTime(String isoTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(_parse(isoTime));
  }

  /// Weekday + time (Mon, 04:08 AM)
  static String weekdayTime(String isoTime) {
    return DateFormat('EEE, hh:mm a').format(_parse(isoTime));
  }

  /// Custom format
  static String custom(String isoTime, String pattern) {
    return DateFormat(pattern).format(_parse(isoTime));
  }
}
