import 'package:flutter/material.dart';
import 'custom_text.dart';

/// **CustomButton**
///
/// Modern Material 3 button wrapper with semantic variants and auto-translation.
///
/// **Why**
/// - Leverage Material 3's built-in theming, states, and accessibility
/// - Provide semantic variants for common actions (positive/negative/outlined)
/// - Auto-translate button text via CustomText
/// - Support loading and icon states
///
/// **Key Features**
/// - Default: Filled button with primary color
/// - `.positive`: Filled button with success/positive color scheme
/// - `.negative`: Filled button with error/destructive color scheme
/// - `.outlined`: Outlined button for secondary actions
/// - `.text`: Text button for low-emphasis actions
/// - Icon support via `icon` parameter
/// - Loading state with spinner via `isLoading` parameter
/// - Theme-aware colors that adapt to light/dark mode
/// - Automatic ripple, focus, and hover states
///
/// **Example**
/// ```dart
/// CustomButton(
///   text: 'buttons.confirm',
///   onPressed: () => print('Confirmed'),
/// )
///
/// CustomButton.positive(
///   text: 'buttons.save',
///   icon: Icons.check,
///   isLoading: isSaving,
///   onPressed: _handleSave,
/// )
///
/// CustomButton.negative(
///   text: 'buttons.delete',
///   icon: Icons.delete,
///   onPressed: _handleDelete,
/// )
/// ```
///
// ────────────────────────────────────────────────
class CustomButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final Widget? loadingWidget;
  final _ButtonStyle _style;
  final double? fontSize;

  /// Private constructor used by all named constructors
  const CustomButton._({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.loadingWidget,
    required _ButtonStyle style,
    this.fontSize,
  }) : _style = style;

  /// Default filled button with primary color.
  ///
  /// Use for primary actions and main CTAs.
  const CustomButton({
    Key? key,
    String? text,
    Widget? child,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    Widget? loadingWidget,
    double? fontSize,
  }) : this._(
          key: key,
          text: text,
          child: child,
          onPressed: onPressed,
          icon: icon,
          isLoading: isLoading,
          loadingWidget: loadingWidget,
          style: _ButtonStyle.filled,
          fontSize: fontSize,
        );

  /// Positive/success button (green-toned).
  ///
  /// Use for confirm, save, success actions.
  const CustomButton.positive({
    Key? key,
    String? text,
    Widget? child,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    Widget? loadingWidget,
    double? fontSize,
  }) : this._(
          key: key,
          text: text,
          child: child,
          onPressed: onPressed,
          icon: icon,
          isLoading: isLoading,
          loadingWidget: loadingWidget,
          style: _ButtonStyle.positive,
          fontSize: fontSize,
        );

  /// Negative/destructive button (red-toned).
  ///
  /// Use for delete, cancel, destructive actions.
  const CustomButton.negative({
    Key? key,
    String? text,
    Widget? child,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    Widget? loadingWidget,
    double? fontSize,
  }) : this._(
          key: key,
          text: text,
          child: child,
          onPressed: onPressed,
          icon: icon,
          isLoading: isLoading,
          loadingWidget: loadingWidget,
          style: _ButtonStyle.negative,
          fontSize: fontSize,
        );

  /// Outlined button for secondary actions.
  ///
  /// Use for secondary actions with less emphasis.
  const CustomButton.outlined({
    Key? key,
    String? text,
    Widget? child,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    Widget? loadingWidget,
    double? fontSize,
  }) : this._(
          key: key,
          text: text,
          child: child,
          onPressed: onPressed,
          icon: icon,
          isLoading: isLoading,
          loadingWidget: loadingWidget,
          style: _ButtonStyle.outlined,
          fontSize: fontSize,
        );

  /// Text button for low-emphasis actions.
  ///
  /// Use for tertiary actions like "Cancel" or "Skip".
  const CustomButton.text({
    Key? key,
    String? text,
    Widget? child,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    Widget? loadingWidget,
    double? fontSize,
  }) : this._(
          key: key,
          text: text,
          child: child,
          onPressed: onPressed,
          icon: icon,
          isLoading: isLoading,
          loadingWidget: loadingWidget,
          style: _ButtonStyle.text,
          fontSize: fontSize,
        );

  @override
  Widget build(BuildContext context) {
    final buttonChild = _buildButtonChild(context);
    final onPressedCallback = (isLoading || onPressed == null) ? null : onPressed;

    switch (_style) {
      case _ButtonStyle.filled:
        return _buildFilledButton(context, buttonChild, onPressedCallback);
      case _ButtonStyle.positive:
        return _buildPositiveButton(context, buttonChild, onPressedCallback);
      case _ButtonStyle.negative:
        return _buildNegativeButton(context, buttonChild, onPressedCallback);
      case _ButtonStyle.outlined:
        return _buildOutlinedButton(context, buttonChild, onPressedCallback);
      case _ButtonStyle.text:
        return _buildTextButton(context, buttonChild, onPressedCallback);
    }
  }

  /// Builds the button content (text/icon/loading spinner)
  Widget _buildButtonChild(BuildContext context) {
    // Loading state
    if (isLoading) {
      return loadingWidget ??
          const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
    }

    // Custom child widget
    if (child != null) {
      return child!;
    }

    // Icon + Text
    if (icon != null && text != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          CustomText(
            text!,
            fontSize: fontSize ?? 16,
            fontWeight: FontWeight.w600,
          ),
        ],
      );
    }

    // Icon only
    if (icon != null) {
      return Icon(icon, size: 20);
    }

    // Text only
    return CustomText(
      text ?? '',
      fontSize: fontSize ?? 16,
      fontWeight: FontWeight.w600,
    );
  }

  /// Standard filled button with primary color
  Widget _buildFilledButton(BuildContext context, Widget child, VoidCallback? callback) {
    return FilledButton(
      onPressed: callback,
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: child,
    );
  }

  /// Positive/success button (green)
  Widget _buildPositiveButton(BuildContext context, Widget child, VoidCallback? callback) {
    return FilledButton(
      onPressed: callback,
      style: FilledButton.styleFrom(
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.green[600]?.withValues(alpha: 0.38),
        minimumSize: const Size(double.infinity, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: child,
    );
  }

  /// Negative/destructive button (red)
  Widget _buildNegativeButton(BuildContext context, Widget child, VoidCallback? callback) {
    final colorScheme = Theme.of(context).colorScheme;

    return FilledButton(
      onPressed: callback,
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.error,
        foregroundColor: colorScheme.onError,
        disabledBackgroundColor: colorScheme.error.withValues(alpha: 0.38),
        minimumSize: const Size(double.infinity, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: child,
    );
  }

  /// Outlined button for secondary actions
  Widget _buildOutlinedButton(BuildContext context, Widget child, VoidCallback? callback) {
    return OutlinedButton(
      onPressed: callback,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: child,
    );
  }

  /// Text button for low-emphasis actions
  Widget _buildTextButton(BuildContext context, Widget child, VoidCallback? callback) {
    return TextButton(
      onPressed: callback,
      style: TextButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: child,
    );
  }
}

/// Internal enum for button style variants
enum _ButtonStyle {
  filled,
  positive,
  negative,
  outlined,
  text,
}
