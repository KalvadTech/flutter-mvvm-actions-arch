import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/menu_item.dart';

/// ViewModel for managing menu navigation and state.
///
/// This controller handles:
/// - Menu item selection and navigation
/// - Current page display management
/// - Menu items configuration
///
/// ## Usage:
/// ```dart
/// final controller = Get.find<MenuViewModel>();
/// controller.selectMenuItem(menuItem);
/// ```
///
/// The ViewModel uses GetX for reactive state management and follows
/// the MVVM pattern for clean separation of concerns.
class MenuViewModel extends GetxController {
  /// Currently selected menu item index.
  final RxInt _selectedIndex = 0.obs;

  /// Getter for the currently selected menu item index.
  int get selectedIndex => _selectedIndex.value;

  /// Currently displayed page widget.
  final Rx<Widget> _currentPage = Rx<Widget>(const SizedBox.shrink());

  /// Getter for the currently displayed page.
  Widget get currentPage => _currentPage.value;

  /// List of available menu items.
  ///
  /// This can be configured during initialization or updated dynamically.
  final RxList<MenuItem> _menuItems = <MenuItem>[].obs;

  /// Getter for the list of menu items.
  List<MenuItem> get menuItems => _menuItems;

  /// Configures the menu with the provided list of menu items.
  ///
  /// This method should be called during initialization to set up the menu.
  /// It will automatically select the first menu item if available.
  ///
  /// ## Example:
  /// ```dart
  /// controller.configureMenu([
  ///   MenuItem(id: 'home', label: 'Home', icon: Icons.home, page: HomePage()),
  ///   MenuItem(id: 'profile', label: 'Profile', icon: Icons.person, page: ProfilePage()),
  /// ]);
  /// ```
  void configureMenu(List<MenuItem> items) {
    _menuItems.value = items;
    // Set the first page as current if available
    if (items.isNotEmpty && items[0].page != null) {
      _currentPage.value = items[0].page!;
      _selectedIndex.value = 0;
    }
  }

  /// Selects a menu item by its index.
  ///
  /// Updates the selected index and displays the associated page if available.
  ///
  /// ## Parameters:
  /// - [index]: The zero-based index of the menu item to select.
  ///
  /// ## Example:
  /// ```dart
  /// controller.selectMenuItemByIndex(1); // Select second menu item
  /// ```
  void selectMenuItemByIndex(int index) {
    if (index >= 0 && index < _menuItems.length) {
      _selectedIndex.value = index;
      final menuItem = _menuItems[index];
      if (menuItem.page != null) {
        _currentPage.value = menuItem.page!;
      }
    }
  }

  /// Selects a menu item by its ID.
  ///
  /// Finds the menu item with the matching ID and selects it.
  ///
  /// ## Parameters:
  /// - [id]: The unique identifier of the menu item to select.
  ///
  /// ## Example:
  /// ```dart
  /// controller.selectMenuItemById('home');
  /// ```
  void selectMenuItemById(String id) {
    final index = _menuItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      selectMenuItemByIndex(index);
    }
  }

  /// Selects a menu item directly.
  ///
  /// Updates the selection based on the provided menu item.
  ///
  /// ## Parameters:
  /// - [menuItem]: The menu item to select.
  ///
  /// ## Example:
  /// ```dart
  /// controller.selectMenuItem(homeMenuItem);
  /// ```
  void selectMenuItem(MenuItem menuItem) {
    final index = _menuItems.indexWhere((item) => item.id == menuItem.id);
    if (index != -1) {
      selectMenuItemByIndex(index);
    }
  }

  /// Checks if a menu item at the given index is currently selected.
  ///
  /// ## Parameters:
  /// - [index]: The index to check.
  ///
  /// ## Returns:
  /// `true` if the item at the given index is selected, `false` otherwise.
  bool isSelected(int index) => _selectedIndex.value == index;
}
