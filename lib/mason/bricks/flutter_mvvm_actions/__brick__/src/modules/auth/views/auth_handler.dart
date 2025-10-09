import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth.dart';

/// **AuthHandler**
///
/// Observes [AuthViewModel] via `Obx` and renders the appropriate subtree based on
/// authentication state.
/// 
/// **Why**
/// - Centralizes auth-gate UI switching (splash while checking, login when unauthenticated,
///   main app when authenticated) in a simple, reusable widget.
///
/// **Parameters**
/// - `onChecking`: Widget to render while session status is being determined.
/// - `onAuthenticated`: Widget to render when a valid session exists.
/// - `onNotAuthenticated`: Widget to render when no session exists.
///
/// **Usage**
/// ```dart
/// AuthHandler(
///   onChecking: const SplashPage(),
///   onAuthenticated: const MenuPageWithDrawer(),
///   onNotAuthenticated: LoginPage(),
/// )
/// ```
///
/// Notes
/// - Requires an [AuthViewModel] to be bound in GetX (e.g., via a Binding) so that
///   [GetWidget] can resolve it.
///
/// // ────────────────────────────────────────────────
class AuthHandler extends GetWidget<AuthViewModel> {
  final Widget onAuthenticated;
  final Widget onChecking;
  final Widget onNotAuthenticated;

  const AuthHandler({
    super.key,
    required this.onChecking,
    required this.onAuthenticated,
    required this.onNotAuthenticated,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isChecking()
          ? onChecking
          : controller.isAuthenticated()
              ? onAuthenticated
              : onNotAuthenticated,
    );
  }
}
