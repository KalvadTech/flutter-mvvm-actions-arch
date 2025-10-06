import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/modules/menu/controllers/menu_view_model.dart';

/// Bottom navigation bar for the menu system.
///
/// Displays menu items as a bottom navigation bar with icons and labels.
/// Automatically updates when menu items are selected.
///
/// ## Features:
/// - Shows up to 5 menu items (recommended for bottom nav)
/// - Active item highlighted with primary color
/// - Reactive to menu state changes
/// - Material Design 3 styling
///
/// ## Usage:
/// ```dart
/// Scaffold(
///   bottomNavigationBar: MenuBottomNavigation(),
///   body: // your content
/// )
/// ```
///
/// **Note**: Bottom navigation works best with 3-5 items.
/// For more items, consider using side drawer navigation instead.
class MenuBottomNavigation extends GetWidget<MenuViewModel> {
  /// Creates a [MenuBottomNavigation].
  const MenuBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        // Don't show bottom nav if no menu items
        if (controller.menuItems.isEmpty) {
          return const SizedBox.shrink();
        }

        // Limit to 5 items for bottom navigation
        final items = controller.menuItems.take(5).toList();

        return NavigationBar(
          selectedIndex: controller.selectedIndex < items.length
              ? controller.selectedIndex
              : 0,
          onDestinationSelected: (index) {
            controller.selectMenuItemByIndex(index);
          },
          destinations: items.map((menuItem) {
            return NavigationDestination(
              icon: Icon(menuItem.icon),
              label: menuItem.label,
            );
          }).toList(),
        );
      },
    );
  }
}

/// Legacy Material 2 style bottom navigation bar.
///
/// Uses the classic BottomNavigationBar widget instead of
/// Material 3's NavigationBar.
///
/// ## Usage:
/// ```dart
/// Scaffold(
///   bottomNavigationBar: MenuBottomNavigationLegacy(),
///   body: // your content
/// )
/// ```
class MenuBottomNavigationLegacy extends GetWidget<MenuViewModel> {
  /// Creates a [MenuBottomNavigationLegacy].
  const MenuBottomNavigationLegacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        // Don't show bottom nav if no menu items
        if (controller.menuItems.isEmpty) {
          return const SizedBox.shrink();
        }

        // Limit to 5 items for bottom navigation
        final items = controller.menuItems.take(5).toList();

        return BottomNavigationBar(
          currentIndex: controller.selectedIndex < items.length
              ? controller.selectedIndex
              : 0,
          onTap: (index) {
            controller.selectMenuItemByIndex(index);
          },
          type: BottomNavigationBarType.fixed,
          items: items.map((menuItem) {
            return BottomNavigationBarItem(
              icon: Icon(menuItem.icon),
              label: menuItem.label,
            );
          }).toList(),
        );
      },
    );
  }
}
