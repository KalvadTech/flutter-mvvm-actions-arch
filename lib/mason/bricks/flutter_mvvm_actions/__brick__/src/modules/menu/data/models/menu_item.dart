import 'package:flutter/material.dart';

/// Represents a single menu item in the navigation drawer.
///
/// Each menu item contains:
/// - A unique [id] for identification
/// - A [label] for display text
/// - An [icon] for visual representation
/// - An optional [page] widget to display when selected
///
/// ## Example:
/// ```dart
/// final homeItem = MenuItem(
///   id: 'home',
///   label: 'Home',
///   icon: Icons.home,
///   page: HomePage(),
/// );
/// ```
class MenuItem {
  /// Unique identifier for this menu item.
  final String id;

  /// Display label for the menu item.
  final String label;

  /// Icon to display alongside the label.
  final IconData icon;

  /// The page widget to display when this item is selected.
  ///
  /// If null, selecting this item won't change the displayed page.
  final Widget? page;

  /// Creates a [MenuItem].
  ///
  /// The [id], [label], and [icon] parameters are required.
  /// The [page] parameter is optional.
  const MenuItem({
    required this.id,
    required this.label,
    required this.icon,
    this.page,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MenuItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'MenuItem(id: $id, label: $label)';
}
