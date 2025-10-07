import '../../modules/locale/data/keys.dart';

/// Base class for all custom exceptions in the app.
class AppException implements Exception {
  /// The error message associated with the exception.
  final String message;

  /// A prefix to indicate the type or source of the exception.
  final String prefix;

  /// Constructs an [AppException] with an optional [message] and [prefix].
  AppException([this.message = "", this.prefix = ""]);

  @override
  String toString() {
    return "$prefix: $message";
  }
}

/// Exception for authentication-related issues.
class AuthException extends AppException {
  /// Constructs an [AuthException] with an optional [message].
  AuthException([String? message]) : super(message ?? "", tkAuthError);
}

/// Exception for API-related issues.
class APIException extends AppException {
  /// Constructs an [APIException] with an optional [message].
  APIException([String? message]) : super(message ?? "", tkApiError);
}

/// Exception for network-related issues.
class NetworkException extends AppException {
  /// Constructs a [NetworkException] with an optional [message].
  NetworkException([String? message]) : super(message ?? "", tkNetworkError);
}

/// Exception for data fetching issues.
class FetchingException extends AppException {
  /// Constructs a [FetchingException] with an optional [message].
  FetchingException([String? message]) : super(message ?? "", tkFetchingError);
}
