import 'contracts/cache_policy.dart';

/// **SimpleTimeToLiveCachePolicy**
///
/// Straightforward time-to-live (TTL) cache policy suitable for most APIs.
///
/// **Why**
/// - Sensible defaults: cache GET responses only; do not cache writes.
/// - Avoid caching error responses by checking status code range.
///
/// **Key Features**
/// - Reads from cache only when not forced to refresh.
/// - Writes only successful (2xx) responses.
/// - Fixed TTL provided via constructor.
///
/// **Example**
/// ```dart
/// final policy = SimpleTimeToLiveCachePolicy(timeToLive: Duration(hours: 6));
/// ```
///
// ────────────────────────────────────────────────
class SimpleTimeToLiveCachePolicy implements CachePolicy {
  SimpleTimeToLiveCachePolicy({
    Duration? timeToLive,
    this.cacheGetRequestsOnly = true,
  }) : _timeToLive = timeToLive ?? const Duration(days: 365);

  /// Fixed time window for cached entries.
  final Duration _timeToLive;

  /// When true (default), caching is limited to GET requests.
  final bool cacheGetRequestsOnly;

  bool _isSuccessStatus(int? statusCode) => statusCode != null && statusCode >= 200 && statusCode < 300;

  /// **canRead**
  ///
  /// Only allow reads when not forced and when method constraints permit.
  // ────────────────────────────────────────────────
  @override
  bool canRead(String method, String url, Map<String, dynamic>? query, {bool forceRefresh = false}) {
    if (forceRefresh) return false;
    if (cacheGetRequestsOnly && method.toUpperCase() != 'GET') return false;
    return true;
  }

  /// **canWrite**
  ///
  /// Permit cache writes for successful responses and allowed methods.
  // ────────────────────────────────────────────────
  @override
  bool canWrite(String method, String url, int? statusCode) {
    if (cacheGetRequestsOnly && method.toUpperCase() != 'GET') return false;
    return _isSuccessStatus(statusCode);
  }

  /// **timeToLiveFor**
  ///
  /// Return the configured fixed TTL regardless of inputs.
  // ────────────────────────────────────────────────
  @override
  Duration timeToLiveFor(String method, String url, int? statusCode) => _timeToLive;
}
