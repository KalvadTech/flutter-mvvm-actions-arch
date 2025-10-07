# 📏 Coding, Documentation, and Naming Guidelines

Comprehensive guidelines for naming, structure, documentation, and architecture in this Flutter template using **MVVM + Actions Layer (GetX-based)** architecture.

---

## 📑 Table of Contents

- [💭 Philosophy & Principles](#-philosophy--principles)
- [🎯 Quick Reference Card](#-quick-reference-card)
- [🏗️ Architecture Overview](#️-architecture-overview)
- [📁 File & Folder Structure](#-file--folder-structure)
- [🔤 Naming Conventions](#-naming-conventions)
- [📝 Documentation Style (DartDoc)](#-documentation-style-dartdoc)
- [📄 README Writing Guidelines](#-readme-writing-guidelines)
- [🔌 API Integration Pattern](#-api-integration-pattern)
- [💾 Storage Guidelines](#-storage-guidelines)
- [🌐 Services & Networking](#-services--networking)
- [📦 Caching Guidelines](#-caching-guidelines)
- [📡 Connectivity Module Guidelines](#-connectivity-module-guidelines)
- [🎨 Theming](#-theming)
- [🧪 Testing & Safety](#-testing--safety)
- [🔧 Git & PR Hygiene](#-git--pr-hygiene)

---

## 💭 Philosophy & Principles

### Why MVVM + Actions Layer?

Traditional MVVM often mixes UX concerns (loading overlays, error toasts, navigation) with business logic in ViewModels. By introducing an **Actions layer**, we achieve:

- **🧼 Clean Separation**: Views (UI), Actions (UX), ViewModels (Logic), Services (Data)
- **🎯 Centralized UX**: All loaders, errors, and feedback in one place
- **🔁 Consistency**: Every user action follows the same pattern
- **🧪 Testability**: Each layer tested in isolation
- **📖 Readability**: Code clearly expresses "what" vs "how"

### Core Principles

1. **Separation of Concerns**
   - Views: UI rendering only
   - Actions: UX concerns (loaders, errors, toasts)
   - ViewModels: Business logic and state
   - Services: Data access (HTTP, storage)

2. **Reactive State**
   - Views observe ViewModels via GetX reactivity
   - No manual state updates or `setState`

3. **Dependency Injection**
   - Services injected into ViewModels
   - ViewModels accessed in Views via GetX, Obx, GetView

4. **Type Safety**
   - Use `ApiResponse<T>` for async operations
   - Typed exceptions (`AuthException`, `APIException`)

5. **Single Responsibility**
   - Each class does one thing well
   - No business logic in Views
   - No UI logic in ViewModels
   - No orchestration in Services

---

## 🎯 Quick Reference Card

Visual summary of architectural boundaries:

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

## 🏗️ Architecture Overview

### Architectural Pattern

This template uses **MVVM (Model-View-ViewModel)** augmented with an **Actions layer** for user intent handling. While inspired by clean architecture concepts, it is adapted to GetX conventions and pragmatic Flutter development.

**Key Characteristics:**
- GetX for dependency injection, routing, and reactive state management
- No domain layer or repository pattern (services handle data directly)
- Actions layer wraps user intents with UX concerns (loaders, error handling)
- ViewModels expose reactive state; Views observe and render

### Architectural Layers

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

#### 1️⃣ View (Presentation Layer)

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

#### 2️⃣ Actions (User Intent Handler)

- Singleton classes extending `ActionPresenter` base class
- Wraps ViewModel method calls with:
  - Global loader overlay (via `loader_overlay` package)
  - Unified error handling and user feedback (snackbars/toasts)
  - Exception reporting to Sentry
- Provides navigation helpers
- **Purpose:** Separate UX concerns from business logic

**Example:**
```dart
class AuthActions extends ActionPresenter {
  Future signIn(BuildContext context) async {
    actionHandler(context, () async {
      await _authViewModel.signIn();
      showSuccessSnackBar('Sign In', 'Done Successfully');
    });
  }
}
```

**Key Points:**
- `ActionPresenter` is a base utility class, not an architectural layer by itself
- Actions classes are feature-scoped singletons accessed via `.instance`
- Always pass `BuildContext` to show/hide overlays safely

**Naming:** `<Feature>Actions`

#### 3️⃣ ViewModel (Business Logic Layer)

- GetX Controllers (`GetxController`)
- Orchestrates business logic and data fetching via Services
- Exposes **reactive state** using GetX observables (`Rx<T>`, `.obs`)
- Wraps data in `ApiResponse<T>` for lifecycle states (idle/loading/success/error)
- **Does NOT** handle UI concerns (no loaders, no snackbars, no navigation)

**Example:**
```dart
class PostViewModel extends GetxController {
  final PostService _postService;
  final Rx<ApiResponse<List<PostModel>>> _posts = ApiResponse.idle().obs;

  ApiResponse<List<PostModel>> get posts => _posts.value;

  void _fetchPosts() {
    apiFetch(_postService.fetchPosts).listen((value) => _posts.value = value);
  }
}
```

**Key Points:**
- Initialize via GetX Bindings (not service locators inside widgets)
- Use `apiFetch` helper to manage loading/success/error lifecycle
- ViewModels are stateful and lifecycle-aware (via `onInit`, `onClose`)

**Naming:** `<Feature>ViewModel`

#### 4️⃣ Service (Data Layer)

- Classes extending `ApiService` (which extends GetConnect)
- Handle HTTP calls, token refresh, error mapping, and caching
- May also handle local storage (via `AppStorageService`)
- Return domain models (not raw JSON)
- **Does NOT** contain business logic (that's ViewModel's job)

**Example:**
```dart
class AuthService extends ApiService {
  Future<UserModel> signIn(String username, String password) async {
    final response = await post(
      APIConfiguration.signInUrl,
      {'username': username, 'password': password}
    );
    if (response.isOk) return UserModel.fromJson(response.body);
    throw APIException(response.statusText);
  }
}
```

**Key Points:**
- `ApiService` provides automatic auth header injection, retry on 401, and redacted logging
- Services are registered in Bindings and injected into ViewModels
- **Service naming convention**: Use `*Service` suffix (e.g., `AuthService`, `PostService`) instead of `*Repository`/`*RepositoryImpl`

**Naming:** `<Feature>Service`

#### 5️⃣ Model (Domain Objects)

- Plain Dart classes representing domain entities
- Typically have `fromJson`/`toJson` methods for serialization
- Immutable when possible (all fields `final`)
- No business logic (pure data containers)

**Example:**
```dart
class PostModel {
  final int id;
  final String title;

  PostModel({required this.id, required this.title});

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id: json['id'],
    title: json['title'],
  );

  Map<String, dynamic> toJson() => {"id": id, "title": title};
}
```

**Naming:** `<Feature>Model`

### Data Flow

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

### Dependency Injection (GetX Bindings)

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

### State Management Helpers

#### ApiResponse<T>
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

#### apiFetch<T>
Stream-based helper for managing request lifecycle:
```dart
apiFetch(() => service.loadUser()).listen((state) => _user.value = state);
```

#### ApiHandler<T>
Widget that renders loading/success/error/empty states:
```dart
ApiHandler<List<PostModel>>(
  response: controller.posts,
  tryAgain: controller.refreshData,
  isEmpty: (items) => items.isEmpty,
  successBuilder: (items) => PostsGridView(posts: items),
)
```

### Comparison with Other Patterns

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

## 📁 File & Folder Structure

### Module Structure

- Core primitives under `lib/src/core/` and app configuration under `lib/src/config/`
- Features under `lib/src/modules/<feature>/` following MVVM + Actions layer structure:
  - `actions/` - User intent handlers extending ActionPresenter (optional, only if needed)
  - `controllers/` - ViewModels (GetX Controllers) - **Use `controllers/` directory, NOT `viewmodels/`**
  - `data/models/` - Domain objects (plain Dart classes) - **MUST be plural `models/`**
  - `data/services/` - Data access layer (HTTP, storage)
  - `views/` - UI widgets
  - `views/widgets/` - Feature-specific reusable widgets
  - `<feature>_bindings.dart` - GetX dependency injection (at module root)
  - `<feature>.dart` - Barrel export file (at module root)

### Module Naming Conventions

- **Module folder names:** Use plural when representing collections (e.g., `posts/`, `connections/`, NOT `post/`, `connection/`)
- **Bindings file:** Must match module name exactly (e.g., `posts_bindings.dart` for `posts/` module)
- **Bindings class:** Must match module name exactly (e.g., `PostsBindings` for `posts/` module)
- **Model folder:** Always use plural `models/` (e.g., `data/models/`, NOT `data/model/`)
- **Controllers folder:** Always use `controllers/` (GetX convention, NOT `viewmodels/`)

**Example Structure:**
```
lib/src/modules/posts/
├── actions/                       # Optional
│   └── post_actions.dart
├── controllers/
│   └── post_view_model.dart       # ViewModel files use *_view_model.dart
├── data/
│   ├── models/                    # Plural: models/
│   │   └── post_model.dart
│   └── services/
│       └── post_service.dart
├── views/
│   ├── posts_page.dart
│   └── widgets/
│       └── post_list_tile.dart
├── posts_bindings.dart            # Matches module name
└── posts.dart                     # Barrel export
```

### Infrastructure

- Caching abstractions live under `lib/src/infrastructure/cache/`:
  - `cache_store.dart`, `cache_key_strategy.dart`, `cache_policy.dart`, `cache_manager.dart`
  - Defaults: `default_cache_key_strategy.dart`, `simple_ttl_cache_policy.dart` (`SimpleTimeToLiveCachePolicy`)
  - Implementation: `get_storage_cache_store.dart` (`GetStorageCacheStorage`)
- HTTP-calling services should extend `ApiService` and live under each feature's `data/services/`
- `ApiService` itself lives under `lib/src/infrastructure/http/`

### Complete Folder Structure

```
lib/src/
├── app.dart                      # 🎯 Main app widget
├── main.dart                     # 🚀 Entry point
├── config/
│   ├── api_config.dart          # 🌐 API endpoints
│   └── keys.dart                # 🔑 Translation keys
├── core/
│   ├── errors/                  # ❌ Exception classes
│   └── presentation/            # 🎨 ApiResponse, ActionPresenter
├── infrastructure/
│   ├── http/                    # 🌐 ApiService
│   ├── cache/                   # 💾 Caching system
│   └── storage/                 # 💿 AppStorageService
├── presentation/
│   ├── actions/                 # 🎛️ ActionPresenter base
│   ├── screens/                 # 📱 Shared screens
│   └── widgets/                 # 🧱 Reusable widgets
├── utils/
│   ├── binding.dart             # 💉 Global DI
│   ├── route_manager.dart       # 🧭 Navigation
│   └── color_manager.dart       # 🎨 Colors
└── modules/
    ├── auth/                    # 🔐 Authentication
    ├── connections/             # 📡 Connectivity
    ├── locale/                  # 🌍 Localization
    ├── theme/                   # 🎨 Theme switching
    ├── posts/                   # 📝 API example
    └── menu/                    # 🍔 Navigation menu
```

---

## 🔤 Naming Conventions

### General Rules

- **Use clear, specific names** - Avoid unnecessary abbreviations
  - ✅ Good: `AuthenticationService`, `RefreshSession`, `AccessToken`, `CacheExpirationDuration`
  - ❌ Avoid: `AuthSvc`, `refreshSess`, `accTok`, `cacheExpDur`
- **Allowed well‑established initialisms**: `API`, `HTTP`, `URL`, `ID`, `JWT`, `TTL`
- **Do not use single‑letter names** except for trivial loops

### Dart Casing

- **Classes, enums, typedefs**: PascalCase (e.g., `AuthService`, `ApiService`)
- **Methods, variables, parameters**: lowerCamelCase (e.g., `refreshSession`, `accessToken`)
- **Constants**: lowerCamelCase with `const` (avoid ALL_CAPS unless interop)
- **Private members**: prefix with `_`
- **File and folder names**: snake_case (e.g., `auth_service.dart`, `cache_policy.dart`)

### Widget Naming

- Widget names end with `Widget` only if they are generic wrappers
- Prefer descriptive names (e.g., `CustomTimeAgoText`)

### Class Naming by Type

| Type | Pattern | Example |
|------|---------|---------|
| **ViewModel** | `<Feature>ViewModel` | `PostViewModel`, `AuthViewModel` |
| **Service** | `<Feature>Service` | `PostService`, `AuthService` |
| **Model** | `<Feature>Model` | `PostModel`, `UserModel` |
| **Actions** | `<Feature>Actions` | `AuthActions`, `PostActions` |
| **Bindings** | `<Feature>Bindings` | `PostsBindings`, `AuthBindings` |
| **Page** | `<Feature>Page` | `PostsPage`, `LoginPage` |
| **Widget** | Descriptive name | `PostListTile`, `ConnectionOverlay` |

### File Naming by Type

| Type | Pattern | Example |
|------|---------|---------|
| **ViewModel** | `<feature>_view_model.dart` | `post_view_model.dart` |
| **Service** | `<feature>_service.dart` | `post_service.dart` |
| **Model** | `<feature>_model.dart` | `post_model.dart` |
| **Actions** | `<feature>_actions.dart` | `auth_actions.dart` |
| **Bindings** | `<feature>_bindings.dart` | `posts_bindings.dart` |
| **Page** | `<feature>_page.dart` | `posts_page.dart` |

---

## 📝 Documentation Style (DartDoc)

**Language:** English only
**Tone:** Precise, engineering-grade
**Format:** Triple-slash `///` DartDoc for all public classes, constructors, methods, and important fields

### Golden Rules

1. Start each docblock with a bold title line, then a one-sentence summary
2. Prefer structured sections with bold headers in this order when applicable:
   - **Why**, **Key Features**, **Parameters**, **Returns**, **Side Effects**, **Errors**, **Usage**, **Notes**
3. End major docblocks with a divider line on its own line:
   ```
   // ────────────────────────────────────────────────
   ```
4. Keep paragraphs concise; use bullet lists for multiple points
5. Provide minimal, runnable code samples in fenced Dart blocks

### Class/Service Doc Template

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

### Method/Function Doc Template

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

> **Note:** Omit sections that do not apply, but keep the order when present.

### Properties, Getters, Setters

Document non-trivial fields and computed getters:
```dart
/// **currentUser**
///
/// Cached, authoritative user model after a successful sign-in.
/// Null until authentication completes.
final UserModel? currentUser;
```

### Constructors

If logic exists (validation or dependency injection), document parameters and purpose:
```dart
/// **PostViewModel**
///
/// Injects services and primes reactive state.
///
/// **Parameters**
/// - `PostService postService`: Service for fetching posts
///
// ────────────────────────────────────────────────
PostViewModel(this._postService);
```

### Async, Streams, and Concurrency

Always call out lifecycle and threading:
```dart
/// **startListening**
///
/// Subscribes to the post stream and updates local cache.
///
/// **Side Effects**
/// - Opens a stream subscription; remember to call [dispose].
///
/// **Errors**
/// - Propagates network errors thrown by `posts.watch()`.
///
// ────────────────────────────────────────────────
```

### MVVM & GetX Documentation Notes

- **ViewModels**: document what state they own and who updates it
- **Bindings**: list registrations under **Side Effects**
- **Navigation**: mention route pushes under **Side Effects** (e.g., "Navigates to `[RouteManager.verifyRoute]`")

### Translation Keys

Use top-level constants with dot-separated paths for translation keys:
```dart
/// Translation Keys (top-level)
const String tkHomeMenuTitle = 'pages.home.menu.title';
const String tkHomeMenuDesc  = 'pages.home.menu.description';
const String tkLoginBtn = 'buttons.login';
```

Group keys by domain for better organization:
- `auth.inputs.*` - Authentication input fields
- `validations.*` - Validation messages
- `errors.*` - Error messages
- `pages.*` - Page titles and descriptions
- `buttons.*` - Button labels

### Error Handling and Results

- When using `Either`/`Result` types, state success and failure shapes under **Returns**
- If throwing, list exact error types and conditions under **Errors**

### File-Level Header (Optional)

At the top of important files, add a brief module banner:
```dart
// ==========================================================
// Module: Posts
// Purpose: Demonstrate complete API integration pattern
// Depends: ApiService, ApiHandler, ApiResponse
// Notes  : Uses JSONPlaceholder API for examples
// ==========================================================
```

### TODO / FIXME / DEPRECATED Conventions

- `// TODO(username): <actionable task>`
- `// FIXME(username): <known bug>`
- `@deprecated` in DartDoc with a short migration note

### Formatting and Line Length

- Keep lines around 100–110 characters max
- Wrap bullets and sections cleanly; no trailing whitespace
- Always place the divider line on its own line

### Commit Messages and Documentation

- If a change modifies behavior, update docblocks in the same commit
- Use prefixes like: `docs(vm):`, `docs(svc):`, `docs(api):`

---

## 📄 README Writing Guidelines

### Philosophy

READMEs are the first impression of your project. They should be:
- **🎯 User-focused**: Answer "What is this?" and "How do I use it?" immediately
- **🗺️ Well-organized**: Clear hierarchy with table of contents
- **👁️ Visual**: Use emojis and icons for visual landmarks
- **📚 Comprehensive**: Cover installation, usage, examples, and troubleshooting
- **🔗 Navigable**: Anchor links for easy jumping between sections

### README Structure Template

```markdown
# 🚀 Project Name

Brief one-sentence description of what this project does.

**✨ Key Features:**
- 🏗️ Feature 1
- 🔄 Feature 2
- 🌐 Feature 3

---

## 📑 Table of Contents

- [💭 Philosophy](#-philosophy)
- [📏 Conventions & Guidelines](#-conventions--guidelines)
- [🚀 Quick Start](#-quick-start)
- [🏗️ Architecture](#️-architecture)
- [📁 Structure](#-structure)
- [🧩 Features](#-features)
- [❓ FAQ](#-faq)
- [📚 Documentation](#-documentation)
- [🤝 Contributing](#-contributing)
- [👤 Author](#-author)
- [📄 License](#-license)

---

## 💭 Philosophy

Explain the "why" behind your project's design decisions.

**Why This Approach?**
- Reason 1
- Reason 2
- Reason 3

---

## 📏 Conventions & Guidelines

Quick visual reference card:
- **🧼 Layer 1**: Responsibility
- **🎛️ Layer 2**: Responsibility
- **🧠 Layer 3**: Responsibility

**Golden Rule**: [Insert decision-making heuristic]

---

## 🚀 Quick Start

### Installation

#### 🎯 Option 1: Recommended Method
```sh
command here
```

#### 📋 Option 2: Alternative Method
```sh
alternative command
```

### ▶️ Run

```sh
run command
```

---

## 🏗️ Architecture

Brief explanation with ASCII diagram:

```
User Interaction
    ↓
🧼 Layer 1
    ↓
🎛️ Layer 2
    ↓
🧠 Layer 3
```

---

## 📁 Structure

```
project/
├── 📁 folder1/
│   ├── file1.dart
│   └── file2.dart
├── 📁 folder2/
└── main.dart
```

---

## 🧩 Features

### 🔐 Feature 1

Description of feature 1.

**Key Points:**
- Point 1
- Point 2

**Usage:**
```dart
example code
```

### 📡 Feature 2

Description of feature 2.

---

## ❓ FAQ

### ❓ Question 1?

**Short answer:** Brief one-liner

**Long answer:** Detailed explanation with examples if needed.

### 🔄 Question 2?

Answer here.

---

## 📚 Documentation

- **`docs/file1.md`** - Description
- **`docs/file2.md`** - Description

---

## 🤝 Contributing

Contributions welcome!

### 📋 How to Contribute
1. Fork the repo
2. Create feature branch
3. Follow coding guidelines
4. Submit PR

---

## 👤 Author

**Your Name**
- GitHub: [@username](https://github.com/username)
- Email: email@example.com

---

## 📄 License

MIT License

Copyright (c) 2024 Your Name

[Full license text]
```

### README Best Practices

#### 1️⃣ Use Emojis Consistently

**Section Headers:**
- 💭 Philosophy/Why
- 🎯 Quick Reference
- 🚀 Getting Started/Installation
- 🏗️ Architecture
- 📁 Structure/Organization
- 🔤 Naming
- 📝 Documentation
- 🔌 Integration/Patterns
- 🧩 Features/Modules
- ⚙️ Configuration
- ❓ FAQ
- 📚 Documentation Links
- ✅ Checklist
- 🧪 Testing
- 🤝 Contributing
- 👤 Author
- 📄 License
- 🔗 Resources

**Feature Icons:**
- 🔐 Authentication/Security
- 📡 Connectivity/Network
- 🌍 Localization/i18n
- 🎨 Theming/UI
- 💾 Caching
- 📦 State Management
- 🔄 Reactive/Updates

#### 2️⃣ Table of Contents

**Always include a TOC for docs > 100 lines:**
```markdown
## 📑 Table of Contents

- [Section 1](#section-1)
- [Section 2](#section-2)

Use kebab-case for anchors, lowercase with hyphens.
```

#### 3️⃣ Code Examples

**Good code examples:**
- ✅ Minimal and focused
- ✅ Runnable (no placeholders)
- ✅ Well-commented
- ✅ Show common use cases

**Example:**
````markdown
```dart
// ✅ Good: Complete, runnable example
class PostService extends ApiService {
  Future<List<PostModel>> fetchPosts() async {
    final response = await get(APIConfiguration.postsUrl);
    return postModelFromJson(response.body);
  }
}
```

```dart
// ❌ Bad: Incomplete with placeholders
class MyService extends ApiService {
  Future<List<Model>> fetchData() async {
    // ... implementation here
  }
}
```
````

#### 4️⃣ Visual Hierarchy

Use formatting for emphasis:
- **Bold** for important terms
- `Code` for technical terms, file names, class names
- > Blockquotes for notes/warnings
- Tables for comparisons
- Lists for steps/features

#### 5️⃣ Links and References

**Internal links:**
```markdown
See [Architecture](#architecture) for details.
```

**External links:**
```markdown
- [GetX Documentation](https://pub.dev/packages/get)
- [Flutter Docs](https://flutter.dev/docs)
```

**File references:**
```markdown
See `lib/src/modules/auth/auth_service.dart` for implementation.
```

#### 6️⃣ FAQ Section

**Structure:**
```markdown
### ❓ Question in user's words?

**Short answer:** One-liner for skimmers

**Long answer:** Detailed explanation with:
- Bullet points
- Code examples
- Links to relevant docs
```

#### 7️⃣ Installation Instructions

**Be specific:**
- ✅ Include exact commands
- ✅ Specify versions if important
- ✅ Provide multiple options (manual, CLI, etc.)
- ✅ List prerequisites

**Example:**
```markdown
### 1️⃣ Install Mason CLI

```sh
dart pub global activate mason_cli
```

Verify installation:
```sh
mason --version
```

### 2️⃣ Add Template

```sh
mason add -g template_name --git-url https://...
```
```

#### 8️⃣ Troubleshooting Section

Include common issues with solutions:
```markdown
### Import Errors

**Problem:** Red underlines on imports
**Solution:**
1. Run `flutter pub get`
2. Restart your IDE
3. Run `flutter clean && flutter pub get`
```

#### 9️⃣ Keep it Updated

- Update README when features change
- Add new FAQ items based on user questions
- Keep examples in sync with actual code
- Update version numbers and dependencies

#### 🔟 Length Guidelines

- **Project README**: 500-1500 lines (comprehensive)
- **Module README**: 200-500 lines (focused)
- **Quick Start Guide**: 50-150 lines (minimal)

### README Anti-Patterns

❌ **Avoid:**
- Walls of text without structure
- Missing table of contents
- Outdated examples
- No code examples
- Technical jargon without explanation
- Missing installation instructions
- No visual hierarchy
- Dead links
- Incomplete code snippets
- Missing context/prerequisites

---

## 🔌 API Integration Pattern

This template provides a type-safe, reactive pattern for API integration with automatic state management.

### Pattern Overview

```
Service (HTTP) → apiFetch() → ApiResponse<T> → ApiHandler<T> → UI
```

**Benefits:**
- ✅ Automatic loading/success/error state management
- ✅ Type-safe data flow
- ✅ Reusable error handling
- ✅ Empty state detection
- ✅ Reactive UI updates via GetX

### Step-by-Step Implementation

#### 1️⃣ Define Model with JSON Serialization

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

#### 2️⃣ Create Service Extending ApiService

```dart
class PostService extends ApiService {
  Future<List<PostModel>> fetchPosts() async {
    final response = await get(APIConfiguration.postsUrl);
    return postModelFromJson(response.body);
  }
}
```

**Important:** All API URLs must be defined in `APIConfiguration` (see [Services & Networking](#-services--networking))

#### 3️⃣ Create ViewModel with apiFetch Pattern

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

#### 4️⃣ Create View with ApiHandler

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

#### 5️⃣ Register in Bindings

```dart
class PostsBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostService>(() => PostService(), fenix: true);
    Get.put<PostViewModel>(PostViewModel(Get.find()), permanent: true);
  }
}
```

### ApiResponse States

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

### Complete Example

See the **Posts module** for a working implementation:
- Model: `lib/src/modules/posts/data/models/post_model.dart`
- Service: `lib/src/modules/posts/data/services/post_service.dart`
- ViewModel: `lib/src/modules/posts/controllers/post_view_model.dart`
- View: `lib/src/modules/posts/views/posts_page.dart`
- Documentation: `docs/examples/api_pattern_example.md`

### Advanced: POST Requests

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

---

## 💾 Storage Guidelines

### AppStorageService Facade

Use `AppStorageService` as the unified facade for device-local storage:
- Exposes `PreferencesStorage` (GetStorage) for preferences
- Exposes `SecureTokenStorage` (Keychain/Keystore) for sensitive tokens
- Provides convenience methods for common operations

### Initialization

Initialize storage once at app startup:
```dart
await AppStorageService.instance.initialize();
```

### Reading Tokens

Prefer synchronous getters for hot paths (e.g., HTTP headers):
```dart
final token = AppStorageService.instance.accessToken;
final refreshToken = AppStorageService.instance.refreshToken;
```

### Writing Tokens

```dart
await AppStorageService.instance.setAccessToken('token');
await AppStorageService.instance.setRefreshToken('refresh_token');
```

### Preferences

```dart
// Write
await AppStorageService.instance.preferences.write('key', 'value');

// Read
final value = AppStorageService.instance.preferences.read('key');

// Delete
await AppStorageService.instance.preferences.remove('key');
```

### Container Alignment

Align GetStorage container names across the app:
```dart
final container = AppStorageService.container; // Use this consistently
```

### Deprecation Note

**MemoryService is deprecated.** Do not use it in new code. Migrate existing references to:
- `AppStorageService` for preferences
- `SecureTokenStorage` for tokens
- Or use the facade's methods

---

## 🌐 Services & Networking

### ApiService Foundation

- Centralize HTTP behavior in `ApiService`; feature services extend it
- Authorization header: include `Authorization: Bearer <token>` only when a non‑empty token exists; no stray spaces
- Retry policy: on 401, attempt one token refresh; if successful, retry once
- Error handling: map to typed exceptions (`AuthException`, `APIException`) without secondary decode errors
- Logging: gate logs with `assert(() { ... return true; }())`; redact sensitive data (mask Authorization header)
- Timeouts: default HTTP timeout is 120 seconds (set in `onInit`)

### File Downloads

`ApiService.downloadFile` reuses `GetConnect.get` with `ResponseType.bytes` for uniform behavior and headers (including one-shot retry after refresh):
- ✅ Honors `httpClient.timeout` and logging
- ✅ Writes bytes to disk
- ✅ Optional progress callback reports completion
- ⚠️ For true streaming progress or proxy/certificate customization, implement a specialized downloader

### API URL Configuration

**All API URLs must be defined in `APIConfiguration`** class (`lib/src/config/api_config.dart`)

**Rules:**
- ✅ Never hardcode URLs in service classes
- ✅ Use environment-aware URLs with `isDevelopment` flag
- ✅ Group URLs by module with clear section dividers

**Example:**
```dart
// ✅ Good: URLs in APIConfiguration
class APIConfiguration {
  static const bool isDevelopment = true;

  static const String _stagingUrl = 'https://staging-api.example.com';
  static const String _productionUrl = 'https://api.example.com';

  static const String baseUrl = isDevelopment ? _stagingUrl : _productionUrl;

  // --- Auth Module URLs ---
  static const String signInUrl = '$baseUrl/signin';
  static const String signUpUrl = '$baseUrl/signup';

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
```

```dart
// ❌ Bad: Hardcoded URL in service
class PostService extends ApiService {
  static const String _baseUrl = 'https://api.example.com'; // Wrong!

  Future<List<PostModel>> fetchPosts() async {
    final response = await get('$_baseUrl/posts'); // Wrong!
    return postModelFromJson(response.body);
  }
}
```

---

## 📦 Caching Guidelines

### Caching Strategy

- Store and retrieve raw response text (`bodyString`)
- Rehydrate types at the call site using the provided decoder
- Cache only successful (2xx) responses
- Avoid caching error responses or sensitive endpoints (e.g., authentication)

### Default Policy

**Read from cache:**
- Only when explicitly requested (`useCache == true`)
- Not when forced to refresh

**Write to cache:**
- By default, cache `GET` requests
- Do not cache writes (`POST/PUT/DELETE`)

### Strategy-Based Design

Components:
- `CacheStore` - Storage interface
- `CacheKeyStrategy` - Key building
- `CachePolicy` - Read/write rules + TTL
- `CacheManager` - Orchestrator

**Global on/off switch:**
Compose `CacheManager` at startup; if `null`, caching is disabled.

**Enable caching:**
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

---

## 📡 Connectivity Module Guidelines

### Single Source of Truth

- Use `ConnectionViewModel` for network state across the app
- Do not create ad‑hoc listeners in widgets; observe the VM

### Binding/DI

- Register `ConnectionViewModel` early via `ConnectionBindings` before `runApp`
- Place `ConnectionOverlay` above `GetMaterialApp`
- This prevents null controller crashes at boot
- Avoid duplicate registrations by checking `Get.isRegistered`

### State Semantics

- `ConnectivityType.connecting` - Transitional state while probing (NOT considered connected)
- `ConnectivityType.noInternet` - Transport exists (Wi‑Fi/Cellular) but internet isn't reachable
- `ConnectivityType.wifi` and `ConnectivityType.mobileData` - Connected states

### Debounce and Lifecycle

- Debounce connectivity events to reduce flapping (default 250 ms)
- Duration configurable via VM constructor
- Always re‑check connectivity on app resume (via `WidgetsBindingObserver`)
- Do not duplicate this logic in views

### Reachability

- Use `ReachabilityService` for probing
- Default: DNS lookup to google.com with 3s timeout
- Can switch to HTTP health endpoint later
- On Web, DNS probing is skipped; prefer HTTP health for strict accuracy

### Timers and Telemetry

- Offline duration timer starts once when entering disconnected/noInternet
- Stops on reconnect; guarded against duplicates
- `dialogTimer` is `RxString`, consume via `Obx`
- Optional callbacks:
  - `onWentOffline`: `VoidCallback?`
  - `onBackOnline(offlineDuration)`: `void Function(Duration)?`

### UI Usage Patterns

**Global overlay:**
```dart
GlobalLoaderOverlay(
  child: ConnectionOverlay(
    child: GetMaterialApp(...),
  ),
)
```

**Section gating:**
```dart
ConnectionHandler(
  connectedWidget: MyContent(),
  onConnectingWidget: ConnectingIndicator(),
  onRetry: () => controller.checkConnection(),
)
```

### Theming

- Use Material 3 ColorScheme tokens:
  - `surfaceVariant` for connecting bar
  - `errorContainer`/`onErrorContainer` for offline card
- Wrap overlays in `SafeArea`
- Add `Semantics` labels

### Error Handling

- Do not throw from connectivity listeners or reachability checks
- Drive UX solely from state transitions in the VM
- Avoid navigation in the VM; keep it presentation‑agnostic
- Use actions layer for user prompts

### Testing

- Construct `ConnectionViewModel(autoInit: false)` to avoid platform calls
- Set `connectionType.value` directly to simulate states
- Set `dialogTimer.value` to assert timer rendering
- Widget tests: verify overlay surfaces and handler gating
- Ensure retry is user‑initiated

### Configurability

VM constructor parameters:
- `reachability`: `ReachabilityService` (strategy/host/timeout)
- `debounceDuration`: `Duration` (default 250 ms)
- `onWentOfflineCallback`: `VoidCallback?`
- `onBackOnlineCallback`: `void Function(Duration)?`
- `autoInit`: `bool` (default true)

---

## 🎨 Theming

### Material 3

Use Material 3 with rosy‑red seed color:
```dart
ColorScheme.fromSeed(
  seedColor: const Color(0xFFE91E63),
  brightness: Brightness.light
)
```

### Color Usage

Prefer `Theme.of(context).colorScheme.*` over deprecated fields:
- ✅ Use for: SnackBars, FABs, Dialogs, Chips
- ❌ Avoid: Direct color values, deprecated theme properties

**Example:**
```dart
// ✅ Good
Container(
  color: Theme.of(context).colorScheme.primaryContainer,
  child: Text(
    'Hello',
    style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
  ),
)

// ❌ Bad
Container(
  color: Colors.blue, // Doesn't respect theme
  child: Text('Hello'),
)
```

---

## 🧪 Testing & Safety

### Unit Testing

**Test networking edge cases:**
- 401 refresh retry
- No cache on error
- Header formatting

**Test cache policies:**
- Deterministic inputs
- Key strategies

### Widget Testing

- Keep views pure
- Use fakes for presenters and view models
- Test connectivity overlay surfaces
- Verify handler gating
- Ensure user-initiated retry

### ActionPresenter Overlay Guard

When showing global loader overlay from presenters/actions, always guard calls:

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

**Key Points:**
- Use `context.mounted` checks before interacting with overlay
- Wrap show/hide in try/catch to tolerate missing overlay in tests
- Keep error handling centralized
- Avoid double-reporting the same error
- Prefer user-friendly messages for known failures
- Keep logs redacted; use assert-gated logging for sensitive data

---

## 🔧 Git & PR Hygiene

### Commit Messages

- Use imperative mood (e.g., "Add cache adapter strategy")
- Reference scope/files
- Keep commits focused and atomic

**Format:**
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation only
- `style` - Formatting, missing semicolons, etc.
- `refactor` - Code change that neither fixes a bug nor adds a feature
- `test` - Adding or updating tests
- `chore` - Changes to build process or auxiliary tools

**Example:**
```
feat(posts): add API integration pattern example

- Add PostModel with JSON serialization
- Add PostService extending ApiService
- Add PostViewModel with apiFetch pattern
- Add PostsPage with ApiHandler
- Add comprehensive documentation

Closes #123
```

### Pull Requests

**PR Description:**
- Small, focused PRs
- Describe intent, behavior change, and risk
- Include screenshots for UI changes
- Reference related issues

**Before Submitting:**
- ✅ Run `flutter analyze` (no warnings)
- ✅ Run `flutter test` (all tests pass)
- ✅ Update documentation if behavior changed
- ✅ Add tests for new functionality
- ✅ Follow coding guidelines

---

## 📚 Additional Resources

### Dart & Flutter Coding Style

- **Null safety**: prefer non‑nullable fields; use `?` only when truly optional
- **Constructors**: mark as `const` when possible; provide sensible defaults
- **Immutability**: prefer `final` for fields and local variables
- **Imports**: use absolute package imports from `/src/...`
- **Inline comments**: keep brief and intent-revealing
- **Formatting**: add trailing commas in widget trees
- **Widgets**: keep views pure; do not call repositories/services directly
- **Time and date**: encapsulate formatting in helpers or small widgets

### Exceptions and Initialisms

**Accept widespread, unambiguous initialisms:**
- `API`, `HTTP`, `URL`, `ID`, `JWT`, `TTL`

**When in doubt:**
- Prefer full word (e.g., `Identifier` over `Id`)
- Use complete term (e.g., `RefreshToken` over `Rt`)

---

## 🎓 Living Documentation

These guidelines are living documentation. Propose improvements via PRs and mirror changes into the mason brick equivalents to keep generated projects aligned.

**Feedback welcome:**
- 🐛 Report issues: [GitHub Issues](https://github.com/KalvadTech/flutter-mvvm-actions-arch/issues)
- 💡 Suggest improvements: [GitHub Discussions](https://github.com/KalvadTech/flutter-mvvm-actions-arch/discussions)
- 🔧 Contribute: [Contributing Guide](#-git--pr-hygiene)

---

**⭐ Follow these guidelines to maintain consistency and quality across the codebase!**
