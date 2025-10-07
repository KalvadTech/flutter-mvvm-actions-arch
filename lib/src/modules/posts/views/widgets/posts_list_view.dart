import 'package:flutter/material.dart';
import '/src/modules/posts/data/models/post_model.dart';
import '/src/modules/posts/views/widgets/post_list_tile.dart';

/// **PostsListView**
///
/// Scrollable list view displaying multiple blog posts.
///
/// **Features**:
/// - Separated list items with spacing
/// - Safe area padding
/// - Responsive to different screen sizes
/// - Clean, modern card-based design
///
/// **Usage**:
/// ```dart
/// PostsListView(posts: postsList)
/// ```
class PostsListView extends StatelessWidget {
  /// List of posts to display.
  final List<PostModel> posts;

  const PostsListView({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: posts.length,
      itemBuilder: (context, index) => PostListTile(post: posts[index]),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }
}
