import 'package:intl/intl.dart';

/// **DateTime Extensions**
///
/// Extension methods for DateTime providing convenient date/time operations.
///
/// **Features**:
/// - Date comparison (today, yesterday, tomorrow, same day/month/year)
/// - Date formatting with customizable patterns
/// - Relative time calculations
/// - Duration formatting
///
/// **Usage**:
/// ```dart
/// final date = DateTime.now();
///
/// // Check date relationships
/// if (date.isToday) {
///   // Today's date
/// }
///
/// // Format dates
/// String formatted = date.format('dd/MM/yyyy');
///
/// // Get relative time
/// String relative = date.timeAgo();
/// ```
extension DateTimeExtensions on DateTime {
  // ═══════════════════════════════════════════════════════════════════════════
  // Date Comparisons
  // ═══════════════════════════════════════════════════════════════════════════

  /// Checks if this date is today.
  ///
  /// Example:
  /// ```dart
  /// bool isToday = DateTime.now().isToday; // true
  /// ```
  bool get isToday {
    final now = DateTime.now();
    return isSameDay(now);
  }

  /// Checks if this date was yesterday.
  ///
  /// Example:
  /// ```dart
  /// bool wasYesterday = someDate.isYesterday;
  /// ```
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(yesterday);
  }

  /// Checks if this date is tomorrow.
  ///
  /// Example:
  /// ```dart
  /// bool isTomorrow = someDate.isTomorrow;
  /// ```
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return isSameDay(tomorrow);
  }

  /// Checks if this date is on the same day as [other] (ignoring time).
  ///
  /// Example:
  /// ```dart
  /// bool same = date1.isSameDay(date2);
  /// ```
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Checks if this date is in the same month as [other].
  ///
  /// Example:
  /// ```dart
  /// bool sameMonth = date1.isSameMonth(date2);
  /// ```
  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  /// Checks if this date is in the same year as [other].
  ///
  /// Example:
  /// ```dart
  /// bool sameYear = date1.isSameYear(date2);
  /// ```
  bool isSameYear(DateTime other) {
    return year == other.year;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Date Manipulation
  // ═══════════════════════════════════════════════════════════════════════════

  /// Returns the start of the day (00:00:00) for this date.
  ///
  /// Example:
  /// ```dart
  /// DateTime start = DateTime.now().startOfDay;
  /// ```
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  /// Returns the end of the day (23:59:59.999) for this date.
  ///
  /// Example:
  /// ```dart
  /// DateTime end = DateTime.now().endOfDay;
  /// ```
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }

  /// Calculates the difference in days between this date and [other] (ignoring time).
  ///
  /// Example:
  /// ```dart
  /// int days = date1.daysBetween(date2);
  /// ```
  int daysBetween(DateTime other) {
    final fromDate = startOfDay;
    final toDate = other.startOfDay;
    return toDate.difference(fromDate).inDays;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Formatting
  // ═══════════════════════════════════════════════════════════════════════════

  /// Formats this date using the specified [pattern].
  ///
  /// Defaults to 'dd/MM/yyyy'.
  ///
  /// Example:
  /// ```dart
  /// String date = DateTime.now().format(); // 28/10/2024
  /// String custom = DateTime.now().format('yyyy-MM-dd'); // 2024-10-28
  /// ```
  String format([String pattern = 'dd/MM/yyyy']) {
    return DateFormat(pattern).format(this);
  }

  /// Formats this date as a time string.
  ///
  /// Defaults to 'HH:mm' (24-hour format).
  ///
  /// Example:
  /// ```dart
  /// String time = DateTime.now().formatTime(); // 14:30
  /// ```
  String formatTime([String pattern = 'HH:mm']) {
    return DateFormat(pattern).format(this);
  }

  /// Formats this date as a date-time string.
  ///
  /// Defaults to 'dd/MM/yyyy HH:mm'.
  ///
  /// Example:
  /// ```dart
  /// String dateTime = DateTime.now().formatDateTime(); // 28/10/2024 14:30
  /// ```
  String formatDateTime([String pattern = 'dd/MM/yyyy HH:mm']) {
    return DateFormat(pattern).format(this);
  }

  /// Returns a human-readable relative time string (e.g., "2 hours ago", "in 3 days").
  ///
  /// Example:
  /// ```dart
  /// String relative = DateTime.now().subtract(Duration(hours: 2)).timeAgo();
  /// print(relative); // "2 hours ago"
  /// ```
  String timeAgo() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.isNegative) {
      // Future date
      final futureDiff = this.difference(now);
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
}

/// **Duration Extensions**
///
/// Extension methods for Duration providing convenient formatting.
///
/// **Usage**:
/// ```dart
/// final duration = Duration(hours: 2, minutes: 5);
/// String formatted = duration.format(); // "02:05:00"
/// ```
extension DurationExtensions on Duration {
  /// Formats this duration into a human-readable string 'HH:mm:ss'.
  ///
  /// Example:
  /// ```dart
  /// String formatted = Duration(hours: 2, minutes: 5).format();
  /// print(formatted); // "02:05:00"
  /// ```
  String format() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(inHours);
    final minutes = twoDigits(inMinutes.remainder(60));
    final seconds = twoDigits(inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }
}
