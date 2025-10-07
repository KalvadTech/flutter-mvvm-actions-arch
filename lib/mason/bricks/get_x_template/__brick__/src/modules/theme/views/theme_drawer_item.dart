import 'package:flutter/material.dart';
import 'theme_mode_label.dart';
import 'theme_mode_switch.dart';

/// **ThemeDrawerItem**
///
/// A ListTile widget for displaying theme controls in a drawer menu.
///
/// **Why**
/// - Provide a ready-to-use theme control for navigation drawers.
/// - Combine icon, label, and switch in a single consistent widget.
///
/// **Key Features**
/// - Moon icon for theme/dark mode.
/// - Translatable label via ThemeModeLabel.
/// - Interactive switch via ThemeModeSwitch.
///
/// **Example**
/// ```dart
/// Drawer(
///   child: ListView(
///     children: [
///       ThemeDrawerItem(),
///     ],
///   ),
/// )
/// ```
///
// ────────────────────────────────────────────────
class ThemeDrawerItem extends StatelessWidget {
  /// Constructor for ThemeDrawerItem.
  const ThemeDrawerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: Icon(Icons.brightness_3),
      title: ThemeModeLabel(),
      trailing: ThemeModeSwitch(),
    );
  }
}
