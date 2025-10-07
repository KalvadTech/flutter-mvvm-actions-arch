// To parse this JSON data, use the following:
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

/// Parses a list of JSON objects into a list of `UserModel` instances.
List<UserModel> userModelFromJson(List<dynamic> json) =>
    List<UserModel>.from(json.map((x) => UserModel.fromJson(x)));

/// Parses a JSON string into a `UserModel` instance.
UserModel userModelFromString(String value) =>
    UserModel.fromJson(json.decode(value));

/// Converts a `UserModel` instance to a JSON string.
String userModelToJson(UserModel data) => json.encode(data.toJson());

/// Model class representing a user.
class UserModel {
  /// Constructor for `UserModel`.
  UserModel({
    this.username,
    this.phone,
    this.role,
    this.id,
    this.email,
    this.password,
  });

  String? username; // User's username
  String? phone; // User's phone number
  String? role; // User's role (e.g., admin, user)
  String? id; // User's unique identifier
  String? email; // User's email address
  String? password; // User's password (optional)

  /// Creates a copy of the current `UserModel` with optional new values.
  UserModel copyWith({
    String? username,
    String? phone,
    String? role,
    String? id,
    String? email,
    String? password,
  }) =>
      UserModel(
        username: username ?? this.username,
        phone: phone ?? this.phone,
        role: role ?? this.role,
        id: id ?? this.id,
        email: email ?? this.email,
        password: password ?? this.password,
      );

  /// Creates a `UserModel` instance from a JSON object.
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["_id"],
    username: json["username"],
    phone: json["phone"],
    role: json["role"],
    email: json["email"],
  );

  /// Creates an empty `UserModel` instance with default values.
  factory UserModel.empty() => UserModel(
    id: "",
    username: "",
    phone: "",
    role: "",
    email: "",
    password: "",
  );

  /// Converts the `UserModel` instance to a JSON object.
  Map<String, dynamic> toJson() => {
    "_id": id,
    "username": username,
    "phone": phone,
    "email": email,
    "role": role,
  };
}
