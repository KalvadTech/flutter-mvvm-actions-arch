import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// **Light Theme**
///
/// Material 3 rosy-red seeded light theme.
///
/// **Why**
/// - Adopt Material 3 for modern components and dynamic color harmonization.
/// - Use a single seed to derive a cohesive ColorScheme.
///
/// **Notes**
/// - Prefer Theme.of(context).colorScheme.* in widgets instead of legacy fields.
///
// ────────────────────────────────────────────────
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFE91E63),
    brightness: Brightness.light,
  ),
  textTheme: GoogleFonts.nunitoTextTheme(ThemeData.light().textTheme),
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
);

/// **Dark Theme**
///
/// Material 3 rosy-red seeded dark theme.
///
/// **Why**
/// - Provide dark mode support for better UX in low-light environments.
/// - Match light theme color palette for consistency.
///
/// **Notes**
/// - Uses same seed color to maintain brand consistency.
///
// ────────────────────────────────────────────────
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: const Color(0xFFE91E63),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFE91E63),
    brightness: Brightness.dark,
  ),
  textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme),
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.light,
  ),
);

/// Legacy export for backwards compatibility
@Deprecated('Use lightTheme instead')
final ThemeData theme = lightTheme;
