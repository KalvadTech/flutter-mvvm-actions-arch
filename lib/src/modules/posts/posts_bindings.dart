import 'package:get/get.dart';
import '/src/modules/posts/controllers/post_view_model.dart';
import '/src/modules/posts/data/services/post_service.dart';

/// **PostsBindings**
///
/// Dependency injection setup for the posts module using GetX bindings.
///
/// **Why**
/// - Centralizes dependency registration for the posts module.
/// - Uses lazy loading for efficient memory usage.
/// - Ensures proper dependency order (Service before ViewModel).
///
/// **Usage**
/// ```dart
/// GetPage(
///   name: '/posts',
///   page: () => PostsPage(),
///   binding: PostsBindings(),
/// )
/// ```
///
/// **Dependencies Registered**:
/// 1. [PostService] - API communication layer
/// 2. [PostViewModel] - State management with apiFetch pattern
class PostsBindings implements Bindings {
  @override
  void dependencies() {
    // Register PostService if not already registered.
    if (!Get.isRegistered<PostService>()) {
      Get.lazyPut<PostService>(() => PostService(), fenix: true);
    }

    // Register PostViewModel as permanent to persist across navigation.
    // This prevents the ViewModel from being disposed when navigating away
    // from the posts page, preserving the data and state.
    if (!Get.isRegistered<PostViewModel>()) {
      Get.put<PostViewModel>(PostViewModel(Get.find()), permanent: true);
    }
  }

  /// **destroy**
  ///
  /// Cleans up and removes posts module dependencies from GetX.
  ///
  /// **Why**
  /// - Called when user logs out to free resources and reset state
  /// - Ensures clean slate for next authentication
  /// - Prevents memory leaks from registered dependencies
  ///
  /// **What it does:**
  /// - Removes [PostViewModel] from GetX dependency injection
  /// - Removes [PostService] from GetX dependency injection
  /// - Resets posts state for next login
  ///
  /// **Order matters:**
  /// - ViewModel is deleted first (depends on Service)
  /// - Service is deleted second (has no dependencies)
  ///
  /// **Usage**
  /// ```dart
  /// // Called in AuthBindings._onNotAuthenticated()
  /// PostsBindings.destroy();
  /// ```
  ///
  /// **Side Effects**
  /// - PostViewModel and PostService will be deleted from GetX registry
  /// - Posts state and cached data will be cleared
  /// - Next login will create fresh instances
  ///
  /// **Notes**
  /// - Uses `force: true` because PostViewModel has `permanent: true`
  /// - Safe to call multiple times (checks if registered first)
  ///
  /// // ────────────────────────────────────────────────
  static void destroy() {
    // Delete ViewModel first (depends on Service)
    if (Get.isRegistered<PostViewModel>()) {
      Get.delete<PostViewModel>(force: true);
    }

    // Delete Service second (independent)
    if (Get.isRegistered<PostService>()) {
      Get.delete<PostService>(force: true);
    }
  }
}
