# Project Coding, Documentation, and Naming Guidelines

These guidelines define how we name things, structure code, and document public APIs in this template. They merge the existing project conventions with a precise documentation style for Dart/Flutter (GetX, MVPVM-oriented). Follow them when adding or modifying code and when maintaining the mason brick.


## 1) Naming conventions (prefer specific, not shortened)
- Use clear, specific names. Avoid unnecessary abbreviations.
  - Good: `AuthenticationService`, `RefreshSession`, `AccessToken`, `CacheExpirationDuration`.
  - Avoid: `AuthSvc`, `refreshSess`, `accTok`, `cacheExpDur`.
- Allowed well‑established initialisms: `API`, `HTTP`, `URL`, `ID`, `JWT`, `TTL`.
- Dart casing:
  - Classes, enums, typedefs: PascalCase (e.g., `AuthService`, `ApiService`).
  - Methods, variables, parameters: lowerCamelCase (e.g., `refreshSession`, `accessToken`).
  - Constants: lowerCamelCase with `const` (avoid ALL_CAPS unless interop).
  - Private members: prefix with `_`.
- File and folder names: snake_case (e.g., `auth_service.dart`, `cache_policy.dart`).
- Widget names end with `Widget` only if they are generic wrappers; prefer descriptive names (e.g., `CustomTimeAgoText`).
- Do not use single‑letter names except for trivial loops.


## 2) File and folder structure
- Core primitives under `lib/src/core/` and app configuration under `lib/src/config/`.
- Features under `lib/src/modules/<feature>/` (current template). As MVPVM is introduced, new features may live under `lib/features/<feature>/` with `model/`, `domain/`, `data/`, `presentation/`.
- Caching abstractions live under `lib/src/infrastructure/cache/`:
  - `cache_store.dart`, `cache_key_strategy.dart`, `cache_policy.dart`, `cache_manager.dart`, plus defaults like `default_cache_key_strategy.dart`, `simple_ttl_cache_policy.dart` (`SimpleTimeToLiveCachePolicy`), and `get_storage_cache_store.dart` (`GetStorageCacheStorage`).
- HTTP-calling services should extend `ApiService` (current design) and live under each feature’s `data/services/`. ApiService itself lives under `lib/src/infrastructure/http/`.


## 3) Documentation style (DartDoc)
Language: English only. Tone: precise, engineering-grade. Use triple-slash `///` DartDoc for all public classes, constructors, methods, and important fields.

### 3.1 Golden rules
- Start each docblock with a bold title line, then a one-sentence summary.
- Prefer structured sections with bold headers in this order when applicable: **Why**, **Key Features**, **Parameters**, **Returns**, **Side Effects**, **Errors**, **Usage**, **Notes**.
- End major docblocks with a divider line on its own line:
  `// ────────────────────────────────────────────────`
- Keep paragraphs concise; use bullet lists for multiple points.
- Provide minimal, runnable code samples in fenced Dart blocks.

### 3.2 Class/Service doc template
````dart
/// **<ClassName>**
///
/// <One-sentence summary of what the class is responsible for.>
/// 
/// **Why**
/// - <Reason/intent>
/// - <Design choice(s) or pattern(s) used>
///
/// **Key Features**
/// - <Feature 1>
/// - <Feature 2>
/// - <Feature 3>
///
/// **Example**
/// ```dart
/// final vm = <ClassName>(...);
/// vm.doThing();
/// ```
///
// ────────────────────────────────────────────────
class ClassName { /* ... */ }
````

### 3.3 Method/function doc template
````dart
/// **<methodName>**
///
/// <One-sentence summary in the imperative mood.>
///
/// **Parameters**
/// - `<paramName>`: <description>
/// - `<paramName>`: <description>
///
/// **Returns**
/// - `<Type>`: <what the caller receives and when>
///
/// **Side Effects**
/// - <State mutations, navigation, I/O, analytics, timers, etc.>
/// 
/// **Errors**
/// - Throws `<ErrorType>` when <condition>.
/// - Returns `<Result>` with failure when <condition>.
///
/// **Usage**
/// ```dart
/// final ok = service.method(input);
/// ```
///
// ────────────────────────────────────────────────
````
> Omit sections that do not apply, but keep the order when present.

### 3.4 Properties, getters, setters
Document non-trivial fields and computed getters:
```dart
/// **currentUser**
///
/// Cached, authoritative user model after a successful sign-in.
/// Null until authentication completes.
final UserModel? currentUser;
```

### 3.5 Constructors
If logic exists (validation or dependency injection), document parameters and purpose:
```dart
/// **MyViewModel**
///
/// Injects services and primes reactive state.
/// 
/// **Parameters**
/// - `ProjectService projects`
/// - `int projectId`
// ────────────────────────────────────────────────
MyViewModel(this.projects, this.projectId) { /* ... */ }
```

### 3.6 Async, streams, and concurrency
Always call out lifecycle and threading:
```dart
/// **startListening**
///
/// Subscribes to the project stream and updates local cache.
///
/// **Side Effects**
/// - Opens a stream subscription; remember to call [dispose].
///
/// **Errors**
/// - Propagates network errors thrown by `projects.watch()`.
// ────────────────────────────────────────────────
```

### 3.7 MVVM & GetX documentation notes
- ViewModels: document what state they own and who updates it.
- Bindings: list registrations under **Side Effects**.
- Navigation: mention route pushes under **Side Effects** (e.g., “Navigates to `[RouteManager.verifyRoute]`”).

### 3.8 Translation keys
Prefer top-level constants unless a namespace is already required:
```dart
/// Translation Keys (top-level)
const String tkHomeMenuTitle = 'tour.home.menu.title';
const String tkHomeMenuDesc  = 'tour.home.menu.desc';
```
If a namespace class is used, document the group at the top and still use `///` style.

### 3.9 Error handling and results
- When using `Either`/`Result` types, state success and failure shapes under **Returns**.
- If throwing, list exact error types and conditions under **Errors**.

### 3.10 File-level header (optional)
At the top of important files, add a brief module banner:
```dart
// ==========================================================
// Module: Sentence Engine
// Purpose: Process and emit game sentences with TTS/STT glue.
// Depends: flutter_tts, speech_to_text
// Notes  : Keep UI out; pure logic only.
// ==========================================================
```

### 3.11 TODO / FIXME / DEPRECATED conventions
- `// TODO(username): <actionable task>`
- `// FIXME(username): <known bug>`
- `@deprecated` in DartDoc with a short migration note.

### 3.12 Formatting and line length for docs
- Keep lines around 100–110 characters max.
- Wrap bullets and sections cleanly; no trailing whitespace.
- Always place the divider line on its own line.

### 3.13 Commit messages tied to docs (nice-to-have)
- If a change modifies behavior, update docblocks in the same commit.
- Use prefixes like: `docs(vm):`, `docs(svc):`, `docs(api):`.


## 4) Dart & Flutter coding style (code)
- Null safety: prefer non‑nullable fields; use `?` only when a value is truly optional.
- Constructors: mark as `const` when possible; provide sensible defaults for named parameters.
- Immutability: prefer `final` for fields and local variables that do not change.
- Imports: use absolute package imports from `/src/...` (e.g., `import '/src/infrastructure/http/api_service.dart';`).
- Inline comments: keep brief and intent-revealing.
- Formatting: add trailing commas in widget trees to aid formatting.
- Widgets: keep views pure; do not call repositories/services directly in widgets.
- Time and date: encapsulate formatting in helpers or small widgets (see `custom_date_text.dart`).


## 5) Services and networking
- Centralize HTTP behavior in `ApiService`; feature services extend it.
- Authorization header: include `Authorization: Bearer <token>` only when a non‑empty token exists; no stray spaces.
- Retry policy: on 401, attempt one token refresh; if successful, retry once.
- Error handling: map to typed exceptions (`AuthException`, `APIException`) without secondary decode errors.
- Logging: gate logs with `assert(() { ... return true; }())`; redact sensitive data (mask Authorization header).
- Timeouts: default HTTP timeout is 120 seconds (set in `onInit`).
- File downloads: `ApiService.downloadFile` reuses `GetConnect.get` with `ResponseType.bytes` for uniform behavior and headers (including one-shot retry after refresh). It honors `httpClient.timeout` and logging, writes bytes to disk, and the optional progress callback reports completion since the body is returned whole. If you need true streaming progress or proxy/certificate customization, implement a specialized downloader.


## 6) Caching guidelines
- Store and retrieve raw response text (`bodyString`); rehydrate types at the call site using the provided decoder.
- Default policy:
  - Read from cache only when explicitly requested (`useCache == true`) and not forced to refresh.
  - Cache only successful (2xx) responses.
  - By default, cache `GET`; do not cache writes (`POST/PUT/DELETE`).
- Avoid caching error responses or sensitive endpoints (e.g., authentication).
- Strategy-based design:
  - Use `CacheStore` (storage), `CacheKeyStrategy` (key building), `CachePolicy` (read/write + TTL), and `CacheManager` (orchestrator).
  - Provide a global on/off switch by composing `CacheManager` at startup; if `null`, caching is disabled.


## 7) Architecture guidance (MVPVM baseline)
- Keep GetX for DI/routing in the near term.
- Views are pure widgets; no business logic or direct repository calls.
- Presenters handle user intents; ViewModels expose stream or listenable state.
- State classes are immutable and expose `copyWith`.
- Domain layer defines repository interfaces; data layer provides implementations.
- Use cases return `Future<Result<T>>` and should not throw.
- Inject dependencies via constructors (avoid service locators inside widgets).
- Naming: `<Feature>Presenter`, `<Feature>ViewModel`, `<Feature>State`, `<Feature>Repository`, `<Feature>RepositoryImpl`.


## 8) Theming
- Use Material 3 with rosy‑red seed color: `ColorScheme.fromSeed(seedColor: const Color(0xFFE91E63), brightness: Brightness.light)`.
- Prefer `Theme.of(context).colorScheme.*` over deprecated fields (SnackBars, FABs, dialogs, chips).


## 9) Testing and safety
- Unit test networking edge cases: 401 refresh retry, no cache on error, header formatting.
- Unit test cache policies and key strategies with deterministic inputs.
- Widget tests: keep views pure; use fakes for presenters and view models.


## 10) Git and PR hygiene
- Small, focused PRs. Describe the intent, behavior change, and risk.
- Commit messages in the imperative mood (e.g., "Add cache adapter strategy") and reference scope/files.


## 11) Exceptions and acceptable initialisms
- Accept widespread, unambiguous initialisms: `API`, `HTTP`, `URL`, `ID`, `JWT`, `TTL`.
- When in doubt, prefer the full word (e.g., `Identifier` over `Id`; `RefreshToken` over `Rt`).


---

These guidelines are living documentation. Propose improvements via PRs and mirror changes into the mason brick equivalents to keep generated projects aligned.

## 12) Storage
- Use AppStorageService as the unified facade for device-local storage: it exposes PreferencesStorage (GetStorage) for preferences and SecureTokenStorage (Keychain/Keystore) for sensitive tokens.
- Initialize storage once at app startup: `await AppStorageService.instance.initialize();`.
- Prefer reading tokens via AppStorageService synchronous getters for hot paths (e.g., HTTP headers): `AppStorageService.instance.accessToken`.
- MemoryService is deprecated. Do not use it in new code. Migrate existing references to AppStorageService (preferences) and SecureTokenStorage (tokens) or the facade’s methods.
- Align GetStorage container names across the app by using `AppStorageService.container`.



## Presenters: loader overlay guard

When showing a global loader overlay from presenters/actions (e.g., ActionPresenter), always guard calls so the app does not crash if the overlay is not mounted.

- Use context.mounted checks before interacting with the overlay.
- Wrap show/hide in try/catch to tolerate missing overlay in tests or minimal shells.
- Keep error handling centralized and avoid double-reporting the same error.

Example (simplified):
```dart
Future<void> actionHandler(BuildContext context, AsyncCallback action) async {
  // Show overlay if available
  try {
    if (context.mounted) {
      context.loaderOverlay.show();
    }
  } catch (_) { /* overlay not present; ignore */ }

  try {
    await action();
  } on AppException catch (e, st) {
    _handleException(e, st, e.prefix, e.message);
  } catch (e, st) {
    _handleException(e, st, tkError, tkSomethingWentWrongMsg);
  } finally {
    // Hide overlay if available
    try {
      if (context.mounted) {
        context.loaderOverlay.hide();
      }
    } catch (_) { /* overlay not present; ignore */ }
  }
}
```

Notes
- Prefer showing user-friendly messages for known auth failures (e.g., invalid credentials) while keeping generic copy for unknown errors.
- Keep logs redacted and use assert-gated logging for sensitive data.
