import '../../../core/presentation/actions/action_presenter.dart';
import '/src/modules/grades/data/model/grade_model.dart';
import '/src/utils/route_manager.dart';
import 'package:get/get.dart';

/// A singleton class for managing grade-related actions in the application.
class GradeActions extends ActionPresenter {
  /// Singleton instance of [GradeActions].
  static final GradeActions _mInstance = GradeActions._();

  /// Provides global access to the singleton instance.
  static GradeActions get instance => _mInstance;

  /// Private constructor to implement the singleton pattern.
  GradeActions._();

  /// Navigates to the subject page when a grade is selected.
  ///
  /// [gradeModel]: The selected grade's model, passed as an argument to the subject page.
  void onGradeSelected(GradeModel gradeModel) {
    // Get.toNamed(RouteManager.subjectRoute, arguments: gradeModel);
  }
}
