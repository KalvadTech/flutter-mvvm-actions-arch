import 'package:flutter/material.dart';
import '/src/presentation/custom/custom_card.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// ⚠️  MOCK PAGES - FOR DEMONSTRATION ONLY
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
// These pages are example implementations to showcase the menu module.
// They contain mock data and placeholder UI components.
//
// ⚠️ DO NOT USE IN PRODUCTION
//
// Replace these with your actual application pages:
// 1. Create your pages in their respective modules
// 2. Update menu_bindings.dart to use your pages
// 3. Remove or ignore this file
//
// See: docs/menu/README.md for instructions on adding menu items
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Dashboard/Home page for the application.
///
/// This page displays an overview of the application with
/// quick access cards and statistics.
class DashboardPage extends StatelessWidget {
  /// Creates [DashboardPage].
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24.0),

          // Stats Cards
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.folder,
                  title: 'Projects',
                  value: '12',
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: _StatCard(
                  icon: Icons.task_alt,
                  title: 'Tasks',
                  value: '48',
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.notifications,
                  title: 'Alerts',
                  value: '3',
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: _StatCard(
                  icon: Icons.check_circle,
                  title: 'Completed',
                  value: '28',
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32.0),

          Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16.0),

          // Activity List
          _ActivityItem(
            icon: Icons.add_task,
            title: 'New task created',
            subtitle: '2 hours ago',
          ),
          _ActivityItem(
            icon: Icons.done,
            title: 'Task completed',
            subtitle: '5 hours ago',
          ),
          _ActivityItem(
            icon: Icons.message,
            title: 'New message received',
            subtitle: '1 day ago',
          ),
        ],
      ),
    );
  }
}

/// Settings page for application configuration.
///
/// This page provides access to various app settings and
/// preferences.
class SettingsPage extends StatelessWidget {
  /// Creates [SettingsPage].
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 24.0),

        _SettingsSection(
          title: 'Account',
          children: [
            _SettingsTile(
              icon: Icons.person,
              title: 'Profile',
              subtitle: 'Manage your profile information',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.security,
              title: 'Privacy',
              subtitle: 'Privacy and security settings',
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 24.0),

        _SettingsSection(
          title: 'Preferences',
          children: [
            _SettingsTile(
              icon: Icons.notifications,
              title: 'Notifications',
              subtitle: 'Manage notification preferences',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.storage,
              title: 'Storage',
              subtitle: 'Manage app storage',
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 24.0),

        _SettingsSection(
          title: 'About',
          children: [
            _SettingsTile(
              icon: Icons.info,
              title: 'App Info',
              subtitle: 'Version 1.0.0',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.help,
              title: 'Help & Support',
              subtitle: 'Get help and support',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

/// Profile page for user information.
///
/// Displays user profile details and account information.
class ProfilePage extends StatelessWidget {
  /// Creates [ProfilePage].
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 24.0),

          // Profile Avatar
          CircleAvatar(
            radius: 50.0,
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              Icons.person,
              size: 50.0,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 16.0),

          Text(
            'John Doe',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'john.doe@example.com',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
          ),
          const SizedBox(height: 32.0),

          // Profile Info Cards
          _ProfileInfoCard(
            icon: Icons.email,
            title: 'Email',
            value: 'john.doe@example.com',
          ),
          const SizedBox(height: 12.0),
          _ProfileInfoCard(
            icon: Icons.phone,
            title: 'Phone',
            value: '+1 234 567 8900',
          ),
          const SizedBox(height: 12.0),
          _ProfileInfoCard(
            icon: Icons.location_on,
            title: 'Location',
            value: 'New York, USA',
          ),
          const SizedBox(height: 12.0),
          _ProfileInfoCard(
            icon: Icons.calendar_today,
            title: 'Member Since',
            value: 'January 2024',
          ),
          const SizedBox(height: 32.0),

          // Edit Profile Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper Widgets

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return FloatSurfaceCard(
      size: FSCSize.standard,
      elevation: FSCElevation.resting,
      width: double.infinity,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 32.0),
          const SizedBox(height: 12.0),
          Text(
            value.length > 1 ? value : '0$value',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4.0),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: FloatSurfaceCard(
        size: FSCSize.row,
        elevation: FSCElevation.quiet,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          child: Icon(icon, color: Theme.of(context).primaryColor, size: 20),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ),
        FloatSurfaceCard(
          size: FSCSize.standard,
          elevation: FSCElevation.resting,
          padding: EdgeInsets.zero,
          body: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileInfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return FloatSurfaceCard(
      size: FSCSize.standard,
      elevation: FSCElevation.resting,
      leading: Icon(icon, color: Theme.of(context).primaryColor, size: 24),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
