import 'package:get/get.dart';
import 'controllers/connection_view_model.dart';

/// ConnectionsBindings
///
/// Ensures ConnectionViewModel is available before any widgets that depend
/// on it (e.g., ConnectionOverlay) are built. Use this binding early in
/// app startup (e.g., in main() before runApp) since ConnectionOverlay is
/// wrapped outside GetMaterialApp where initialBinding would not yet run.
class ConnectionsBindings extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ConnectionViewModel>()) {
      Get.put(ConnectionViewModel(), permanent: true);
    }
  }
}
