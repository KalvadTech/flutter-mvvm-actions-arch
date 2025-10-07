# Changelog

All notable changes to this project template will be documented in this file.

The format is based on Keep a Changelog, and this project adheres loosely to Semantic Versioning for the template itself.

## [0.2.0] - 2025-10-02

### Added
- Introduced clear layering split between `core/` and `infrastructure/`:
  - `src/core/` now hosts primitives and presentation-layer contracts (e.g., `core/presentation/api_response.dart`, `core/errors/app_exception.dart`).
  - `src/infrastructure/` now hosts concrete adapters: `http/ApiService`, `cache/*`, and `storage/*`.
- Strategy-based HTTP response caching:
  - `infrastructure/cache/CacheStore`, `CacheKeyStrategy`, `CachePolicy`, and `CacheManager` abstractions.
  - Default implementations: `DefaultCacheKeyStrategy`, `SimpleTimeToLiveCachePolicy`, `GetStorageCacheStorage`.
  - Global enable/disable via `ApiService.configureCache(CacheManager?)`.
  - Header-aware cache keys (whitelist): keys now include `Accept-Language` and an `Authorization`-presence fingerprint to avoid wrong cache hits.
- Unified storage facade: `infrastructure/storage/AppStorageService` providing a single entry point for preferences (GetStorage) and secure tokens (Keychain/Keystore).
- Secure token storage: `SecureTokenStorage` backed by `flutter_secure_storage` with in-memory caches and initialization.
- Preferences storage: `PreferencesStorage` backed by `GetStorage` with a centralized container name.
- `ApiResponse<E>` upgraded to an immutable, error-preserving model with `ApiStatus { idle, loading, success, error }` and a thunk-based `apiFetch` helper.
- `ApiHandler<E>` simplified UI helper for rendering loading/success/error; now placed under `src/presentation/widgets/`.
- Downloading files: `ApiService.downloadFile` reimplemented using `GetConnect.get` to fetch bytes for uniform headers, timeout, logging, and refresh+retry handling.

### Changed
- `ApiService` hardening:
  - Authorization header formatting fixed and only included when a token exists.
  - One-shot retry of the original request after a successful 401 refresh.
  - Robust error mapping without secondary decode errors; sensitive logs are redacted and gated via `assert`.
  - Central cache helpers `_decodeCachedPayload`, `_tryServeFromCache`, `_tryWriteCache` to remove duplication across verbs.
  - Header handling: when a per-request `headers` map is provided, it is used as-is; otherwise, defaults (authorized headers) are applied. No merging.
- Caching defaults: GET uses cache by default; POST/PUT/DELETE do not cache unless explicitly opted in. Error responses are never cached.
- Moved shared UI utilities:
  - `api_handler.dart` → `src/presentation/widgets/api_handler.dart`.
  - `api_response.dart` → `src/core/presentation/api_response.dart`.
- README and coding guidelines updated to reflect the new structure and APIs.

- Auth module hardening:
  - AuthViewModel.checkSession now ends in `authenticated` or `notAuthenticated` and never stays in `checking` after completion.
  - AuthViewModel.logout now awaits `signOut()` before setting `notAuthenticated`.
  - AuthService.signIn validates response shape (`access`/`refresh`) and throws `APIException` on malformed bodies.
  - ActionPresenter guards loader overlay show/hide (no crash if overlay not mounted) and provides clearer user feedback for auth errors.

### Deprecated
- `MemoryService` is deprecated in favor of the unified `AppStorageService` facade and the split `PreferencesStorage` + `SecureTokenStorage`.

### Removed
- Legacy `essentials/` usage for infra concerns has been replaced by `infrastructure/`. Remove old imports and use the new paths.

### Fixed
- Incorrect `Authorization` header formatting (removed leading space and conditional inclusion).
- Avoid caching writes by default and prevent caching of error responses.
- Safer error logging: redacted `Authorization` header, truncated response previews, and `assert`-gated logs to avoid leaking in release builds.
- `downloadFile` now benefits from the same auth/timeout/logging behavior as other requests and writes bytes reliably to disk.

### Migration Notes
- Imports:
  - Replace `src/essentials/services/api_service.dart` with `src/infrastructure/http/api_service.dart`.
  - Replace `src/essentials/cache/*` with `src/infrastructure/cache/*`.
  - Replace `src/essentials/config/api_response.dart` with `src/core/presentation/api_response.dart`.
  - Use `src/presentation/widgets/api_handler.dart` instead of any legacy `views/custom/api_handler.dart` path.
- Storage:
  - Replace `MemoryService` usage with `AppStorageService`. Initialize once in `main()`:
    Example: await AppStorageService.instance.initialize();
  - For direct token operations, prefer the facade:
    Example: read via `AppStorageService.instance.accessToken` and write via `AppStorageService.instance.setAccessToken('...')`.
- Caching:
  - Enable globally in `main()` by creating a `GetStorage`-backed cache store, composing a `CacheManager` with a key strategy and policy, then calling `ApiService.configureCache(manager)`.
  - To disable globally, call `ApiService.configureCache(null)`.
  - To disable globally: `ApiService.configureCache(null);`
- ApiService header behavior:
  - When you pass `headers`, you must include `Authorization` and `content-type` yourself. If you pass `null`, defaults are applied.
- UI state helpers:
  - `ApiStatus.fail` → `ApiStatus.error`.
  - `ApiHandler` takes `successBuilder` (data-aware) and optional `loadingWidget`/`errorBuilder`; handle empty states in your success builder or parent widget.

### Security
- Tokens are now stored in platform secure storage by default; legacy migration kept in a separate method that can be removed in new projects.

---

## [0.1.0] - 2025-08-15
- Initial public template with GetX modules (auth, connections, locale, theme), basic theming, and `ActionPresenter`.

## [Unreleased]

### Added
- **Auth module tests**: 31 comprehensive tests for authentication
  - AuthViewModel (23 tests): initialization, state transitions, sign-in/sign-up/logout flows, token refresh, error handling, reactivity
  - AuthService (8 tests): mock sign-up, service instantiation, UserModel validation
  - All tests passing, bringing total test count from 171 to 202
- **Auth architecture documentation**: docs/architecture/auth_module.md covering:
  - Authentication states and transitions
  - Token lifecycle and refresh strategy
  - Mock authentication guide
  - Error handling patterns
  - Testing guidelines
  - Migration from mock to real API
- **Menu module refactoring**: Complete MVVM restructure with dual navigation patterns
  - MenuItem model for configurable menu items
  - MenuPageWithDrawer and MenuPageWithBottomNav ready to use
  - Sample pages (Dashboard, Settings, Profile) with clear mock warnings
  - LanguageDrawerItem and LogoutDrawerItem components
  - Menu module tests (10 tests) covering navigation and state
  - Documentation: docs/menu/README.md and docs/menu/NAVIGATION_TYPES.md
- **Theme module tests**: 92 comprehensive tests for theme management
  - ThemeViewModel tests covering initialization, theme switching, persistence
  - Widget tests for theme switcher UI components
- **Locale module tests**: 57 comprehensive tests for localization
  - LocalizationViewModel tests covering language selection and persistence
  - Language picker dialog widget tests
- PR3 (connections): Unit and widget tests for the connectivity module
  - ConnectionOverlay: renders connecting bar, offline card, and hides when connected
  - ConnectionHandler: shows connected content only when connected; retry tap triggers callback once
  - ConnectionViewModel: basic `isConnected` truth table
- Documentation: docs/architecture/connectivity_module.md covering states, ReachabilityService config, debounce, lifecycle re-check, theming (M3 tokens), and telemetry callbacks

### Changed
- Note: `connecting` is NOT treated as connected by `ConnectionViewModel.isConnected()` (landed in PR1; reiterated here for clarity in tests/docs)
- **Renamed MenuPage to MenuPageWithDrawer** for naming consistency with MenuPageWithBottomNav
- **Removed MenuPageWithBottomNavComplete** duplicate class; kept only MenuPageWithBottomNav

### Fixed
- **Color extension deprecation warnings**: Updated to use new Flutter Color API (a, r, g, b) instead of deprecated properties (alpha, red, green, blue)
- **Menu initialization bug**: Fixed MenuBindings to properly configure menu items on initialization

### Internal / Testability
- ConnectionViewModel: added optional `autoInit` constructor flag (default true) to skip platform connectivity initialization in tests. Does not affect production behavior
- MockAuthService created for testing AuthViewModel in isolation
