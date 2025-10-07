import 'dart:isolate';
import 'package:intl/intl.dart';

/// Utility class containing helper methods for formatting, time operations, and parallel processing.
class Utils {

  /// Runs a given synchronous [function] in an isolate to avoid blocking the main thread.
  ///
  /// Returns the result of the function as a Future.
  ///
  /// Example:
  /// ```dart
  /// final result = await Utils.isolator(() => someHeavyComputation());
  /// ```
  static Future<T> isolator<T>(T Function() function) async {
    ReceivePort receivePort = ReceivePort(); // Creates a port to receive data from the isolate.
    await Isolate.spawn((message) {
      T result = function(); // Executes the function.
      Isolate.exit(message as SendPort?, result); // Sends the result back to the main thread.
    }, receivePort.sendPort);
    return await receivePort.first as T; // Returns the result.
  }

  /// Formats a given [date] into a string with the specified [format], defaulting to 'HH:mm'.
  ///
  /// Example:
  /// ```dart
  /// String formattedTime = Utils.formatTimeFromDate(DateTime.now());
  /// print(formattedTime); // Output: 14:30
  /// ```
  static String formatTimeFromDate(DateTime date, {String format = 'HH:mm'}) {
    return DateFormat(format).format(date);
  }

  /// Formats a given [date] into a string with the specified [format], defaulting to 'dd/MM/yyyy'.
  ///
  /// Example:
  /// ```dart
  /// String formattedDate = Utils.formatDate(DateTime.now());
  /// print(formattedDate); // Output: 28/10/2024
  /// ```
  static String formatDate(DateTime date, {String format = 'dd/MM/yyyy'}) {
    return DateFormat(format).format(date);
  }

  /// Checks if the given [date] is today's date.
  ///
  /// Example:
  /// ```dart
  /// bool isToday = Utils.isToday(DateTime.now());
  /// print(isToday); // Output: true
  /// ```
  static bool isToday(DateTime date) {
    final now = DateTime.now(); // Gets the current date and time.
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  /// Converts a [duration] into a formatted string 'HH:mm:ss'.
  ///
  /// Example:
  /// ```dart
  /// String formattedDuration = Utils.printDuration(Duration(hours: 2, minutes: 5));
  /// print(formattedDuration); // Output: 02:05:00
  /// ```
  static String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0"); // Ensures two-digit formatting.
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
