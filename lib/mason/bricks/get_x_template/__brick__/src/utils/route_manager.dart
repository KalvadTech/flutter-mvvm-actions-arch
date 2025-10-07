import 'package:get/get.dart';
import '/src/modules/auth/auth_middleware.dart';
import '/src/modules/menu/menu.dart';
import '/src/modules/auth/auth.dart';
import '/src/modules/connections/connection.dart';

/// Manages application routes using GetX for navigation and route handling.
/// Implements a singleton pattern to ensure only one instance exists across the app.
class RouteManager {
  // Singleton instance to ensure only one instance of RouteManager exists.
  static final RouteManager _mInstance = RouteManager._();

  // Getter for accessing the singleton instance.
  static RouteManager get instance => _mInstance;

  // Private list to store the application's routes.
  final List<GetPage> _pages = [];

  // Getter to access the routes list, wrapped with List.unmodifiable for immutability.
  List<GetPage> get pages => List.unmodifiable(_pages);

  // Private constructor to prevent external instantiation.
  RouteManager._();

  // Route constants for better readability and reusability.
  static const String initialRoute = '/';
  static const String authRoute = '/auth';
  static const String registerRoute = '/auth/register';
  static const String menuRoute = '/menu';

  /// Initializes the routes list by clearing any existing routes and adding new ones.
  ///
  /// Example usage:
  /// ```dart
  /// RouteManager.instance.initialize();
  /// ```
  void initialize() {
    _pages.clear(); // Clears any previously added routes to avoid duplication.
    _pages.addAll([
      GetPage(
        name: initialRoute,
        page: () => const ConnectivityCheckerSplash(),
      ),
      GetPage(
        name: authRoute,
        page: () => const AuthPage(),
        binding: AuthBindings(),
      ),
      GetPage(
        name: registerRoute,
        page: () => const RegisterPage(),
      ),
      GetPage(
        name: menuRoute,
        page: () => const MenuPageWithDrawer(),
        binding: MenuBindings(),
        middlewares: [AuthMiddleware()],
      ),
    ]);
  }

  /// Navigates to the register page using GetX's named route.
  ///
  /// Example usage:
  /// ```dart
  /// RouteManager.toRegisterPage();
  /// ```
  static void toRegisterPage() {
    Get.toNamed(registerRoute);
  }
}
