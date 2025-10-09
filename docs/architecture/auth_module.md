# Authentication Module

Status: stable, tested (202 tests total, 31 for auth) | Last updated: 2025-10-07

This document summarizes the authentication module responsibilities, states, token lifecycle, mock authentication, error handling, and testing notes.


## Why
- Provide a single source of truth for authentication state across the app.
- Centralize session management, token refresh, and authentication flows.
- Offer a consistent, secure approach to credential handling and persistence.
- Enable testable authentication without requiring a backend (mock mode).


## High-level overview
- State controller: AuthViewModel (GetX)
  - Exposes `Rx<AuthState>` with three states: `checking`, `authenticated`, `notAuthenticated`.
  - Orchestrates sign-in, sign-up, logout, and session checks.
  - Delegates token operations and HTTP calls to AuthService.
  - Automatically checks session on initialization.
  - Clears sensitive credentials after successful operations.
- Service layer: AuthService (extends ApiService)
  - Handles HTTP authentication calls (sign-in, sign-up, refresh).
  - Manages token storage via AppStorageService (secure storage facade).
  - Validates JWT tokens using jwt_decoder.
  - Supports mock authentication for development/testing.
- Actions layer: AuthActions
  - Wraps authentication operations with loader overlays and error handling.
  - Presents user-friendly error messages via ActionPresenter.
  - Avoids unsafe navigation patterns.
- Views: AuthHandler, LoginPage, SignUpPage
  - AuthHandler switches UI based on AuthState.
  - Login/SignUp pages handle validation and user input.


## States

### AuthState enum
- `checking`: Initial state while determining session validity (splash screen).
- `authenticated`: User has a valid session (access token not expired or successfully refreshed).
- `notAuthenticated`: No valid session; user must sign in.

### State transitions
\`\`\`
App Start
   ↓
checking (AuthViewModel.checkSession())
   ↓
   ├─→ authenticated (valid tokens or successful refresh)
   └─→ notAuthenticated (no tokens or expired refresh token)

User Sign-In
   ↓
notAuthenticated
   ↓
AuthViewModel.signIn() → authenticated

User Logout
   ↓
authenticated
   ↓
AuthViewModel.logout() → notAuthenticated
\`\`\`

### Important notes
- `checking` is transient: always resolves to `authenticated` or `notAuthenticated`.
- State never stays stuck in `checking` after initialization completes.
- `isAuthenticated()` returns `true` only for `authenticated` state.


## File structure
\`\`\`
lib/src/modules/auth/
├── controllers/
│   └── auth_view_model.dart          # State management (GetX controller)
├── data/
│   ├── models/
│   │   └── user.dart                 # User data model
│   └── services/
│       └── auth_service.dart         # HTTP calls, token management
├── actions/
│   └── auth_actions.dart             # User action handlers with error handling
├── views/
│   ├── auth.dart                     # Main auth page
│   ├── auth_handler.dart             # State-based UI switcher
│   ├── login.dart                    # Login form
│   ├── sign_up.dart                  # Registration form
│   └── splash_page.dart              # Loading screen during checks
├── auth_bindings.dart                # GetX DI + feature module registration
└── auth.dart                         # Barrel export

test/modules/auth/
├── auth_view_model_test.dart         # 23 tests for AuthViewModel
└── auth_service_test.dart            # 8 tests for AuthService
\`\`\`


## Dependency management & callbacks

### State change callbacks

AuthViewModel supports optional callbacks for authentication state changes. This enables better separation of concerns and allows feature modules to be loaded on-demand without circular dependencies.

**Constructor signature:**
\`\`\`dart
class AuthViewModel extends GetxController {
  final AuthService _authService;
  final VoidCallback? onAuthenticated;
  final VoidCallback? onNotAuthenticated;

  AuthViewModel(
    this._authService, {
    this.onAuthenticated,
    this.onNotAuthenticated,
  });
}
\`\`\`

**When callbacks are triggered:**
- `onAuthenticated`: Called when user successfully signs in, signs up, or has a valid session
- `onNotAuthenticated`: Called when user logs out or session expires

**Why callbacks?**
- AuthViewModel doesn't need to know about Menu or Posts modules
- Feature modules registered only when user is authenticated
- Cleaner dependency graph (no circular dependencies)
- Better testability (can mock callbacks in tests)
- Improved performance (smaller initial bundle size)

### AuthBindings pattern

AuthBindings uses state callbacks to register feature modules on-demand:

\`\`\`dart
class AuthBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthService(), fenix: true);
    Get.lazyPut(
      () => AuthViewModel(
        Get.find(),
        onAuthenticated: _onAuthenticated,
        onNotAuthenticated: _onNotAuthenticated,
      ),
    );
  }

  /// Register feature modules for authenticated users
  void _onAuthenticated() {
    MenuBindings().dependencies();
    PostsBindings().dependencies();
    // Add other authenticated-only modules here
  }

  /// Optional cleanup when user logs out
  void _onNotAuthenticated() {
    // Cleanup logic if needed
  }
}
\`\`\`

**Benefits:**
- Menu and Posts modules only loaded after successful authentication
- No need to register all modules upfront in InitialBindings
- Clear separation between core (always-loaded) and feature (on-demand) modules
- Easy to add new authenticated-only modules

### Dependency lifecycle

\`\`\`
App Start
   ↓
InitialBindings registers:
   - ConnectionsBindings (permanent)
   - ThemeBindings (permanent)
   - LocaleBindings (permanent)
   ↓
AuthRoute triggered → AuthBindings registers:
   - AuthService (fenix: true, survives disposal)
   - AuthViewModel (with callbacks)
   ↓
checkSession() runs on AuthViewModel.onInit()
   ↓
   ├─→ authenticated → onAuthenticated() callback
   │      ↓
   │   MenuBindings().dependencies()
   │   PostsBindings().dependencies()
   │
   └─→ notAuthenticated → onNotAuthenticated() callback
          ↓
       (cleanup if needed)
\`\`\`

**Key points:**
- Use `Get.lazyPut()` with `fenix: true` for services that should survive controller disposal
- Feature modules registered via callbacks, not in InitialBindings
- Callbacks fired on every state change (login, logout, session refresh)
- Safe to call `.dependencies()` multiple times (GetX checks if already registered)


## Mock authentication

The service includes mock authentication for development and testing. See MOCK_AUTH_README.md for full details.

**⚠️ Important**: Set `_useMockAuth = false` in production builds.


## Testing

### Test coverage
- **31 tests** for auth module (AuthViewModel + AuthService).
- **23 tests** for AuthViewModel: initialization, state transitions, flows, errors, reactivity.
- **8 tests** for AuthService: mock sign-up, instantiation, UserModel validation.

### Running tests
\`\`\`bash
flutter test test/modules/auth/
\`\`\`


## References

- [GetX documentation](https://pub.dev/packages/get)
- [JWT decoder](https://pub.dev/packages/jwt_decoder)
- [Coding guidelines](./coding_guidelines.md)
- [Mock Auth Guide](../../MOCK_AUTH_README.md)
