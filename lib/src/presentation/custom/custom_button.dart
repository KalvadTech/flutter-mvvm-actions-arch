import 'package:flutter/material.dart';
import '/src/utils/screen_utils.dart';
import '../../config/config.dart';
import 'custom_text.dart';

/// **CustomButton**
///
/// Reusable button widget with gradient backgrounds, disabled states, and semantic variants.
///
/// **Why**
/// - Provide consistent button styling across the app.
/// - Support positive/negative semantic variants for actions (e.g., confirm/cancel).
/// - Integrate responsive sizing and auto-translation.
///
/// **Key Features**
/// - Default constructor with customizable gradient and text color.
/// - Named constructors: `.positive` (green-toned) and `.negative` (red-toned).
/// - Disabled state visual feedback (grayed-out).
/// - Responsive width and padding via [ScreenUtils].
/// - Accepts either `text` (auto-translated) or custom `child` widget.
///
/// **Example**
/// ```dart
/// CustomButton.positive(
///   text: 'buttons.confirm',
///   onPressed: () => print('Confirmed'),
/// )
/// CustomButton.negative(
///   text: 'buttons.cancel',
///   onPressed: () => Navigator.pop(context),
/// )
/// ```
///
// ────────────────────────────────────────────────
class CustomButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final double? width;
  final LinearGradient gradient;
  final Color textColor;
  final double fontSize;
  final bool enabled;
  final EdgeInsets? padding;

  const CustomButton({
    super.key,
    this.text,
    this.onPressed,
    this.width = double.infinity,
    this.gradient = ColorManager.buttonGradient,
    this.textColor = ColorManager.titleColor,
    this.fontSize = 16.0,
    this.enabled = true,
    this.padding,
    this.child,
  });

  const CustomButton.positive({
    super.key,
    this.text,
    this.onPressed,
    this.width,
    this.gradient = ColorManager.positiveButtonGradient,
    this.textColor = ColorManager.titleColor,
    this.fontSize = 16.0,
    this.enabled = true,
    this.padding,
    this.child,
  });

  const CustomButton.negative({
    super.key,
    this.text,
    this.onPressed,
    this.width,
    this.gradient = ColorManager.negativeButtonGradient,
    this.textColor = ColorManager.titleColor,
    this.fontSize = 16.0,
    this.enabled = true,
    this.padding,
    this.child,
  });


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onPressed : null,
      child: Container(
          width: width ?? ScreenUtils.getScreenWidth(context, 0.12),
          padding: padding ?? EdgeInsets.all(ScreenUtils.getFontSize(context, 16)),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: enabled ? gradient.colors.last.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: enabled ? gradient.colors.last : Colors.grey)
          ),
          child: child ??
              CustomText(
                text ?? '',
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              )),
    );
  }
}
