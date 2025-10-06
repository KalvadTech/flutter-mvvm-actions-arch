import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../data/services/localization_service.dart';

/// A list of supported languages with their respective codes and country codes.
List<LanguageModel> supportedLanguage = [
  LanguageModel('English', 'en', 'GB'),
  LanguageModel('العربية', 'ar', 'AE'),
];

/// **LocalizationViewModel**
///
/// GetX controller responsible for managing app-wide localization state and
/// language switching with persistence via [LocalizationService].
///
/// **Why**
/// - Provide a single entry point for locale changes across the app.
/// - Keep views reactive via observable [language] property.
///
/// **Key Features**
/// - Reactive `language` property exposed to UI.
/// - Persists selected locale using [LocalizationService].
/// - Initializes date formatting for the selected locale.
/// - Fetches default language from storage on startup.
///
/// **Example**
/// ```dart
/// final localeVM = Get.find<LocalizationViewModel>();
/// await localeVM.selectLanguage(LanguageModel('العربية', 'ar', 'AE'));
/// ```
///
// ────────────────────────────────────────────────
class LocalizationViewModel extends GetxController {
  /// Observable to keep track of the currently selected language.
  final Rx<LanguageModel> _language = LanguageModel('English', 'en', 'GB').obs;

  /// Getter for the currently selected language.
  LanguageModel get language => _language.value;

  /// Constructor to initialize and fetch the default language on startup.
  LocalizationViewModel() {
    _fetchDefaultLanguage();
  }

  /// Fetches the default language from the saved preferences and sets it.
  Future _fetchDefaultLanguage() async {
    LocalizationService.init(); // Initialize the localization service.
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate a small delay.
    final newLang = supportedLanguage.firstWhere(
          (element) => element.code == LocalizationService.savedLanguageCode,
    );
    selectLanguage(newLang); // Set the fetched language.
  }

  /// Updates the selected language and applies it throughout the app.
  Future selectLanguage(LanguageModel languageModel) async {
    _language.value = languageModel;
    LocalizationService.changeLocale(languageModel.code); // Change app locale.
    await initializeDateFormatting(languageModel.code, null); // Update date formatting.
  }

  /// Handler for language dropdown changes.
  void onChange(LanguageModel? value) {
    if (value != null) {
      _language.value = value; // Update the selected language.
    }
  }

  /// Saves the current language change to preferences.
  void saveLanguageChange() {
    LocalizationService.changeLocale(_language.value.code); // Save the selected locale.
  }

  /// Dismisses the language selection and reverts to the default saved language.
  void dismiss() {
    _language.value = supportedLanguage.firstWhere(
          (element) => Get.locale!.languageCode == element.code,
    );
  }
}

/// Model to represent a language with its name, language code, and country code.
class LanguageModel {
  final String name; // The display name of the language.
  final String code; // The language code (e.g., 'en', 'ar').
  final String countryCode; // The country code associated with the language.

  /// Constructor for `LanguageModel`.
  LanguageModel(this.name, this.code, this.countryCode);
}
