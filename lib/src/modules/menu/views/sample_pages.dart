import 'package:flutter/material.dart';

/// Sample page 1 for demonstration purposes.
///
/// This is a placeholder page that can be replaced with actual
/// application pages when implementing the menu system.
class Page1 extends StatelessWidget {
  /// Creates [Page1].
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home,
            size: 64.0,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 16.0),
          Text(
            'Page 1',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8.0),
          Text(
            'Home page content',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

/// Sample page 2 for demonstration purposes.
///
/// This is a placeholder page that can be replaced with actual
/// application pages when implementing the menu system.
class Page2 extends StatelessWidget {
  /// Creates [Page2].
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category,
            size: 64.0,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 16.0),
          Text(
            'Page 2',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8.0),
          Text(
            'Categories page content',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

/// Sample page 3 for demonstration purposes.
///
/// This is a placeholder page that can be replaced with actual
/// application pages when implementing the menu system.
class Page3 extends StatelessWidget {
  /// Creates [Page3].
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: 64.0,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 16.0),
          Text(
            'Page 3',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8.0),
          Text(
            'Profile page content',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
