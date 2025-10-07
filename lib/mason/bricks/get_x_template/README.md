# 🧱 getX_template Mason Brick

A Flutter application template Mason brick using **GetX** for state management with **MVVM + Actions Layer** architecture.

**✨ Key Features:**
- 🏗️ Clean MVVM architecture with Actions layer for UX concerns
- 🔄 Reactive state management with GetX
- 🌐 Complete API integration pattern with `apiFetch → ApiResponse → ApiHandler`
- 🔐 Authentication with token refresh and secure storage
- 📡 Connectivity monitoring with offline handling
- 🌍 Multi-language support with localization
- 🎨 Light/Dark theme switching
- 📦 Strategy-based HTTP response caching

---

## 📑 Table of Contents

- [💭 Philosophy](#-philosophy)
- [🚀 Installation](#-installation)
- [▶️ Usage](#️-usage)
- [📁 What Gets Generated](#-what-gets-generated)
- [✅ Post-Generation Steps](#-post-generation-steps)
- [🧩 Module Details](#-module-details)
- [🛠️ Customization](#️-customization)
- [❓ FAQ](#-faq)
- [📚 Documentation](#-documentation)
- [🐛 Troubleshooting](#-troubleshooting)
- [📄 License](#-license)

---

## 💭 Philosophy

**Why MVVM + Actions Layer?**

This template embraces **separation of concerns** at every level. Traditional MVVM often mixes UX concerns (loading overlays, error toasts, navigation) with business logic in ViewModels. By introducing an **Actions layer**, we achieve:

- **🧼 Clean Controllers**: ViewModels focus purely on business logic and state management
- **🎯 Centralized UX**: All loader overlays, error handling, and user feedback live in one place
- **🔁 Consistency**: Every user action follows the same pattern for error handling and feedback
- **🧪 Testability**: Each layer can be tested in isolation without mocking UI concerns

**📏 Quick Conventions:**
- **🧼 Views**: Pure widgets, zero business logic, delegate to Actions/ViewModels
- **🎛️ Actions**: UX concerns (loaders/toasts/errors), wrap ViewModel calls
- **🧠 Controllers**: Orchestrate services, expose reactive state, contain business logic
- **🌍 Services**: Data layer only (HTTP/storage), return domain models
- **📦 Models**: Immutable, JSON serialization only
- **⏲️ State**: Prefer `ApiResponse<T>` over scattered boolean flags

---

## 🚀 Installation

### 1️⃣ Install Mason CLI

```sh
dart pub global activate mason_cli
```

Verify installation:
```sh
mason --version
```

### 2️⃣ Add Brick from Git

**Global installation (recommended):**
```sh
mason add -g get_x_template --git-url https://github.com/KalvadTech/getX-template --git-path lib/mason/bricks/get_x_template
```

**Or add to your project's Mason file:**
```yaml
# mason.yaml
bricks:
  get_x_template:
    git:
      url: https://github.com/KalvadTech/getX-template
      path: lib/mason/bricks/get_x_template
```

Then run:
```sh
mason get
```

### 3️⃣ Verify Installation

```sh
mason list
# or
mason ls
```

You should see:
```
get_x_template - A Flutter application template using getX for state management...
```

---

## ▶️ Usage

### Quick Start

**1. Create a new Flutter project:**
```sh
flutter create my_awesome_app
cd my_awesome_app/lib
```

**2. Generate from template:**
```sh
mason make get_x_template
```

**3. Answer the prompts:**
```sh
? What is your project name? my_awesome_app
? What is your project description? My awesome Flutter app
? What is your organization name (e.g., com.example)? com.mycompany
```

**4. Follow post-generation steps** (see below)

### Example Session

```sh
$ cd my_flutter_project/lib
$ mason make get_x_template

✓ What is your project name? awesome_app
✓ What is your project description? My awesome Flutter app
✓ What is your organization name? com.mycompany

✓ Generated 106 file(s):
  ✓ src/app.dart
  ✓ src/main.dart
  ✓ src/config/api_config.dart
  ✓ src/modules/auth/controllers/auth_view_model.dart
  ... (102 more files)

✨ Done! Run 'flutter pub get' to install dependencies.
```

---

## 📁 What Gets Generated

The brick generates a complete `src/` directory structure with all modules:

```
lib/src/
├── app.dart                      # 🎯 Main app widget with GetMaterialApp
├── main.dart                     # 🚀 Entry point with initialization
├── config/
│   ├── api_config.dart          # 🌐 API endpoints configuration
│   └── keys.dart                # 🔑 Translation keys
├── core/
│   ├── errors/                  # ❌ Exception classes
│   └── presentation/            # 🎨 ApiResponse, ActionPresenter
├── infrastructure/
│   ├── http/                    # 🌐 ApiService (HTTP client)
│   ├── cache/                   # 💾 Response caching system
│   └── storage/                 # 💿 AppStorageService facade
├── presentation/
│   ├── actions/                 # 🎛️ ActionPresenter base class
│   ├── screens/                 # 📱 Shared screens (splash, onboarding)
│   └── widgets/                 # 🧱 Reusable widgets (ApiHandler)
├── utils/
│   ├── binding.dart             # 💉 Global DI setup
│   ├── route_manager.dart       # 🧭 Navigation routes
│   └── color_manager.dart       # 🎨 Color constants
└── modules/
    ├── auth/                    # 🔐 Authentication
    ├── connections/             # 📡 Connectivity monitoring
    ├── locale/                  # 🌍 Localization
    ├── theme/                   # 🎨 Theme switching
    ├── posts/                   # 📝 API pattern example
    └── menu/                    # 🍔 Navigation menu
```

**Total:** ~106 files including all modules, documentation, and examples.

---

## ✅ Post-Generation Steps

Follow these steps after generating the template:

### 1️⃣ Install Dependencies

Add required packages to your `pubspec.yaml`:

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

Then run:
```sh
flutter pub get
```

### 2️⃣ Configure API URLs

Edit `lib/src/config/api_config.dart`:

```dart
class APIConfiguration {
  static const String _stagingUrl = 'https://your-staging-api.com';
  static const String _productionUrl = 'https://your-production-api.com';

  static const String signInUrl = '$baseUrl/api/auth/signin';
  static const String signUpUrl = '$baseUrl/api/auth/signup';
  // Add your custom endpoints here
}
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

### 4️⃣ Update Main Entry Point (if needed)

Ensure `lib/main.dart` imports the generated app:

```dart
import 'src/main.dart' as src;

void main() {
  src.main();
}
```

### 5️⃣ Configure Assets (optional)

If using custom assets, update `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/
    - assets/icons/
```

### 6️⃣ Run the App

```sh
flutter run
```

---

## 🧩 Module Details

All modules are included by default. Here's what each module provides:

### 🔐 Authentication

Complete authentication flow with login/register pages, form validation, and token management.

**Architecture:**
- `AuthActions` → `AuthViewModel` → `AuthService` → `UserModel`

**Features:**
- ✅ Username/password authentication
- ✅ Token refresh on 401
- ✅ Secure token storage (Keychain/Keystore)
- ✅ Session checking on app start
- ✅ Form validation

**Key Files:**
- `lib/src/modules/auth/actions/auth_actions.dart`
- `lib/src/modules/auth/controllers/auth_view_model.dart`
- `lib/src/modules/auth/views/login.dart`

📖 See `docs/architecture/auth_module.md` for detailed documentation.

### 📡 Connections

Real-time connectivity monitoring with offline/online detection and reachability probing.

**Architecture:**
- `ConnectionViewModel` → `ReachabilityService`

**Features:**
- ✅ Wi-Fi, mobile data, and offline detection
- ✅ Reachability probing (DNS to google.com)
- ✅ Debounced connectivity events (250ms)
- ✅ Offline duration timer
- ✅ Material 3 themed overlays

**Usage:**
```dart
// Global overlay (shows connectivity status app-wide)
GlobalLoaderOverlay(
  child: ConnectionOverlay(
    child: GetMaterialApp(...),
  ),
)

// Conditional rendering
ConnectionHandler(
  connectedWidget: MyContent(),
  onRetry: () => controller.checkConnection(),
)
```

📖 See `docs/architecture/connectivity_module.md` for configuration.

### 📝 Posts Example

Reference implementation demonstrating the complete API integration pattern using JSONPlaceholder public API.

**Purpose:**
- 📚 Educational example of `apiFetch → ApiResponse → ApiHandler` pattern
- 🎯 Shows best practices for API integration
- 📝 Serves as template for creating your own modules

**What It Demonstrates:**
- `PostModel` with JSON serialization
- `PostService` extending `ApiService`
- `PostViewModel` using `apiFetch()` pattern
- `PostsPage` with `ApiHandler`
- Pull-to-refresh, error handling, empty states

**How to Adapt:**
1. Replace `PostModel` with your data model
2. Update `PostService` to call your API
3. Customize UI in `PostsPage`

📖 See `docs/examples/api_pattern_example.md` for complete guide.

### 🌍 Localization

Multi-language support with dynamic language switching and persistent preferences.

**Features:**
- ✅ Arabic and English built-in
- ✅ Translation key management
- ✅ RTL support
- ✅ Persistent language preference

**Usage:**
```dart
Text('auth.login.title'.tr) // Uses GetX translation
```

**How to Add a Language:**
1. Add to `LocalizationViewModel.supportedLanguages`
2. Create translation file in `lib/src/modules/locale/data/lang/<code>.dart`

### 🎨 Theme

Light and dark theme switching with Material 3 design and persistent preferences.

**Features:**
- ✅ Material 3 design system
- ✅ Rosy-red seed color
- ✅ System theme detection
- ✅ Persistent preference
- ✅ Google Fonts integration

**Usage:**
```dart
ThemeSwitch() // Switch widget
ThemeDrawerItem() // Drawer list tile
```

### 🍔 Menu

Simple drawer menu with navigation to all modules and theme/language pickers.

**Features:**
- ✅ Navigation to all pages
- ✅ Theme switcher integration
- ✅ Language picker integration
- ✅ Material 3 design

---

## 🛠️ Customization

### Adding Your Own Module

Use the `posts/` module as a reference:

**1️⃣ Create module structure:**
```
lib/src/modules/my_feature/
├── actions/                      # Optional
│   └── my_feature_actions.dart
├── controllers/
│   └── my_feature_view_model.dart
├── data/
│   ├── models/
│   │   └── my_model.dart
│   └── services/
│       └── my_service.dart
├── views/
│   ├── my_feature_page.dart
│   └── widgets/
├── my_feature_bindings.dart
└── my_feature.dart               # Barrel export
```

**2️⃣ Register in `lib/src/utils/binding.dart`:**
```dart
MyFeatureBindings().dependencies();
```

**3️⃣ Add route in `lib/src/utils/route_manager.dart`:**
```dart
static const String myFeaturePage = '/my-feature';

static void toMyFeaturePage() {
  Get.toNamed(myFeaturePage);
}
```

### Removing Modules

To remove a module you don't need:

1. Delete the module directory: `lib/src/modules/<module>/`
2. Remove bindings from `lib/src/utils/binding.dart`
3. Remove routes from `lib/src/utils/route_manager.dart`
4. Remove imports from `lib/src/app.dart`

### Customizing Core Components

**ActionPresenter** - Add analytics:
```dart
class MyActionPresenter extends ActionPresenter {
  @override
  Future actionHandler(BuildContext context, Future Function() action) async {
    analytics.logEvent('action_start');
    await super.actionHandler(context, action);
  }
}
```

**ApiService** - Add custom headers:
```dart
class MyApiService extends ApiService {
  @override
  Future<Response<T>> get<T>(String url, ...) async {
    httpClient.addRequestModifier<void>((request) {
      request.headers['X-Custom-Header'] = 'value';
      return request;
    });
    return super.get(url, ...);
  }
}
```

---

## ❓ FAQ

### ❓ Why use Mason instead of copying files manually?

**Benefits:**
- ⚡ Faster setup (1 command vs manual copy)
- 🔄 Versioning (update template easily)
- 🎯 Consistency (no missing files)
- 🔧 Customization (variables for project name, org, etc.)

### 🔄 Can I update the template after generation?

**Yes, but with caveats:**
- Re-running `mason make get_x_template` will overwrite files
- Best practice: Generate once, customize, commit to version control
- For updates: Use git to merge template changes selectively

### 📦 Can I use only specific modules?

**Yes!** After generation:
1. Delete unwanted module directories
2. Remove bindings from `lib/src/utils/binding.dart`
3. Remove routes from `lib/src/utils/route_manager.dart`

**Note:** Keep `core/` and `infrastructure/` - they're required by all modules.

### 🧪 How do I test generated code?

**ViewModels:**
```dart
test('fetchPosts emits loading then success', () async {
  final service = MockPostService();
  final viewModel = PostViewModel(service);

  when(service.fetchPosts()).thenAnswer((_) async => [PostModel(id: 1)]);

  viewModel.onInit();

  expect(viewModel.posts.isLoading, true);
  await Future.delayed(Duration.zero);
  expect(viewModel.posts.isSuccess, true);
});
```

### 🔐 How do I change the auth flow?

Edit these files:
- `lib/src/modules/auth/controllers/auth_view_model.dart` - Business logic
- `lib/src/modules/auth/data/services/auth_service.dart` - API calls
- `lib/src/modules/auth/views/login.dart` - UI

### 🌐 How do I add a new API endpoint?

**4 steps:**
1. Add URL to `lib/src/config/api_config.dart`
2. Create model in `data/models/`
3. Create service method extending `ApiService`
4. Use in ViewModel with `apiFetch()`

See `docs/examples/api_pattern_example.md` for detailed guide.

### 🎨 How do I change the theme colors?

Edit `lib/src/modules/theme/controllers/theme_view_model.dart`:

```dart
ColorScheme.fromSeed(
  seedColor: Color(0xFFYOUR_COLOR), // Change this
  brightness: brightness,
)
```

---

## 📚 Documentation

Comprehensive documentation is generated alongside the code:

### 🏛️ Architecture Docs
- **`docs/architecture/coding_guidelines.md`** - Naming conventions, MVVM pattern, module structure
- **`docs/architecture/auth_module.md`** - Authentication flow, state machine, testing
- **`docs/architecture/connectivity_module.md`** - Connectivity states, configuration

### 📖 Examples
- **`docs/examples/api_pattern_example.md`** - Complete API integration guide with examples

### 📝 Changelog
- **`CHANGELOG.md`** - Version history and migration guides

### 💡 Additional Resources
- [Main README](https://github.com/KalvadTech/getX-template/blob/master/README.md) - Complete template documentation
- [GetX Documentation](https://pub.dev/packages/get)
- [Mason Documentation](https://github.com/felangel/mason)

---

## 🐛 Troubleshooting

### Import Errors After Generation

**Problem:** Red underlines on imports
**Solution:**
1. Run `flutter pub get`
2. Restart your IDE
3. Run `flutter clean && flutter pub get`

### Module Not Working

**Problem:** Module features not functioning
**Solution:**
1. Check `lib/src/utils/binding.dart` - ensure module bindings are registered
2. Check `lib/src/main.dart` - ensure `AppStorageService.instance.initialize()` is called
3. Run `flutter clean && flutter pub get`

### Analyzer Errors

**Problem:** Flutter analyze shows errors
**Solution:**
1. Ensure all dependencies are in `pubspec.yaml`
2. Run `flutter pub get`
3. Run `flutter analyze` to see specific issues

### Auth Not Working

**Problem:** Login/register fails
**Solution:**
1. Update API URLs in `lib/src/config/api_config.dart`
2. Update `UserModel` to match your API response
3. Check network logs in `ApiService`

### Connectivity Module Always Shows "No Internet"

**Problem:** Connection overlay always red
**Solution:**
1. Check device connectivity
2. Update reachability host in `ReachabilityService` if google.com is blocked
3. See `docs/architecture/connectivity_module.md` for configuration

---

## 📦 Version History

- **0.3.0** (Current)
  - ✨ Added comprehensive README reorganization
  - ✨ Added FAQ section
  - ✨ Added Philosophy section
  - ✨ Enhanced module documentation
  - 🔄 Naming standardization (plural folders, matching bindings)
  - 📝 Enhanced coding guidelines

- **0.2.0**
  - ⚙️ Infrastructure refactoring
  - 💾 Added caching system
  - 💿 Added storage facade (`AppStorageService`)
  - 📦 Deprecated `MemoryService`

- **0.1.0**
  - 🎉 Initial release
  - 🔐 Auth, 📡 Connections, 🌍 Locale, 🎨 Theme modules
  - 📝 Posts example module

---

## 🤝 Support & Contributing

### 💬 Get Help
- **Repository**: [KalvadTech/getX-template](https://github.com/KalvadTech/getX-template)
- **Issues**: [Report bugs or request features](https://github.com/KalvadTech/getX-template/issues)
- **Discussions**: Ask questions in GitHub Discussions

### 🔧 Contributing
Contributions are welcome! See the main repository's [Contributing Guide](https://github.com/KalvadTech/getX-template#contributing).

### ⭐ Show Your Support
If this template helped you, consider:
- ⭐ Starring the repository
- 🐛 Reporting issues
- 🔧 Contributing improvements
- 📢 Sharing with others

---

## 👤 Author

**Mohamed Elamin**
- GitHub: [@KalvadTech](https://github.com/KalvadTech)
- Email: contact@kalvad.tech
- Organization: [Kalvad Technologies](https://kalvad.tech)

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

**🚀 Happy Coding!**

**🧱 [Main Template](https://github.com/KalvadTech/getX-template) | 📖 [Documentation](https://github.com/KalvadTech/getX-template/tree/master/docs) | 🐛 [Report Issues](https://github.com/KalvadTech/getX-template/issues)**
