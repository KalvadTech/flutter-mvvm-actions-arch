import 'dart:convert';

/// Converts a JSON List into a list of `PostModel` instances.
///
/// [json] is the input JSON list from the API.
///
/// Returns a list of `PostModel` objects.
List<PostModel> postModelFromJson(List json) =>
    List<PostModel>.from(json.map((x) => PostModel.fromJson(x)));

/// Converts a list of `PostModel` instances into a JSON-encoded string.
///
/// [data] is the list of `PostModel` to convert.
///
/// Returns the JSON-encoded string representation of the list.
String postModelToJson(List<PostModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// **PostModel**
///
/// A model representing a blog post from JSONPlaceholder API.
///
/// This model is used as an example to demonstrate the template's
/// API integration patterns: apiFetch() → ApiResponse → ApiHandler.
///
/// **Fields**:
/// - `id`: Unique identifier for the post
/// - `userId`: ID of the user who created the post
/// - `title`: Post title/headline
/// - `body`: Post content/body text
///
/// **Example JSON**:
/// ```json
/// {
///   "userId": 1,
///   "id": 1,
///   "title": "sunt aut facere repellat provident",
///   "body": "quia et suscipit\nsuscipit recusandae..."
/// }
/// ```
///
/// **API Source**: https://jsonplaceholder.typicode.com/posts
class PostModel {
  /// Unique identifier for the post.
  final int id;

  /// ID of the user who created this post.
  final int userId;

  /// Title of the post.
  final String title;

  /// Body/content of the post.
  final String body;

  /// Constructor to initialize all required fields.
  PostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  /// Factory method to create a `PostModel` from a JSON map.
  ///
  /// [json] is the JSON map containing the post details from the API.
  ///
  /// Returns a `PostModel` instance.
  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json["id"],
        userId: json["userId"],
        title: json["title"],
        body: json["body"],
      );

  /// Converts the `PostModel` instance into a JSON map.
  ///
  /// Returns a map representing the `PostModel` instance.
  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "title": title,
        "body": body,
      };
}
