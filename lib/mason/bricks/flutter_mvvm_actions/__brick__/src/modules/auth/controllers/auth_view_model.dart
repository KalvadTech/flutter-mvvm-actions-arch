import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/modules/auth/data/models/user.dart';
import '/src/modules/auth/data/services/auth_service.dart';

/// **AuthState**
///
/// Authentication lifecycle states used by the app shell to decide what to render.
///
/// - `checking`: App is determining session status (splash/loading).
/// - `authenticated`: User has a valid session.
/// - `notAuthenticated`: No valid session; show login/registration.
///
/// Notes
/// - This enum is observed by [AuthHandler] via `Obx` to switch UI trees.
///
/// Example
/// // Used internally by [AuthViewModel].
///
// ────────────────────────────────────────────────
enum AuthState { checking, authenticated, notAuthenticated }

/// **AuthViewModel**
///
/// GetX controller responsible for managing authentication lifecycle and
/// exposing a reactive [AuthState] for the app shell.
///
/// Why
/// - Centralizes session checks, login/signup orchestration, and logout.
/// - Keeps views simple; they react to state via `Obx` and delegate actions
///   to [AuthActions] which wrap calls with loader and error handling.
///
/// Key Features
/// - Emits `checking → authenticated | notAuthenticated` deterministically.
/// - Supports token refresh via [AuthService.refreshSession].
/// - Clears sensitive credentials after successful sign-in.
/// - Supports state change callbacks for dependency registration.
///
/// Example
/// final vm = Get.find<AuthViewModel>();
/// if (vm.isAuthenticated()) { /* navigate to home */ }
///
// ────────────────────────────────────────────────
class AuthViewModel extends GetxController {
  /// Instance of `AuthService` to perform authentication-related operations.
  final AuthService _authService;

  /// Callback invoked when authentication state changes to authenticated.
  final VoidCallback? onAuthenticated;

  /// Callback invoked when authentication state changes to not authenticated.
  final VoidCallback? onNotAuthenticated;

  /// Observable authentication state.
  final Rx<AuthState> _authState = AuthState.checking.obs;

  /// Getter for the current authentication state.
  AuthState get authState => _authState.value;

  /// Stores the currently authenticated user.
  UserModel? _user;

  /// Getter for the currently authenticated user.
  UserModel? get user => _user;

  /// Stores the username and password for sign-in.
  String? username, password;

  /// Instance of a new user for the sign-up process.
  UserModel newUser = UserModel.empty();

  /// **AuthViewModel**
  ///
  /// Injects [AuthService] and triggers an initial [checkSession] to determine
  /// the starting auth state.
  ///
  /// **Parameters**
  /// - `authService`: Service used for token checks and auth calls.
  /// - `onAuthenticated`: Optional callback invoked when state becomes authenticated.
  /// - `onNotAuthenticated`: Optional callback invoked when state becomes not authenticated.
  ///
  /// // ────────────────────────────────────────────────
  AuthViewModel(
    this._authService, {
    this.onAuthenticated,
    this.onNotAuthenticated,
  }) {
    checkSession();
  }

  // Checks if there is an active session by verifying token status.
  // Refreshes the session if the access token is expired but the refresh token is valid.
  /// **checkSession**
  ///
  /// Determine current authentication status and emit a terminal state.
  ///
  /// Returns
  /// - `bool`: `true` when a valid session exists after checks/refresh; otherwise `false`.
  ///
  /// Side Effects
  /// - May call [AuthService.refreshSession] when access is expired and refresh is valid.
  /// - May clear tokens and set [AuthState.notAuthenticated] when refresh is expired.
  ///
  /// Errors
  /// - Any unexpected error is caught; state falls back to not authenticated.
  ///
  // ────────────────────────────────────────────────
  Future<bool> checkSession() async {
    checking();
    try {
      if (!await _authService.isLoggedIn()) {
        notAuthenticated();
        return false;
      }

      final isAccessTokenExpired = await _authService.isAccessTokenExpired();
      final isRefreshTokenExpired = await _authService.isRefreshTokenExpired();

      if (isAccessTokenExpired && !isRefreshTokenExpired) {
        await refreshSession();
      } else if (isRefreshTokenExpired) {
        // Refresh token expired → clear tokens and require login
        await _authService.signOut();
        notAuthenticated();
        return false;
      }

      authenticated();
      return true;
    } catch (_) {
      // Any unexpected error → fail safe to not authenticated
      notAuthenticated();
      return false;
    }
  }

  /// Refreshes the session by calling the refreshSession method from AuthService
  Future refreshSession() async {
    await _authService.refreshSession();
  }

  /// Performs user sign-in with the provided username and password.
  Future<void> signIn() async {
    await _authService.signIn(username!, password!);
    clear();
    authenticated();
  }

  /// Registers a new user using the provided `newUser` details.
  Future<void> signUp() async {
    await _authService.signUp(newUser);
  }

  /// Sets the state to authenticated and invokes the onAuthenticated callback.
  void authenticated() {
    _authState.value = AuthState.authenticated;
    onAuthenticated?.call();
  }

  /// Sets the state to not authenticated and invokes the onNotAuthenticated callback.
  void notAuthenticated() {
    _authState.value = AuthState.notAuthenticated;
    onNotAuthenticated?.call();
  }

  /// Sets the state to checking.
  void checking() {
    _authState.value = AuthState.checking;
  }

  /// Checks if the current state is authenticated.
  bool isAuthenticated() {
    return _authState.value == AuthState.authenticated;
  }

  /// Checks if the current state is checking.
  bool isChecking() {
    return _authState.value == AuthState.checking;
  }

  /// Logs out the user and sets the state to not authenticated.
  Future<void> logout() async {
    await _authService.signOut();
    notAuthenticated();
  }

  void clear() {
    username = null;
    password = null;
  }

}