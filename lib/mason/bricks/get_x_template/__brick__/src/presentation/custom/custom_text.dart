import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/utils/responsive_utils.dart';

/// **CustomText**
///
/// Reusable text widget with responsive font sizing and GetX translation support.
///
/// **Why**
/// - Standardize text styling across the app with named constructors following Material Design.
/// - Integrate automatic translation via GetX `.tr` extension.
/// - Support responsive font scaling via [ScreenUtils].
/// - Theme-aware colors that adapt to light/dark mode.
///
/// **Key Features**
/// - Default constructor for body text (Material's bodyMedium).
/// - Named constructors: `.title`, `.subtitle`, `.caption` following Material Design type scale.
/// - Auto-translates `text` via GetX when rendered.
/// - Responsive `fontSize` scaling based on screen size.
/// - Theme-aware colors from `Theme.of(context).textTheme`.
///
/// **Example**
/// ```dart
/// CustomText.title('pages.home.title') // Large title, auto-translated
/// CustomText('Some body text') // Default body text
/// CustomText.caption('Last updated 2 hours ago') // Small caption text
/// ```
///
// ────────────────────────────────────────────────
class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final double fontSize;
  final double? letterSpacing;
  final double? height;
  final int? maxLines;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final String? semanticsLabel;

  /// Private base constructor used by all named constructors.
  const CustomText._(
    this.text, {
    super.key,
    required this.fontSize,
    required this.fontWeight,
    this.color,
    this.height,
    this.letterSpacing,
    this.fontFamily,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.decoration,
    this.decorationColor,
    this.semanticsLabel,
  });

  /// Default constructor for body text (Material Design bodyMedium).
  ///
  /// Font size: 14px (default), weight: w400 (default)
  const CustomText(
    String text, {
    Key? key,
    Color? color,
    double fontSize = 14.0,
    FontWeight fontWeight = FontWeight.w400,
    double? height,
    double? letterSpacing,
    String? fontFamily,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
    TextDecoration? decoration,
    Color? decorationColor,
    String? semanticsLabel,
  }) : this._(
          text,
          key: key,
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
          fontFamily: fontFamily,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          softWrap: softWrap,
          decoration: decoration,
          decorationColor: decorationColor,
          semanticsLabel: semanticsLabel,
        );

  /// Title text constructor (Material Design titleLarge).
  ///
  /// Font size: 22px, weight: w700
  /// Use for section titles and headers.
  const CustomText.title(
    String text, {
    Key? key,
    Color? color,
    double? height,
    double? letterSpacing,
    String? fontFamily,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
    TextDecoration? decoration,
    Color? decorationColor,
    String? semanticsLabel,
  }) : this._(
          text,
          key: key,
          fontSize: 22.0,
          fontWeight: FontWeight.w700,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
          fontFamily: fontFamily,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          softWrap: softWrap,
          decoration: decoration,
          decorationColor: decorationColor,
          semanticsLabel: semanticsLabel,
        );

  /// Subtitle text constructor (Material Design titleMedium).
  ///
  /// Font size: 16px, weight: w500
  /// Use for subtitles and secondary headers.
  const CustomText.subtitle(
    String text, {
    Key? key,
    Color? color,
    double? height,
    double? letterSpacing,
    String? fontFamily,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
    TextDecoration? decoration,
    Color? decorationColor,
    String? semanticsLabel,
  }) : this._(
          text,
          key: key,
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
          fontFamily: fontFamily,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          softWrap: softWrap,
          decoration: decoration,
          decorationColor: decorationColor,
          semanticsLabel: semanticsLabel,
        );

  /// Caption text constructor (Material Design bodySmall).
  ///
  /// Font size: 12px, weight: w400
  /// Use for small text, timestamps, and hints.
  const CustomText.caption(
    String text, {
    Key? key,
    Color? color,
    double? height,
    double? letterSpacing,
    String? fontFamily,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
    TextDecoration? decoration,
    Color? decorationColor,
    String? semanticsLabel,
  }) : this._(
          text,
          key: key,
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
          fontFamily: fontFamily,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          softWrap: softWrap,
          decoration: decoration,
          decorationColor: decorationColor,
          semanticsLabel: semanticsLabel,
        );

  /// Determines the theme-aware color based on font size.
  /// Falls back to theme defaults for light/dark mode support.
  Color? _getThemeColor(BuildContext context) {
    if (color != null) return color;

    final theme = Theme.of(context).textTheme;

    // Match based on font size to determine appropriate theme color
    if (fontSize >= 22) {
      return theme.titleLarge?.color;
    } else if (fontSize >= 16) {
      return theme.titleMedium?.color;
    } else if (fontSize >= 14) {
      return theme.bodyMedium?.color;
    } else {
      return theme.bodySmall?.color;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text.tr,
      style: TextStyle(
        fontSize: ResponsiveUtils.scaledFontSize(context, fontSize),
        color: _getThemeColor(context),
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        height: height,
        fontFamily: fontFamily,
        decoration: decoration,
        decorationColor: decorationColor,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      semanticsLabel: semanticsLabel,
    );
  }
}


/// **CustomTranslatedText**
///
/// Text widget that displays different strings based on the current locale.
///
/// **⚠️ Deprecation Notice:**
/// Consider using proper translation keys with CustomText instead.
/// This widget is useful for dynamic content from APIs with pre-translated text.
///
/// **Why**
/// - Handle hard-coded locale-specific text without translation keys.
/// - Useful for dynamic content received from APIs that includes multiple language variants.
///
/// **Key Features**
/// - Accepts separate text for different locales via a Map.
/// - Switches displayed text based on `Get.locale.languageCode`.
/// - Supports full text styling customization.
/// - Responsive font sizing via ScreenUtils.
///
/// **Example**
/// ```dart
/// CustomTranslatedText(
///   translations: {
///     'en': 'Hello',
///     'ar': 'مرحبا',
///     'fr': 'Bonjour',
///   },
///   fontSize: 16,
///   color: Colors.black,
/// )
/// ```
///
// ────────────────────────────────────────────────
class CustomTranslatedText extends StatelessWidget {
  final Map<String, String> translations;
  final String? fallbackText;
  final Color? color;
  final double fontSize;
  final double? letterSpacing;
  final double? height;
  final int? maxLines;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final String? semanticsLabel;

  const CustomTranslatedText({
    required this.translations,
    this.fallbackText,
    super.key,
    this.color,
    this.fontSize = 14.0,
    this.fontWeight,
    this.height,
    this.letterSpacing,
    this.fontFamily,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.decoration,
    this.decorationColor,
    this.semanticsLabel,
  });

  String _getLocalizedText() {
    final currentLocale = Get.locale?.languageCode ?? 'en';
    return translations[currentLocale] ?? fallbackText ?? translations.values.first;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _getLocalizedText(),
      style: TextStyle(
        fontSize: ResponsiveUtils.scaledFontSize(context, fontSize),
        color: color,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        height: height,
        fontFamily: fontFamily,
        decoration: decoration,
        decorationColor: decorationColor,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      semanticsLabel: semanticsLabel,
    );
  }
}
