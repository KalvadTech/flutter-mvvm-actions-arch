import 'package:alakhtabut/src/essentials/config/api_config.dart';
import 'package:alakhtabut/src/essentials/services/api_service.dart';
import 'package:alakhtabut/src/modules/grades/data/model/grade_model.dart';

/// Service for handling grade-related API requests and mock data.
class GradeService extends ApiService {

  /// Fetches grades from the server.
  ///
  /// Makes a GET request to the grades endpoint and parses the response.
  ///
  /// Returns a list of `GradeModel` objects.
  /// Throws an exception if the API call fails or the response is invalid.
  Future<List<GradeModel>> fetchGrades() async {
    final response = await get(APIConfiguration.gradesUrl);
    return gradeModelFromJson(response.body);
  }
}
