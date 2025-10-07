# getX_starter

A Flutter application template using **GetX** for state management with **MVVM + Actions Layer** architecture. Includes pre-built modules for authentication, connectivity, localization, theme management, and a complete API integration pattern example.

**Key Features:**
- 🏗️ Clean MVVM architecture with Actions layer for UX concerns
- 🔄 Reactive state management with GetX
- 🌐 Complete API integration pattern with `apiFetch → ApiResponse → ApiHandler`
- 🔐 Authentication with token refresh and secure storage
- 📡 Connectivity monitoring with offline handling
- 🌍 Multi-language support with localization
- 🎨 Light/Dark theme switching
- 📦 Strategy-based HTTP response caching
- 📝 Comprehensive documentation and coding guidelines

---

## Architecture

This template uses **MVVM (Model-View-ViewModel)** augmented with an **Actions layer** for user intent handling:

```
User Interaction
    ↓
View (Flutter Widgets)
    ↓
Actions (ActionPresenter) ← Loader, Error Handling, Feedback
    ↓
ViewModel (GetxController) ← Business Logic, State Management
    ↓
Service (ApiService) ← HTTP, Storage, Data Access
    ↓
Model (Data Classes) ← JSON Serialization
```

**Why This Pattern?**
- **Separation of Concerns**: UI, UX, logic, and data are clearly separated
- **Reactive Updates**: Views automatically rebuild when state changes
- **Reusable Error Handling**: Actions layer handles loaders, errors, and feedback consistently
- **Type-Safe API Integration**: `apiFetch()` → `ApiResponse<T>` → `ApiHandler<T>` provides automatic state management
- **Testable**: Each layer can be tested in isolation

---

## Template Structure

Each feature module follows a consistent structure:

```
lib/src/modules/<feature>/
├── actions/                      # User intent handlers (optional)
│   └── <feature>_actions.dart   # Extends ActionPresenter
├── controllers/                  # ViewModels
│   └── <feature>_view_model.dart # Extends GetxController
├── data/
│   ├── models/                  # Domain objects
│   │   └── <feature>_model.dart # fromJson/toJson serialization
│   └── services/                # Data access layer
│       └── <feature>_service.dart # Extends ApiService
├── views/                       # UI layer
│   ├── <feature>_page.dart     # Main page
│   └── widgets/                 # Feature-specific widgets
├── <feature>_bindings.dart      # GetX dependency injection
└── <feature>.dart               # Barrel export file
```

### Layer Responsibilities

#### **actions/** - User Intent Handlers
Extends `ActionPresenter` base class to handle user interactions with:
- **Global loader overlay** - Shows/hides loading spinner during async operations
- **Unified error handling** - Catches exceptions and displays user-friendly messages
- **Success feedback** - Shows snackbars/toasts for successful operations
- **Sentry reporting** - Automatically reports errors to crash analytics

**Example:**
```dart
class AuthActions extends ActionPresenter {
  Future signIn(BuildContext context) async {
    actionHandler(context, () async {
      await _authViewModel.signIn();
      showSuccessSnackBar('Success', 'Signed in successfully');
    });
  }
}
```

#### **controllers/** - ViewModels
Extends `GetxController` for business logic and state management:
- **Reactive state** with `Rx<T>` observables
- **Business logic orchestration** - Coordinates service calls
- **State wrapping** - Uses `ApiResponse<T>` for loading/success/error states
- **Lifecycle management** - `onInit()`, `onClose()` hooks

**Example:**
```dart
class PostViewModel extends GetxController {
  final Rx<ApiResponse<List<PostModel>>> _posts = ApiResponse.idle().obs;

  ApiResponse<List<PostModel>> get posts => _posts.value;

  @override
  void onInit() {
    super.onInit();
    _fetchPosts();
  }

  void _fetchPosts() {
    apiFetch(_postService.fetchPosts).listen((value) => _posts.value = value);
  }
}
```

#### **data/models/** - Domain Objects
Plain Dart classes representing domain entities:
- **Immutable** - All fields are `final`
- **JSON serialization** - `fromJson` factory and `toJson` method
- **No business logic** - Pure data containers

**Example:**
```dart
class PostModel {
  final int id;
  final String title;

  PostModel({required this.id, required this.title});

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {"id": id, "title": title};
}
```

#### **data/services/** - Data Access Layer
Extends `ApiService` for HTTP communication:
- **Automatic auth headers** - Injects bearer tokens
- **Retry on 401** - Refreshes token and retries once
- **Error mapping** - Converts HTTP errors to typed exceptions
- **Redacted logging** - Logs requests with sensitive data masked
- **Optional caching** - Strategy-based response caching

**Example:**
```dart
class PostService extends ApiService {
  Future<List<PostModel>> fetchPosts() async {
    final response = await get(APIConfiguration.postsUrl);
    return postModelFromJson(response.body);
  }
}
```

#### **views/** - Presentation Layer
Pure Flutter widgets:
- **Observes ViewModel** via `GetX<ViewModel>` or `Obx`
- **No business logic** - Delegates to Actions/ViewModels
- **No direct service calls** - Uses ViewModels only
- **Form validation** - Handles UI-level validation

---

## Core Components

### ActionPresenter
Base class for user intent handlers that wraps ViewModel calls with UX concerns:

- ✅ Shows global loader overlay during async operations
- ✅ Catches `AppException` and shows user-friendly error messages
- ✅ Reports exceptions to Sentry for crash analytics
- ✅ Safely guards overlay show/hide to prevent crashes in tests

**Usage:**
```dart
class MyActions extends ActionPresenter {
  Future doSomething(BuildContext context) async {
    actionHandler(context, () async {
      await _viewModel.performAction();
      showSuccessSnackBar('Done', 'Action completed');
    });
  }
}
```

### ApiResponse Pattern

Type-safe state container for async operations:

```dart
enum ApiStatus { idle, loading, success, error }

class ApiResponse<T> {
  final T? data;
  final Object? error;
  final ApiStatus status;

  bool get isLoading => status == ApiStatus.loading;
  bool get isSuccess => status == ApiStatus.success && data != null;
  bool get hasError => status == ApiStatus.error;
}
```

**apiFetch() Helper:**
Wraps service calls and emits `Stream<ApiResponse<T>>`:

```dart
apiFetch(_service.fetchData).listen((state) => _data.value = state);
// Emits: loading → success(data) OR error(message)
```

### ApiHandler Widget

Smart widget that automatically renders UI based on `ApiResponse` state:

```dart
ApiHandler<List<PostModel>>(
  response: controller.posts,          // ApiResponse state
  tryAgain: controller.refreshData,    // Retry callback
  isEmpty: (posts) => posts.isEmpty,   // Empty check
  successBuilder: (posts) => ListView(...), // Success UI

  // Optional customizations:
  loadingWidget: CustomLoader(),
  errorBuilder: (msg) => CustomError(msg),
  emptyBuilder: () => EmptyState(),
)
```

**States handled automatically:**
- **Loading** - Shows spinner or custom loading widget
- **Error** - Shows error message with retry button
- **Empty** - Shows empty state message
- **Success** - Builds UI with data using `successBuilder`

### ApiService

Centralized HTTP client extending GetConnect:

**Features:**
- ✅ Automatic `Authorization: Bearer <token>` header injection
- ✅ Token refresh on 401 with one-shot retry
- ✅ Typed exception mapping (`AuthException`, `APIException`)
- ✅ Redacted logging (masks sensitive headers)
- ✅ 120s timeout with configurable duration
- ✅ Optional response caching with strategy pattern
- ✅ File download support with progress callbacks

**Configuration:**
All API URLs must be defined in `lib/src/config/api_config.dart`:

```dart
class APIConfiguration {
  static const bool isDevelopment = true;
  static const String baseUrl = isDevelopment ? _stagingUrl : _productionUrl;

  static const String signInUrl = '$baseUrl/signin';
  static const String postsUrl = '$baseUrl/posts';
}
```

---

## API Integration Pattern

This template provides a complete, type-safe API integration pattern:

**Flow:** `Service` → `apiFetch()` → `ApiResponse<T>` → `ApiHandler<T>` → `UI`

### Quick Example

**1. Model:**
```dart
class PostModel {
  final int id;
  final String title;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id: json["id"],
    title: json["title"],
  );
}
```

**2. Service:**
```dart
class PostService extends ApiService {
  Future<List<PostModel>> fetchPosts() async {
    final response = await get(APIConfiguration.postsUrl);
    return postModelFromJson(response.body);
  }
}
```

**3. ViewModel:**
```dart
class PostViewModel extends GetxController {
  final Rx<ApiResponse<List<PostModel>>> _posts = ApiResponse.idle().obs;

  ApiResponse<List<PostModel>> get posts => _posts.value;

  @override
  void onInit() {
    super.onInit();
    _fetchPosts();
  }

  void _fetchPosts() {
    apiFetch(_postService.fetchPosts).listen((value) => _posts.value = value);
  }

  void refreshData() => _fetchPosts();
}
```

**4. View:**
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

**5. Bindings:**
```dart
class PostsBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostService>(() => PostService(), fenix: true);
    Get.put<PostViewModel>(PostViewModel(Get.find()), permanent: true);
  }
}
```

📖 **Complete Guide:** See `docs/examples/api_pattern_example.md` for detailed documentation with advanced patterns, POST requests, and migration guide.

---

## Getting Started

### Installation

You can use the template in two ways:

#### Manual
Clone the project and copy the `src` directory to your new Flutter project's `lib` directory. Or copy only the desired modules.

**Note:** If copying only specific modules, ensure you also copy the configuration files and dependencies.

#### Mason CLI
<p align="center">
<img src="https://raw.githubusercontent.com/felangel/mason/master/assets/mason_full.png" height="125" alt="mason logo" />
</p>

<p align="center">
<a href="https://pub.dev/packages/mason"><img src="https://img.shields.io/pub/v/mason.svg" alt="Pub"></a>
<a href="https://github.com/felangel/mason/actions"><img src="https://github.com/felangel/mason/workflows/mason/badge.svg" alt="mason"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

Install Mason CLI first (check [Mason documentation](https://github.com/felangel/mason)).

Add the template to your global bricks:

```sh
mason add -g --source git https://github.com/KalvadTech/getX-template --path lib/mason/bricks/get_x_template
```

Verify installation:

```sh
mason list
# or
mason ls
```

You should see:
```
get_x_template - A Flutter application template using getX for state management with pre defined modules for authentication, connections and localizations.
```

Create a new Flutter project, navigate to the `lib` folder, and run:

```sh
mason make get_x_template
```

#### Required Packages

Add these packages to your `pubspec.yaml` file (versions indicative; prefer keeping them in sync with this template's pubspec):

```yaml
dependencies:
  get: ^4.6.6
  loader_overlay: ^4.0.3
  flutter_spinkit: ^5.2.1
  connectivity_plus: ^6.1.0
  flutter_svg: ^2.0.13
  get_storage: ^2.1.1
  google_fonts: ^6.2.1
  intl: ^0.19.0
  jwt_decoder: ^2.0.1
  path_provider: ^2.1.5
  flutter_secure_storage: ^9.2.2
```

---

## Modules

All pre-defined modules are located in the `lib/src/modules/` directory.

### Authentication

Complete authentication flow with login/register pages, form validation, and token management.

**Architecture:**
- `AuthActions` - Extends `ActionPresenter` for sign-in/sign-up/logout with loader overlay and error handling
- `AuthViewModel` - Manages reactive auth state (`checking → authenticated | notAuthenticated`)
- `AuthService` - Extends `ApiService` for HTTP calls, validates response shape, persists tokens via `AppStorageService`
- `UserModel` - User data model with JSON serialization

**Features:**
- ✅ Username/password authentication with validation
- ✅ Token refresh on 401 with automatic retry
- ✅ Secure token storage (Keychain/Keystore)
- ✅ Session checking on app start
- ✅ Custom login/register pages with form validation
- ✅ Auth state machine with definitive states

**Configuration:**
1. Update API URLs in `lib/src/config/api_config.dart`
2. Update `UserModel` in `lib/src/modules/auth/data/models/user.dart` to match your API response
3. Customize `login.dart` and `register.dart` pages if needed

**Auth Flow:**
- App start: `AuthViewModel.checkSession()` verifies tokens → `authenticated` or `notAuthenticated`
- Login: View validates → `AuthActions.signIn()` shows loader → `AuthViewModel.signIn()` calls service → tokens saved → state updated
- Logout: `AuthViewModel.logout()` clears tokens → `notAuthenticated` state

📖 **Documentation:** See `docs/architecture/auth_module.md` for detailed architecture and testing guide.

### Connections

Real-time connectivity monitoring with offline/online detection and reachability probing.

**Architecture:**
- `ConnectionViewModel` - Reactive connectivity state (wifi/mobile/connecting/offline/noInternet)
- `ConnectionOverlay` - Global status bar showing connectivity changes
- `ConnectionHandler` - Widget that conditionally renders content based on connection state
- `ReachabilityService` - DNS/HTTP probing to verify internet access

**Features:**
- ✅ Wi-Fi, mobile data, and offline detection
- ✅ Reachability probing (DNS to google.com by default)
- ✅ Debounced connectivity events (250ms) to reduce flapping
- ✅ Automatic connectivity re-check on app resume
- ✅ Offline duration timer for telemetry
- ✅ Material 3 themed overlays with SafeArea and Semantics

**Usage:**

**Global Overlay** (shows connectivity status app-wide):
```dart
GlobalLoaderOverlay(
  child: ConnectionOverlay(
    child: GetMaterialApp(...),
  ),
)
```

**Conditional Rendering** (show content only when connected):
```dart
ConnectionHandler(
  connectedWidget: MyContent(),
  onConnectingWidget: ConnectingIndicator(),
  onRetry: () => controller.checkConnection(),
)
```

**State Management:**
- `ConnectivityType.wifi` and `ConnectivityType.mobileData` = connected
- `ConnectivityType.connecting` = probing reachability (NOT considered connected)
- `ConnectivityType.noInternet` = transport exists but no internet access

📖 **Documentation:** See `docs/architecture/connectivity_module.md` for configuration, testing, and telemetry callbacks.

### Posts Example

Reference implementation demonstrating the complete API integration pattern using JSONPlaceholder public API.

**Purpose:**
- 📚 Educational example of `apiFetch → ApiResponse → ApiHandler` pattern
- 🎯 Shows best practices for API integration
- 🔄 Demonstrates pull-to-refresh, error handling, and empty states
- 📝 Serves as template for creating your own API modules

**What It Demonstrates:**
- `PostModel` with `fromJson`/`toJson` serialization
- `PostService` extending `ApiService` with GET requests
- `PostViewModel` using `apiFetch()` pattern and `onInit()` initialization
- `PostsPage` with `ApiHandler` and `RefreshIndicator`
- `PostsBindings` with permanent ViewModel registration
- Material Design card-based UI with user badges

**Features:**
- ✅ Fetches 100 blog posts from `https://jsonplaceholder.typicode.com/posts`
- ✅ Automatic loading spinner
- ✅ Error handling with retry button
- ✅ Empty state detection
- ✅ Pull-to-refresh support
- ✅ Persistent state across navigation

**How to Adapt for Your API:**
1. Replace `PostModel` with your data model
2. Update `PostService` to call your API endpoints
3. Configure URLs in `APIConfiguration`
4. Customize `PostListTile` widget for your design
5. Add POST/PUT/DELETE methods as needed

📖 **Complete Guide:** See `docs/examples/api_pattern_example.md`

### Localization

Multi-language support with dynamic language switching and persistent preferences.

**Architecture:**
- `LocalizationViewModel` - Manages selected language and locale state
- `LocalizationService` - Loads translations and handles GetX locale updates
- `LanguageModel` - Language metadata (code, name, flag)
- `LanguagePickerDialog` - UI for language selection

**Features:**
- ✅ Arabic and English built-in (easily add more languages)
- ✅ Translation key management in `config/keys.dart`
- ✅ Right-to-left (RTL) support
- ✅ Persistent language preference
- ✅ Date formatting with locale awareness

**How to Add a Language:**
1. Add language to `LocalizationViewModel.supportedLanguages`
2. Create translation file in `lib/src/modules/locale/data/lang/<language_code>.dart`
3. Add translation keys with values

**Usage:**
```dart
Text('auth.login.title'.tr) // Uses GetX translation
```

### Theme

Light and dark theme switching with Material 3 design and persistent preferences.

**Architecture:**
- `ThemeViewModel` - Manages theme mode state (light/dark/system)
- `ThemeService` - Handles theme persistence
- `ThemeSwitch` - Switch widget for theme toggling
- `ThemeDrawerItem` - Drawer list tile for theme selection

**Features:**
- ✅ Material 3 design system
- ✅ Rosy-red seed color (`Color(0xFFE91E63)`)
- ✅ System theme detection
- ✅ Persistent theme preference
- ✅ Google Fonts integration

**Color Scheme:**
Uses Material 3 `ColorScheme.fromSeed()` with rosy-red seed color for automatic color generation.

**Usage:**
```dart
ThemeSwitch() // Switch widget
ThemeDrawerItem() // Drawer list tile
```

---

## Infrastructure Overview

This template splits cross-cutting concerns into clear layers:

### Core Layer (`lib/src/core/`)
Primitives and contracts:
- `core/errors/` - `AppException`, `AuthException`, `APIException`
- `core/presentation/` - `ApiResponse`, `ActionPresenter`

### Infrastructure Layer (`lib/src/infrastructure/`)
Concrete adapters:

#### HTTP (`infrastructure/http/`)
- `ApiService` - Centralizes headers, retry-after-refresh, error mapping, logging, and optional caching

#### Cache (`infrastructure/cache/`)
Strategy-based HTTP response caching:
- `CacheStore` - Storage interface
- `CacheKeyStrategy` - Cache key generation
- `CachePolicy` - Read/write rules and TTL
- `CacheManager` - Orchestrator
- Implementations: `GetStorageCacheStorage`, `DefaultCacheKeyStrategy`, `SimpleTimeToLiveCachePolicy`

**Enable caching in `main()`:**
```dart
final store = await GetStorageCacheStorage.create(
  container: AppStorageService.container,
);
final cache = CacheManager(
  store,
  const DefaultCacheKeyStrategy(),
  SimpleTimeToLiveCachePolicy(timeToLive: Duration(hours: 6)),
);
ApiService.configureCache(cache);
```

**Disable globally:**
```dart
ApiService.configureCache(null);
```

**Caching Rules:**
- GET requests use cache by default
- POST/PUT/DELETE do not cache unless explicitly opted in
- Only 2xx responses are cached
- Cache stores raw response text; decoding happens in `ApiService`

#### Storage (`infrastructure/storage/`)
- `AppStorageService` - Unified facade for device-local storage
- `PreferencesStorage` - GetStorage backend for preferences
- `SecureTokenStorage` - Keychain/Keystore backend for sensitive tokens

**Initialize in `main()`:**
```dart
await AppStorageService.instance.initialize();
```

**Usage:**
```dart
// Read token
final token = AppStorageService.instance.accessToken;

// Write token
await AppStorageService.instance.setAccessToken('token');

// Preferences
await AppStorageService.instance.preferences.write('key', 'value');
final value = AppStorageService.instance.preferences.read('key');
```

**Deprecation Note:** `MemoryService` is deprecated. Use `AppStorageService` for all storage needs.

### File Downloads

`ApiService.downloadFile()` reuses `GetConnect.get` with `ResponseType.bytes` for uniform behavior:
- ✅ Includes auth headers
- ✅ Retry-after-refresh on 401
- ✅ Honors timeout and logging
- ✅ Optional progress callback (reports completion)
- ✅ Writes bytes to disk

**Note:** For streaming progress or proxy/certificate customization, implement a specialized downloader.

---

## Documentation

Comprehensive documentation is available in the `docs/` directory:

### Architecture
- **`docs/architecture/coding_guidelines.md`** - Naming conventions, MVVM pattern, documentation style, module structure
- **`docs/architecture/auth_module.md`** - Authentication flow, state machine, testing guide
- **`docs/architecture/connectivity_module.md`** - Connectivity states, reachability, configuration

### Examples
- **`docs/examples/api_pattern_example.md`** - Complete API integration guide with step-by-step implementation, architecture flow diagram, POST request examples, and migration guide

### Changelog
- **`CHANGELOG.md`** - Full log of changes, migrations, and deprecations

---

## Quick Start Checklist

Follow these steps to adapt the template for your project:

### 1. Configure API URLs
Edit `lib/src/config/api_config.dart`:
```dart
static const String _stagingUrl = 'https://your-staging-api.com';
static const String _productionUrl = 'https://your-production-api.com';

static const String signInUrl = '$baseUrl/api/auth/signin';
static const String signUpUrl = '$baseUrl/api/auth/signup';
// Add your custom endpoints here
```

### 2. Initialize Storage
In `lib/src/main.dart`, ensure storage is initialized:
```dart
await AppStorageService.instance.initialize();
```

### 3. Update User Model
Edit `lib/src/modules/auth/data/models/user.dart` to match your API response:
```dart
class UserModel {
  final String id;
  final String email;
  // Add your fields here

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    email: json["email"],
    // Map your fields
  );
}
```

### 4. Create Your First Module
Use the `posts/` module as a reference:

1. Copy the posts module structure
2. Rename files and classes
3. Update the model to match your API response
4. Update the service to call your endpoint
5. Add module to `lib/src/utils/binding.dart`

### 5. Customize UI
- Replace app name in `pubspec.yaml`
- Update Material 3 seed color in theme module
- Customize login/register pages
- Add your app logo and assets

### 6. Test
- Run tests: `flutter test`
- Check analyzer: `flutter analyze`
- Test on devices/emulators

---

## Resources

A few resources to get you started with Flutter:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)
- [GetX Documentation](https://pub.dev/packages/get)
- [Material 3 Design](https://m3.material.io/)

For help getting started with Flutter, view the [online documentation](https://flutter.dev/docs), which offers tutorials, samples, guidance on mobile development, and a full API reference.

---

## License

MIT License - see LICENSE file for details

## Contributing

Contributions are welcome! Please read the coding guidelines in `docs/architecture/coding_guidelines.md` before submitting pull requests.
