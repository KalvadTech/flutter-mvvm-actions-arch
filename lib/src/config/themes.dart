import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Material 3 rosy‑red seeded theme.
///
/// Why
/// - Adopt Material 3 for modern components and dynamic color harmonization.
/// - Use a single seed to derive a cohesive ColorScheme.
///
/// Notes
/// - Prefer Theme.of(context).colorScheme.* in widgets instead of legacy fields.
final ThemeData theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE91E63)),
  textTheme: GoogleFonts.nunitoTextTheme(),
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.light,
  ),
);
