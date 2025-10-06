/// **APIConfiguration**
///
/// Centralized configuration for API endpoints and environment selection.
///
/// **Why**
/// - Provide a single source of truth for API base URLs.
/// - Enable easy switching between staging and production environments.
///
/// **Key Features**
/// - `isDevelopment` flag to toggle between staging and production.
/// - Module-specific URL constants (auth, grades, etc.).
/// - Type-safe, compile-time constants for all endpoints.
///
/// **Example**
/// ```dart
/// final url = APIConfiguration.signInUrl; // Uses staging or production based on isDevelopment
/// ```
///
// ────────────────────────────────────────────────
class APIConfiguration {
  /// TODO: Set the value to `false` before pushing to the repository.
  /// This flag determines whether the app is running in development mode.
  static const bool isDevelopment = true;

  /// The base URL for the staging environment.
  static const String _stagingUrl = 'https://app-2f58668c-3ee7-467e-abc6-0bf73d700387.cleverapps.io';

  /// The base URL for the production environment.
  static const String _productionUrl = 'https://app-2f58668c-3ee7-467e-abc6-0bf73d700387.cleverapps.io';

  /// The base URL used in the application.
  /// If `isDevelopment` is true, the staging URL will be used; otherwise, the production URL.
  static const String baseUrl = isDevelopment ? _stagingUrl : _productionUrl;

  // --- Auth module URLs ---

  /// URL for signing in to the application.
  static const String signInUrl = '$baseUrl/signin';

  /// URL for signing up a new user.
  static const String signUpUrl = '$baseUrl/signup';

  /// URL for refreshing an existing user session.
  static const String refreshSessionUrl = '$baseUrl/token/refresh';

  static const String gradesUrl = '$baseUrl/folders';

}
