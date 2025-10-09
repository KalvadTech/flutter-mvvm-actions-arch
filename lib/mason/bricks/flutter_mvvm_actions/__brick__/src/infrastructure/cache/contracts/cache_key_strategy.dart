/// **CacheKeyStrategy**
///
/// Strategy interface for building deterministic cache keys from request data.
///
/// **Why**
/// - Ensure identical requests map to the same cache entry.
/// - Keep key-building policy independent from storage and HTTP orchestration.
///
/// **Key Features**
/// - Can incorporate method, URL, query parameters, and optionally headers.
/// - Implementations should guarantee stable ordering (e.g., sort query keys).
///
/// **Example**
/// ```dart
/// final s = DefaultCacheKeyStrategy();
/// final key = s.buildKey('https://api/users', {'page': 1}, method: 'GET');
/// ```
///
// ────────────────────────────────────────────────
abstract class CacheKeyStrategy {
  /// **buildKey**
  ///
  /// Build a deterministic cache key using URL, query, HTTP method, and optional headers.
  ///
  /// **Parameters**
  /// - `url`: Full request URL.
  /// - `query`: Query map; implementations should sort keys for stability.
  /// - `method`: HTTP method (default: `GET`).
  /// - `headers`: Optional headers included in key if the strategy requires it.
  ///
  /// **Returns**
  /// - `String`: Deterministic cache key.
  ///
  // ────────────────────────────────────────────────
  String buildKey(
    String url,
    Map<String, dynamic>? query, {
    String method = 'GET',
    Map<String, String>? headers,
  });
}
