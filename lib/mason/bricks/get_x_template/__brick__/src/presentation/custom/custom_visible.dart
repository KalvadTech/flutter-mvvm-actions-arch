import 'package:flutter/material.dart';

/// **CustomVisible**
///
/// A conditional visibility widget with optional animated transitions.
///
/// **Features**:
/// - Conditionally renders child based on `isVisible` flag
/// - Optional animated transitions (fade, scale, slide)
/// - Optional placeholder widget when child is hidden
/// - Configurable animation duration and curve
/// - Uses `SizedBox.shrink()` as default placeholder
///
/// **Usage**:
/// ```dart
/// // Simple visibility toggle (no animation)
/// CustomVisible(
///   isVisible: isLoggedIn,
///   child: ProfileWidget(),
/// )
///
/// // With fade animation
/// CustomVisible(
///   isVisible: showContent,
///   child: ContentWidget(),
///   animated: true,
///   animationType: VisibilityAnimation.fade,
/// )
///
/// // With slide animation and custom duration
/// CustomVisible(
///   isVisible: isExpanded,
///   child: DetailPanel(),
///   animated: true,
///   animationType: VisibilityAnimation.slideVertical,
///   duration: Duration(milliseconds: 300),
/// )
///
/// // With custom placeholder
/// CustomVisible(
///   isVisible: hasData,
///   child: DataView(),
///   placeholder: LoadingIndicator(),
/// )
/// ```
enum VisibilityAnimation {
  /// Fade in/out animation
  fade,

  /// Scale in/out animation
  scale,

  /// Slide from top animation
  slideVertical,

  /// Slide from left animation
  slideHorizontal,
}

class CustomVisible extends StatelessWidget {
  /// Whether the child widget should be visible.
  final bool isVisible;

  /// The widget to display when `isVisible` is true.
  final Widget child;

  /// Optional widget to display when `isVisible` is false.
  ///
  /// Defaults to `SizedBox.shrink()` if not provided.
  final Widget? placeholder;

  /// Whether to animate transitions between visible states.
  final bool animated;

  /// The type of animation to use when `animated` is true.
  final VisibilityAnimation animationType;

  /// Animation duration (only used when `animated` is true).
  final Duration duration;

  /// Animation curve (only used when `animated` is true).
  final Curve curve;

  const CustomVisible({
    super.key,
    required this.isVisible,
    required this.child,
    this.placeholder,
    this.animated = false,
    this.animationType = VisibilityAnimation.fade,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    if (!animated) {
      return isVisible ? child : (placeholder ?? const SizedBox.shrink());
    }

    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: curve,
      switchOutCurve: curve,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return _buildAnimatedTransition(child, animation);
      },
      child: isVisible
          ? KeyedSubtree(
              key: const ValueKey('visible'),
              child: child,
            )
          : KeyedSubtree(
              key: const ValueKey('hidden'),
              child: placeholder ?? const SizedBox.shrink(),
            ),
    );
  }

  Widget _buildAnimatedTransition(Widget child, Animation<double> animation) {
    switch (animationType) {
      case VisibilityAnimation.fade:
        return FadeTransition(
          opacity: animation,
          child: child,
        );

      case VisibilityAnimation.scale:
        return ScaleTransition(
          scale: animation,
          child: child,
        );

      case VisibilityAnimation.slideVertical:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.2),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );

      case VisibilityAnimation.slideHorizontal:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-0.2, 0),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
    }
  }
}
