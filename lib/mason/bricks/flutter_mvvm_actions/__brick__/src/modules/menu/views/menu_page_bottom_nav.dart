import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/modules/menu/controllers/menu_view_model.dart';
import '/src/modules/menu/views/menu_bottom_navigation.dart';

/// Menu page with bottom navigation bar.
///
/// Alternative to [MenuPage] that uses a bottom navigation bar
/// instead of a side drawer for navigation.
///
/// ## Features:
/// - Bottom navigation with menu items
/// - Displays current page in body
/// - AppBar with settings access
/// - Settings drawer for theme, language, logout
///
/// ## Usage:
/// ```dart
/// // In auth.dart, replace MenuPage with MenuPageWithBottomNav
/// AuthHandler(
///   onAuthenticated: const MenuPageWithBottomNav(),
///   // ...
/// )
/// ```
///
/// Or use with routes:
/// ```dart
/// GetPage(
///   name: '/menu',
///   page: () => const MenuPageWithBottomNav(),
///   binding: MenuBindings(),
/// )
/// ```
///
/// **Recommendation**: Use bottom nav for 3-5 menu items.
/// For more items or deeper navigation, use the drawer version.
class MenuPageWithBottomNav extends GetWidget<MenuViewModel> {
  /// Creates a [MenuPageWithBottomNav].
  const MenuPageWithBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          // Show the label of the currently selected menu item
          if (controller.selectedIndex >= 0 &&
              controller.selectedIndex < controller.menuItems.length) {
            return Text(controller.menuItems[controller.selectedIndex].label);
          }
          return const SizedBox.shrink();
        }),
        actions: [
          // Settings button to access drawer
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              tooltip: 'Settings',
            ),
          ),
        ],
      ),
      // Settings drawer on the right
      endDrawer: _buildSettingsDrawer(context),
      // Current page content
      body: Obx(() => controller.currentPage),
      // Bottom navigation bar
      bottomNavigationBar: const MenuBottomNavigation(),
    );
  }

  /// Builds the settings drawer with theme, language, and logout.
  Widget _buildSettingsDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.settings,
                  size: 48.0,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              ],
            ),
          ),
          // Import theme and locale widgets
          _buildSettingsItems(),
        ],
      ),
    );
  }

  /// Builds settings items (to be imported from theme/locale modules).
  Widget _buildSettingsItems() {
    // Import these from theme and locale modules
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.dark_mode),
          title: const Text('Theme'),
          subtitle: const Text('Dark / Light mode'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Theme switching will be handled by ThemeDrawerItem
          },
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Language'),
          subtitle: const Text('English / Arabic'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Language switching will be handled by LanguageDrawerItem
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text(
            'Logout',
            style: TextStyle(color: Colors.red),
          ),
          onTap: () {
            // Logout will be handled by LogoutDrawerItem
          },
        ),
      ],
    );
  }
}
