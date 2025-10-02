import 'dart:ui';
import 'package:get/get.dart';
import '/src/infrastructure/storage/preferences_storage.dart';
import '/src/modules/locale/data/lang/lang.dart';

/// A service for managing localization using GetX.
/// This service handles the retrieval and saving of the user's language preferences,
/// and it also provides the fallback locale for the application.
class LocalizationService extends Translations {
  /// The fallback locale used when the desired locale is not available.
  static const fallbackLocale = Locale('en');

  /// The current locale of the device or the fallback locale if unavailable.
  static Locale? _locale = Get.deviceLocale;

  /// Returns the current locale or the fallback locale if the current one is unavailable.
  static Locale get locale => _locale ?? fallbackLocale;

  /// Retrieves the saved language code or the device's locale code if none is saved.
  static String get savedLanguageCode {
    return PreferencesStorage.instance.languageCode ??
        Get.deviceLocale?.languageCode ??
        fallbackLocale.languageCode;
  }

  /// Initializes the localization by checking if a language code is saved
  /// and updates the locale accordingly.
  static init() {
    String? languageCode = PreferencesStorage.instance.languageCode;
    if (languageCode != null) {
      _updateLocale(languageCode);
    }
  }

  /// Saves the selected language code to persistent storage.
  static void _saveLocale(String languageCode) {
    PreferencesStorage.instance.languageCode = languageCode;
  }

  /// Updates the locale and applies it to the GetX instance.
  static void _updateLocale(String languageCode) {
    _locale = Locale(languageCode);
    Get.updateLocale(_locale!);
  }

  /// Changes the current locale and saves the new language code.
  static void changeLocale(String languageCode) {
    _updateLocale(languageCode);
    _saveLocale(languageCode);
  }

  /// A map containing all supported translations.
  @override
  Map<String, Map<String, String>> get keys => {
    'en': englishTranslationsMap,
    'ar': arabicTranslationsMap,
  };
}
