import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/modules/locale/controllers/localization_view_model.dart';
import '/src/modules/locale/views/language_dialog.dart';

/// Language selector drawer item for the navigation menu.
///
/// Displays the current language and allows changing it via a dialog.
///
/// ## Usage:
/// ```dart
/// Drawer(
///   child: ListView(
///     children: [
///       LanguageDrawerItem(),
///     ],
///   ),
/// )
/// ```
class LanguageDrawerItem extends GetWidget<LocalizationViewModel> {
  /// Creates a [LanguageDrawerItem].
  const LanguageDrawerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListTile(
        leading: const Icon(Icons.language),
        title: Text(
          'Language',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Text(
          controller.language.name,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showLanguageDialog(context),
      ),
    );
  }

  /// Shows the language picker dialog.
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LanguagePickerDialog(),
    );
  }
}
