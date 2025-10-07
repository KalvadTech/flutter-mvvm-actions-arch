import 'package:get/get.dart';
import '/src/core/presentation/api_response.dart';
import '/src/modules/posts/data/models/post_model.dart';
import '/src/modules/posts/data/services/post_service.dart';

/// **PostViewModel**
///
/// GetX controller responsible for managing posts list state and
/// orchestrating data fetching via [PostService].
///
/// This ViewModel demonstrates the template's recommended API pattern:
/// **apiFetch() → ApiResponse → ApiHandler**
///
/// **Why**
/// - Encapsulates posts business logic separate from UI.
/// - Provides reactive [ApiResponse] state for loading/success/error rendering.
/// - Showcases proper error handling and state management.
///
/// **Key Features**
/// - Reactive `posts` observable wrapped in [ApiResponse].
/// - Automatic data fetch on initialization.
/// - Refresh capability for pull-to-refresh or manual reload.
/// - Uses [apiFetch] helper to manage loading/success/error lifecycle.
///
/// **Example Usage**
/// ```dart
/// // In view
/// final postsVM = Get.find<PostViewModel>();
///
/// // Trigger refresh
/// postsVM.refreshData();
///
/// // Access state
/// if (postsVM.posts.isSuccess) {
///   final posts = postsVM.posts.data;
/// }
/// ```
///
/// **API Pattern Flow**:
/// ```
/// 1. _fetchPosts() called
/// 2. apiFetch() wraps service call
/// 3. Emits ApiResponse states: loading → success/error
/// 4. UI reacts via ApiHandler widget
/// ```
class PostViewModel extends GetxController {
  /// Service used to fetch posts from the JSONPlaceholder API.
  final PostService _postService;

  /// Constructor initializing the post service.
  PostViewModel(this._postService);

  /// Observable state holding the API response for posts.
  ///
  /// Wrapped in [ApiResponse] to track loading/success/error/idle states.
  /// UI widgets observe this via [ApiHandler] for reactive rendering.
  final Rx<ApiResponse<List<PostModel>>> _posts = ApiResponse<List<PostModel>>.idle().obs;

  /// Getter to expose the posts API response.
  ///
  /// **States**:
  /// - `idle`: Initial state before any fetch
  /// - `loading`: Data is being fetched
  /// - `success`: Data fetched successfully (check `.data`)
  /// - `error`: Fetch failed (check `.message`)
  ApiResponse<List<PostModel>> get posts => _posts.value;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  /// Initializes the ViewModel by fetching the initial data.
  void _initialize() {
    _fetchData();
  }

  /// Triggers fetching of posts data.
  ///
  /// Called internally on initialization and externally via [refreshData].
  void _fetchData() {
    _fetchPosts();
  }

  /// Fetches posts data from the API and updates the observable state.
  ///
  /// Uses [apiFetch] which:
  /// 1. Emits `loading` state immediately
  /// 2. Calls the service method
  /// 3. Emits `success` with data or `error` with message
  /// 4. Returns a Stream<ApiResponse<T>> for reactive updates
  ///
  /// The stream is listened to and updates `_posts.value` automatically.
  void _fetchPosts() async {
    apiFetch(_postService.fetchPosts).listen((value) => _posts.value = value);
  }

  /// Refreshes the posts data.
  ///
  /// Useful for:
  /// - Pull-to-refresh gestures
  /// - Manual reload buttons
  /// - Retry after error
  ///
  /// **Example**:
  /// ```dart
  /// RefreshIndicator(
  ///   onRefresh: () async => controller.refreshData(),
  ///   child: PostsListView(),
  /// )
  /// ```
  void refreshData() {
    _fetchData();
  }
}
