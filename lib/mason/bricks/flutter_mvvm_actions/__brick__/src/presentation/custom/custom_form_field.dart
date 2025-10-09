import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/utils/responsive_utils.dart';

/// **CustomFormField**
///
/// A Material 3 theme-aware text input field with responsive sizing.
///
/// **Features**:
/// - Material 3 design with automatic light/dark mode support
/// - Responsive font sizing via [ScreenUtils]
/// - Built-in validation support
/// - Customizable borders, colors, and styling
/// - i18n support via GetX `.tr` extension
///
/// **Usage**:
/// ```dart
/// // Simple text field
/// CustomFormField(
///   hint: 'Enter your email',
///   controller: emailController,
/// )
///
/// // With validation and icon
/// CustomFormField(
///   hint: 'Username',
///   label: 'Username',
///   icon: Icon(Icons.person),
///   validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
/// )
///
/// // Multi-line with custom styling
/// CustomFormField(
///   hint: 'Description',
///   maxLines: 5,
///   fontSize: 16,
///   borderRadius: 12,
/// )
/// ```
class CustomFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String? hint;
  final String? label;
  final Widget? icon;
  final Widget? suffixIcon;
  final InputBorder? border;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final FormFieldSetter<String>? onChanged;
  final int? maxLines;
  final InputDecoration? decoration;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;
  final double borderRadius;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final FocusNode? focusNode;

  const CustomFormField({
    super.key,
    this.controller,
    this.hint,
    this.label,
    this.validator,
    this.onSaved,
    this.icon,
    this.suffixIcon,
    this.border,
    this.maxLines,
    this.decoration,
    this.onChanged,
    this.initialValue,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 14,
    this.borderRadius = 8.0,
    this.keyboardType,
    this.textInputAction,
    this.autofocus = false,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBackgroundColor =
        backgroundColor ?? colorScheme.surface;
    final effectiveTextColor = textColor ?? colorScheme.onSurface;
    final hintColor = colorScheme.onSurface.withValues(alpha: 0.6);

    final hintStyle = TextStyle(
      color: hintColor,
      fontWeight: FontWeight.w400,
      fontSize: ResponsiveUtils.scaledFontSize(context, fontSize),
    );

    final textStyle = TextStyle(
      color: effectiveTextColor,
      fontWeight: FontWeight.w500,
      fontSize: ResponsiveUtils.scaledFontSize(context, fontSize),
    );

    final borderRadiusValue = BorderRadius.circular(borderRadius);
    final defaultBorder = OutlineInputBorder(
      borderRadius: borderRadiusValue,
      borderSide: BorderSide(
        color: colorScheme.outline,
        width: 1,
      ),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: borderRadiusValue,
      borderSide: BorderSide(
        color: colorScheme.primary,
        width: 2,
      ),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: borderRadiusValue,
      borderSide: BorderSide(
        color: colorScheme.error,
        width: 1,
      ),
    );

    final focusedErrorBorder = OutlineInputBorder(
      borderRadius: borderRadiusValue,
      borderSide: BorderSide(
        color: colorScheme.error,
        width: 2,
      ),
    );

    return TextFormField(
      initialValue: initialValue,
      controller: controller,
      onSaved: onSaved,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      style: textStyle,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofocus: autofocus,
      obscureText: obscureText,
      readOnly: readOnly,
      enabled: enabled,
      focusNode: focusNode,
      decoration: decoration ??
          InputDecoration(
            filled: true,
            fillColor: effectiveBackgroundColor,
            contentPadding: const EdgeInsets.all(12.0),
            hintText: hint?.tr,
            labelText: label?.tr,
            prefixIcon: icon,
            suffixIcon: suffixIcon,
            border: border ?? defaultBorder,
            enabledBorder: border ?? defaultBorder,
            focusedBorder: border ?? focusedBorder,
            errorBorder: border ?? errorBorder,
            focusedErrorBorder: border ?? focusedErrorBorder,
            labelStyle: textStyle,
            hintStyle: hintStyle,
          ),
    );
  }
}

/// **PasswordFormField**
///
/// A Material 3 theme-aware password input field with visibility toggle.
///
/// **Features**:
/// - Material 3 design with automatic light/dark mode support
/// - Built-in password visibility toggle
/// - Responsive font sizing via [ScreenUtils]
/// - Validation support
/// - i18n support via GetX `.tr` extension
///
/// **Usage**:
/// ```dart
/// // Simple password field
/// PasswordFormField(
///   hint: 'Enter password',
///   controller: passwordController,
/// )
///
/// // With validation and custom styling
/// PasswordFormField(
///   hint: 'Password',
///   label: 'Password',
///   validator: (value) => value!.length < 6 ? 'Too short' : null,
///   fontSize: 16,
///   borderRadius: 12,
/// )
///
/// // With prefix icon
/// PasswordFormField(
///   hint: 'Password',
///   icon: Icon(Icons.lock),
/// )
/// ```
class PasswordFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String? hint;
  final String? label;
  final Widget? icon;
  final InputBorder? border;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final FormFieldSetter<String>? onChanged;
  final int? maxLines;
  final InputDecoration? decoration;
  final bool enabled;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;
  final double borderRadius;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final FocusNode? focusNode;

  const PasswordFormField({
    super.key,
    this.controller,
    this.initialValue,
    this.hint,
    this.label,
    this.icon,
    this.border,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.maxLines = 1,
    this.decoration,
    this.enabled = true,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 14,
    this.borderRadius = 8.0,
    this.keyboardType,
    this.textInputAction,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBackgroundColor =
        widget.backgroundColor ?? colorScheme.surface;
    final effectiveTextColor = widget.textColor ?? colorScheme.onSurface;
    final hintColor = colorScheme.onSurface.withValues(alpha: 0.6);

    final hintStyle = TextStyle(
      color: hintColor,
      fontWeight: FontWeight.w400,
      fontSize: ResponsiveUtils.scaledFontSize(context, widget.fontSize),
    );

    final textStyle = TextStyle(
      color: effectiveTextColor,
      fontWeight: FontWeight.w500,
      fontSize: ResponsiveUtils.scaledFontSize(context, widget.fontSize),
    );

    final borderRadiusValue = BorderRadius.circular(widget.borderRadius);
    final defaultBorder = OutlineInputBorder(
      borderRadius: borderRadiusValue,
      borderSide: BorderSide(
        color: colorScheme.outline,
        width: 1,
      ),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: borderRadiusValue,
      borderSide: BorderSide(
        color: colorScheme.primary,
        width: 2,
      ),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: borderRadiusValue,
      borderSide: BorderSide(
        color: colorScheme.error,
        width: 1,
      ),
    );

    final focusedErrorBorder = OutlineInputBorder(
      borderRadius: borderRadiusValue,
      borderSide: BorderSide(
        color: colorScheme.error,
        width: 2,
      ),
    );

    return TextFormField(
      initialValue: widget.initialValue,
      controller: widget.controller,
      enabled: widget.enabled,
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      validator: widget.validator,
      maxLines: widget.maxLines,
      style: textStyle,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType ?? TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      decoration: widget.decoration ??
          InputDecoration(
            filled: true,
            fillColor: effectiveBackgroundColor,
            contentPadding: const EdgeInsets.all(12.0),
            hintText: widget.hint?.tr,
            labelText: widget.label?.tr,
            hintStyle: hintStyle,
            labelStyle: textStyle,
            prefixIcon: widget.icon,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            border: widget.border ?? defaultBorder,
            enabledBorder: widget.border ?? defaultBorder,
            focusedBorder: widget.border ?? focusedBorder,
            errorBorder: widget.border ?? errorBorder,
            focusedErrorBorder: widget.border ?? focusedErrorBorder,
            errorMaxLines: 2,
          ),
    );
  }
}
