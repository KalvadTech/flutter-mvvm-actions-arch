import '/src/essentials/config/api_response.dart';
import '/src/modules/grades/data/model/grade_model.dart';
import '/src/modules/grades/data/service/grade_service.dart';
import 'package:get/get.dart';

/// ViewModel class to manage grades' state and business logic.
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
    apiFetch(_gradeService.fetchGrades()).listen((value) => _grades.value = value);
  }

  /// Refreshes the grades data, useful for pull-to-refresh or manual reload actions.
  void refreshData() {
    _fetchData();
  }
}
