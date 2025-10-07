import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_view_model.dart';

/// **ThemeModeSwitch**
///
/// A Cupertino-style switch widget for toggling between light and dark themes.
///
/// **Why**
/// - Provide intuitive UI control for theme switching.
/// - Use reactive state via GetX Obx to reflect theme changes.
///
/// **Key Features**
/// - Cupertino switch for iOS-style appearance.
/// - Reactive to ThemeViewModel's isDark state.
/// - Automatically updates when theme changes elsewhere.
///
/// **Example**
/// ```dart
/// ThemeModeSwitch() // Automatically binds to ThemeViewModel
/// ```
///
// ────────────────────────────────────────────────
class ThemeModeSwitch extends GetWidget<ThemeViewModel> {
  /// Constructor for ThemeModeSwitch.
  const ThemeModeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CupertinoSwitch(
        value: controller.isDark,
        onChanged: (value) {
          controller.changeTheme(value ? ThemeMode.dark : ThemeMode.light);
        },
      ),
    );
  }
}
