import 'dart:convert';

/// Converts a JSON List into a list of `GradeModel` instances.
///
/// [json] is the input JSON list.
///
/// Returns a list of `GradeModel`.
List<GradeModel> gradeModelFromJson(List json) =>
    List<GradeModel>.from(json.map((x) => GradeModel.fromJson(x)));

/// Converts a list of `GradeModel` instances into a JSON-encoded string.
///
/// [data] is the list of `GradeModel` to convert.
///
/// Returns the JSON-encoded string representation of the list.
String gradeModelToJson(List<GradeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// A model representing a Grade with its associated details.
class GradeModel {
  /// Unique identifier for the grade.
  final String id;

  /// Name of the grade.
  final String name;

  /// Path associated with the grade.
  final String path;

  /// Constructor to initialize all required fields.
  GradeModel({
    required this.id,
    required this.name,
    required this.path,
  });

  /// Factory method to create a `GradeModel` from a JSON map.
  ///
  /// [json] is the JSON map containing the grade details.
  ///
  /// Returns a `GradeModel` instance.
  factory GradeModel.fromJson(Map<String, dynamic> json) => GradeModel(
    id: json["id"],
    name: json["name"],
    path: json["path"],
  );

  /// Converts the `GradeModel` instance into a JSON map.
  ///
  /// Returns a map representing the `GradeModel` instance.
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "path": path,
  };
}
