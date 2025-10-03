import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_starter/src/core/presentation/actions/action_presenter.dart';
import 'package:getx_starter/src/utils/route_manager.dart';
import '../controllers/auth_view_model.dart';

/// **AuthActions**
///
/// High-level user intents for authentication screens. Wraps calls to
/// [AuthViewModel] with a loader overlay and unified error handling via
/// [ActionPresenter]. Intended to be used directly from views.
///
/// Why
/// - Centralizes UX concerns (loader, toasts/snackbars, error surfaces).
/// - Keeps views thin: form validation occurs in the view; actions run here.
///
/// Key Features
/// - Shows a global loader while actions execute.
/// - Catches exceptions, reports to Sentry (via ActionPresenter), and shows feedback.
/// - Provides simple navigation helpers.
///
/// Example
/// // From LoginPage on submit:
/// // await AuthActions.instance.signIn(context);
///
// ────────────────────────────────────────────────
class AuthActions extends ActionPresenter {
  static final AuthActions _mInstance = AuthActions._();

  static AuthActions get instance => _mInstance;

  late AuthViewModel _authViewModel;

  AuthActions._() {
    _authViewModel = Get.find();
  }

  /// **signIn**
  ///
  /// Runs the sign-in flow using [AuthViewModel.signIn] wrapped with loader and
  /// error handling. Shows a success snackbar upon completion.
  ///
  /// Parameters
  /// - `context`: Build context used to show/hide the loader overlay and snackbars.
  ///
  /// Side Effects
  /// - Displays a global loader overlay while the action runs.
  /// - On success, shows a snackbar. Errors are handled by [ActionPresenter].
  ///
  /// Notes
  /// - Does not pop the current route implicitly.
  ///
  // ────────────────────────────────────────────────
  Future signIn(BuildContext context) async {
    actionHandler(context, () async {
      await _authViewModel.signIn();
      Get.snackbar('Sign In', 'Done Successfully');
    });
  }

  /// **signUp**
  ///
  /// Runs the sign-up flow using [AuthViewModel.signUp] wrapped with loader and
  /// error handling. Pops the current route if possible and shows a success
  /// snackbar instructing the user to log in.
  ///
  /// Parameters
  /// - `context`: Build context used to show/hide the loader overlay and snackbars.
  ///
  /// Side Effects
  /// - Displays a global loader overlay while the action runs.
  /// - On success, attempts to pop the current route (if any) and shows a snackbar.
  ///
  // ────────────────────────────────────────────────
  Future signUp(BuildContext context) async {
    actionHandler(context, () async {
      await _authViewModel.signUp();
      // Avoid unsafe pops; only pop if there is a route to pop.
      try {
        final navigator = Navigator.of(context);
        if (navigator.canPop()) navigator.pop();
      } catch (_) {/* ignore if no Navigator available */}
      Get.snackbar('Sign Up', 'Done Successfully Now Login');
    });
  }

  /// **toRegisterPage**
  ///
  /// Navigates to the registration page.
  ///
  /// Side Effects
  /// - Triggers navigation via [RouteManager].
  ///
  // ────────────────────────────────────────────────
  void toRegisterPage() {
    RouteManager.toRegisterPage();
  }
}
