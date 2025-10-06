import 'package:flutter/material.dart';
import '/src/modules/menu/actions/menu_actions.dart';

/// Logout drawer item for the navigation menu.
///
/// Displays a logout option that triggers the logout flow.
///
/// ## Usage:
/// ```dart
/// Drawer(
///   child: ListView(
///     children: [
///       LogoutDrawerItem(),
///     ],
///   ),
/// )
/// ```
class LogoutDrawerItem extends StatelessWidget {
  /// Creates a [LogoutDrawerItem].
  const LogoutDrawerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.logout,
        color: Colors.red,
      ),
      title: Text(
        'Logout',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
      ),
      onTap: () => _showLogoutConfirmation(context),
    );
  }

  /// Shows a confirmation dialog before logging out.
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close drawer
              MenuActions.logout(); // Perform logout
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
