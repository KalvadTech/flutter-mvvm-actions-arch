import 'package:get/get.dart';
import '/src/modules/auth/auth_middleware.dart';
import '/src/modules/menu/menu.dart';
import '/src/modules/auth/auth.dart';
import '/src/modules/connections/connection.dart';

/// **RouteManager**
///
/// Centralized route management using GetX navigation.
///
/// **Features**:
/// - Type-safe route constants
/// - Navigation helper methods
/// - Middleware and bindings support
/// - Singleton pattern for consistent access
///
/// **Usage**:
/// ```dart
/// // Initialize routes in main.dart
/// RouteManager.instance.initialize();
///
/// // Navigate
/// RouteManager.toAuth();
/// RouteManager.toMenu();
/// RouteManager.toRegister();
///
/// // Custom navigation
/// RouteManager.to(RouteManager.authRoute);
/// RouteManager.off(RouteManager.menuRoute);
/// RouteManager.offAll(RouteManager.initialRoute);
/// ```
class RouteManager {
  RouteManager._(); // Private constructor

  // ═══════════════════════════════════════════════════════════════════════════
  // Singleton
  // ═══════════════════════════════════════════════════════════════════════════

  static final RouteManager _instance = RouteManager._();
  static RouteManager get instance => _instance;

  // ═══════════════════════════════════════════════════════════════════════════
  // Route Constants
  // ═══════════════════════════════════════════════════════════════════════════

  /// Initial splash/connectivity check route
  static const String initialRoute = '/';

  /// Authentication/login route
  static const String authRoute = '/auth';

  /// Registration route
  static const String registerRoute = '/auth/register';

  /// Main menu/home route (protected by AuthMiddleware)
  static const String menuRoute = '/menu';

  // ═══════════════════════════════════════════════════════════════════════════
  // Pages List
  // ═══════════════════════════════════════════════════════════════════════════

  final List<GetPage> _pages = [];

  /// Returns an immutable list of application routes.
  ///
  /// Use this in GetMaterialApp:
  /// ```dart
  /// GetMaterialApp(
  ///   getPages: RouteManager.instance.pages,
  ///   initialRoute: RouteManager.initialRoute,
  /// )
  /// ```
  List<GetPage> get pages => List.unmodifiable(_pages);

  // ═══════════════════════════════════════════════════════════════════════════
  // Initialization
  // ═══════════════════════════════════════════════════════════════════════════

  /// Initializes the route configuration.
  ///
  /// Call this once during app initialization:
  /// ```dart
  /// void main() {
  ///   RouteManager.instance.initialize();
  ///   runApp(MyApp());
  /// }
  /// ```
  void initialize() {
    _pages.clear();
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

  // ═══════════════════════════════════════════════════════════════════════════
  // Navigation Helpers
  // ═══════════════════════════════════════════════════════════════════════════

  /// Navigate to a named route (pushes onto stack).
  ///
  /// Example:
  /// ```dart
  /// RouteManager.to('/settings');
  /// ```
  static Future<T?>? to<T>(String route, {dynamic arguments}) {
    return Get.toNamed<T>(route, arguments: arguments);
  }

  /// Navigate and remove previous route from stack.
  ///
  /// Example:
  /// ```dart
  /// RouteManager.off('/menu'); // Can't go back
  /// ```
  static Future<T?>? off<T>(String route, {dynamic arguments}) {
    return Get.offNamed<T>(route, arguments: arguments);
  }

  /// Navigate and clear entire route stack.
  ///
  /// Example:
  /// ```dart
  /// RouteManager.offAll('/auth'); // Clear all routes
  /// ```
  static Future<T?>? offAll<T>(String route, {dynamic arguments}) {
    return Get.offAllNamed<T>(route, arguments: arguments);
  }

  /// Go back to previous route.
  ///
  /// Example:
  /// ```dart
  /// RouteManager.back();
  /// RouteManager.back(result: {'success': true});
  /// ```
  static void back<T>({T? result}) {
    Get.back<T>(result: result);
  }

  /// Navigate until a specific route (removes routes until condition is met).
  ///
  /// Example:
  /// ```dart
  /// RouteManager.until(RouteManager.menuRoute);
  /// ```
  static Future<T?>? until<T>(String route, {dynamic arguments}) {
    return Get.offNamedUntil<T>(route, (route) => false, arguments: arguments);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Specific Route Helpers
  // ═══════════════════════════════════════════════════════════════════════════

  /// Navigate to authentication page.
  static Future<dynamic>? toAuth() => to(authRoute);

  /// Navigate to registration page.
  static Future<dynamic>? toRegister() => to(registerRoute);

  /// Navigate to menu page.
  static Future<dynamic>? toMenu() => to(menuRoute);

  /// Navigate to initial route (splash).
  static Future<dynamic>? toInitial() => to(initialRoute);

  /// Navigate to auth and clear stack (logout scenario).
  ///
  /// Example:
  /// ```dart
  /// RouteManager.logout(); // Clear session and go to login
  /// ```
  static Future<dynamic>? logout() => offAll(authRoute);

  /// Navigate to menu and clear stack (login success scenario).
  ///
  /// Example:
  /// ```dart
  /// RouteManager.loginSuccess(); // Clear auth flow and go to menu
  /// ```
  static Future<dynamic>? loginSuccess() => offAll(menuRoute);

  // ═══════════════════════════════════════════════════════════════════════════
  // Utilities
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get the current route name.
  ///
  /// Example:
  /// ```dart
  /// String current = RouteManager.currentRoute;
  /// if (current == RouteManager.authRoute) {
  ///   // We're on auth page
  /// }
  /// ```
  static String get currentRoute => Get.currentRoute;

  /// Check if a specific route is currently active.
  ///
  /// Example:
  /// ```dart
  /// bool isOnAuth = RouteManager.isCurrentRoute(RouteManager.authRoute);
  /// ```
  static bool isCurrentRoute(String route) => Get.currentRoute == route;

  /// Get route arguments passed during navigation.
  ///
  /// Example:
  /// ```dart
  /// // From previous page:
  /// RouteManager.to('/profile', arguments: {'userId': 123});
  ///
  /// // On profile page:
  /// final args = RouteManager.arguments;
  /// final userId = args['userId']; // 123
  /// ```
  static dynamic get arguments => Get.arguments;
}
