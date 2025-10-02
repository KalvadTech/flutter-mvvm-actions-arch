import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/presentation/custom/custom_text.dart';
import '../theme.dart';

/// A widget to provide a switch for toggling between light and dark themes using GetX.
class ThemeSwitch extends GetWidget<ThemeViewModel> {
  /// Constructor for `ThemeSwitch`.
  const ThemeSwitch({super.key});

  /// Builds the switch with an observer to detect theme changes.
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CupertinoSwitch(
        value: controller.isDark, // Current theme state (dark or light).
        onChanged: (value) {
          // Toggles the theme between dark and light modes.
          controller.changeTheme(value ? ThemeMode.dark : ThemeMode.light);
        },
      ),
    );
  }
}

/// A widget to display text describing the current theme setting.
class ThemeText extends StatelessWidget {
  /// Constructor for `ThemeText`.
  const ThemeText({Key? key}) : super(key: key);

  /// Builds a text widget displaying "Dark mode".
  @override
  Widget build(BuildContext context) {
    return const CustomText('Dark mode'); // Custom text widget for uniformity.
  }
}

/// A widget to represent a list tile item in a drawer with a theme switch.
class ThemeDrawerItem extends StatelessWidget {
  /// Constructor for `ThemeDrawerItem`.
  const ThemeDrawerItem({Key? key}) : super(key: key);

  /// Builds a list tile containing an icon, theme text, and a theme switch.
  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: Icon(Icons.brightness_3), // Icon for theme mode.
      title: ThemeText(), // Title showing "Dark mode".
      trailing: ThemeSwitch(), // A switch to toggle themes.
    );
  }
}
