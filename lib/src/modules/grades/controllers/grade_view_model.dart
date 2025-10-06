import '../../../core/presentation/api_response.dart';
import '/src/modules/grades/data/model/grade_model.dart';
import '/src/modules/grades/data/service/grade_service.dart';
import 'package:get/get.dart';

/// **GradeViewModel**
///
/// GetX controller responsible for managing grades list state and
/// orchestrating data fetching via [GradeService].
///
/// **Why**
/// - Encapsulate grades business logic separate from UI.
/// - Provide reactive [ApiResponse] state for loading/success/error rendering.
///
/// **Key Features**
/// - Reactive `grades` observable wrapped in [ApiResponse].
/// - Automatic data fetch on initialization.
/// - Refresh capability for pull-to-refresh or manual reload.
/// - Uses [apiFetch] helper to manage loading/success/error lifecycle.
///
/// **Example**
/// ```dart
/// final gradesVM = Get.find<GradeViewModel>();
/// gradesVM.refreshData();
/// ```
///
// ────────────────────────────────────────────────
class GradeViewModel extends GetxController {
  /// Service used to fetch grades from the API.
  final GradeService _gradeService;

  /// Constructor initializing the grade service and triggering data fetching.
  GradeViewModel(this._gradeService) {
    _initialize();
  }

  /// Observable state holding the API response for grades.
  final Rx<ApiResponse<List<GradeModel>>> _grades = ApiResponse<List<GradeModel>>.idle().obs;

  /// Getter to expose the grades API response.
  ApiResponse<List<GradeModel>> get grades => _grades.value;

  /// Initializes the ViewModel by fetching the initial data.
  void _initialize() {
    _fetchData();
  }

  /// Triggers fetching of grades data.
  void _fetchData() {
    _fetchGrades();
  }

  /// Fetches grades data from the API and updates the observable state.
  void _fetchGrades() async {
    apiFetch(_gradeService.fetchGrades).listen((value) => _grades.value = value);
  }

  /// Refreshes the grades data, useful for pull-to-refresh or manual reload actions.
  void refreshData() {
    _fetchData();
  }
}
