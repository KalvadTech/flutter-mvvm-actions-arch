import 'package:get/get.dart';
import '/src/modules/menu/menu_bindings.dart';
import '/src/modules/posts/posts_bindings.dart';
import 'auth.dart';

/// **AuthBindings**
///
/// Registers authentication dependencies with state change callbacks.
///
/// **Features**:
/// - Registers AuthViewModel with AuthService
/// - Configures callbacks for state changes
/// - Registers feature modules (Menu, Posts) on authentication success
///
/// **Usage**:
/// ```dart
/// GetPage(
///   name: '/auth',
///   page: () => AuthPage(),
///   binding: AuthBindings(),
/// )
/// ```
class AuthBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthService(), fenix: true);
    Get.lazyPut(
      () => AuthViewModel(
        Get.find(),
        onAuthenticated: _onAuthenticated,
        onNotAuthenticated: _onNotAuthenticated,
      ),
    );
  }

  /// Called when user successfully authenticates.
  ///
  /// Registers feature modules that are only needed for logged-in users:
  /// - MenuBindings: Navigation and menu functionality
  /// - PostsBindings: Posts example module
  void _onAuthenticated() {
    // Register menu/navigation bindings
    MenuBindings().dependencies();

    // Register posts example module bindings
    PostsBindings().dependencies();
  }

  /// **_onNotAuthenticated**
  ///
  /// Called when user is not authenticated (logout or session expiration).
  ///
  /// **Why**
  /// - Cleanup feature modules to free resources
  /// - Reset state for next authentication
  /// - Prevent memory leaks from registered dependencies
  ///
  /// **What it does:**
  /// - Calls PostsBindings.destroy() to cleanup posts module
  /// - Calls MenuBindings.destroy() to cleanup menu module
  ///
  /// **Order matters:**
  /// - Posts module is cleaned up first (feature module)
  /// - Menu module is cleaned up second (navigation module)
  ///
  /// **Side Effects**
  /// - All feature module dependencies removed from GetX registry
  /// - State and cached data cleared
  /// - Next login creates fresh instances
  ///
  /// // ────────────────────────────────────────────────
  void _onNotAuthenticated() {
    // Clean up posts module (reverse order of registration)
    PostsBindings.destroy();

    // Clean up menu module
    MenuBindings.destroy();
  }
}
