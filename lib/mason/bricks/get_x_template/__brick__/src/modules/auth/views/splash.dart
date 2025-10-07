import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/src/config/config.dart';

/// **SplashPage**
///
/// Minimal splash screen shown while the app determines the current
/// authentication status. Typically rendered by [AuthHandler] when
/// [AuthState.checking] is active.
///
/// Why
/// - Provides a lightweight branded screen during initial session checks.
///
/// Notes
/// - Uses the app logo SVG and tints it with the active theme color.
///
/// // ────────────────────────────────────────────────
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          AssetsManager.logoPath,
          colorFilter: ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.srcIn),
          width: MediaQuery.of(context).size.height * 0.1,
        ),
      ),
    );
  }
}
