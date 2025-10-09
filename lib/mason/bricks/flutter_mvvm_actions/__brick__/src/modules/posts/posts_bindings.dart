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
}
