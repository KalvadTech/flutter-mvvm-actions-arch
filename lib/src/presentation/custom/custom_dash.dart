import 'package:flutter/material.dart';

/// **CustomDashLine**
///
/// A theme-aware widget that creates dashed separators (horizontal or vertical).
///
/// **Features**:
/// - Theme-aware colors with automatic light/dark mode support
/// - Horizontal and vertical orientations
/// - Customizable dash size, spacing, and fill rate
/// - Named constructors for common use cases
/// - Smooth rounded dash ends
///
/// **Usage**:
/// ```dart
/// // Horizontal divider (default)
/// CustomDashLine.divider()
///
/// // Vertical separator
/// CustomDashLine.vertical(height: 100)
///
/// // Custom dash pattern
/// CustomDashLine(
///   dashWidth: 8,
///   dashGap: 4,
///   color: Colors.blue,
/// )
/// ```
class CustomDashLine extends StatelessWidget {
  /// Creates a custom dashed line.
  const CustomDashLine({
    super.key,
    this.height = 1,
    this.dashHeight = 1,
    this.dashWidth = 5,
    this.dashGap = 5,
    this.color,
    this.direction = Axis.horizontal,
  });

  /// Creates a horizontal dashed divider (common use case).
  ///
  /// Uses theme's divider color and standard Material divider thickness.
  const CustomDashLine.divider({
    super.key,
    this.dashWidth = 4,
    this.dashGap = 4,
    this.color,
  })  : height = 1,
        dashHeight = 1,
        direction = Axis.horizontal;

  /// Creates a vertical dashed separator.
  ///
  /// [height] determines the total vertical extent of the separator.
  const CustomDashLine.vertical({
    super.key,
    required this.height,
    this.dashWidth = 4,
    this.dashGap = 4,
    this.color,
  })  : dashHeight = 1,
        direction = Axis.vertical;

  /// The total height of the line container (including padding).
  final double height;

  /// The thickness of each individual dash.
  final double dashHeight;

  /// The length of each individual dash.
  final double dashWidth;

  /// The gap between dashes.
  final double dashGap;

  /// The color of the dashes.
  ///
  /// If null, uses theme's divider color for seamless integration.
  final Color? color;

  /// The direction of the dashed line (horizontal or vertical).
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.dividerColor;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxSize = direction == Axis.horizontal
            ? constraints.constrainWidth()
            : constraints.constrainHeight();

        // Calculate number of dashes that can fit
        final dashUnit = dashWidth + dashGap;
        final dCount = (boxSize / dashUnit).floor();

        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: direction == Axis.horizontal ? height / 2 : 0,
            horizontal: direction == Axis.vertical ? height / 2 : 0,
          ),
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.start,
            direction: direction,
            children: List.generate(dCount, (index) {
              return Container(
                width: direction == Axis.horizontal ? dashWidth : dashHeight,
                height: direction == Axis.horizontal ? dashHeight : dashWidth,
                margin: EdgeInsets.only(
                  right: direction == Axis.horizontal && index < dCount - 1
                      ? dashGap
                      : 0,
                  bottom: direction == Axis.vertical && index < dCount - 1
                      ? dashGap
                      : 0,
                ),
                decoration: BoxDecoration(
                  color: effectiveColor,
                  borderRadius: BorderRadius.circular(dashHeight / 2),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
