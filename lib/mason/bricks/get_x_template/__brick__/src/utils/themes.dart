import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Creates a customized [ThemeData] object based on the provided parameters.
///
/// - `brightness`: The brightness of the theme (light or dark).
/// - `primarySwatch`: The primary material color swatch.
/// - `systemOverlayStyle`: Style of the system UI overlay (e.g., status bar).
/// - `background`: The background color for the app.
/// - `primaryText`: The primary text color.
/// - `secondaryText`: The secondary text color.
/// - `primaryColor`: The primary color for the theme.
/// - `accentColor`: The accent color used for interactive elements.
/// - `textTheme`: The text theme for the app.
/// - `divider`: Optional color for dividers.
/// - `buttonBackground`: Optional background color for buttons.
/// - `buttonText`: The text color for buttons.
/// - `cardBackground`: Optional background color for cards.
/// - `disabled`: Optional color for disabled elements.
/// - `error`: The color used to display errors.
/// - `fontFamily`: Optional font family for the text.

ThemeData createTheme({
  required Brightness brightness,
  required MaterialColor primarySwatch,
  required SystemUiOverlayStyle systemOverlayStyle,
  required Color background,
  required Color primaryText,
  required Color secondaryText,
  required Color primaryColor,
  required Color accentColor,
  required TextTheme textTheme,
  Color? divider,
  Color? buttonBackground,
  required Color buttonText,
  Color? cardBackground,
  Color? disabled,
  required Color error,
  String? fontFamily,
}) {
  return ThemeData(
    useMaterial3: false, // Disable Material 3 if needed
    brightness: brightness,
    canvasColor: background,
    cardColor: background,
    dividerColor: divider,
    textTheme: textTheme,
    dividerTheme: DividerThemeData(
      color: divider,
      space: 1,
      thickness: 1,
    ),
    cardTheme: CardThemeData(
      color: cardBackground,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
    ),
    primaryColor: primaryColor,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: accentColor,
      selectionColor: accentColor,
      selectionHandleColor: accentColor,
    ),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: systemOverlayStyle,
      backgroundColor: cardBackground,
      titleTextStyle: TextStyle(
        color: secondaryText,
        fontFamily: fontFamily,
        fontSize: 18,
      ),
      toolbarTextStyle: TextStyle(
        color: secondaryText,
        fontFamily: fontFamily,
        fontSize: 18,
      ),
      iconTheme: IconThemeData(color: secondaryText),
    ),
    iconTheme: IconThemeData(
      color: secondaryText,
      size: 16.0,
    ),
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: accentColor,
        secondary: accentColor,
        surface: background,
        error: error,
        onPrimary: buttonText,
        onSecondary: buttonText,
        onSurface: buttonText,
        onError: buttonText,
      ),
      padding: const EdgeInsets.all(16.0),
    ),
    cupertinoOverrideTheme: CupertinoThemeData(
      brightness: brightness,
      primaryColor: accentColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      errorStyle: TextStyle(color: error),
      labelStyle: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w600,
        fontSize: 16.0,
        color: primaryText.withValues(alpha: 0.5),
      ),
      hintStyle: TextStyle(
        color: secondaryText,
        fontSize: 13.0,
        fontWeight: FontWeight.w300,
      ),
    ),
    fontFamily: fontFamily,
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return null;
        if (states.contains(WidgetState.selected)) return accentColor;
        return null;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return null;
        if (states.contains(WidgetState.selected)) return accentColor;
        return null;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return null;
        if (states.contains(WidgetState.selected)) return accentColor;
        return null;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return null;
        if (states.contains(WidgetState.selected)) return accentColor;
        return null;
      }),
    ),
    dialogTheme: const DialogThemeData(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
    ),
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
    ).copyWith(
      surface: background,
      error: error,
    ),
  );
}
