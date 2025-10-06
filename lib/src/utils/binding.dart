import 'package:get/get.dart';
import 'package:getx_starter/src/modules/grades/grade_bindings.dart';
import '/src/modules/menu/menu.dart';
import '/src/modules/auth/auth.dart';
import '/src/modules/connections/connection.dart';

/// InitialBindings class is responsible for initializing and managing the core dependencies
/// required throughout the application lifecycle.
///
/// This class registers the essential bindings like `ConnectionViewModel`,
/// along with `AuthBindings` and `MenuBindings`, ensuring they are loaded lazily when needed.
class InitialBindings extends Bindings {

  /// Registers dependencies using GetX's lazy loading mechanism.
  ///
  /// This method ensures that instances are only created when they are accessed for the first time,
  /// promoting performance and efficient resource management.
  @override
  void dependencies() {
    // Registers ConnectionViewModel as a lazy-loaded dependency.
    if (!Get.isRegistered<ConnectionViewModel>()) {
      Get.put(ConnectionViewModel(), permanent: true);
    }

    // Registers the dependencies required for authentication.
    AuthBindings().dependencies();

    // Registers the dependencies related to menu functionality.
    MenuBindings().dependencies();

    GradeBindings().dependencies();
  }
}
