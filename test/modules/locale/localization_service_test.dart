import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_starter/src/modules/locale/data/services/localization_service.dart';
import 'package:getx_starter/src/infrastructure/storage/preferences_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalizationService', () {
    setUp(() {
      // Initialize GetX for testing
      Get.testMode = true;
    });

    tearDown(() {
      Get.reset();
    });

    group('savedLanguageCode', () {
      test('returns fallback locale code when no saved preference', () {
        // When no language is saved, should return fallback (English)
        final code = LocalizationService.savedLanguageCode;
        expect(code, equals('en'));
      });

      test('validates saved code against supported languages', () {
        // The service should validate against supported translations
        final code = LocalizationService.savedLanguageCode;
        final supportedCodes = LocalizationService().keys.keys;
        expect(supportedCodes.contains(code), isTrue);
      });
    });

    group('fallbackLocale', () {
      test('is set to English', () {
        expect(LocalizationService.fallbackLocale, equals(const Locale('en')));
      });
    });

    group('keys', () {
      test('contains English translations', () {
        final service = LocalizationService();
        expect(service.keys.containsKey('en'), isTrue);
      });

      test('contains Arabic translations', () {
        final service = LocalizationService();
        expect(service.keys.containsKey('ar'), isTrue);
      });

      test('English translations are not empty', () {
        final service = LocalizationService();
        final enTranslations = service.keys['en'];
        expect(enTranslations, isNotNull);
        expect(enTranslations!.isNotEmpty, isTrue);
      });

      test('Arabic translations are not empty', () {
        final service = LocalizationService();
        final arTranslations = service.keys['ar'];
        expect(arTranslations, isNotNull);
        expect(arTranslations!.isNotEmpty, isTrue);
      });

      test('both languages have same keys', () {
        final service = LocalizationService();
        final enKeys = service.keys['en']!.keys.toSet();
        final arKeys = service.keys['ar']!.keys.toSet();

        // Check if all English keys exist in Arabic
        expect(arKeys.containsAll(enKeys), isTrue,
            reason: 'Arabic translations should contain all English keys');

        // Check if all Arabic keys exist in English
        expect(enKeys.containsAll(arKeys), isTrue,
            reason: 'English translations should contain all Arabic keys');
      });
    });

    group('changeLocale', () {
      test('ignores invalid language codes', () {
        // Should not throw when given invalid code
        expect(() => LocalizationService.changeLocale('invalid'), returnsNormally);
      });

      test('accepts valid language codes', () {
        // Should not throw when given valid codes
        expect(() => LocalizationService.changeLocale('en'), returnsNormally);
        expect(() => LocalizationService.changeLocale('ar'), returnsNormally);
      });
    });

    group('init', () {
      test('does not throw when called multiple times', () {
        // Should be idempotent
        expect(() {
          LocalizationService.init();
          LocalizationService.init();
          LocalizationService.init();
        }, returnsNormally);
      });
    });

    group('Translation keys', () {
      test('app name key exists in both languages', () {
        final service = LocalizationService();
        expect(service.keys['en']!.containsKey('app.name'), isTrue);
        expect(service.keys['ar']!.containsKey('app.name'), isTrue);
      });

      test('auth input keys exist', () {
        final service = LocalizationService();
        final enKeys = service.keys['en']!;

        expect(enKeys.containsKey('auth.inputs.username'), isTrue);
        expect(enKeys.containsKey('auth.inputs.email'), isTrue);
        expect(enKeys.containsKey('auth.inputs.password'), isTrue);
        expect(enKeys.containsKey('auth.inputs.phone'), isTrue);
      });

      test('validation message keys exist', () {
        final service = LocalizationService();
        final enKeys = service.keys['en']!;

        expect(enKeys.containsKey('validations.email.empty'), isTrue);
        expect(enKeys.containsKey('validations.email.notValid'), isTrue);
        expect(enKeys.containsKey('validations.password.empty'), isTrue);
      });

      test('error message keys exist', () {
        final service = LocalizationService();
        final enKeys = service.keys['en']!;

        expect(enKeys.containsKey('errors.generic'), isTrue);
        expect(enKeys.containsKey('errors.network'), isTrue);
        expect(enKeys.containsKey('errors.noInternet'), isTrue);
      });

      test('page title keys exist', () {
        final service = LocalizationService();
        final enKeys = service.keys['en']!;

        expect(enKeys.containsKey('pages.home.title'), isTrue);
        expect(enKeys.containsKey('pages.login.title'), isTrue);
        expect(enKeys.containsKey('pages.register.title'), isTrue);
      });

      test('button label keys exist', () {
        final service = LocalizationService();
        final enKeys = service.keys['en']!;

        expect(enKeys.containsKey('buttons.confirm'), isTrue);
        expect(enKeys.containsKey('buttons.login'), isTrue);
        expect(enKeys.containsKey('buttons.register'), isTrue);
      });
    });
  });
}