import 'contracts/cache_key_strategy.dart';

/// **DefaultCacheKeyStrategy**
///
/// Builds keys from `METHOD URL?sortedQuery` and appends a compact, whitelisted
/// header fingerprint to avoid wrong cache hits when servers vary responses by
/// localization or authentication.
///
/// **Why**
/// - Deterministic keys independent of map iteration order.
/// - Simple and human-readable keys for debugging.
/// - Avoids collisions between authenticated vs unauthenticated responses and
///   language-specific responses without exploding the key space.
///
/// **Key Features**
/// - Uppercases HTTP method to normalize.
/// - Sorts query parameters lexicographically by key.
/// - Includes a minimal header suffix built from:
///   - `Accept-Language`: lowercased value when present.
///   - `Authorization`: presence flag (`auth=1` if non-empty, otherwise `auth=0`).
///     This intentionally does not store token material to avoid leaking secrets
///     in cache keys.
///
/// **Example**
/// ```dart
/// const s = DefaultCacheKeyStrategy();
/// final key = s.buildKey('https://api/users', {'page': 1}, method: 'GET', headers: {
///   'Accept-Language': 'en',
///   'Authorization': 'Bearer abc.def.ghi',
/// });
/// // => 'GET https://api/users?page=1 | H:lang=en,auth=1'
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

    // Build a compact header fingerprint from a whitelist.
    final lang = _headerValue(headers, 'accept-language');
    final hasAuth = _hasNonEmptyHeader(headers, 'authorization');
    final parts = <String>[];
    if (lang != null && lang.isNotEmpty) parts.add('lang=${lang.toLowerCase()}');
    parts.add('auth=${hasAuth ? '1' : '0'}');
    if (parts.isNotEmpty) {
      buf.write(' | H:');
      buf.write(parts.join(','));
    }

    return buf.toString();
  }

  String? _headerValue(Map<String, String>? headers, String nameLower) {
    if (headers == null || headers.isEmpty) return null;
    for (final entry in headers.entries) {
      if (entry.key.toLowerCase() == nameLower) return entry.value;
    }
    return null;
  }

  bool _hasNonEmptyHeader(Map<String, String>? headers, String nameLower) {
    final v = _headerValue(headers, nameLower);
    return v != null && v.trim().isNotEmpty;
  }
}
