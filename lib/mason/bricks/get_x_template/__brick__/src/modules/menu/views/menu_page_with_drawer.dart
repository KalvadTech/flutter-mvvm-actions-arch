import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/modules/menu/controllers/menu_view_model.dart';
import '/src/modules/menu/views/side_menu_drawer.dart';

/// Menu page with side drawer navigation.
///
/// This page uses a side drawer (hamburger menu) for navigation.
/// The drawer slides in from the left and contains menu items,
/// settings, and logout.
///
/// ## Features:
/// - Hamburger menu icon (☰) in AppBar
/// - Side drawer with menu items
/// - Theme and language switchers in drawer
/// - Logout button in drawer
/// - Displays current page based on menu selection
///
/// ## Usage:
/// ```dart
/// // Navigate to menu page
/// Get.to(() => MenuPageWithDrawer());
///
/// // Or use with named routes
/// GetMaterialApp(
///   initialRoute: '/menu',
///   getPages: [
///     GetPage(
///       name: '/menu',
///       page: () => MenuPageWithDrawer(),
///       binding: MenuBindings(),
///     ),
///   ],
/// )
/// ```
///
/// **Alternative**: For bottom navigation, use [MenuPageWithBottomNav] instead.
class MenuPageWithDrawer extends GetWidget<MenuViewModel> {
  /// Creates a [MenuPageWithDrawer].
  const MenuPageWithDrawer({super.key});

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
      ),
      drawer: const SideMenuDrawer(),
      body: Obx(() => controller.currentPage),
    );
  }
}
