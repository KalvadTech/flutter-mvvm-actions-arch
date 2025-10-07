# 🚀 getX_starter

A Flutter application template using **GetX** for state management with **MVVM + Actions Layer** architecture. Includes pre-built modules for authentication, connectivity, localization, theme management, and a complete API integration pattern example.

**✨ Key Features:**
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

## 📑 Table of Contents

- [💭 Philosophy](#-philosophy)
- [📏 Conventions & Guidelines](#-conventions--guidelines)
- [🚀 Quick Start](#-quick-start)
- [🏗️ Architecture](#️-architecture)
- [📁 Template Structure](#-template-structure)
- [🧩 Modules](#-modules)
- [🔌 API Integration Pattern](#-api-integration-pattern)
- [⚙️ Infrastructure Overview](#️-infrastructure-overview)
- [❓ FAQ](#-faq)
- [📚 Documentation](#-documentation)
- [✅ Quick Start Checklist](#-quick-start-checklist)
- [🤝 Contributing](#-contributing)
- [👤 Author & Acknowledgments](#-author--acknowledgments)
- [📄 License](#-license)
- [🔗 Resources](#-resources)

---

## 💭 Philosophy

**Why MVVM + Actions Layer?**

This template embraces **separation of concerns** at every level. Traditional MVVM often mixes UX concerns (loading overlays, error toasts, navigation) with business logic in ViewModels. By introducing an **Actions layer**, we achieve:

- **🧼 Clean Controllers**: ViewModels focus purely on business logic and state management
- **🎯 Centralized UX**: All loader overlays, error handling, and user feedback live in one place
- **🔁 Consistency**: Every user action follows the same pattern for error handling and feedback
- **🧪 Testability**: Each layer can be tested in isolation without mocking UI concerns
- **📖 Readability**: Code clearly expresses "what" (Actions) vs "how" (ViewModels)

**The Origin Story**

Real talk—I was tired of choosing between messy MVVM code and over-engineered MVPVM setups that take forever to implement. I wanted that clean **single responsibility** vibe from MVPVM without the headache. So I built this template as the perfect middle ground: powerful enough for production apps, simple enough to actually enjoy using. No cap.

**Why GetX?**

- **⚡ Minimal Boilerplate**: No need for BuildContext in most cases
- **🔄 Reactive by Default**: `.obs` and `Obx()` make state updates trivial
- **💉 Smart DI**: Lazy loading and automatic disposal of dependencies
- **🧭 Simple Routing**: Navigate without context, type-safe routes
- **🌍 Built-in i18n**: Translation system included

**🔌 Built Like LEGO Blocks**

This isn't your typical rigid template. It's built to adapt to your needs:

- **Plug & Play**: Use the entire template as-is, or cherry-pick just the modules that fit your project
- **Layer Independence**: Every architectural layer (Actions, ViewModels, Services) is decoupled—swap any layer with your own implementation without breaking the rest
- **Framework Agnostic**: Don't like GetX? No problem. Replace it with Riverpod, Bloc, or whatever you prefer. The architecture patterns remain solid regardless of your state management choice

Think of it as **architecture-as-a-library** rather than architecture-as-a-framework. You're in control.

**Clean Architecture Principles**

- **Layers don't skip**: View → Action → ViewModel → Service → Model (never View → Service directly)
- **Dependencies point inward**: Outer layers depend on inner layers, never the reverse
- **Immutable data**: Models are immutable value objects with no business logic
- **Single Responsibility**: Each class does one thing well
- **Fail loudly**: Use typed exceptions (`AppException`, `AuthException`) not error codes

---

## 📏 Conventions & Guidelines

Quick reference for architectural boundaries:

- **🧼 Views**: Pure Flutter widgets, zero business logic, delegate everything to Actions/ViewModels
- **🎛️ Actions**: Handle UX concerns (loaders, toasts, error surfaces), wrap ViewModel calls, never fetch data directly
- **🧠 Controllers**: Orchestrate services, expose reactive state, contain business logic, manage lifecycles
- **🌍 Services**: Data layer only (HTTP, storage, external APIs), return domain models, no state management
- **📦 Models**: Immutable, JSON serialization only, no methods beyond `fromJson`/`toJson`, all fields `final`
- **⏲️ State Management**: Prefer `ApiResponse<T>` over scattered boolean flags (`isLoading`, `hasError`)
- **🔗 Bindings**: File names must match module names (`posts_bindings.dart` for `posts/` module)
- **📁 Naming**: Use plural for collections (`models/`, `posts/`, `connections/`), singular for individual concepts

**Golden Rule**: If you're unsure where code belongs, ask: "Is this about **what** the user wants (Action), **how** to do it (ViewModel), or **where** to get it (Service)?"

---

## 🚀 Quick Start

### Installation

You can use this template in two ways:

#### 🎯 Option 1: Mason CLI (Recommended)

<p align="center">
<img src="https://raw.githubusercontent.com/felangel/mason/master/assets/mason_full.png" height="125" alt="mason logo" />
</p>

<p align="center">
<a href="https://pub.dev/packages/mason"><img src="https://img.shields.io/pub/v/mason.svg" alt="Pub"></a>
<a href="https://github.com/felangel/mason/actions"><img src="https://github.com/felangel/mason/workflows/mason/badge.svg" alt="mason"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

**1. Install Mason CLI:**
```sh
dart pub global activate mason_cli
```

**2. Add the template:**
```sh
mason add -g --source git https://github.com/KalvadTech/getX-template --path lib/mason/bricks/get_x_template
```

**3. Verify installation:**
```sh
mason list
# Output: get_x_template - A Flutter application template using getX...
```

**4. Create a new Flutter project:**
```sh
flutter create my_app
cd my_app/lib
```

**5. Generate from template:**
```sh
mason make get_x_template
```

You'll be prompted for:
- `project_name` - Your project name
- `description` - Brief description
- `org_name` - Organization identifier (e.g., com.example)

#### 📋 Option 2: Manual

1. Clone this repository
2. Copy the `lib/src/` directory to your Flutter project's `lib/` folder
3. Copy desired modules (or all of them)
4. Update `pubspec.yaml` with required dependencies (see below)

**⚠️ Note**: If copying only specific modules, ensure you also copy:
- `lib/src/core/` - Core abstractions
- `lib/src/infrastructure/` - HTTP, storage, cache services
- `lib/src/config/` - API configuration
- `lib/src/utils/` - Bindings and utilities

### 📦 Required Packages

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management & DI
  get: ^4.6.6

  # UI Components
  loader_overlay: ^4.0.3
  flutter_spinkit: ^5.2.1
  flutter_svg: ^2.0.13
  google_fonts: ^6.2.1

  # Connectivity
  connectivity_plus: ^6.1.0

  # Storage
  get_storage: ^2.1.1
  flutter_secure_storage: ^9.2.2
  path_provider: ^2.1.5

  # Utilities
  intl: ^0.19.0
  jwt_decoder: ^2.0.1
```

### ▶️ Run

```sh
flutter pub get
flutter run
```

---

## 🏗️ Architecture

This template uses **MVVM (Model-View-ViewModel)** augmented with an **Actions layer** for user intent handling:

```
User Interaction
    ↓
🧼 View (Flutter Widgets)
    ↓
🎛️ Actions (ActionPresenter) ← Loader, Error Handling, Feedback
    ↓
🧠 ViewModel (GetxController) ← Business Logic, State Management
    ↓
🌍 Service (ApiService) ← HTTP, Storage, Data Access
    ↓
📦 Model (Data Classes) ← JSON Serialization
```

### 🔑 Core Components

#### ActionPresenter
Base class for user intent handlers that wraps ViewModel calls with UX concerns:

- ✅ Shows global loader overlay during async operations
- ✅ Catches `AppException` and shows user-friendly error messages
- ✅ Reports exceptions to Sentry for crash analytics
- ✅ Safely guards overlay show/hide to prevent crashes in tests

**Usage:**
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

#### ApiResponse Pattern

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

#### ApiHandler Widget

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
- **⏳ Loading** - Shows spinner or custom loading widget
- **❌ Error** - Shows error message with retry button
- **📭 Empty** - Shows empty state message
- **✅ Success** - Builds UI with data using `successBuilder`

#### ApiService

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

## 📁 Template Structure

Each feature module follows a consistent structure:

```
lib/src/modules/<feature>/
├── actions/                      # 🎛️ User intent handlers (optional)
│   └── <feature>_actions.dart   # Extends ActionPresenter
├── controllers/                  # 🧠 ViewModels
│   └── <feature>_view_model.dart # Extends GetxController
├── data/
│   ├── models/                  # 📦 Domain objects
│   │   └── <feature>_model.dart # fromJson/toJson serialization
│   └── services/                # 🌍 Data access layer
│       └── <feature>_service.dart # Extends ApiService
├── views/                       # 🧼 UI layer
│   ├── <feature>_page.dart     # Main page
│   └── widgets/                 # Feature-specific widgets
├── <feature>_bindings.dart      # 💉 GetX dependency injection
└── <feature>.dart               # 📦 Barrel export file
```

### Layer Responsibilities

#### 🎛️ actions/ - User Intent Handlers
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

#### 🧠 controllers/ - ViewModels
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

#### 📦 data/models/ - Domain Objects
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

#### 🌍 data/services/ - Data Access Layer
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

#### 🧼 views/ - Presentation Layer
Pure Flutter widgets:
- **Observes ViewModel** via `GetX<ViewModel>` or `Obx`
- **No business logic** - Delegates to Actions/ViewModels
- **No direct service calls** - Uses ViewModels only
- **Form validation** - Handles UI-level validation

---

## 🧩 Modules

All pre-built modules are located in the `lib/src/modules/` directory.

### 🔐 Authentication

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
- **App start**: `AuthViewModel.checkSession()` verifies tokens → `authenticated` or `notAuthenticated`
- **Login**: View validates → `AuthActions.signIn()` shows loader → `AuthViewModel.signIn()` calls service → tokens saved → state updated
- **Logout**: `AuthViewModel.logout()` clears tokens → `notAuthenticated` state

📖 **Documentation:** See `docs/architecture/auth_module.md` for detailed architecture and testing guide.

### 📡 Connections

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

### 📝 Posts Example

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

### 🌍 Localization

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

### 🎨 Theme

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

### 🍔 Menu

Simple drawer menu with navigation to all modules and theme/language pickers.

**Features:**
- ✅ Navigation to all module pages
- ✅ Theme switcher integration
- ✅ Language picker integration
- ✅ Material 3 design

---

## 🔌 API Integration Pattern

This template provides a complete, type-safe API integration pattern:

**Flow:** `Service` → `apiFetch()` → `ApiResponse<T>` → `ApiHandler<T>` → `UI`

### 🎯 Quick Example

**1️⃣ Model:**
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

**2️⃣ Service:**
```dart
class PostService extends ApiService {
  Future<List<PostModel>> fetchPosts() async {
    final response = await get(APIConfiguration.postsUrl);
    return postModelFromJson(response.body);
  }
}
```

**3️⃣ ViewModel:**
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

**4️⃣ View:**
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

**5️⃣ Bindings:**
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

## ⚙️ Infrastructure Overview

This template splits cross-cutting concerns into clear layers:

### 🏛️ Core Layer (`lib/src/core/`)
Primitives and contracts:
- `core/errors/` - `AppException`, `AuthException`, `APIException`
- `core/presentation/` - `ApiResponse`, `ActionPresenter`

### 🔧 Infrastructure Layer (`lib/src/infrastructure/`)
Concrete adapters:

#### 🌐 HTTP (`infrastructure/http/`)
- `ApiService` - Centralizes headers, retry-after-refresh, error mapping, logging, and optional caching

#### 💾 Cache (`infrastructure/cache/`)
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

#### 💿 Storage (`infrastructure/storage/`)
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

**⚠️ Deprecation Note:** `MemoryService` is deprecated. Use `AppStorageService` for all storage needs.

### 📥 File Downloads

`ApiService.downloadFile()` reuses `GetConnect.get` with `ResponseType.bytes` for uniform behavior:
- ✅ Includes auth headers
- ✅ Retry-after-refresh on 401
- ✅ Honors timeout and logging
- ✅ Optional progress callback (reports completion)
- ✅ Writes bytes to disk

**Note:** For streaming progress or proxy/certificate customization, implement a specialized downloader.

---

## ❓ FAQ

### ❓ Why Actions instead of putting UX in the ViewModel?

**Short answer:** To centralize UX plumbing and keep controllers focused on logic.

**Long answer:** Traditional MVVM often results in ViewModels that manage both business logic AND UX concerns (loading flags, error messages, navigation). This violates Single Responsibility Principle. By extracting UX concerns into Actions:
- ViewModels stay pure business logic
- All user interactions get consistent error handling and feedback
- Testing becomes easier (no need to mock loaders or verify toast calls)
- You can swap out UX strategy (e.g., from overlay to inline loaders) in one place

### 🔄 Can I swap GetX for another state management solution later?

**Yes** — most pieces are framework-agnostic; you'll just need to replace DI/observable wrappers.

**What's coupled to GetX:**
- `GetxController` base class in ViewModels → Replace with your state solution (Bloc, Riverpod, etc.)
- `Get.find()` dependency injection → Replace with Provider, get_it, etc.
- `.obs` and `Obx()` reactivity → Replace with your reactive primitives
- `Get.to()` navigation → Use Navigator or your preferred router

**What's NOT coupled to GetX:**
- Models (pure Dart classes)
- Services (extend GetConnect, but can be rewritten to use Dio/http)
- Actions pattern (just needs BuildContext and error handling)
- ApiResponse pattern (pure state container)

**Migration effort:** Moderate. Budget 2-4 hours for a small app, 1-2 days for large apps.

### 📊 Where do I add analytics/crash reporting?

**Hook into `ActionPresenter` and `ApiService` interceptors:**

**For Analytics (user actions):**
Override `ActionPresenter.actionHandler()`:
```dart
class MyActionPresenter extends ActionPresenter {
  @override
  Future actionHandler(BuildContext context, Future Function() action) async {
    final stopwatch = Stopwatch()..start();
    try {
      await super.actionHandler(context, action);
      analytics.logEvent('action_success', {'duration': stopwatch.elapsedMilliseconds});
    } catch (e) {
      analytics.logEvent('action_error', {'error': e.toString()});
      rethrow;
    }
  }
}
```

**For Crash Reporting (API errors):**
`ActionPresenter` already reports to Sentry in the `reportError()` method. To customize:
```dart
@override
void reportError(Object error, StackTrace stackTrace) {
  Sentry.captureException(error, stackTrace: stackTrace);
  FirebaseCrashlytics.instance.recordError(error, stackTrace);
}
```

**For API Logging:**
`ApiService` already logs all requests. To add telemetry:
```dart
class MyApiService extends ApiService {
  @override
  Future<Response<T>> get<T>(String url, ...) async {
    analytics.logEvent('api_request', {'endpoint': url, 'method': 'GET'});
    return super.get(url, ...);
  }
}
```

### 🧪 How do I test Actions and ViewModels?

**ViewModels are easy** - they're pure logic:
```dart
test('fetchPosts emits loading then success', () async {
  final service = MockPostService();
  final viewModel = PostViewModel(service);

  when(service.fetchPosts()).thenAnswer((_) async => [PostModel(id: 1)]);

  viewModel.onInit();

  expect(viewModel.posts.isLoading, true);
  await Future.delayed(Duration.zero); // Wait for async
  expect(viewModel.posts.isSuccess, true);
  expect(viewModel.posts.data?.length, 1);
});
```

**Actions require context** - use widget tests:
```dart
testWidgets('signIn shows loader and navigates on success', (tester) async {
  final viewModel = MockAuthViewModel();
  Get.put(viewModel);

  await tester.pumpWidget(MaterialApp(home: LoginPage()));
  await tester.tap(find.text('Sign In'));
  await tester.pump();

  expect(find.byType(LoaderOverlay), findsOneWidget);
  verify(viewModel.signIn()).called(1);
});
```

### 🔐 How does token refresh work?

**Automatic and transparent:**

1. `ApiService` detects `401 Unauthorized` response
2. Calls `ApiService.refreshSession()` (base class implementation) with refresh token
3. Saves new access token to `AppStorageService`
4. Retries original request with new token (one time only)
5. If refresh fails, throws `AuthException` → user logged out

**Key Points:**
- Token refresh is handled automatically by `ApiService` base class
- `AuthService` does not override this method
- All HTTP requests benefit from automatic token refresh on 401
- Tokens are stored in `AppStorageService` (secure storage for tokens, GetStorage for preferences)

**No token refresh endpoint?**
Override `ApiService._retryAfterRefresh()` to return `false`.

### 💾 When should I use caching?

**Use caching for:**
- ✅ Reference data that changes infrequently (categories, settings, config)
- ✅ Large lists that are expensive to fetch (product catalogs)
- ✅ Offline-first features (reading cached data when offline)

**Don't use caching for:**
- ❌ Real-time data (live scores, stock prices, chat messages)
- ❌ User-specific data that changes often (cart, notifications)
- ❌ POST/PUT/DELETE requests (mutations shouldn't be cached)

**Default behavior:**
- GET requests are cached (6-hour TTL by default)
- All other methods bypass cache
- Cache can be disabled globally: `ApiService.configureCache(null)`

### 🌐 How do I add a new API endpoint?

**4 steps:**

**1️⃣ Add URL to config:**
```dart
// lib/src/config/api_config.dart
static const String usersUrl = '$baseUrl/users';
```

**2️⃣ Create Model:**
```dart
// lib/src/modules/users/data/models/user_model.dart
class UserModel {
  final int id;
  final String name;

  factory UserModel.fromJson(Map<String, dynamic> json) => ...
}
```

**3️⃣ Create Service:**
```dart
// lib/src/modules/users/data/services/user_service.dart
class UserService extends ApiService {
  Future<List<UserModel>> fetchUsers() async {
    final response = await get(APIConfiguration.usersUrl);
    return userModelFromJson(response.body);
  }
}
```

**4️⃣ Use in ViewModel:**
```dart
apiFetch(_userService.fetchUsers).listen((state) => _users.value = state);
```

### 📦 Can I use only specific modules?

**Yes!** Modules are designed to be independent.

**To use only Auth + Theme:**
1. Copy `lib/src/core/` (required for all modules)
2. Copy `lib/src/infrastructure/` (required for API/storage)
3. Copy `lib/src/config/` (API configuration)
4. Copy `lib/src/modules/auth/` and `lib/src/modules/theme/`
5. Remove unused bindings from `lib/src/utils/binding.dart`
6. Remove unused routes from `lib/src/utils/route_manager.dart`

**Dependency note:** Auth module requires `AppStorageService` from infrastructure.

### 🎯 What's the difference between actions/ and controllers/?

**Quick rule:** Actions = **WHAT** (user wants), Controllers = **HOW** (to do it)

**Actions (User Intent):**
- Triggered by user interactions (button press, form submit)
- Shows loaders, handles errors, shows feedback
- Calls ViewModel methods
- Lives in `actions/` folder
- Extends `ActionPresenter`

**Controllers (Business Logic):**
- Orchestrates services, manages state
- Contains business rules and validation
- Exposes reactive state to views
- Lives in `controllers/` folder
- Extends `GetxController`

**Example:**
```dart
// ACTION: User wants to sign in
AuthActions.signIn(context) {
  actionHandler(() async {
    await _viewModel.signIn(); // Calls controller
    showSuccessSnackBar('Welcome!');
  });
}

// CONTROLLER: How to sign in
AuthViewModel.signIn() async {
  final user = await _authService.signIn(email, password); // Calls service
  _user.value = user; // Updates state
}
```

### 🔌 How do I handle WebSocket/GraphQL?

**WebSocket:**
Create a `WebSocketService` in `infrastructure/`:
```dart
class WebSocketService {
  late IOWebSocketChannel _channel;

  Stream<dynamic> connect(String url) {
    _channel = IOWebSocketChannel.connect(url);
    return _channel.stream;
  }

  void send(dynamic message) => _channel.sink.add(message);
  void close() => _channel.sink.close();
}
```

Use in ViewModel:
```dart
class ChatViewModel extends GetxController {
  final _messages = <Message>[].obs;

  @override
  void onInit() {
    _webSocket.connect(chatUrl).listen((data) {
      _messages.add(Message.fromJson(data));
    });
  }
}
```

**GraphQL:**
Replace `ApiService` base class with GraphQL client (e.g., `graphql_flutter`):
```dart
class GraphQLService {
  final GraphQLClient client;

  Future<T> query<T>(String query, {Map<String, dynamic>? variables}) async {
    final result = await client.query(QueryOptions(
      document: gql(query),
      variables: variables ?? {},
    ));
    if (result.hasException) throw APIException(result.exception.toString());
    return result.data as T;
  }
}
```

Pattern stays the same: Service → ViewModel → View.

---

## 📚 Documentation

Comprehensive documentation is available in the `docs/` directory:

### 🏛️ Architecture
- **`docs/architecture/coding_guidelines.md`** - Naming conventions, MVVM pattern, documentation style, module structure
- **`docs/architecture/auth_module.md`** - Authentication flow, state machine, testing guide
- **`docs/architecture/connectivity_module.md`** - Connectivity states, reachability, configuration

### 📖 Examples
- **`docs/examples/api_pattern_example.md`** - Complete API integration guide with step-by-step implementation, architecture flow diagram, POST request examples, and migration guide

### 📝 Changelog
- **`CHANGELOG.md`** - Full log of changes, migrations, and deprecations

---

## ✅ Quick Start Checklist

Follow these steps to adapt the template for your project:

### 1️⃣ Configure API URLs
Edit `lib/src/config/api_config.dart`:
```dart
static const String _stagingUrl = 'https://your-staging-api.com';
static const String _productionUrl = 'https://your-production-api.com';

static const String signInUrl = '$baseUrl/api/auth/signin';
static const String signUpUrl = '$baseUrl/api/auth/signup';
// Add your custom endpoints here
```

### 2️⃣ Initialize Storage
In `lib/src/main.dart`, ensure storage is initialized:
```dart
await AppStorageService.instance.initialize();
```

### 3️⃣ Update User Model
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

### 4️⃣ Create Your First Module
Use the `posts/` module as a reference:

1. Copy the posts module structure
2. Rename files and classes
3. Update the model to match your API response
4. Update the service to call your endpoint
5. Add module to `lib/src/utils/binding.dart`

### 5️⃣ Customize UI
- Replace app name in `pubspec.yaml`
- Update Material 3 seed color in theme module
- Customize login/register pages
- Add your app logo and assets

### 6️⃣ Test
- Run tests: `flutter test`
- Check analyzer: `flutter analyze`
- Test on devices/emulators

---

## 🤝 Contributing

Contributions are welcome! Help make this template better for everyone.

### 📋 How to Contribute

1. **🐛 Report Issues**: Found a bug? [Open an issue](https://github.com/KalvadTech/getX-template/issues) with:
   - Clear description of the problem
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots if applicable

2. **💡 Suggest Features**: Have an idea? [Open a feature request](https://github.com/KalvadTech/getX-template/issues) explaining:
   - Use case and problem it solves
   - Proposed solution
   - Alternative approaches considered

3. **🔧 Submit Pull Requests**:
   - Fork the repository
   - Create a feature branch (`git checkout -b feature/amazing-feature`)
   - Follow coding guidelines (see `docs/architecture/coding_guidelines.md`)
   - Write tests for new functionality
   - Run `flutter analyze` and `flutter test` before committing
   - Commit with descriptive messages
   - Push to your fork and submit a PR

### 📏 PR Requirements

- ✅ Code follows existing style and conventions
- ✅ All tests pass (`flutter test`)
- ✅ No analyzer warnings (`flutter analyze`)
- ✅ New features include tests
- ✅ Documentation updated (README, docs/, DartDoc comments)
- ✅ Commit messages are descriptive

### 🎯 Areas We'd Love Help With

- 📝 More documentation and examples
- 🧪 Additional test coverage
- 🌐 More localization languages
- 🎨 UI/UX improvements
- 🐛 Bug fixes and performance improvements

### 📖 Coding Standards

Please read `docs/architecture/coding_guidelines.md` before contributing. Key points:
- Use MVVM + Actions architecture
- Follow naming conventions (plural folders, matching bindings)
- Write DartDoc comments for public APIs
- Keep actions/, controllers/, services/ separate
- Use `ApiResponse<T>` for async state

---

## 👤 Author & Acknowledgments

### 👨‍💻 Author

**Mohamed Elamin (FIFTY)**
- GitHub: [@mohamed50](https://github.com/mohamed50)
- Organization: [Kalvad Technologies](https://www.kalvad.com/) | [@KalvadTech](https://github.com/KalvadTech)
- Email: mohamed@kalvad.com

### 🙏 Acknowledgments

This template stands on the shoulders of giants:

- **[GetX](https://pub.dev/packages/get)** by Jonny Borges - Reactive state management and DI
- **[Mason CLI](https://github.com/felangel/mason)** by Felix Angelov - Code generation tool

### 💖 Support

If this template helped you, consider:
- ⭐ Starring the repository
- 🐛 Reporting issues
- 🔧 Contributing improvements
- 📢 Sharing with others

---

## 📄 License

MIT License

Copyright (c) 2024 Kalvad Technologies

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

## 🔗 Resources

### 🎯 GetX Resources
- [GetX Documentation](https://pub.dev/packages/get)
- [GetX GitHub Repository](https://github.com/jonataslaw/getx)
- [State Management Guide](https://github.com/jonataslaw/getx#state-management)
- [Dependency Injection Guide](https://github.com/jonataslaw/getx#dependency-management)

### 🛠️ Tools
- [Mason CLI](https://github.com/felangel/mason) - Code generation
- [Flutter DevTools](https://flutter.dev/docs/development/tools/devtools/overview) - Debugging and profiling
- [Very Good CLI](https://pub.dev/packages/very_good_cli) - Flutter project generation

---

**⭐ Star this repo if you found it helpful!**

**🐛 [Report Issues](https://github.com/KalvadTech/getX-template/issues) | 💡 [Request Features](https://github.com/KalvadTech/getX-template/issues) | 🤝 [Contribute](https://github.com/KalvadTech/getX-template/pulls)**
