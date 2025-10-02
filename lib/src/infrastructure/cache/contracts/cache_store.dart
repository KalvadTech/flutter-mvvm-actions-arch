import 'dart:async';

/// **CacheStore**
///
/// Minimal, time-to-live (TTL) capable key–value storage abstraction.
/// Implementations may persist to memory, disk, or any backend.
///
/// **Why**
/// - Decouple HTTP/caching orchestration from concrete storage engines.
/// - Enable global cache on/off by swapping implementations at composition time.
///
/// **Key Features**
/// - TTL-aware put/get semantics.
/// - Minimal surface: put, get, remove, clear.
/// - Designed to store raw response text (e.g., JSON strings).
///
/// **Example**
/// ```dart
/// final store = await GetStorageCacheStorage.create(container: 'appName-app');
/// await store.put('GET https://api/users', '{"id":"u1"}', ttl: Duration(hours: 6));
/// final cached = await store.get('GET https://api/users');
/// ```
///
// ────────────────────────────────────────────────
abstract class CacheStore {
  /// **put**
  ///
  /// Persist a raw string value under a key with a time-to-live (TTL).
  ///
  /// **Parameters**
  /// - `key`: Deterministic cache key.
  /// - `value`: Raw string payload to store (e.g., response bodyString).
  /// - `ttl`: Time window during which the entry is considered valid.
  ///
  /// **Side Effects**
  /// - Writes to the underlying storage.
  ///
  // ────────────────────────────────────────────────
  Future<void> put(String key, String value, {required Duration ttl});

  /// **get**
  ///
  /// Retrieve a cached value by key.
  ///
  /// **Returns**
  /// - `String?`: Raw string payload when present and not expired; `null` otherwise.
  ///
  // ────────────────────────────────────────────────
  Future<String?> get(String key);

  /// **remove**
  ///
  /// Remove a single entry by key, if present.
  // ────────────────────────────────────────────────
  Future<void> remove(String key);

  /// **clear**
  ///
  /// Remove all cached entries.
  // ────────────────────────────────────────────────
  Future<void> clear();
}
