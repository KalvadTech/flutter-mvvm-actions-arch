import 'package:flutter/material.dart';
import 'custom_text.dart';

/// **TextDivider**
///
/// A theme-aware horizontal divider with centered text label.
///
/// **Features**:
/// - Theme-aware colors with automatic light/dark mode support
/// - Centered text with dividers on both sides
/// - Customizable spacing, thickness, and text style
/// - Optional icon support
/// - Common use cases: "OR" dividers, section separators, timeline markers
///
/// **Usage**:
/// ```dart
/// // Simple text divider
/// TextDivider('OR')
///
/// // Custom styling
/// TextDivider(
///   'Section Title',
///   fontSize: 14,
///   fontWeight: FontWeight.bold,
///   spacing: 24,
/// )
///
/// // With icon
/// TextDivider(
///   'Account Settings',
///   icon: Icons.settings,
///   thickness: 2,
/// )
///
/// // Custom color
/// TextDivider(
///   'New Messages',
///   color: Colors.blue,
/// )
/// ```
class CustomTextDivider extends StatelessWidget {
  /// The text to display in the center of the divider.
  final String text;

  /// The vertical space around the divider.
  final double height;

  /// The thickness of the divider lines.
  final double thickness;

  /// The color of both the divider lines and text.
  ///
  /// If null, uses theme's divider color.
  final Color? color;

  /// Horizontal spacing between divider lines and text.
  final double spacing;

  /// Optional icon to display before the text.
  final IconData? icon;

  /// Font size for the text.
  final double? fontSize;

  /// Font weight for the text.
  final FontWeight? fontWeight;


  const CustomTextDivider(
    this.text, {
    super.key,
    this.height = 16.0,
    this.thickness = 1.0,
    this.color,
    this.spacing = 16.0,
    this.icon,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.dividerColor;

    return Row(
      children: [
        Expanded(
          child: Divider(
            height: height,
            thickness: thickness,
            color: effectiveColor,
          ),
        ),
        SizedBox(width: spacing),
        if (icon != null) ...[
          Icon(
            icon,
            size: fontSize ?? 14,
            color: effectiveColor,
          ),
          const SizedBox(width: 8),
        ],
        CustomText(
          text,
          color: effectiveColor,
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.w400,
        ),
        SizedBox(width: spacing),
        Expanded(
          child: Divider(
            height: height,
            thickness: thickness,
            color: effectiveColor,
          ),
        ),
      ],
    );
  }
}
