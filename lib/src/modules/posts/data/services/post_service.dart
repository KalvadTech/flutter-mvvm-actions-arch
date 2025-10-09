import '/src/config/api_config.dart';

import '/src/infrastructure/http/api_service.dart';
import '/src/modules/posts/data/models/post_model.dart';

/// **PostService**
///
/// Service layer for handling post-related API requests.
///
/// **Why**
/// - Encapsulates HTTP communication logic away from ViewModels.
/// - Extends [ApiService] to inherit auth headers, error handling, retry logic.
/// - Uses public JSONPlaceholder API for demonstration purposes.
///
/// **Key Features**
/// - Fetches posts using URLs from [APIConfiguration]
/// - Returns parsed List<PostModel>
/// - No authentication required
/// - Perfect for demonstrating apiFetch/ApiResponse/ApiHandler patterns
///
/// **Example Usage**
/// ```dart
/// final postService = PostService();
/// final posts = await postService.fetchPosts();
/// ```
///
/// **Note**: All API URLs are configured in [APIConfiguration].
/// This service uses `APIConfiguration.postsUrl` to fetch data.
///
/// **API Documentation**: https://jsonplaceholder.typicode.com/
class PostService extends ApiService {

  /// Fetches all posts from the JSONPlaceholder API.
  ///
  /// Makes a GET request to /posts endpoint and parses the response
  /// into a list of [PostModel] objects.
  ///
  /// **Returns**: List of 100 posts from the API.
  ///
  /// **Throws**: Exception if the API call fails or response is invalid.
  ///
  /// **Example Response**:
  /// ```json
  /// [
  ///   {
  ///     "userId": 1,
  ///     "id": 1,
  ///     "title": "sunt aut facere repellat provident",
  ///     "body": "quia et suscipit..."
  ///   },
  ///   ...
  /// ]
  /// ```
  Future<List<PostModel>> fetchPosts() async {
    final response = await get(APIConfiguration.postsUrl);
    return postModelFromJson(response.body);
  }

  /// Fetches a single post by ID.
  ///
  /// [postId] is the unique identifier of the post to fetch.
  ///
  /// **Returns**: A single [PostModel] object.
  ///
  /// **Throws**: Exception if the API call fails or post not found.
  ///
  /// **Example**: `fetchPostById(1)` returns the first post.
  Future<PostModel> fetchPostById(int postId) async {
    final response = await get('${APIConfiguration.postsUrl}/$postId');
    return PostModel.fromJson(response.body);
  }
}
