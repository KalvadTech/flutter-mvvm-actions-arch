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
├── auth_bindings.dart                # GetX dependency injection
└── auth.dart                         # Barrel export

test/modules/auth/
├── auth_view_model_test.dart         # 23 tests for AuthViewModel
└── auth_service_test.dart            # 8 tests for AuthService
\`\`\`


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
