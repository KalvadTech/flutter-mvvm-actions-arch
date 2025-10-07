import 'package:flutter/cupertino.dart';

/// Utility class for handling screen size, orientation, and responsive design adjustments.
class ScreenUtils {
  /// Padding values for different screen sizes.
  static const double largeScreenPadding = 12;
  static const double smallScreenPadding = 12;

  /// Checks if the device is in portrait orientation.
  ///
  /// Example:
  /// ```dart
  /// bool isPortrait = ScreenUtils.isPortrait(context);
  /// ```
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Gets the screen height as a fraction of the total screen height.
  ///
  /// `screenPercentage`: The percentage of the screen height to return (default is 1, the full height).
  ///
  /// Example:
  /// ```dart
  /// double halfHeight = ScreenUtils.getScreenHeight(context, 0.5);
  /// ```
  static double getScreenHeight(BuildContext context, [double screenPercentage = 1]) {
    return MediaQuery.of(context).size.height * screenPercentage;
  }

  /// Gets the screen width as a fraction of the total screen width.
  ///
  /// `screenPercentage`: The percentage of the screen width to return (default is 1, the full width).
  ///
  /// Example:
  /// ```dart
  /// double halfWidth = ScreenUtils.getScreenWidth(context, 0.5);
  /// ```
  static double getScreenWidth(BuildContext context, [double screenPercentage = 1]) {
    return MediaQuery.of(context).size.width * screenPercentage;
  }

  /// Determines if the device is a tablet based on screen width.
  ///
  /// A width greater than 600 is considered a tablet.
  ///
  /// Example:
  /// ```dart
  /// bool isTablet = ScreenUtils.isTablet(context);
  /// ```
  static bool isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = isPortrait(context) ? size.width : size.height;
    return width > 600;
  }

  /// Returns the font size, adjusting for tablets if applicable.
  ///
  /// `fontSize`: The base font size.
  ///
  /// Example:
  /// ```dart
  /// double adjustedFontSize = ScreenUtils.getFontSize(context, 16);
  /// ```
  static double getFontSize(BuildContext context, double fontSize) {
    return isTablet(context) ? fontSize * 1.05 : fontSize;
  }

  /// Provides default padding based on whether the device is a tablet or mobile.
  ///
  /// Example:
  /// ```dart
  /// double padding = ScreenUtils.getDefaultPadding(context);
  /// ```
  static double getDefaultPadding(BuildContext context) {
    return isTablet(context) ? largeScreenPadding : smallScreenPadding;
  }
}
