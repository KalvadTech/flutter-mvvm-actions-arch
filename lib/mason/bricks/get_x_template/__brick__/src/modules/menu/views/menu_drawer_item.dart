import 'package:flutter/material.dart';

/// A custom drawer item widget for the navigation menu.
///
/// Displays a menu item with an icon and label, with visual feedback
/// for the selected state.
///
/// ## Features:
/// - Shows icon and label horizontally
/// - Highlights when selected with primary color
/// - Responds to tap gestures
/// - Consistent styling and spacing
///
/// ## Example:
/// ```dart
/// MenuDrawerItem(
///   label: 'Home',
///   icon: Icons.home,
///   isSelected: true,
///   onTap: () => controller.selectMenuItem(homeItem),
/// )
/// ```
class MenuDrawerItem extends StatelessWidget {
  /// The text label to display.
  final String label;

  /// The icon to display before the label.
  final IconData icon;

  /// Whether this item is currently selected.
  final bool isSelected;

  /// Callback when the item is tapped.
  final VoidCallback onTap;

  /// Creates a [MenuDrawerItem].
  ///
  /// All parameters are required.
  const MenuDrawerItem({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.horizontal(
            right: Radius.circular(16.0),
          ),
          color: isSelected
              ? Theme.of(context).primaryColor.withValues(alpha: 0.5)
              : Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24.0,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
