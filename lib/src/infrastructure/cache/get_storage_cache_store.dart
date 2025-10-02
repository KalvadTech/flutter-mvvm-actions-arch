import 'dart:convert';
import 'package:get_storage/get_storage.dart';

import 'contracts/cache_store.dart';

/// **GetStorageCacheStorage**
///
/// A [CacheStore] implementation backed by `get_storage` that stores values
/// with an expiry timestamp.
///
/// **Why**
/// - Simple, lightweight persistent storage suitable for mobile apps.
/// - JSON-encoded payload with explicit expiry makes invalidation deterministic.
///
/// **Key Features**
/// - Asynchronous factory to ensure container initialization.
/// - Stores entries as JSON: `{ "body": String, "expiry": ISO8601 String }`.
/// - Removes corrupted or expired entries on read.
///
/// **Example**
/// ```dart
/// final store = await GetStorageCacheStorage.create(container: 'appName-app');
/// await store.put('GET https://api/users', '{"id":"u1"}', ttl: Duration(hours: 6));
/// final value = await store.get('GET https://api/users');
/// ```
///
// ────────────────────────────────────────────────
class GetStorageCacheStorage implements CacheStore {
  GetStorageCacheStorage._(this._storage);

  /// **_storage**
  ///
  /// Underlying GetStorage instance (container-scoped).
  final GetStorage _storage;

  /// **create**
  ///
  /// Factory that ensures the storage container is initialized before use.
  ///
  /// **Parameters**
  /// - `container`: Named container to isolate data per app/flavor.
  ///
  /// **Returns**
  /// - `Future<GetStorageCacheStorage>`: Ready-to-use storage wrapper.
  ///
  // ────────────────────────────────────────────────
  static Future<GetStorageCacheStorage> create({String container = 'appName-app'}) async {
    await GetStorage.init(container);
    return GetStorageCacheStorage._(GetStorage(container));
    }

  /// **put**
  ///
  /// Store a raw string value with an expiry computed from TTL.
  // ────────────────────────────────────────────────
  @override
  Future<void> put(String key, String value, {required Duration ttl}) async {
    final expiry = DateTime.now().add(ttl).toIso8601String();
    final payload = jsonEncode({'body': value, 'expiry': expiry});
    await _storage.write(key, payload);
  }

  /// **get**
  ///
  /// Retrieve a value when present and not expired. Removes invalid entries.
  // ────────────────────────────────────────────────
  @override
  Future<String?> get(String key) async {
    final raw = _storage.read(key);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      final expiry = DateTime.parse(decoded['expiry'] as String);
      if (expiry.isAfter(DateTime.now())) {
        final body = decoded['body'];
        if (body is String) return body;
        // If stored as non-string by mistake, coerce
        return jsonEncode(body);
      } else {
        await remove(key);
        return null;
      }
    } catch (_) {
      // Corrupted entry; remove it.
      await remove(key);
      return null;
    }
  }

  /// **remove**
  ///
  /// Delete a single entry by key.
  // ────────────────────────────────────────────────
  @override
  Future<void> remove(String key) async {
    await _storage.remove(key);
  }

  /// **clear**
  ///
  /// Remove all entries from the container.
  // ────────────────────────────────────────────────
  @override
  Future<void> clear() async {
    await _storage.erase();
  }
}
