import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/services/theme_service.dart';

/// **ThemeViewModel**
///
/// GetX controller responsible for managing app theme mode (light/dark/system)
/// and persisting user preference via [ThemeService].
///
/// **Why**
/// - Centralize theme state and provide reactive theme switching.
/// - Keep views decoupled from storage details; they observe [isDark] via `Obx`.
/// - Handle theme initialization and persistence automatically.
///
/// **Key Features**
/// - Reactive `isDark` boolean for UI consumption.
/// - Persists theme mode preference using [ThemeService].
/// - Fallback to light mode when no preference is saved.
/// - Integrates with GetX theme engine via `Get.changeThemeMode`.
/// - Supports light, dark, and system theme modes.
///
/// **Example**
/// ```dart
/// final themeVM = Get.find<ThemeViewModel>();
/// themeVM.changeTheme(ThemeMode.dark);
/// // Or toggle:
/// themeVM.toggleTheme();
/// ```
///
// ────────────────────────────────────────────────
class ThemeViewModel extends GetxController {
  /// Service to handle saving and retrieving the theme preference.
  final ThemeService _themeService;

  /// Fallback theme mode when no preference is found.
  static const ThemeMode fallbackTheme = ThemeMode.light;

  /// Reactive boolean to track if the current theme is dark mode.
  final RxBool _isDark = false.obs;

  /// Reactive theme mode state.
  final Rx<ThemeMode> _themeMode = ThemeMode.light.obs;

  /// Getter to access the current dark mode status.
  bool get isDark => _isDark.value;

  /// Getter to retrieve the current theme mode.
  ThemeMode get themeMode => _themeMode.value;

  /// Constructor to inject the [ThemeService] dependency.
  ThemeViewModel(this._themeService);

  @override
  void onInit() {
    super.onInit();
    _initializeTheme();
  }

  /// **_initializeTheme**
  ///
  /// Initializes the theme by applying saved preference or fallback.
  ///
  /// **Side Effects**
  /// - Reads from storage via ThemeService.
  /// - Updates theme mode via Get.changeThemeMode.
  /// - Updates reactive _isDark and _themeMode.
  ///
  // ────────────────────────────────────────────────
  void _initializeTheme() {
    final savedMode = _getSavedThemeMode();
    _applyTheme(savedMode);
  }

  /// **changeTheme**
  ///
  /// Updates the app's theme to the given [newThemeMode] and persists it.
  ///
  /// **Parameters**
  /// - `newThemeMode`: The theme mode to apply (light, dark, or system).
  ///
  /// **Side Effects**
  /// - Updates reactive state (_isDark, _themeMode).
  /// - Calls Get.changeThemeMode to update UI.
  /// - Persists preference via ThemeService.
  ///
  // ────────────────────────────────────────────────
  void changeTheme(ThemeMode newThemeMode) {
    _applyTheme(newThemeMode);
    _themeService.saveThemeMode(newThemeMode.toString());
  }

  /// **toggleTheme**
  ///
  /// Toggles between light and dark theme modes.
  ///
  /// **Side Effects**
  /// - Switches from light to dark or dark to light.
  /// - Persists the new theme preference.
  ///
  // ────────────────────────────────────────────────
  void toggleTheme() {
    final newMode = _isDark.value ? ThemeMode.light : ThemeMode.dark;
    changeTheme(newMode);
  }

  /// **_applyTheme**
  ///
  /// Internal method to apply theme mode to app and reactive state.
  ///
  /// **Parameters**
  /// - `mode`: Theme mode to apply.
  ///
  /// **Side Effects**
  /// - Updates _isDark boolean based on mode.
  /// - Updates _themeMode reactive property.
  /// - Calls Get.changeThemeMode if not in test mode.
  ///
  // ────────────────────────────────────────────────
  void _applyTheme(ThemeMode mode) {
    _themeMode.value = mode;
    _updateDarkModeFlag(mode);

    if (!Get.testMode) {
      try {
        Get.changeThemeMode(mode);
      } catch (e) {
        // Theme change failed in test/special environment
      }
    }
  }

  /// **_updateDarkModeFlag**
  ///
  /// Updates the reactive _isDark boolean based on theme mode.
  ///
  /// **Parameters**
  /// - `mode`: Theme mode to evaluate.
  ///
  // ────────────────────────────────────────────────
  void _updateDarkModeFlag(ThemeMode mode) {
    _isDark.value = mode == ThemeMode.dark;
  }

  /// **_getSavedThemeMode**
  ///
  /// Retrieves the saved theme mode from storage with fallback.
  ///
  /// **Returns**
  /// - `ThemeMode`: Saved theme mode or fallback (light).
  ///
  // ────────────────────────────────────────────────
  ThemeMode _getSavedThemeMode() {
    final savedString = _themeService.getSavedThemeMode();

    if (savedString == null) {
      return fallbackTheme;
    }

    // Parse saved string to ThemeMode enum
    if (savedString == ThemeMode.dark.toString()) {
      return ThemeMode.dark;
    } else if (savedString == ThemeMode.system.toString()) {
      return ThemeMode.system;
    } else {
      return ThemeMode.light;
    }
  }
}
