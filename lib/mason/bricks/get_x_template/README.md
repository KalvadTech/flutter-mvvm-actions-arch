# getX_template Mason Brick

A Flutter application template Mason brick using GetX for state management with **MVVM + Actions Layer** architecture.

## Features

🏗️ **Clean Architecture**
- MVVM + Actions Layer pattern
- Separation of concerns (UI, UX, Logic, Data)
- Reactive state management with GetX

🔐 **Authentication Module** (optional)
- Login/Register pages with validation
- Token management with secure storage
- Auto token refresh on 401

📡 **Connectivity Module** (optional)
- Real-time connectivity monitoring
- Offline/online detection
- Reachability probing

🌍 **Localization Module** (optional)
- Multi-language support (Arabic/English)
- RTL support
- Persistent language preference

🎨 **Theme Module** (optional)
- Light/Dark theme switching
- Material 3 design
- Persistent theme preference

📚 **Posts Example Module** (optional)
- Complete API integration pattern example
- Demonstrates `apiFetch → ApiResponse → ApiHandler`
- Reference implementation for custom modules

🧭 **Menu Module** (optional)
- Drawer and Bottom Navigation options
- Configurable menu items
- Pre-built example pages

## Installation

### Install Mason CLI

```sh
dart pub global activate mason_cli
```

### Add Brick from Git

```sh
mason add get_x_template --git-url https://github.com/KalvadTech/getX-template --git-path lib/mason/bricks/get_x_template
```

Or add to your local bricks:

```sh
mason add get_x_template --path /path/to/getX-template/lib/mason/bricks/get_x_template
```

## Usage

Navigate to your Flutter project's `lib` directory and run:

```sh
mason make get_x_template
```

You'll be prompted for:
- **project_name**: Your Flutter project name (e.g., `my_app`)
- **description**: Project description
- **org_name**: Organization identifier (e.g., `com.example`)
- **Module selections**: Choose which modules to include

### Example

```sh
$ mason make get_x_template
? What is your project name? awesome_app
? What is your project description? My awesome Flutter app
? What is your organization name (e.g., com.example)? com.mycompany
? Include authentication module? Yes
? Include connectivity monitoring module? Yes
? Include localization module? Yes
? Include theme switching module? Yes
? Include posts example module? Yes
? Include menu module? Yes
```

This will generate the `src/` directory with all selected modules in your current location.

## What Gets Generated

The brick generates a complete `src/` directory structure:

```
lib/src/
├── app.dart
├── main.dart
├── config/
├── core/
├── infrastructure/
├── presentation/
├── utils/
└── modules/
    ├── auth/           (if selected)
    ├── connections/    (if selected)
    ├── locale/         (if selected)
    ├── theme/          (if selected)
    ├── posts/          (if selected)
    └── menu/           (if selected)
```

## Post-Generation Steps

After running `mason make get_x_template`, complete these steps:

### 1. Add Required Packages

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
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

Then run:

```sh
flutter pub get
```

### 2. Update API Configuration

Edit `lib/src/config/api_config.dart` with your API URLs:

```dart
static const String _stagingUrl = 'https://your-staging-api.com';
static const String _productionUrl = 'https://your-production-api.com';
```

### 3. Update User Model (if using auth)

Edit `lib/src/modules/auth/data/models/user.dart` to match your API response.

### 4. Configure Assets (optional)

If using assets, update `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/
    - assets/icons/
```

### 5. Run the App

```sh
flutter run
```

## Module Details

### Authentication Module
- **Pages**: Login, Register, Splash
- **Features**: Form validation, token management, session checking
- **Architecture**: AuthActions → AuthViewModel → AuthService → UserModel

### Connectivity Module
- **Widgets**: ConnectionOverlay, ConnectionHandler
- **Features**: Wi-Fi/Mobile detection, reachability probing, offline timer
- **Architecture**: ConnectionViewModel → ReachabilityService

### Localization Module
- **Languages**: Arabic, English (easily add more)
- **Features**: Translation keys, RTL support, persistent preference
- **Architecture**: LocalizationViewModel → LocalizationService → LanguageModel

### Theme Module
- **Themes**: Light, Dark, System
- **Features**: Material 3, persistent preference, Google Fonts
- **Architecture**: ThemeViewModel → ThemeService

### Posts Example Module
- **Purpose**: Demonstrates API integration pattern
- **API**: JSONPlaceholder (https://jsonplaceholder.typicode.com/posts)
- **Features**: Pull-to-refresh, error handling, loading states
- **Architecture**: PostViewModel → PostService → PostModel → ApiHandler

### Menu Module
- **Options**: Drawer navigation, Bottom navigation
- **Features**: Configurable menu items, example pages
- **Architecture**: MenuViewModel → MenuItem → MenuBindings

## Customization

### Adding Your Own Module

Use the `posts/` module as a reference:

1. Create module directory: `lib/src/modules/my_feature/`
2. Follow the standard structure:
   - `controllers/` - ViewModels
   - `data/models/` - Data models
   - `data/services/` - API services
   - `views/` - UI pages
   - `<feature>_bindings.dart` - DI setup
   - `<feature>.dart` - Barrel export

3. Register in `lib/src/utils/binding.dart`

### Removing Modules

If you didn't include a module during generation, you can safely add it later by:
1. Manually copying the module from the template repository
2. Updating `lib/src/utils/binding.dart`
3. Running `flutter pub get`

## Documentation

Comprehensive documentation is available in the generated code:

- `docs/architecture/coding_guidelines.md` - Coding standards and MVVM pattern
- `docs/examples/api_pattern_example.md` - Complete API integration guide
- `docs/architecture/auth_module.md` - Authentication flow
- `docs/architecture/connectivity_module.md` - Connectivity configuration

## Troubleshooting

### Import Errors

If you see import errors after generation, ensure:
1. All required packages are in `pubspec.yaml`
2. You ran `flutter pub get`
3. Your IDE has indexed the project (restart if needed)

### Module Not Working

If a module isn't working:
1. Check `lib/src/utils/binding.dart` - ensure the module bindings are registered
2. Check `lib/src/main.dart` - ensure required initializations are present
3. Run `flutter clean && flutter pub get`

## Version History

- **0.3.0** - Added Posts example module, enhanced documentation, naming standardization
- **0.2.0** - Infrastructure refactoring, caching, storage facade
- **0.1.0** - Initial release with core modules

## Support

- **Repository**: https://github.com/KalvadTech/getX-template
- **Issues**: https://github.com/KalvadTech/getX-template/issues
- **Documentation**: See generated `docs/` directory

## License

MIT License - see LICENSE file for details
