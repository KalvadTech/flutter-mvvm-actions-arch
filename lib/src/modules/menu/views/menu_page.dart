import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/modules/menu/controllers/menu_view_model.dart';
import '/src/modules/menu/views/side_menu_drawer.dart';

/// The main menu page with navigation drawer.
///
/// This page serves as the primary navigation container for the app.
/// It displays the currently selected page content and provides access
/// to the navigation drawer.
///
/// ## Features:
/// - Displays current page based on menu selection
/// - Provides side navigation drawer
/// - Reactive to menu state changes
/// - Material Design app bar
///
/// ## Usage:
/// ```dart
/// // Navigate to menu page
/// Get.to(() => MenuPage());
///
/// // Or use with named routes
/// GetMaterialApp(
///   initialRoute: '/menu',
///   getPages: [
///     GetPage(
///       name: '/menu',
///       page: () => MenuPage(),
///       binding: MenuBindings(),
///     ),
///   ],
/// )
/// ```
class MenuPage extends GetWidget<MenuViewModel> {
  /// Creates a [MenuPage].
  const MenuPage({super.key});

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
