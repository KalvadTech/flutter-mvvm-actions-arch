import 'package:flutter_test/flutter_test.dart';
import 'package:getx_starter/src/modules/locale/data/model/language_model.dart';

void main() {
  group('LanguageModel', () {
    group('constructor', () {
      test('creates instance with all required fields', () {
        const language = LanguageModel('English', 'en', 'GB');

        expect(language.name, equals('English'));
        expect(language.code, equals('en'));
        expect(language.countryCode, equals('GB'));
      });

      test('is const constructor', () {
        // Should be able to create const instances
        const english1 = LanguageModel('English', 'en', 'GB');
        const english2 = LanguageModel('English', 'en', 'GB');

        expect(identical(english1, english2), isTrue);
      });
    });

    group('properties', () {
      test('name property holds display name', () {
        const english = LanguageModel('English', 'en', 'GB');
        const arabic = LanguageModel('العربية', 'ar', 'AE');

        expect(english.name, equals('English'));
        expect(arabic.name, equals('العربية'));
      });

      test('code property holds ISO 639-1 language code', () {
        const english = LanguageModel('English', 'en', 'GB');
        const arabic = LanguageModel('العربية', 'ar', 'AE');

        expect(english.code, equals('en'));
        expect(arabic.code, equals('ar'));
        expect(english.code.length, equals(2));
        expect(arabic.code.length, equals(2));
      });

      test('countryCode property holds ISO 3166-1 country code', () {
        const english = LanguageModel('English', 'en', 'GB');
        const arabic = LanguageModel('العربية', 'ar', 'AE');

        expect(english.countryCode, equals('GB'));
        expect(arabic.countryCode, equals('AE'));
        expect(english.countryCode.length, equals(2));
        expect(arabic.countryCode.length, equals(2));
      });

      test('all properties are final', () {
        const language = LanguageModel('English', 'en', 'GB');

        // This test ensures the properties are final by checking
        // they can't be modified (compile-time check)
        expect(language.name, equals('English'));
        expect(language.code, equals('en'));
        expect(language.countryCode, equals('GB'));
      });
    });

    group('immutability', () {
      test('is immutable value object', () {
        const language = LanguageModel('English', 'en', 'GB');

        // All fields should be immutable
        expect(language.name, equals('English'));
        expect(language.code, equals('en'));
        expect(language.countryCode, equals('GB'));

        // Creating another instance with same values should be independent
        const sameLang = LanguageModel('English', 'en', 'GB');
        expect(identical(language, sameLang), isTrue); // const makes them identical
      });
    });

    group('real-world language examples', () {
      test('English (Great Britain)', () {
        const english = LanguageModel('English', 'en', 'GB');

        expect(english.name, equals('English'));
        expect(english.code, equals('en'));
        expect(english.countryCode, equals('GB'));
      });

      test('Arabic (United Arab Emirates)', () {
        const arabic = LanguageModel('العربية', 'ar', 'AE');

        expect(arabic.name, equals('العربية'));
        expect(arabic.code, equals('ar'));
        expect(arabic.countryCode, equals('AE'));
      });

      test('supports multiple English variants', () {
        const britishEnglish = LanguageModel('English (UK)', 'en', 'GB');
        const americanEnglish = LanguageModel('English (US)', 'en', 'US');

        expect(britishEnglish.code, equals('en'));
        expect(americanEnglish.code, equals('en'));
        expect(britishEnglish.countryCode, equals('GB'));
        expect(americanEnglish.countryCode, equals('US'));
      });

      test('supports multiple Arabic variants', () {
        const uaeArabic = LanguageModel('العربية (الإمارات)', 'ar', 'AE');
        const saudiArabic = LanguageModel('العربية (السعودية)', 'ar', 'SA');

        expect(uaeArabic.code, equals('ar'));
        expect(saudiArabic.code, equals('ar'));
        expect(uaeArabic.countryCode, equals('AE'));
        expect(saudiArabic.countryCode, equals('SA'));
      });
    });

    group('usage in collections', () {
      test('can be used in lists', () {
        const languages = [
          LanguageModel('English', 'en', 'GB'),
          LanguageModel('العربية', 'ar', 'AE'),
        ];

        expect(languages.length, equals(2));
        expect(languages[0].code, equals('en'));
        expect(languages[1].code, equals('ar'));
      });

      test('can be filtered by properties', () {
        const languages = [
          LanguageModel('English', 'en', 'GB'),
          LanguageModel('العربية', 'ar', 'AE'),
          LanguageModel('Français', 'fr', 'FR'),
        ];

        final arabic = languages.where((lang) => lang.code == 'ar').first;
        expect(arabic.name, equals('العربية'));

        final english = languages.where((lang) => lang.code == 'en').first;
        expect(english.name, equals('English'));
      });

      test('can be used as const in lists', () {
        const languages = [
          LanguageModel('English', 'en', 'GB'),
          LanguageModel('العربية', 'ar', 'AE'),
        ];

        // Should be compile-time const
        expect(languages, isNotEmpty);
      });
    });

    group('edge cases', () {
      test('handles empty strings (though not recommended)', () {
        const empty = LanguageModel('', '', '');

        expect(empty.name, equals(''));
        expect(empty.code, equals(''));
        expect(empty.countryCode, equals(''));
      });

      test('handles very long language names', () {
        const longName = LanguageModel(
          'English (International, United Kingdom, British)',
          'en',
          'GB',
        );

        expect(longName.name.length, greaterThan(20));
        expect(longName.code, equals('en'));
      });

      test('handles special characters in name', () {
        const withSpecial = LanguageModel('日本語 (Japanese)', 'ja', 'JP');

        expect(withSpecial.name, contains('日本語'));
        expect(withSpecial.code, equals('ja'));
      });
    });
  });
}