import 'package:flutter/material.dart';

/// **ResponsiveUtils**
///
/// A utility class for handling responsive design and screen adaptations.
///
/// **Features**:
/// - Device type detection (mobile, tablet, desktop)
/// - Configurable breakpoints
/// - Responsive value selection based on screen size
/// - Font size scaling for different devices
/// - Screen dimension helpers
///
/// **Usage**:
/// ```dart
/// // Check device type
/// if (ResponsiveUtils.isMobile(context)) {
///   // Mobile layout
/// }
///
/// // Get responsive value
/// double padding = ResponsiveUtils.valueByDevice(
///   context,
///   mobile: 16,
///   tablet: 24,
///   desktop: 32,
/// );
///
/// // Scale font size
/// double fontSize = ResponsiveUtils.scaledFontSize(context, 16);
/// ```
class ResponsiveUtils {
  ResponsiveUtils._(); // Private constructor

  // ═══════════════════════════════════════════════════════════════════════════
  // Breakpoints
  // ═══════════════════════════════════════════════════════════════════════════

  /// Breakpoint for mobile devices (width < 600)
  static double mobileBreakpoint = 600;

  /// Breakpoint for tablets (width >= 600 && width < 1024)
  static double tabletBreakpoint = 1024;

  /// Breakpoint for desktop devices (width >= 1024 && width < 1440)
  static double desktopBreakpoint = 1440;

  /// Breakpoint for wide desktop devices (width >= 1440)
  static double wideBreakpoint = 1440;

  // ═══════════════════════════════════════════════════════════════════════════
  // Screen Dimensions
  // ═══════════════════════════════════════════════════════════════════════════

  /// Gets the screen height as a fraction of the total screen height.
  ///
  /// [percentage]: The percentage of the screen height to return (0.0 to 1.0).
  ///
  /// Example:
  /// ```dart
  /// double halfHeight = ResponsiveUtils.screenHeight(context, 0.5);
  /// ```
  static double screenHeight(BuildContext context, [double percentage = 1.0]) {
    return MediaQuery.of(context).size.height * percentage;
  }

  /// Gets the screen width as a fraction of the total screen width.
  ///
  /// [percentage]: The percentage of the screen width to return (0.0 to 1.0).
  ///
  /// Example:
  /// ```dart
  /// double halfWidth = ResponsiveUtils.screenWidth(context, 0.5);
  /// ```
  static double screenWidth(BuildContext context, [double percentage = 1.0]) {
    return MediaQuery.of(context).size.width * percentage;
  }

  /// Gets the device's pixel ratio.
  ///
  /// Example:
  /// ```dart
  /// double pixelRatio = ResponsiveUtils.pixelRatio(context);
  /// ```
  static double pixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Orientation
  // ═══════════════════════════════════════════════════════════════════════════

  /// Checks if the device is in portrait orientation.
  ///
  /// Example:
  /// ```dart
  /// bool isPortrait = ResponsiveUtils.isPortrait(context);
  /// ```
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Checks if the device is in landscape orientation.
  ///
  /// Example:
  /// ```dart
  /// bool isLandscape = ResponsiveUtils.isLandscape(context);
  /// ```
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Device Type Detection
  // ═══════════════════════════════════════════════════════════════════════════

  /// Gets the current device width (accounting for orientation).
  static double _getDeviceWidth(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return isPortrait(context) ? size.width : size.height;
  }

  /// Checks if the device is a mobile phone.
  ///
  /// Width < 600px
  ///
  /// Example:
  /// ```dart
  /// if (ResponsiveUtils.isMobile(context)) {
  ///   // Show mobile layout
  /// }
  /// ```
  static bool isMobile(BuildContext context) {
    return _getDeviceWidth(context) < mobileBreakpoint;
  }

  /// Checks if the device is a tablet.
  ///
  /// Width >= 600px && width < 1024px
  ///
  /// Example:
  /// ```dart
  /// if (ResponsiveUtils.isTablet(context)) {
  ///   // Show tablet layout
  /// }
  /// ```
  static bool isTablet(BuildContext context) {
    final width = _getDeviceWidth(context);
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Checks if the device is a desktop.
  ///
  /// Width >= 1024px && width < 1440px
  ///
  /// Example:
  /// ```dart
  /// if (ResponsiveUtils.isDesktop(context)) {
  ///   // Show desktop layout
  /// }
  /// ```
  static bool isDesktop(BuildContext context) {
    final width = _getDeviceWidth(context);
    return width >= tabletBreakpoint && width < wideBreakpoint;
  }

  /// Checks if the device is a wide desktop.
  ///
  /// Width >= 1440px
  ///
  /// Example:
  /// ```dart
  /// if (ResponsiveUtils.isWideDesktop(context)) {
  ///   // Show wide desktop layout
  /// }
  /// ```
  static bool isWideDesktop(BuildContext context) {
    return _getDeviceWidth(context) >= wideBreakpoint;
  }

  /// Gets the current device type as an enum.
  ///
  /// Example:
  /// ```dart
  /// DeviceType type = ResponsiveUtils.deviceType(context);
  /// switch (type) {
  ///   case DeviceType.mobile:
  ///     // Mobile layout
  ///   case DeviceType.tablet:
  ///     // Tablet layout
  ///   // ...
  /// }
  /// ```
  static DeviceType deviceType(BuildContext context) {
    if (isMobile(context)) return DeviceType.mobile;
    if (isTablet(context)) return DeviceType.tablet;
    if (isWideDesktop(context)) return DeviceType.wide;
    return DeviceType.desktop;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Responsive Values
  // ═══════════════════════════════════════════════════════════════════════════

  /// Returns different values based on the current device type.
  ///
  /// Falls back to mobile value if specific breakpoint value is not provided.
  ///
  /// Example:
  /// ```dart
  /// double padding = ResponsiveUtils.valueByDevice<double>(
  ///   context,
  ///   mobile: 16,
  ///   tablet: 24,
  ///   desktop: 32,
  ///   wide: 40,
  /// );
  /// ```
  static T valueByDevice<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? wide,
  }) {
    if (isWideDesktop(context)) return wide ?? desktop ?? tablet ?? mobile;
    if (isDesktop(context)) return desktop ?? tablet ?? mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return mobile;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Font Scaling
  // ═══════════════════════════════════════════════════════════════════════════

  /// Returns a scaled font size based on the device type.
  ///
  /// Scaling factors:
  /// - Mobile: 1.0x
  /// - Tablet: 1.1x
  /// - Desktop: 1.15x
  /// - Wide: 1.2x
  ///
  /// Example:
  /// ```dart
  /// double fontSize = ResponsiveUtils.scaledFontSize(context, 16);
  /// ```
  static double scaledFontSize(BuildContext context, double baseSize) {
    return valueByDevice<double>(
      context,
      mobile: baseSize,
      tablet: baseSize * 1.1,
      desktop: baseSize * 1.15,
      wide: baseSize * 1.2,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Padding & Spacing
  // ═══════════════════════════════════════════════════════════════════════════

  /// Returns device-appropriate padding.
  ///
  /// Default values:
  /// - Mobile: 16
  /// - Tablet: 24
  /// - Desktop: 32
  /// - Wide: 40
  ///
  /// Example:
  /// ```dart
  /// double padding = ResponsiveUtils.padding(context);
  /// ```
  static double padding(BuildContext context) {
    return valueByDevice<double>(
      context,
      mobile: 16,
      tablet: 24,
      desktop: 32,
      wide: 40,
    );
  }

  /// Returns device-appropriate margin.
  ///
  /// Same as [padding] but semantically different.
  static double margin(BuildContext context) => padding(context);

  /// Returns responsive column count for grid layouts.
  ///
  /// Default values:
  /// - Mobile: 2
  /// - Tablet: 3
  /// - Desktop: 4
  /// - Wide: 5
  ///
  /// Example:
  /// ```dart
  /// int columns = ResponsiveUtils.gridColumns(context);
  /// ```
  static int gridColumns(BuildContext context) {
    return valueByDevice<int>(
      context,
      mobile: 2,
      tablet: 3,
      desktop: 4,
      wide: 5,
    );
  }
}

/// Device type enum for responsive layouts.
enum DeviceType {
  /// Mobile phone (width < 600px)
  mobile,

  /// Tablet (width >= 600px && < 1024px)
  tablet,

  /// Desktop (width >= 1024px && < 1440px)
  desktop,

  /// Wide desktop (width >= 1440px)
  wide,
}
