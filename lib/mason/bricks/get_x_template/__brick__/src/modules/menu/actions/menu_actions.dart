import 'package:get/get.dart';
import '../../../core/routing/route_manager.dart';
import '/src/modules/auth/auth.dart';
import '../controllers/menu_view_model.dart';

/// Utility class for menu-related actions and navigation helpers.
///
/// This class provides convenient methods to interact with the menu system
/// without directly accessing the ViewModel from UI code.
///
/// ## Usage:
/// ```dart
/// // Select a menu item by index
/// MenuActions.selectPage(0);
///
/// // Select by ID
/// MenuActions.selectPageById('home');
///
/// // Logout
/// MenuActions.logout();
/// ```
///
/// Note: This class requires [MenuViewModel] to be registered in GetX.
class MenuActions {
  MenuActions._(); // Private constructor to prevent instantiation

  /// Gets the MenuViewModel instance.
  static MenuViewModel get _controller => Get.find<MenuViewModel>();

  /// Selects a menu page by its index.
  ///
  /// ## Parameters:
  /// - [index]: The zero-based index of the page to select.
  ///
  /// ## Example:
  /// ```dart
  /// MenuActions.selectPage(0); // Select first page
  /// ```
  static void selectPage(int index) {
    _controller.selectMenuItemByIndex(index);
  }

  /// Selects a menu page by its ID.
  ///
  /// ## Parameters:
  /// - [id]: The unique identifier of the page to select.
  ///
  /// ## Example:
  /// ```dart
  /// MenuActions.selectPageById('home');
  /// ```
  static void selectPageById(String id) {
    _controller.selectMenuItemById(id);
  }

  /// Gets the currently selected page index.
  ///
  /// ## Returns:
  /// The zero-based index of the currently selected page.
  static int get selectedIndex => _controller.selectedIndex;

  /// Logs out the current user.
  ///
  /// This method delegates to the [AuthViewModel] to handle logout logic.
  ///
  /// ## Example:
  /// ```dart
  /// await MenuActions.logout();
  /// ```
  static Future<void> logout() async {
    final authViewModel = Get.find<AuthViewModel>();
    await authViewModel.logout();
  }

  /// Closes the current screen/dialog and returns to previous screen.
  ///
  /// ## Example:
  /// ```dart
  /// MenuActions.back();
  /// ```
  static void back() {
    RouteManager.back();
  }
}
