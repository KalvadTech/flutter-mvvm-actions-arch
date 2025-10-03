# Auth Module

Status: stable | Last updated: 2025-10-03

This document explains the authentication module: its responsibilities, components, flows, storage, error handling, and how to integrate it into features and the app shell. It reflects the current architecture and guarantees implemented in the codebase.


## Why
// ────────────────────────────────────────────────
- Centralize authentication logic (API calls, token lifecycle, session checks).
- Keep views/controllers simple and focused on UI and basic orchestration.
- Enforce consistent error handling, loading UX, and storage usage across the app.


## High-level overview
// ────────────────────────────────────────────────
- Transport: built on ApiService (GetConnect) for robust HTTP with 401 refresh+retry, typed errors, and redacted logging.
- Storage: tokens live in secure storage via AppStorageService; preferences in GetStorage.
- State: AuthViewModel exposes a reactive AuthState the app shell uses to render splash/login/menu.
- UX actions: AuthActions wraps flows with loader overlays and unified error handling.


## Components
// ────────────────────────────────────────────────

### AuthService
- Path: lib/src/modules/auth/data/services/auth_service.dart
- Extends ApiService; performs sign-in/up; stores/clears tokens via AppStorageService.
- Validates sign-in response shape strictly (expects { access, refresh }).
- Provides isLoggedIn, isAccessTokenExpired, isRefreshTokenExpired using jwt_decoder.

Key methods:
- signIn(email, password) → bool
- signUp(UserModel) → bool
- signOut() → bool
- isLoggedIn() → bool
- isAccessTokenExpired() → bool (throws AuthException when no token)
- isRefreshTokenExpired() → bool (throws AppException when no token)


### AuthViewModel
- Path: lib/src/modules/auth/controllers/auth_view_model.dart
- GetX controller that emits AuthState: checking → authenticated | notAuthenticated.
- Performs checkSession() on construction; refreshes access token when refresh is valid.
- Exposes signIn(), signUp(), logout() which delegate to AuthService.

States:
- checking: splash/loader while determining session
- authenticated: valid session
- notAuthenticated: no/expired session


### AuthActions
- Path: lib/src/modules/auth/actions/auth_actions.dart
- High-level user intents for views. Wraps AuthViewModel operations via ActionPresenter.
- Shows global loader overlay, maps errors, reports to Sentry, and displays snackbars.
- Safe navigation (guards Navigator.pop with canPop()).

Actions:
- signIn(BuildContext context)
- signUp(BuildContext context)
- toRegisterPage()


### Views (current examples)
- Login page: lib/src/modules/auth/views/login.dart (validates input and calls AuthActions)
- AuthHandler: lib/src/modules/auth/views/auth.dart (app shell switcher between splash/login/menu using AuthState)


## Key guarantees (inherited from infrastructure)
// ────────────────────────────────────────────────
- Headers: If per-request headers are provided, they are used as-is; otherwise ApiService.getAuthorizedHeader() is used. Bearer is included only when a token exists; no spurious spaces.
- 401 handling: On a 401 response, ApiService attempts a refresh once and retries the original request once.
- Error mapping: Typed exceptions (AuthException, APIException, etc.); avoids secondary decode errors on non-JSON bodies.
- Logging: assert-gated redacted logs; Authorization header redacted; response preview truncated.
- Caching: Strategy-based, transport-agnostic; defaults to cache GET; never cache errors. Header-aware keys (Accept-Language, auth presence flag only).


## Session lifecycle flows
// ────────────────────────────────────────────────

### App start / checkSession()
1) AuthViewModel constructed → checkSession() runs.
2) If no access token → notAuthenticated.
3) If access expired and refresh valid → AuthService.refreshSession() (via ApiService) → authenticated on success; notAuthenticated if fails.
4) If refresh expired → clear tokens → notAuthenticated.

Outcome is always deterministic: authenticated or notAuthenticated (no sticky checking).


### Sign-in flow
1) View validates email/password and sets them into AuthViewModel.
2) AuthActions.signIn(context) → ActionPresenter shows loader.
3) AuthViewModel.signIn() → AuthService.signIn(email, password).
4) AuthService validates response shape, saves tokens via AppStorageService.
5) On success: loader hides; success snackbar shown; AuthViewModel.authenticated().
6) On failure: ActionPresenter handles errors, shows error snackbar, captures to Sentry.


### Sign-up flow
1) View builds a UserModel and assigns to AuthViewModel.newUser.
2) AuthActions.signUp(context) wraps AuthViewModel.signUp().
3) On success: guarded Navigator.pop() (if possible) and success snackbar prompting login.


### Logout flow
1) View triggers AuthViewModel.logout().
2) AuthService.signOut() clears tokens via AppStorageService.
3) AuthViewModel.notAuthenticated().


## Storage and security
// ────────────────────────────────────────────────
- Initialize storage once at startup:

```dart
Future<void> main() async {
  RouteManager.instance.initialize();
  await AppStorageService.instance.initialize();
  // optional: configure caching
  final store = await GetStorageCacheStorage.create(container: AppStorageService.container);
  final cacheManager = CacheManager(
    store,
    const DefaultCacheKeyStrategy(),
    SimpleTimeToLiveCachePolicy(timeToLive: const Duration(hours: 6)),
  );
  ApiService.configureCache(cacheManager);
  runApp(const App());
}
```

- Tokens are stored securely (FlutterSecureStorage) and accessed synchronously via AppStorageService caches.
- Preferences (language, theme, userId) live in GetStorage via PreferencesStorage, accessed through AppStorageService.
- MemoryService is deprecated; do not use.


## Error handling and UX
// ────────────────────────────────────────────────
- ActionPresenter centralizes loader overlay, snackbars, and Sentry reporting. It guards overlay show/hide calls to avoid crashes in contexts without an overlay or navigator.
- Auth-specific errors (e.g., invalid credentials) are mapped to clearer messages when possible.
- ApiHandler widget is available for request UI states outside of auth, but auth flows typically use AuthActions + snackbars.


## Using the module in views
// ────────────────────────────────────────────────

Example: Login submit handler
```dart
// Inside a StatefulWidget or GetView
final actions = AuthActions.instance;

void onSubmit(BuildContext context) async {
  // validate form and set AuthViewModel credentials first
  final vm = Get.find<AuthViewModel>();
  vm
    ..username = emailController.text.trim()
    ..password = passwordController.text;

  await actions.signIn(context); // loader + errors handled centrally
}
```

App shell: switch UI by auth state
```dart
class AuthHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Get.find<AuthViewModel>();
    return Obx(() {
      switch (vm.authState) {
        case AuthState.checking:
          return const SplashView();
        case AuthState.authenticated:
          return const MenuScaffold();
        case AuthState.notAuthenticated:
          return const LoginPage();
      }
    });
  }
}
```


## API contracts
// ────────────────────────────────────────────────
- Sign-in endpoint must return a JSON object with string fields: access, refresh.
- Refresh endpoint must accept { refresh } and return { access } on success.
- All write calls must set headers explicitly when unauthenticated (getUnauthorizedHeader()).


## Theming and UI
// ────────────────────────────────────────────────
- Material 3 theme using a rosy-red seed ColorScheme: ColorScheme.fromSeed(const Color(0xFFE91E63)).
- Use Theme.of(context).colorScheme.* for colors in auth views/snackbars.


## Testing guidelines
// ────────────────────────────────────────────────
- Unit test AuthService response validation (malformed JSON should throw APIException).
- Unit test checkSession branches: no tokens, access expired + refresh valid, refresh expired.
- Widget test AuthActions guards (no overlay / no Navigator) do not throw.


## FAQ & tips
// ────────────────────────────────────────────────
- Where should I decode JWT payload? Use jwt_decoder in service/viewmodel if you need claims; avoid doing it in views.
- How do I add social login? Keep token exchange in AuthService; add new endpoints/methods and reuse AppStorageService for persistence.
- Can I cache auth endpoints? No; default policy caches only GET and we do not cache errors or writes.


## Future improvements (backlog-aligned)
// ────────────────────────────────────────────────
- Parameterized AuthActions.signIn(username, password) for simpler call sites.
- Refined LoginPage UX and localization for error paths.
- Optional error path in AuthHandler to render better empty/error states.
- Consider bounded backoff for idempotent transient errors (408/429/5xx).
