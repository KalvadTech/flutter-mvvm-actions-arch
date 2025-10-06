import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'menu.dart';

/// Bindings class for the menu module.
///
/// Responsible for:
/// - Registering the [MenuViewModel] in the dependency injection system
/// - Configuring menu items with their associated pages
///
/// ## Usage:
/// ```dart
/// GetPage(
///   name: '/menu',
///   page: () => MenuPage(),
///   binding: MenuBindings(),
/// )
/// ```
///
/// This class implements the [Bindings] interface from GetX.
class MenuBindings implements Bindings {
  /// Registers dependencies and configures the menu.
  ///
  /// This method:
  /// 1. Registers the [MenuViewModel] if not already registered
  /// 2. Configures the default menu items
  ///
  /// Override [configureMenuItems] to customize menu configuration.
  @override
  void dependencies() {
    if (!Get.isRegistered<MenuViewModel>()) {
      final viewModel = MenuViewModel();
      Get.lazyPut<MenuViewModel>(() => viewModel);

      // Configure menu items after putting the controller
      // This will be called when the controller is first accessed
      Get.lazyPut(() {
        viewModel.configureMenu(configureMenuItems());
        return viewModel;
      }, fenix: true);
    }
  }

  /// Configures the menu items for the application.
  ///
  /// Override this method to provide custom menu configuration.
  ///
  /// ## Example:
  /// ```dart
  /// class CustomMenuBindings extends MenuBindings {
  ///   @override
  ///   List<MenuItem> configureMenuItems() {
  ///     return [
  ///       MenuItem(
  ///         id: 'dashboard',
  ///         label: 'Dashboard',
  ///         icon: Icons.dashboard,
  ///         page: DashboardPage(),
  ///       ),
  ///     ];
  ///   }
  /// }
  /// ```
  ///
  /// ## Returns:
  /// A list of [MenuItem] objects to display in the menu.
  List<MenuItem> configureMenuItems() {
    return [
      const MenuItem(
        id: 'page1',
        label: 'Page 1',
        icon: Icons.home,
        page: Page1(),
      ),
      const MenuItem(
        id: 'page2',
        label: 'Page 2',
        icon: Icons.category,
        page: Page2(),
      ),
      const MenuItem(
        id: 'page3',
        label: 'Page 3',
        icon: Icons.person,
        page: Page3(),
      ),
    ];
  }
}
