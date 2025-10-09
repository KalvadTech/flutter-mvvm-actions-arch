/// **TokenStorage**
///
/// Contract for securely storing and retrieving authentication tokens.
///
/// **Why**
/// - Abstract over platform-specific secure storage to enable testing and swaps.
/// - Provide a minimal, intention-revealing API for access/refresh tokens.
///
/// **Key Features**
/// - Separate read/write for access and refresh tokens.
/// - Ability to clear tokens atomically.
///
/// **Example**
/// ```dart
/// final tokens = SecureTokenStorage.instance;
/// await tokens.initialize();
/// await tokens.writeAccessToken('jwt');
/// final jwt = tokens.readAccessTokenSync;
/// ```
///
// ────────────────────────────────────────────────
abstract class TokenStorage {
  /// **initialize**
  ///
  /// Prepare the storage for use (e.g., hydrate in-memory caches).
  // ────────────────────────────────────────────────
  Future<void> initialize();

  /// **readAccessTokenSync**
  ///
  /// Return the cached access token if loaded during [initialize].
  String? get readAccessTokenSync;

  /// **readRefreshTokenSync**
  ///
  /// Return the cached refresh token if loaded during [initialize].
  String? get readRefreshTokenSync;

  /// **writeAccessToken**
  ///
  /// Persist the access token; pass null or empty to delete.
  Future<void> writeAccessToken(String? value);

  /// **writeRefreshToken**
  ///
  /// Persist the refresh token; pass null or empty to delete.
  Future<void> writeRefreshToken(String? value);

  /// **clearTokens**
  ///
  /// Remove access and refresh tokens atomically.
  Future<void> clearTokens();
}