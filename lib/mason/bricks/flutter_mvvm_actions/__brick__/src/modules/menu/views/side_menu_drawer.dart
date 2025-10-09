import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '/src/config/config.dart';
import '/src/modules/menu/controllers/menu_view_model.dart';
import '/src/modules/menu/views/menu_drawer_item.dart';
import '/src/modules/menu/views/logout_drawer_item.dart';
import '/src/modules/theme/theme.dart';
import '/src/modules/locale/locale.dart';

/// Navigation drawer widget for the menu system.
///
/// Displays a side drawer with:
/// - App logo and name
/// - List of menu items from the MenuViewModel
/// - Theme switcher
/// - Automatic drawer close on item selection
///
/// ## Usage:
/// ```dart
/// Scaffold(
///   drawer: SideMenuDrawer(),
///   // ...
/// )
/// ```
///
/// The drawer is reactive and automatically updates when menu items change.
class SideMenuDrawer extends GetWidget<MenuViewModel> {
  /// Creates a [SideMenuDrawer].
  const SideMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Obx(
        () => ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer header with app logo
            _buildDrawerHeader(context),

            // Menu items
            ...controller.menuItems.asMap().entries.map((entry) {
              final index = entry.key;
              final menuItem = entry.value;

              return MenuDrawerItem(
                label: menuItem.label,
                icon: menuItem.icon,
                isSelected: controller.isSelected(index),
                onTap: () {
                  controller.selectMenuItemByIndex(index);
                  Navigator.of(context).pop(); // Close drawer
                },
              );
            }),

            // Divider before settings section
            const Divider(),

            // Settings section header
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Text(
                tkSettings.tr,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
              ),
            ),

            // Theme switcher
            const ThemeDrawerItem(),

            // Language switcher
            const LanguageDrawerItem(),

            // Divider before logout
            const Divider(),

            // Logout
            const LogoutDrawerItem(),
          ],
        ),
      ),
    );
  }

  /// Builds the drawer header with app logo and name.
  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.2,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SvgPicture.asset(
              AssetsManager.logoPath,
              height: MediaQuery.of(context).size.height * 0.15,
              colorFilter: ColorFilter.mode(
                Theme.of(context).primaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Flexible(
            child: Text(
              appName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
