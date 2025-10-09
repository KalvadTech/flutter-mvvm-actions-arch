import 'dart:ui';
import 'package:get/get.dart';
import '/src/infrastructure/storage/preferences_storage.dart';
import '/src/modules/locale/data/lang/lang.dart';

/// **LocalizationService**
///
/// Service responsible for managing application localization using GetX Translations.
/// Handles locale initialization, persistence, and provides fallback mechanisms.
///
/// **Why**
/// - Centralize locale management logic separate from UI concerns.
/// - Provide type-safe access to translations via GetX.
/// - Persist user language preference across app sessions.
///
/// **Key Features**
/// - Static initialization before app startup.
/// - Automatic fallback to device locale or English.
/// - Validation of saved language codes against supported languages.
/// - Integration with GetX translation system.
/// - Persistent storage via PreferencesStorage.
///
/// **Example**
/// ```dart
/// // In main.dart before runApp()
/// await AppStorageService.instance.initialize();
/// LocalizationService.init();
///
/// // Change language at runtime
/// LocalizationService.changeLocale('ar');
/// ```
///
// ────────────────────────────────────────────────
class LocalizationService extends Translations {
  /// The fallback locale used when the desired locale is not available.
  static const fallbackLocale = Locale('en');

  /// The current locale of the device or the fallback locale if unavailable.
  static Locale? _locale = Get.deviceLocale;

  /// Returns the current locale or the fallback locale if the current one is unavailable.
  static Locale get locale => _locale ?? fallbackLocale;

  /// **savedLanguageCode**
  ///
  /// Retrieves the saved language code from storage with fallback chain:
  /// 1. Saved preference (if valid)
  /// 2. Device locale
  /// 3. Fallback locale (English)
  ///
  /// **Returns**
  /// - `String`: Valid language code from supported languages
  static String get savedLanguageCode {
    try {
      final saved = PreferencesStorage.instance.languageCode;
      final supportedCodes = LocalizationService().keys.keys;

      // Validate saved code exists in supported translations
      if (saved != null && supportedCodes.contains(saved)) {
        return saved;
      }

      // Fallback to device locale if supported
      final deviceCode = Get.deviceLocale?.languageCode;
      if (deviceCode != null && supportedCodes.contains(deviceCode)) {
        return deviceCode;
      }

      // Final fallback
      return fallbackLocale.languageCode;
    } catch (e) {
      // If storage read fails, return fallback
      return fallbackLocale.languageCode;
    }
  }

  /// **init**
  ///
  /// Initializes localization by loading saved language preference and
  /// applying it to the GetX locale system.
  ///
  /// **Side Effects**
  /// - Reads from PreferencesStorage
  /// - Updates GetX locale if valid saved code found
  ///
  /// **Notes**
  /// - Should be called in main() after storage initialization
  /// - Safe to call multiple times (idempotent)
  ///
  // ────────────────────────────────────────────────
  static void init() {
    try {
      final languageCode = PreferencesStorage.instance.languageCode;
      final supportedCodes = LocalizationService().keys.keys;
      if (languageCode != null && supportedCodes.contains(languageCode)) {
        _updateLocale(languageCode);
      }
    } catch (e) {
      // Silently fail and use default locale
      // Storage might not be initialized yet
    }
  }

  /// **changeLocale**
  ///
  /// Changes the application locale to the specified language code and
  /// persists the choice to storage.
  ///
  /// **Parameters**
  /// - `languageCode`: Language code (e.g., 'en', 'ar')
  ///
  /// **Side Effects**
  /// - Updates GetX locale
  /// - Writes to PreferencesStorage
  /// - Triggers app-wide UI rebuild
  ///
  /// **Errors**
  /// - Silently ignores invalid language codes
  ///
  // ────────────────────────────────────────────────
  static void changeLocale(String languageCode) {
    final supportedCodes = LocalizationService().keys.keys;
    if (!supportedCodes.contains(languageCode)) {
      return; // Ignore invalid language codes
    }
    _updateLocale(languageCode);
    _saveLocale(languageCode);
  }

  /// Saves the selected language code to persistent storage.
  static void _saveLocale(String languageCode) {
    try {
      PreferencesStorage.instance.languageCode = languageCode;
    } catch (e) {
      // Storage write failed, but locale already updated in memory
    }
  }

  /// Updates the locale and applies it to the GetX instance.
  static void _updateLocale(String languageCode) {
    _locale = Locale(languageCode);
    // Only update GetX locale if not in test mode
    // In test mode, we just update the static _locale for testing
    if (!Get.testMode) {
      try {
        Get.updateLocale(_locale!);
      } catch (e) {
        // Locale update failed, but _locale is still updated in memory
      }
    }
  }

  /// A map containing all supported translations.
  @override
  Map<String, Map<String, String>> get keys => {
    'en': englishTranslationsMap,
    'ar': arabicTranslationsMap,
  };
}
