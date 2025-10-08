import 'package:intl/intl.dart';

/// **DateTimeUtils**
///
/// A utility class providing helper methods for date and time operations.
///
/// **Features**:
/// - Date and time formatting with customizable patterns
/// - Date comparison utilities (today, yesterday, tomorrow, same day/month/year)
/// - Duration formatting for human-readable display
/// - Relative time calculations
///
/// **Usage**:
/// ```dart
/// // Format dates
/// String date = DateTimeUtils.formatDate(DateTime.now()); // 28/10/2024
/// String time = DateTimeUtils.formatTime(DateTime.now()); // 14:30
///
/// // Check date relationships
/// bool today = DateTimeUtils.isToday(someDate);
/// bool yesterday = DateTimeUtils.isYesterday(someDate);
///
/// // Format durations
/// String duration = DateTimeUtils.formatDuration(Duration(hours: 2, minutes: 5));
/// ```
class DateTimeUtils {
  DateTimeUtils._(); // Private constructor to prevent instantiation

  // Common date format patterns
  static const String defaultDateFormat = 'dd/MM/yyyy';
  static const String defaultTimeFormat = 'HH:mm';
  static const String defaultDateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String iso8601Format = 'yyyy-MM-ddTHH:mm:ss';

  /// Formats a given [date] into a time string with the specified [format].
  ///
  /// Defaults to 'HH:mm' (24-hour format).
  ///
  /// Example:
  /// ```dart
  /// String time = DateTimeUtils.formatTime(DateTime.now());
  /// print(time); // Output: 14:30
  /// ```
  static String formatTime(DateTime date, {String format = defaultTimeFormat}) {
    return DateFormat(format).format(date);
  }

  /// Formats a given [date] into a date string with the specified [format].
  ///
  /// Defaults to 'dd/MM/yyyy'.
  ///
  /// Example:
  /// ```dart
  /// String date = DateTimeUtils.formatDate(DateTime.now());
  /// print(date); // Output: 28/10/2024
  /// ```
  static String formatDate(DateTime date, {String format = defaultDateFormat}) {
    return DateFormat(format).format(date);
  }

  /// Formats a given [date] into a date-time string with the specified [format].
  ///
  /// Defaults to 'dd/MM/yyyy HH:mm'.
  ///
  /// Example:
  /// ```dart
  /// String dateTime = DateTimeUtils.formatDateTime(DateTime.now());
  /// print(dateTime); // Output: 28/10/2024 14:30
  /// ```
  static String formatDateTime(
    DateTime date, {
    String format = defaultDateTimeFormat,
  }) {
    return DateFormat(format).format(date);
  }

  /// Checks if the given [date] is today.
  ///
  /// Example:
  /// ```dart
  /// bool isToday = DateTimeUtils.isToday(DateTime.now());
  /// print(isToday); // Output: true
  /// ```
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return isSameDay(date, now);
  }

  /// Checks if the given [date] was yesterday.
  ///
  /// Example:
  /// ```dart
  /// bool wasYesterday = DateTimeUtils.isYesterday(someDate);
  /// ```
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }

  /// Checks if the given [date] is tomorrow.
  ///
  /// Example:
  /// ```dart
  /// bool isTomorrow = DateTimeUtils.isTomorrow(someDate);
  /// ```
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return isSameDay(date, tomorrow);
  }

  /// Checks if two dates are on the same day (ignoring time).
  ///
  /// Example:
  /// ```dart
  /// bool same = DateTimeUtils.isSameDay(date1, date2);
  /// ```
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Checks if two dates are in the same month.
  ///
  /// Example:
  /// ```dart
  /// bool sameMonth = DateTimeUtils.isSameMonth(date1, date2);
  /// ```
  static bool isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }

  /// Checks if two dates are in the same year.
  ///
  /// Example:
  /// ```dart
  /// bool sameYear = DateTimeUtils.isSameYear(date1, date2);
  /// ```
  static bool isSameYear(DateTime date1, DateTime date2) {
    return date1.year == date2.year;
  }

  /// Returns the start of the day (00:00:00) for the given [date].
  ///
  /// Example:
  /// ```dart
  /// DateTime start = DateTimeUtils.startOfDay(DateTime.now());
  /// ```
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Returns the end of the day (23:59:59.999) for the given [date].
  ///
  /// Example:
  /// ```dart
  /// DateTime end = DateTimeUtils.endOfDay(DateTime.now());
  /// ```
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Formats a [duration] into a human-readable string 'HH:mm:ss'.
  ///
  /// Example:
  /// ```dart
  /// String formatted = DateTimeUtils.formatDuration(Duration(hours: 2, minutes: 5));
  /// print(formatted); // Output: 02:05:00
  /// ```
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  /// Returns a human-readable relative time string (e.g., "2 hours ago", "in 3 days").
  ///
  /// Example:
  /// ```dart
  /// String relative = DateTimeUtils.timeAgo(DateTime.now().subtract(Duration(hours: 2)));
  /// print(relative); // Output: "2 hours ago"
  /// ```
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.isNegative) {
      // Future date
      final futureDiff = date.difference(now);
      if (futureDiff.inDays > 365) {
        final years = (futureDiff.inDays / 365).floor();
        return 'in $years ${years == 1 ? 'year' : 'years'}';
      } else if (futureDiff.inDays > 30) {
        final months = (futureDiff.inDays / 30).floor();
        return 'in $months ${months == 1 ? 'month' : 'months'}';
      } else if (futureDiff.inDays > 0) {
        return 'in ${futureDiff.inDays} ${futureDiff.inDays == 1 ? 'day' : 'days'}';
      } else if (futureDiff.inHours > 0) {
        return 'in ${futureDiff.inHours} ${futureDiff.inHours == 1 ? 'hour' : 'hours'}';
      } else if (futureDiff.inMinutes > 0) {
        return 'in ${futureDiff.inMinutes} ${futureDiff.inMinutes == 1 ? 'minute' : 'minutes'}';
      } else {
        return 'in a moment';
      }
    }

    // Past date
    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }

  /// Calculates the difference in days between two dates (ignoring time).
  ///
  /// Example:
  /// ```dart
  /// int days = DateTimeUtils.daysBetween(date1, date2);
  /// ```
  static int daysBetween(DateTime from, DateTime to) {
    final fromDate = startOfDay(from);
    final toDate = startOfDay(to);
    return toDate.difference(fromDate).inDays;
  }
}