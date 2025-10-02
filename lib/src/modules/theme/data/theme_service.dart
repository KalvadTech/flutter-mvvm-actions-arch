import '/src/infrastructure/storage/preferences_storage.dart';

/// The `ThemeService` class is responsible for handling theme-related data storage.
/// It uses the `GetStorage` package to save and retrieve the user's theme preferences locally.
class ThemeService {


  /// Constructor to initialize the `GetStorage` instance.
  ThemeService();

  /// Getter to retrieve the saved theme mode from storage.
  String? get themeMode => PreferencesStorage.instance.themeMode;

  /// Setter to update the stored theme mode.
  set themeMode(String? themeMode) => PreferencesStorage.instance.themeMode = themeMode;

  /// Saves the new theme mode to storage.
  void saveTheme(String newThemeMode) {
    themeMode = newThemeMode;
  }
}
