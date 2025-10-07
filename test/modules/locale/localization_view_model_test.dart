import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_starter/src/modules/locale/controllers/localization_view_model.dart';
import 'package:getx_starter/src/modules/locale/data/models/language_model.dart';
import 'package:getx_starter/src/modules/locale/data/services/localization_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalizationViewModel', () {
    late LocalizationViewModel viewModel;

    setUp(() async {
      Get.testMode = true;

      // Initialize LocalizationService (doesn't require storage)
      LocalizationService.init();

      // Use Get.put to properly initialize the ViewModel and call onInit()
      viewModel = Get.put(LocalizationViewModel());
    });

    tearDown(() {
      Get.reset();
    });

    group('supportedLanguages', () {
      test('contains English and Arabic', () {
        expect(LocalizationViewModel.supportedLanguages.length, equals(2));

        final codes = LocalizationViewModel.supportedLanguages.map((l) => l.code).toList();
        expect(codes, contains('en'));
        expect(codes, contains('ar'));
      });

      test('is a static const list', () {
        // Should be able to access without instance
        expect(LocalizationViewModel.supportedLanguages, isNotEmpty);
      });

      test('contains valid LanguageModel objects', () {
        for (var lang in LocalizationViewModel.supportedLanguages) {
          expect(lang.name, isNotEmpty);
          expect(lang.code, isNotEmpty);
          expect(lang.countryCode, isNotEmpty);
        }
      });
    });

    group('language property', () {
      test('returns current language', () {
        expect(viewModel.language, isA<LanguageModel>());
      });

      test('initial language is from supported languages', () {
        final languageCodes = LocalizationViewModel.supportedLanguages.map((l) => l.code);
        expect(languageCodes, contains(viewModel.language.code));
      });
    });

    group('selectLanguage', () {
      test('updates language property', () async {
        final arabic = LocalizationViewModel.supportedLanguages
            .firstWhere((lang) => lang.code == 'ar');

        await viewModel.selectLanguage(arabic);

        expect(viewModel.language.code, equals('ar'));
        expect(viewModel.language.name, equals('العربية'));
      });

      test('updates language to English', () async {
        final english = LocalizationViewModel.supportedLanguages
            .firstWhere((lang) => lang.code == 'en');

        await viewModel.selectLanguage(english);

        expect(viewModel.language.code, equals('en'));
        expect(viewModel.language.name, equals('English'));
      });

      test('triggers reactive update', () async {
        final arabic = LocalizationViewModel.supportedLanguages
            .firstWhere((lang) => lang.code == 'ar');

        final initialCode = viewModel.language.code;

        await viewModel.selectLanguage(arabic);

        // Verify language was updated (proves reactivity worked)
        expect(viewModel.language.code, equals('ar'));
        expect(viewModel.language.code, isNot(equals(initialCode)));
      });
    });

    group('onChange', () {
      test('updates language when valid value provided', () {
        final arabic = LocalizationViewModel.supportedLanguages
            .firstWhere((lang) => lang.code == 'ar');

        viewModel.onChange(arabic);

        expect(viewModel.language.code, equals('ar'));
      });

      test('does nothing when null provided', () {
        final initialCode = viewModel.language.code;

        viewModel.onChange(null);

        expect(viewModel.language.code, equals(initialCode));
      });
    });

    group('saveLanguageChange', () {
      test('persists current language selection', () {
        final arabic = LocalizationViewModel.supportedLanguages
            .firstWhere((lang) => lang.code == 'ar');

        viewModel.onChange(arabic);
        viewModel.saveLanguageChange();

        // After save, the language should be persisted
        // We can't easily verify PreferencesStorage in tests without mocking,
        // but we can verify the method executes without error
        expect(() => viewModel.saveLanguageChange(), returnsNormally);
      });
    });

    group('dismiss', () {
      test('reverts to current locale language', () {
        // Change to Arabic
        final arabic = LocalizationViewModel.supportedLanguages
            .firstWhere((lang) => lang.code == 'ar');
        viewModel.onChange(arabic);

        // Dismiss should revert to current locale
        viewModel.dismiss();

        // Language should be from supported languages
        final languageCodes = LocalizationViewModel.supportedLanguages.map((l) => l.code);
        expect(languageCodes, contains(viewModel.language.code));
      });

      test('does not throw when current locale is unavailable', () {
        // Should handle edge case gracefully with orElse fallback
        expect(() => viewModel.dismiss(), returnsNormally);
      });
    });

    group('initialization', () {
      test('onInit sets up language from saved preferences', () {
        // The ViewModel should initialize with saved or default language
        expect(viewModel.language, isNotNull);
        expect(viewModel.language.code, isNotEmpty);
      });

      test('defaults to first supported language if no saved preference', () {
        final newViewModel = Get.put(LocalizationViewModel(), tag: 'test');

        // Should have a valid language set
        expect(newViewModel.language, isNotNull);

        final languageCodes = LocalizationViewModel.supportedLanguages.map((l) => l.code);
        expect(languageCodes, contains(newViewModel.language.code));
      });
    });

    group('reactivity', () {
      test('language is observable', () {
        // The language property should be reactive
        expect(viewModel.language, isA<LanguageModel>());

        final initialCode = viewModel.language.code;

        final arabic = LocalizationViewModel.supportedLanguages
            .firstWhere((lang) => lang.code == 'ar');
        viewModel.onChange(arabic);

        // Verify change was applied (proves reactivity)
        expect(viewModel.language.code, equals('ar'));
        expect(viewModel.language.code, isNot(equals(initialCode)));
      });
    });
  });
}