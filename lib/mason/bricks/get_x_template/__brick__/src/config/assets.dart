/// A manager class to store asset paths used across the app.
///
/// Prevents hardcoding asset paths multiple times and centralizes
/// the management of all images, icons, and other assets.
class AssetsManager {
  // Private constructor to prevent instantiation.
  AssetsManager._();

  // **Images**
  /// Path for the Opaala logo in white.
  static const String logoPath = 'assets/icons/logo.svg';

  /// Path for the application icon.
  static const String appIconPath = 'assets/icons/opaala.svg';

  // **Icons**
  /// Path for the home/requests icon.
  static const String homeIconPath = 'assets/icons/requests.svg';
}
