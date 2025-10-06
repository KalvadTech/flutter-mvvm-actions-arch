import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_starter/src/modules/theme/controllers/theme_view_model.dart';
import 'package:getx_starter/src/modules/theme/data/services/theme_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeViewModel', () {
    late ThemeViewModel viewModel;
    late ThemeService service;

    setUp(() {
      Get.testMode = true;
      service = ThemeService();
      viewModel = Get.put(ThemeViewModel(service));
    });

    tearDown(() {
      Get.reset();
    });

    group('initialization', () {
      test('initializes with fallback theme when no saved preference', () {
        expect(viewModel.themeMode, isA<ThemeMode>());
      });

      test('fallback theme is light mode', () {
        expect(ThemeViewModel.fallbackTheme, equals(ThemeMode.light));
      });

      test('onInit sets up theme from saved preferences or fallback', () {
        // ViewModel should be initialized
        expect(viewModel.themeMode, isNotNull);
      });

      test('isDark is false for light theme', () {
        viewModel.changeTheme(ThemeMode.light);
        expect(viewModel.isDark, isFalse);
      });

      test('isDark is true for dark theme', () {
        viewModel.changeTheme(ThemeMode.dark);
        expect(viewModel.isDark, isTrue);
      });
    });

    group('changeTheme', () {
      test('changes theme to dark mode', () {
        viewModel.changeTheme(ThemeMode.dark);

        expect(viewModel.themeMode, equals(ThemeMode.dark));
        expect(viewModel.isDark, isTrue);
      });

      test('changes theme to light mode', () {
        viewModel.changeTheme(ThemeMode.light);

        expect(viewModel.themeMode, equals(ThemeMode.light));
        expect(viewModel.isDark, isFalse);
      });

      test('changes theme to system mode', () {
        viewModel.changeTheme(ThemeMode.system);

        expect(viewModel.themeMode, equals(ThemeMode.system));
        expect(viewModel.isDark, isFalse); // system defaults to false
      });

      test('persists theme change via service', () {
        viewModel.changeTheme(ThemeMode.dark);

        // Service saveThemeMode should have been called
        // (we can't verify without mocking, but it should not throw)
        expect(viewModel.themeMode, equals(ThemeMode.dark));
      });

      test('updates reactive isDark property', () {
        viewModel.changeTheme(ThemeMode.light);
        expect(viewModel.isDark, isFalse);

        viewModel.changeTheme(ThemeMode.dark);
        expect(viewModel.isDark, isTrue);
      });
    });

    group('toggleTheme', () {
      test('toggles from light to dark', () {
        viewModel.changeTheme(ThemeMode.light);
        expect(viewModel.isDark, isFalse);

        viewModel.toggleTheme();

        expect(viewModel.themeMode, equals(ThemeMode.dark));
        expect(viewModel.isDark, isTrue);
      });

      test('toggles from dark to light', () {
        viewModel.changeTheme(ThemeMode.dark);
        expect(viewModel.isDark, isTrue);

        viewModel.toggleTheme();

        expect(viewModel.themeMode, equals(ThemeMode.light));
        expect(viewModel.isDark, isFalse);
      });

      test('multiple toggles alternate correctly', () {
        viewModel.changeTheme(ThemeMode.light);

        viewModel.toggleTheme();
        expect(viewModel.themeMode, equals(ThemeMode.dark));

        viewModel.toggleTheme();
        expect(viewModel.themeMode, equals(ThemeMode.light));

        viewModel.toggleTheme();
        expect(viewModel.themeMode, equals(ThemeMode.dark));
      });
    });

    group('reactive properties', () {
      test('themeMode is reactive', () {
        final initialMode = viewModel.themeMode;

        viewModel.changeTheme(ThemeMode.dark);

        expect(viewModel.themeMode, isNot(equals(initialMode)));
        expect(viewModel.themeMode, equals(ThemeMode.dark));
      });

      test('isDark is reactive', () {
        viewModel.changeTheme(ThemeMode.light);
        final initialDark = viewModel.isDark;

        viewModel.changeTheme(ThemeMode.dark);

        expect(viewModel.isDark, isNot(equals(initialDark)));
        expect(viewModel.isDark, isTrue);
      });
    });

    group('test mode behavior', () {
      test('does not crash when changing theme in test mode', () {
        // In test mode, Get.changeThemeMode should be skipped
        expect(() => viewModel.changeTheme(ThemeMode.dark), returnsNormally);
      });

      test('state updates work even in test mode', () {
        viewModel.changeTheme(ThemeMode.dark);

        expect(viewModel.themeMode, equals(ThemeMode.dark));
        expect(viewModel.isDark, isTrue);
      });
    });

    group('all theme modes', () {
      test('supports light theme mode', () {
        viewModel.changeTheme(ThemeMode.light);

        expect(viewModel.themeMode, equals(ThemeMode.light));
        expect(viewModel.isDark, isFalse);
      });

      test('supports dark theme mode', () {
        viewModel.changeTheme(ThemeMode.dark);

        expect(viewModel.themeMode, equals(ThemeMode.dark));
        expect(viewModel.isDark, isTrue);
      });

      test('supports system theme mode', () {
        viewModel.changeTheme(ThemeMode.system);

        expect(viewModel.themeMode, equals(ThemeMode.system));
        // isDark is false for system mode (doesn't detect actual system theme)
        expect(viewModel.isDark, isFalse);
      });
    });

    group('edge cases', () {
      test('handles rapid theme changes', () {
        expect(() {
          viewModel.changeTheme(ThemeMode.light);
          viewModel.changeTheme(ThemeMode.dark);
          viewModel.changeTheme(ThemeMode.system);
          viewModel.changeTheme(ThemeMode.light);
        }, returnsNormally);

        expect(viewModel.themeMode, equals(ThemeMode.light));
      });

      test('final state is correct after rapid toggles', () {
        viewModel.changeTheme(ThemeMode.light);

        for (int i = 0; i < 10; i++) {
          viewModel.toggleTheme();
        }

        // After even number of toggles, should be back to light
        expect(viewModel.themeMode, equals(ThemeMode.light));
      });
    });

    group('dependency injection', () {
      test('requires ThemeService dependency', () {
        // Creating ViewModel without service should work (DI handles it)
        final vm = ThemeViewModel(ThemeService());
        expect(vm, isA<ThemeViewModel>());
      });

      test('uses injected service for persistence', () {
        final customService = ThemeService();
        final customVM = ThemeViewModel(customService);

        expect(() => customVM.changeTheme(ThemeMode.dark), returnsNormally);
      });
    });
  });
}
