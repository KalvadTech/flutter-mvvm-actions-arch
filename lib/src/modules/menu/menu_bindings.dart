import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/modules/posts/posts.dart';
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
///   page: () => MenuPageWithDrawer(),
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
      Get.lazyPut<MenuViewModel>(() {
        final viewModel = MenuViewModel();
        // Configure menu items immediately after creation
        viewModel.configureMenu(configureMenuItems());
        return viewModel;
      });
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
        id: 'dashboard',
        label: 'Dashboard',
        icon: Icons.dashboard,
        page: DashboardPage(),
      ),
      const MenuItem(
        id: 'posts',
        label: 'Posts Example',
        icon: Icons.article,
        page: PostsPage(),
      ),
      const MenuItem(
        id: 'settings',
        label: 'Settings',
        icon: Icons.settings,
        page: SettingsPage(),
      ),
      const MenuItem(
        id: 'profile',
        label: 'Profile',
        icon: Icons.person,
        page: ProfilePage(),
      ),
    ];
  }
}
