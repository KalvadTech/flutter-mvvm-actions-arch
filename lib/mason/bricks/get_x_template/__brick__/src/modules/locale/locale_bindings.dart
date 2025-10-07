import 'package:get/get.dart';
import 'controllers/localization_view_model.dart';

/// **LocaleBindings**
///
/// Bindings class responsible for registering localization dependencies
/// with GetX dependency injection system.
///
/// **Why**
/// - Ensure LocalizationViewModel is available app-wide
/// - Register as permanent to persist across route changes
/// - Follow MVVM architecture pattern for DI
///
/// **Key Features**
/// - Lazy initialization of LocalizationViewModel
/// - Permanent registration for app-wide availability
///
/// **Example**
/// ```dart
/// // In main.dart or InitialBindings
/// LocaleBindings().dependencies();
/// ```
///
// ────────────────────────────────────────────────
class LocaleBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocalizationViewModel>(
      () => LocalizationViewModel(),
      fenix: true,
    );
  }
}
