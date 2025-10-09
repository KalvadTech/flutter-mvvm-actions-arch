import 'package:get/get.dart';
import '/src/modules/connections/connections_bindings.dart';
import '/src/modules/locale/locale_bindings.dart';
import '/src/modules/theme/theme_bindings.dart';

/// **InitialBindings**
///
/// Registers core app-wide dependencies using GetX dependency injection.
///
/// **Features**:
/// - Lazy loading for performance optimization
/// - Permanent registration for global dependencies
/// - Initialization order management
///
/// **Usage**:
/// ```dart
/// GetMaterialApp(
///   initialBinding: InitialBindings(),
///   // ...
/// )
/// ```
///
/// **Registered Dependencies**:
/// - `ConnectionViewModel` - Connectivity state management (permanent)
/// - `ThemeViewModel` - Theme/dark mode management
/// - `LocalizationViewModel` - Language/locale management
///
/// **Notes**:
/// - Auth, Menu, and Posts bindings are registered after authentication
/// - Dependencies are registered in specific order to handle inter-dependencies
/// - `ThemeViewModel` must be available before app widget builds
/// - Use `permanent: true` for dependencies that should persist across route changes
class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // ═══════════════════════════════════════════════════════════════════════════
    // Core Dependencies (Permanent)
    // ═══════════════════════════════════════════════════════════════════════════

    // Connectivity monitoring - permanent, app-wide
    ConnectionsBindings().dependencies();

    // Theme management - required before app widget builds
    ThemeBindings().dependencies();

    // Localization - permanent, app-wide
    LocaleBindings().dependencies();

    // ═══════════════════════════════════════════════════════════════════════════
    // Feature Dependencies
    // ═══════════════════════════════════════════════════════════════════════════

    // Note: Auth, Menu, and Posts bindings are registered via route bindings
    // and auth success callbacks, not here.
  }
}
