/// **CachePolicy**
///
/// Defines when cache may be read or written and which time-to-live (TTL) to apply.
///
/// **Why**
/// - Separate cache decision logic from storage and HTTP orchestration.
/// - Allow different policies per environment or per service (e.g., no cache for payments).
///
/// **Key Features**
/// - Read gating via [canRead].
/// - Write gating via [canWrite].
/// - TTL selection via [timeToLiveFor].
///
/// **Example**
/// ```dart
/// final policy = SimpleTimeToLiveCachePolicy(timeToLive: Duration(hours: 12));
/// if (policy.canWrite('GET', url, 200)) { /* ... */ }
/// ```
///
// ────────────────────────────────────────────────
abstract class CachePolicy {
  /// **canRead**
  ///
  /// Decide whether to attempt a cache read before the network request.
  ///
  /// **Parameters**
  /// - `method`: HTTP method (e.g., GET, POST).
  /// - `url`: Full request URL.
  /// - `query`: Query parameters.
  /// - `forceRefresh`: If true, bypass cache regardless of other rules.
  ///
  /// **Returns**
  /// - `bool`: `true` to attempt reading from cache.
  ///
  // ────────────────────────────────────────────────
  bool canRead(
    String method,
    String url,
    Map<String, dynamic>? query, {
    bool forceRefresh = false,
  });

  /// **canWrite**
  ///
  /// Decide whether to persist a response in cache.
  ///
  /// **Parameters**
  /// - `method`: HTTP method.
  /// - `url`: Full request URL.
  /// - `statusCode`: Response status code.
  ///
  /// **Returns**
  /// - `bool`: `true` when the response should be cached.
  ///
  // ────────────────────────────────────────────────
  bool canWrite(
    String method,
    String url,
    int? statusCode,
  );

  /// **timeToLiveFor**
  ///
  /// Select the time-to-live (TTL) to apply for a given response.
  ///
  /// **Returns**
  /// - `Duration`: TTL window after which the entry expires.
  ///
  // ────────────────────────────────────────────────
  Duration timeToLiveFor(
    String method,
    String url,
    int? statusCode,
  );
}
