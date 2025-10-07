import 'package:get/get.dart';
import 'auth.dart';

class AuthBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthViewModel(AuthService()));
  }
}