import 'package:flutter/material.dart';
import '/src/modules/posts/data/models/post_model.dart';
import '/src/presentation/custom/custom_card.dart';

/// **PostListTile**
///
/// Individual list item widget displaying a single blog post.
///
/// **Features**:
/// - Clean card design with elevation
/// - User ID badge
/// - Bold title
/// - Truncated body text with ellipsis
/// - Tap interaction (optional navigation)
///
/// **Usage**:
/// ```dart
/// PostListTile(post: postModel)
/// ```
class PostListTile extends StatelessWidget {
  /// The post model to display.
  final PostModel post;

  const PostListTile({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FloatSurfaceCard(
      size: FSCSize.standard,
      elevation: FSCElevation.resting,
      onTap: () => _onPostTapped(context),
      header: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'User ${post.userId}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Spacer(),
          Text(
            '#${post.id}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            post.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),

          // Body (truncated)
          Text(
            post.body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Handles post tap interaction.
  ///
  /// Currently shows a snackbar. Replace with navigation to detail page:
  /// ```dart
  /// RouteManager.to('/post-detail', arguments: post);
  /// ```
  void _onPostTapped(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Post #${post.id}: ${post.title}'),
        duration: const Duration(seconds: 2),
      ),
    );

    // Optional: Navigate to detail page
    // RouteManager.to('/post-detail', arguments: post);
  }
}
