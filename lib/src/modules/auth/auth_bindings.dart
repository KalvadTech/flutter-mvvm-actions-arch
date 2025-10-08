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

  /// Called when user is not authenticated.
  ///
  /// Can be used for cleanup or analytics.
  void _onNotAuthenticated() {
    // Optional: Add cleanup logic here if needed
    // Example: Clear cached data, reset state, etc.
  }
}
