import 'package:get/get.dart';
import 'theme.dart';

/// **ThemeBindings**
///
/// Dependency injection bindings for the theme module.
///
/// **Why**
/// - Ensure ThemeViewModel and ThemeService are properly initialized.
/// - Follow GetX dependency injection pattern consistently.
///
/// **Key Features**
/// - Lazily creates ThemeService singleton.
/// - Lazily creates ThemeViewModel with ThemeService dependency.
/// - Uses fenix mode to allow recreation if deleted.
///
/// **Example**
/// ```dart
/// ThemeBindings().dependencies();
/// final themeVM = Get.find<ThemeViewModel>();
/// ```
///
// ────────────────────────────────────────────────
class ThemeBindings extends Bindings {
  @override
  void dependencies() {
    // Register ThemeService first
    Get.lazyPut<ThemeService>(
      () => ThemeService(),
      fenix: true,
    );

    // Register ThemeViewModel with service dependency
    Get.lazyPut<ThemeViewModel>(
      () => ThemeViewModel(Get.find<ThemeService>()),
      fenix: true,
    );
  }
}
