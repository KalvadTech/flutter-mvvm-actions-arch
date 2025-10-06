import '/src/infrastructure/storage/preferences_storage.dart';

/// **ThemeService**
///
/// Service responsible for persisting and retrieving user theme preferences.
///
/// **Why**
/// - Decouple theme persistence logic from ViewModels.
/// - Provide a clean interface for theme storage operations.
///
/// **Key Features**
/// - Reads saved theme mode from persistent storage.
/// - Writes theme mode preference with error handling.
/// - Uses PreferencesStorage for lightweight key-value storage.
///
/// **Example**
/// ```dart
/// final service = ThemeService();
/// service.saveThemeMode('ThemeMode.dark');
/// final saved = service.getSavedThemeMode();
/// ```
///
// ────────────────────────────────────────────────
class ThemeService {
  /// **getSavedThemeMode**
  ///
  /// Retrieves the saved theme mode from storage.
  ///
  /// **Returns**
  /// - `String?`: Saved theme mode string or null if not set.
  ///
  // ────────────────────────────────────────────────
  String? getSavedThemeMode() {
    try {
      return PreferencesStorage.instance.themeMode;
    } catch (e) {
      // Storage read failed, return null to use fallback
      return null;
    }
  }

  /// **saveThemeMode**
  ///
  /// Persists the theme mode to storage.
  ///
  /// **Parameters**
  /// - `themeMode`: Theme mode string to save (e.g., 'ThemeMode.dark').
  ///
  /// **Side Effects**
  /// - Writes to persistent storage via PreferencesStorage.
  ///
  /// **Errors**
  /// - Silently catches storage write failures.
  ///
  // ────────────────────────────────────────────────
  void saveThemeMode(String themeMode) {
    try {
      PreferencesStorage.instance.themeMode = themeMode;
    } catch (e) {
      // Storage write failed, but theme is already updated in memory
    }
  }
}
