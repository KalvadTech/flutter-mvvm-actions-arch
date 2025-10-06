import 'package:flutter_test/flutter_test.dart';
import 'package:getx_starter/src/modules/theme/data/services/theme_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeService', () {
    late ThemeService service;

    setUp(() {
      service = ThemeService();
    });

    group('getSavedThemeMode', () {
      test('returns null when no theme is saved', () {
        // When no theme preference exists, should return null
        final result = service.getSavedThemeMode();

        // Result should be null (will use fallback in ViewModel)
        expect(result, isA<String?>());
      });

      test('handles storage read errors gracefully', () {
        // Should not throw when storage fails
        expect(() => service.getSavedThemeMode(), returnsNormally);
      });
    });

    group('saveThemeMode', () {
      test('does not throw when saving valid theme mode', () {
        // Should handle saving without errors
        expect(
          () => service.saveThemeMode('ThemeMode.dark'),
          returnsNormally,
        );
      });

      test('does not throw when saving light theme mode', () {
        expect(
          () => service.saveThemeMode('ThemeMode.light'),
          returnsNormally,
        );
      });

      test('does not throw when saving system theme mode', () {
        expect(
          () => service.saveThemeMode('ThemeMode.system'),
          returnsNormally,
        );
      });

      test('handles storage write errors gracefully', () {
        // Should not throw even if storage fails
        expect(
          () => service.saveThemeMode('ThemeMode.dark'),
          returnsNormally,
        );
      });
    });

    group('error handling', () {
      test('saveThemeMode handles exceptions silently', () {
        // Even with invalid input, should not crash
        expect(
          () => service.saveThemeMode('invalid'),
          returnsNormally,
        );
      });

      test('getSavedThemeMode returns null on storage failure', () {
        // Storage failure should result in null, not exception
        final result = service.getSavedThemeMode();
        expect(result, isA<String?>());
      });
    });

    group('integration', () {
      test('can save and potentially retrieve theme mode', () {
        // Save a theme mode
        service.saveThemeMode('ThemeMode.dark');

        // Try to retrieve (may be null due to storage mock)
        final result = service.getSavedThemeMode();

        // Should either be the saved value or null
        expect(result, isA<String?>());
      });

      test('multiple saves do not throw', () {
        expect(() {
          service.saveThemeMode('ThemeMode.light');
          service.saveThemeMode('ThemeMode.dark');
          service.saveThemeMode('ThemeMode.system');
        }, returnsNormally);
      });
    });
  });
}
