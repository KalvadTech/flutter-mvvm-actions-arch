import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/modules/posts/controllers/post_view_model.dart';
import '/src/modules/posts/data/models/post_model.dart';
import '/src/modules/posts/views/widgets/posts_list_view.dart';
import '/src/presentation/widgets/api_handler.dart';

/// **PostsPage**
///
/// Main page displaying a list of blog posts from JSONPlaceholder API.
///
/// **Purpose**
/// This page serves as an **educational example** demonstrating the template's
/// recommended API integration pattern:
///
/// **Pattern Flow**:
/// ```
/// PostService.fetchPosts()
///     ↓ (extends ApiService)
/// apiFetch() wrapper
///     ↓ (emits Stream<ApiResponse<T>>)
/// PostViewModel.posts (Rx<ApiResponse<List<PostModel>>>)
///     ↓ (observed by GetX)
/// ApiHandler<List<PostModel>>
///     ↓ (renders based on state)
/// PostsListView (successBuilder)
/// ```
///
/// **Features**:
/// - ✅ Automatic loading state with progress indicator
/// - ✅ Error state with retry button
/// - ✅ Empty state handling
/// - ✅ Success state with scrollable list
/// - ✅ Pull-to-refresh support
///
/// **Key Components**:
/// - [GetX] - Observes [PostViewModel] reactively
/// - [ApiHandler] - Renders UI based on [ApiResponse] state
/// - [RefreshIndicator] - Pull-to-refresh gesture
/// - [PostsListView] - Displays posts in ListView
///
/// **Usage**:
/// ```dart
/// GetPage(
///   name: '/posts-example',
///   page: () => const PostsPage(),
///   binding: PostBindings(),
/// )
/// ```
///
/// **For Developers**:
/// This example shows how to:
/// 1. Fetch data from an API using [apiFetch]
/// 2. Wrap response in [ApiResponse] for state management
/// 3. Use [ApiHandler] to render different UI states
/// 4. Implement pull-to-refresh
/// 5. Handle errors gracefully
///
/// Replace this with your own API endpoint and model!
class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<PostViewModel>(
        builder: (controller) => RefreshIndicator(
          onRefresh: () async => controller.refreshData(),
          child: ApiHandler<List<PostModel>>(
            // Current API response state from ViewModel
            response: controller.posts,

            // Retry callback when error occurs
            tryAgain: controller.refreshData,

            // Check if data is empty
            isEmpty: (posts) => posts.isEmpty,

            // Success: render the posts list
            successBuilder: (posts) => PostsListView(posts: posts),

            // Optional: Custom loading widget
            // loadingWidget: const CustomLoadingSpinner(),

            // Optional: Custom error builder
            // errorBuilder: (message) => CustomErrorWidget(message: message),
          ),
        ),
      ),
    );
  }
}
