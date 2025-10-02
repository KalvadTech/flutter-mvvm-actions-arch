import 'cache_key_strategy.dart';

/// **DefaultCacheKeyStrategy**
///
/// Builds keys from `METHOD URL?sortedQuery` to maximize cache hit rate.
/// Headers are ignored by default to keep keys stable unless an implementation
/// requires header-based partitioning.
///
/// **Why**
/// - Deterministic keys independent of map iteration order.
/// - Simple and human-readable keys for debugging.
///
/// **Key Features**
/// - Uppercases HTTP method to normalize.
/// - Sorts query parameters lexicographically by key.
/// - Omits headers by default to avoid key explosion.
///
/// **Example**
/// ```dart
/// const s = DefaultCacheKeyStrategy();
/// final key = s.buildKey('https://api/users', {'page': 1}, method: 'GET');
/// // => 'GET https://api/users?page=1'
/// ```
///
// ────────────────────────────────────────────────
class DefaultCacheKeyStrategy implements CacheKeyStrategy {
  const DefaultCacheKeyStrategy();

  @override
  String buildKey(
    String url,
    Map<String, dynamic>? query, {
    String method = 'GET',
    Map<String, String>? headers,
  }) {
    final buf = StringBuffer();
    buf.write(method.toUpperCase());
    buf.write(' ');
    buf.write(url);
    if (query != null && query.isNotEmpty) {
      final entries = query.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));
      final qs = entries.map((e) => '${e.key}=${e.value}').join('&');
      buf.write('?');
      buf.write(qs);
    }
    return buf.toString();
  }
}
