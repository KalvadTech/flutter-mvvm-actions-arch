import 'package:flutter/material.dart';

/// A centralized manager for defining colors and gradients used across the app.
class ColorManager {
  // **Primary Swatch**: A custom primary swatch for consistent theming.
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF00A79B,
    <int, Color>{
      50: Color(0xFFE0F7F5),
      100: Color(0xFFB3EBE3),
      200: Color(0xFF80DED1),
      300: Color(0xFF4DD0BE),
      400: Color(0xFF26C6AF),
      500: Color(0xFF00A79B),
      600: Color(0xFF009B8D),
      700: Color(0xFF008A7C),
      800: Color(0xFF00796B),
      900: Color(0xFF00594D),
    },
  );

  // **Basic Colors**
  static const Color lightBackgroundColor = Color(0xFF1f1f2e);
  static const Color darkBackgroundColor = Color(0xFF141523);
  static const Color cardColor = Color(0xFF141523);
  static const Color primaryColor = Color(0xFF00A79B);
  static const Color secondaryColor = Color(0xFFEA6969);
  static const Color appBarColor = Colors.white;
  static const Color iconsColor = Colors.white;
  static const Color titleColor = Colors.white;
  static const Color bodyColor = Colors.grey;
  static const Color buttonColor = Color(0xFF004843);
  static const Color lightButtonColor = Color(0xFF00A79B);
  static const Color negativeColor = Color(0xFFBE1500);
  static const Color lightNegativeColor = Color(0xFF641005);
  static const Color positiveColor = Color(0xFF00A79B);

  // **Gradients**
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [buttonColor, lightButtonColor],
  );
  static const LinearGradient positiveButtonGradient = LinearGradient(
    colors: [buttonColor, lightButtonColor],
  );
  static const LinearGradient negativeButtonGradient = LinearGradient(
    colors: [lightNegativeColor, negativeColor],
  );
}
