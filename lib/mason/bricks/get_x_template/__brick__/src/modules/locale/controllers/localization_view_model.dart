import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../data/models/language_model.dart';
import '../data/services/localization_service.dart';

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
  /// List of supported languages with their respective codes and country codes.
  static const List<LanguageModel> supportedLanguages = [
    LanguageModel('English', 'en', 'GB'),
    LanguageModel('العربية', 'ar', 'AE'),
  ];

  /// Observable to keep track of the currently selected language.
  late final Rx<LanguageModel> _language;

  /// Getter for the currently selected language.
  LanguageModel get language => _language.value;

  @override
  void onInit() {
    super.onInit();
    _initializeLanguage();
  }

  /// Initializes the language from saved preferences or device locale.
  void _initializeLanguage() {
    final savedCode = LocalizationService.savedLanguageCode;
    final initialLanguage = supportedLanguages.firstWhere(
      (lang) => lang.code == savedCode,
      orElse: () => supportedLanguages.first,
    );
    _language = initialLanguage.obs;
    selectLanguage(initialLanguage);
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
    final currentLocale = Get.locale?.languageCode ?? LocalizationService.fallbackLocale.languageCode;
    _language.value = supportedLanguages.firstWhere(
      (element) => currentLocale == element.code,
      orElse: () => supportedLanguages.first,
    );
  }
}
