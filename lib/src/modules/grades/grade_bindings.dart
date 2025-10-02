import 'package:alakhtabut/src/modules/grades/controllers/grade_view_model.dart';
import 'package:alakhtabut/src/modules/grades/data/service/grade_service.dart';
import 'package:get/get.dart';

/// The `GradeBindings` class sets up the dependencies required for the grades module.
///
/// This includes lazy-loading the `GradeService` and `GradeViewModel` instances.
class GradeBindings implements Bindings {
  @override
  void dependencies() {
    // Lazy load the GradeService instance. It will be created when first requested.
    Get.lazyPut(() => GradeService());

    // Lazy load the GradeViewModel instance, passing the GradeService as a dependency.
    Get.lazyPut(() => GradeViewModel(Get.find()));
  }
}
