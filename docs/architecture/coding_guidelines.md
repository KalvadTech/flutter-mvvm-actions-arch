# Project Coding, Documentation, and Naming Guidelines

These guidelines define how we name things, structure code, and document public APIs in this template. They merge the existing project conventions with a precise documentation style for Dart/Flutter using **MVVM + Actions Layer (GetX-based)** architecture. Follow them when adding or modifying code and when maintaining the mason brick.


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
- Features under `lib/src/modules/<feature>/` following MVVM + Actions layer structure:
  - `actions/` - User intent handlers extending ActionPresenter
  - `controllers/` - ViewModels (GetX Controllers)
  - `data/models/` - Domain objects (plain Dart classes)
  - `data/services/` - Data access layer (HTTP, storage)
  - `views/` - UI widgets
  - `bindings/` - GetX dependency injection (optional)
- Caching abstractions live under `lib/src/infrastructure/cache/`:
  - `cache_store.dart`, `cache_key_strategy.dart`, `cache_policy.dart`, `cache_manager.dart`, plus defaults like `default_cache_key_strategy.dart`, `simple_ttl_cache_policy.dart` (`SimpleTimeToLiveCachePolicy`), and `get_storage_cache_store.dart` (`GetStorageCacheStorage`).
- HTTP-calling services should extend `ApiService` and live under each feature's `data/services/`. ApiService itself lives under `lib/src/infrastructure/http/`.


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
Use top-level constants with dot-separated paths for translation keys:
```dart
/// Translation Keys (top-level)
const String tkHomeMenuTitle = 'pages.home.menu.title';
const String tkHomeMenuDesc  = 'pages.home.menu.description';
const String tkLoginBtn = 'buttons.login';
```
Group keys by domain (e.g., `auth.inputs.*`, `validations.*`, `errors.*`, `pages.*`, `buttons.*`) for better organization and maintainability.

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

### 5.1 API URL Configuration
- **All API URLs must be defined in `APIConfiguration`** class (`lib/src/config/api_config.dart`)
- **Never hardcode URLs in service classes**
- Use environment-aware URLs with `isDevelopment` flag for staging/production switching
- Group URLs by module with clear section dividers

**Example:**
```dart
// ✅ Good: URLs in APIConfiguration
class APIConfiguration {
  static const String baseUrl = isDevelopment ? _stagingUrl : _productionUrl;

  // --- Auth Module URLs ---
  static const String signInUrl = '$baseUrl/signin';

  // --- Posts Module URLs ---
  static const String postsUrl = '$baseUrl/posts';
}

// ✅ Good: Service uses APIConfiguration
class PostService extends ApiService {
  Future<List<PostModel>> fetchPosts() async {
    final response = await get(APIConfiguration.postsUrl);
    return postModelFromJson(response.body);
  }
}

// ❌ Bad: Hardcoded URL in service
class PostService extends ApiService {
  static const String _baseUrl = 'https://api.example.com'; // Wrong!

  Future<List<PostModel>> fetchPosts() async {
    final response = await get('$_baseUrl/posts'); // Wrong!
    return postModelFromJson(response.body);
  }
}
```

### 5.2 API Integration Pattern: apiFetch → ApiResponse → ApiHandler

This template provides a type-safe, reactive pattern for API integration with automatic state management.

**Pattern Overview:**
```
Service (HTTP) → apiFetch() → ApiResponse<T> → ApiHandler<T> → UI
```

**Benefits:**
- ✅ Automatic loading/success/error state management
- ✅ Type-safe data flow
- ✅ Reusable error handling
- ✅ Empty state detection
- ✅ Reactive UI updates via GetX

#### Step-by-Step Implementation

**1. Define Model with JSON serialization:**
```dart
class PostModel {
  final int id;
  final String title;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {"id": id, "title": title};
}
```

**2. Create Service extending ApiService:**
```dart
class PostService extends ApiService {
  Future<List<PostModel>> fetchPosts() async {
    final response = await get(APIConfiguration.postsUrl);
    return postModelFromJson(response.body);
  }
}
```

**3. Create ViewModel with apiFetch pattern:**
```dart
class PostViewModel extends GetxController {
  final PostService _postService;

  PostViewModel(this._postService);

  final Rx<ApiResponse<List<PostModel>>> _posts =
      ApiResponse<List<PostModel>>.idle().obs;

  ApiResponse<List<PostModel>> get posts => _posts.value;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  void _initialize() {
    _fetchPosts();
  }

  void _fetchPosts() {
    apiFetch(_postService.fetchPosts).listen((value) {
      _posts.value = value;
    });
  }

  void refreshData() {
    _fetchPosts();
  }
}
```

**Key Points:**
- Use `Rx<ApiResponse<T>>` for reactive state
- Call `_initialize()` in `onInit()`, NOT in constructor
- Wrap service calls with `apiFetch()` helper
- `apiFetch()` automatically emits: `loading` → `success`/`error`

**4. Create View with ApiHandler:**
```dart
class PostsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<PostViewModel>(
        builder: (controller) => RefreshIndicator(
          onRefresh: () async => controller.refreshData(),
          child: ApiHandler<List<PostModel>>(
            response: controller.posts,
            tryAgain: controller.refreshData,
            isEmpty: (posts) => posts.isEmpty,
            successBuilder: (posts) => ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(posts[index].title),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

**ApiHandler Parameters:**
- `response`: Current `ApiResponse<T>` state
- `tryAgain`: Callback for retry button (on error)
- `isEmpty`: Function to check if data is empty
- `successBuilder`: Widget builder for success state (receives data)
- `loadingWidget` (optional): Custom loading widget
- `errorBuilder` (optional): Custom error builder
- `emptyBuilder` (optional): Custom empty state widget

**5. Register in Bindings:**
```dart
class PostBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostService>(() => PostService());
    Get.lazyPut<PostViewModel>(() => PostViewModel(Get.find()));
  }
}
```

#### ApiResponse States

```dart
enum ApiStatus { idle, loading, success, error }

// Initial state
ApiResponse<T>.idle()

// Loading state (request in progress)
ApiResponse<T>.loading()

// Success state (data available)
ApiResponse<T>.success(data)

// Error state (request failed)
ApiResponse<T>.error(message)
```

#### Complete Example

See the **Posts module** for a working implementation:
- Model: `lib/src/modules/posts/data/models/post_model.dart`
- Service: `lib/src/modules/posts/data/services/post_service.dart`
- ViewModel: `lib/src/modules/posts/controllers/post_view_model.dart`
- View: `lib/src/modules/posts/views/posts_page.dart`
- Documentation: `docs/examples/api_pattern_example.md`

**Advanced: POST Requests**
```dart
// In Service
Future<PostModel> createPost({required String title, required String body}) async {
  final response = await post(APIConfiguration.postsUrl, {
    'title': title,
    'body': body,
  });
  return PostModel.fromJson(jsonDecode(response.body));
}

// In ViewModel
void createPost(String title, String body) {
  apiFetch(() => _postService.createPost(title: title, body: body))
    .listen((value) {
      _createResponse.value = value;
      if (value.status == ApiStatus.success) {
        refreshData(); // Refresh list on success
      }
    });
}
```


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


## 7) Architecture Overview: MVVM + Actions Layer (GetX-based)

### 7.1 Architecture Pattern

This template uses **MVVM (Model-View-ViewModel)** augmented with an **Actions layer** for user intent handling. While inspired by MVPVM and clean architecture concepts, it is adapted to GetX conventions and pragmatic Flutter development.

**Key Characteristics:**
- GetX for dependency injection, routing, and reactive state management
- No domain layer or repository pattern (services handle data directly)
- Actions layer wraps user intents with UX concerns (loaders, error handling)
- ViewModels expose reactive state; Views observe and render

### 7.2 Architectural Layers

#### **1. View (Presentation Layer)**
- Pure Flutter widgets (Stateless/Stateful)
- Observes ViewModel state via `GetX<ViewModel>` or `Obx`
- Handles UI rendering, form validation, and user input
- Delegates user actions to Actions layer
- **Does NOT** call Services directly or contain business logic

**Example:**
```dart
class LoginPage extends GetWidget<AuthViewModel> {
  void _login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      AuthActions.instance.signIn(context); // Delegates to Actions
    }
  }
}
```

**Naming:** `<Feature>Page`, `<Feature>Screen`, or descriptive widget names

---

#### **2. Actions (User Intent Handler)**
- Singleton classes extending `ActionPresenter` base class
- Wraps ViewModel method calls with:
  - Global loader overlay (via `loader_overlay` package)
  - Unified error handling and user feedback (snackbars/toasts)
  - Exception reporting to Sentry
- Provides navigation helpers
- **Purpose:** Separate UX concerns (loading states, errors, success messages) from business logic

**Example:**
```dart
class AuthActions extends ActionPresenter {
  Future signIn(BuildContext context) async {
    actionHandler(context, () async {
      await _authViewModel.signIn();
      Get.snackbar('Sign In', 'Done Successfully');
    });
  }
}
```

**Key Points:**
- `ActionPresenter` is a **base utility class**, not an architectural layer by itself
- Actions classes are feature-scoped singletons accessed via `.instance`
- Always pass `BuildContext` to show/hide overlays safely

**Naming:** `<Feature>Actions`

---

#### **3. ViewModel (Business Logic Layer)**
- GetX Controllers (`GetxController`)
- Orchestrates business logic and data fetching via Services
- Exposes **reactive state** using GetX observables (`Rx<T>`, `.obs`)
- Wraps data in `ApiResponse<T>` for lifecycle states (idle/loading/success/error)
- **Does NOT** handle UI concerns (no loaders, no snackbars, no navigation)

**Example:**
```dart
class GradeViewModel extends GetxController {
  final GradeService _gradeService;
  final Rx<ApiResponse<List<GradeModel>>> _grades = ApiResponse.idle().obs;

  ApiResponse<List<GradeModel>> get grades => _grades.value;

  void _fetchGrades() {
    apiFetch(_gradeService.fetchGrades).listen((value) => _grades.value = value);
  }
}
```

**Key Points:**
- Initialize via GetX Bindings (not service locators inside widgets)
- Use `apiFetch` helper to manage loading/success/error lifecycle
- ViewModels are stateful and lifecycle-aware (via `onInit`, `onClose`)

**Naming:** `<Feature>ViewModel`

---

#### **4. Service (Data Layer)**
- Classes extending `ApiService` (which extends GetConnect)
- Handle HTTP calls, token refresh, error mapping, and caching
- May also handle local storage (via `AppStorageService`)
- Return domain models (not raw JSON)
- **Does NOT** contain business logic (that's ViewModel's job)

**Example:**
```dart
class AuthService extends ApiService {
  Future<UserModel> signIn(String username, String password) async {
    final response = await post('/signin', {'username': username, 'password': password});
    if (response.isOk) return UserModel.fromJson(response.body);
    throw APIException(response.statusText);
  }
}
```

**Key Points:**
- `ApiService` provides automatic auth header injection, retry on 401, and redacted logging
- Services are registered in Bindings and injected into ViewModels
- **Service naming convention**: Use `*Service` suffix (e.g., `AuthService`, `GradeService`) instead of `*Repository`/`*RepositoryImpl`. This aligns with GetX conventions and keeps the template consistent.

**Naming:** `<Feature>Service`

---

#### **5. Model (Domain Objects)**
- Plain Dart classes representing domain entities
- Typically have `fromJson`/`toJson` methods for serialization
- Immutable when possible (all fields `final`)
- No business logic (pure data containers)

**Example:**
```dart
class GradeModel {
  final String id;
  final String name;

  GradeModel({required this.id, required this.name});

  factory GradeModel.fromJson(Map<String, dynamic> json) => GradeModel(
    id: json['id'],
    name: json['name'],
  );
}
```

**Naming:** `<Feature>Model`

---

### 7.3 Data Flow

```
User Interaction
    ↓
View (validates input, calls Actions)
    ↓
Actions (shows loader, calls ViewModel, handles errors)
    ↓
ViewModel (orchestrates Service calls, updates reactive state)
    ↓
Service (HTTP/storage operations, returns Models)
    ↓
ViewModel (wraps result in ApiResponse, emits to View)
    ↓
View (observes state change, re-renders UI)
    ↓
Actions (hides loader, shows success/error feedback)
```

---

### 7.4 Dependency Injection (GetX Bindings)

- Use GetX Bindings to register dependencies at route level or globally
- Avoid `Get.put()` or `Get.find()` directly in widgets
- Prefer constructor injection in Services/ViewModels

**Example:**
```dart
class AuthBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthService());
    Get.lazyPut(() => AuthViewModel(Get.find<AuthService>()));
  }
}
```

---

### 7.5 State Management Helpers

#### **ApiResponse<T>**
Immutable state container for async operations:
```dart
enum ApiStatus { idle, loading, success, error }

class ApiResponse<T> {
  final T? data;
  final Object? error;
  final StackTrace? stackTrace;
  final ApiStatus status;

  bool get isLoading => status == ApiStatus.loading;
  bool get hasData => data != null;
  bool get hasError => error != null;
}
```

#### **apiFetch<T>**
Stream-based helper for managing request lifecycle:
```dart
apiFetch(() => service.loadUser()).listen((state) => _user.value = state);
```

#### **ApiHandler<T>**
Widget that renders loading/success/error/empty states:
```dart
ApiHandler<List<GradeModel>>(
  response: controller.grades,
  tryAgain: controller.refreshData,
  isEmpty: (items) => items.isEmpty,
  successBuilder: (items) => GradesGridView(grades: items),
)
```

---

### 7.6 Comparison with Other Patterns

| Aspect | This Template | MVVM | MVPVM | MVC |
|--------|---------------|------|-------|-----|
| **View** | Pure widgets observing ViewModel | ✅ | ✅ | ❌ (Views update Model) |
| **ViewModel** | GetX Controllers with reactive state | ✅ | ✅ | ❌ |
| **Actions/Presenter** | Actions layer for UX (not classic Presenter) | ❌ | Presenter handles all view logic | Controller handles input |
| **Service/Repository** | Services (no repository pattern) | Varies | Repository + Use Cases | ❌ |
| **Domain Layer** | No domain layer (pragmatic) | ❌ | ✅ | ❌ |
| **Data Binding** | GetX observables (Obx, GetX<>) | ✅ | ✅ | ❌ |
| **DI** | GetX Bindings | Varies | Constructor injection | Varies |

**Summary:** This is **MVVM + Actions layer**, not MVPVM. We avoid the overhead of domain layers, use cases, and repository abstractions in favor of GetX-idiomatic, pragmatic patterns suitable for 90% of projects.

---

### 7.7 Architectural Principles

1. **Separation of Concerns**
   - Views: UI only
   - Actions: UX concerns (loaders, errors, toasts)
   - ViewModels: Business logic
   - Services: Data access

2. **Reactive State**
   - Views observe ViewModels via GetX reactivity
   - No manual state updates or `setState`

3. **Dependency Injection**
   - Services injected into ViewModels
   - ViewModels accessed in Views via `GetWidget<T>` or `Get.find<T>()`

4. **Error Handling**
   - Services throw typed exceptions (`AuthException`, `APIException`)
   - Actions catch and present errors to user
   - ViewModels propagate errors via `ApiResponse.error()`

5. **Single Responsibility**
   - Each layer has one job
   - No business logic in Views
   - No UI logic in ViewModels
   - No orchestration in Services

---

### 7.8 Folder Structure per Feature

```
lib/src/modules/<feature>/
├── actions/              # User intent handlers
│   └── <feature>_actions.dart
├── controllers/          # ViewModels
│   └── <feature>_view_model.dart
├── data/
│   ├── models/          # Domain objects
│   │   └── <feature>_model.dart
│   └── services/        # Data layer
│       └── <feature>_service.dart
├── views/               # UI widgets
│   ├── <feature>_page.dart
│   └── widgets/         # Feature-specific widgets
└── bindings/            # GetX DI configuration (optional)
    └── <feature>_bindings.dart
```


## 8) Connectivity module guidelines (connections)
- Single source of truth: use ConnectionViewModel for network state across the app. Do not create ad‑hoc listeners in widgets; instead, observe the VM.
- Binding/DI:
  - Register ConnectionViewModel early via ConnectionBindings before runApp if you place ConnectionOverlay above GetMaterialApp. This prevents null controller crashes at boot.
  - In other screens, InitialBindings also registers the VM lazily; avoid duplicate registrations by checking Get.isRegistered.
- State semantics:
  - ConnectivityType.connecting is a transitional state while reachability is probed; it is NOT considered connected by isConnected().
  - ConnectivityType.noInternet means transport exists (Wi‑Fi/Cellular) but the internet isn’t reachable (DNS/routing/captive portal).
  - Only ConnectivityType.wifi and ConnectivityType.mobileData are “connected”.
- Debounce and lifecycle:
  - Debounce connectivity events to reduce flapping (default 250 ms). The duration is configurable via the VM constructor.
  - Always re‑check connectivity on app resume (implemented via WidgetsBindingObserver in the VM). Do not duplicate this logic in views.
- Reachability:
  - Use ReachabilityService for probing. Default strategy is DNS lookup to google.com with a 3s timeout. You can switch to an HTTP health endpoint later without changing VM logic.
  - On Web, DNS probing is skipped; prefer HTTP health when strict web accuracy is required.
- Timers and telemetry:
  - The offline duration timer starts once when entering disconnected or noInternet and stops on reconnect; it is guarded against duplicates.
  - dialogTimer is an RxString and should be consumed via Obx.
  - Optional callbacks onWentOffline and onBackOnline(offlineDuration) are constructor params; inject your own logic where needed (toasts, logs, analytics).
- UI usage patterns:
  - Global overlay: wrap GetMaterialApp with ConnectionOverlay so status surfaces are available app‑wide. Example: GlobalLoaderOverlay → ConnectionOverlay → GetMaterialApp.
  - Section gating: use ConnectionHandler with connectedWidget, onConnectingWidget (for the probe state), and a manual retry for offline. Do not auto‑retry on every rebuild.
  - Theming: use Material 3 ColorScheme tokens: surfaceVariant for the connecting bar, errorContainer/onErrorContainer for the offline card. Wrap overlays in SafeArea and add Semantics labels.
- Error handling:
  - Do not throw from connectivity listeners or reachability checks. Drive UX solely from state transitions in the VM.
  - Avoid navigation in the VM; keep it presentation‑agnostic. Use actions layer to trigger user prompts when needed.
- Testing:
  - Construct ConnectionViewModel(autoInit: false) in tests to avoid platform calls.
  - Set connectionType.value directly to simulate states; set dialogTimer.value to assert timer rendering.
  - Widget tests: verify ConnectionOverlay surfaces and ConnectionHandler gating; ensure retry is user‑initiated.
- Configurability recap (VM constructor):
  - reachability: ReachabilityService (strategy/host/timeout/endpoint)
  - debounceDuration: Duration (default 250 ms)
  - onWentOfflineCallback: VoidCallback?
  - onBackOnlineCallback: void Function(Duration)?
  - autoInit: bool (default true)
- Views are pure widgets; no business logic or direct service calls.
- ActionPresenter handles user intents with error handling and loaders; ViewModels expose observable state.
- State classes wrapped in `ApiResponse<T>` with `ApiStatus { idle, loading, success, error }`.
- Data layer: Services extend `ApiService` and handle HTTP + persistence.
- Inject dependencies via constructors (GetX bindings); avoid service locators inside widgets.
- Naming: `<Feature>Actions`, `<Feature>ViewModel`, `<Feature>Service`, `<Feature>Model`.


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
