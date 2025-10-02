import 'dart:async';

import 'contracts/cache_store.dart';
import 'contracts/cache_key_strategy.dart';
import 'contracts/cache_policy.dart';

/// **CacheManager**
///
/// Orchestrates cache reads and writes by delegating to a [CacheKeyStrategy]
/// to build deterministic keys, a [CachePolicy] to decide if/when to cache,
/// and a [CacheStore] to persist raw response text.
///
/// **Why**
/// - Central place to apply caching rules without coupling to HTTP or decoders.
/// - Enables global enable/disable by composing a manager at app startup.
///
/// **Key Features**
/// - Raw string storage (e.g., JSON) to keep decoding at the call site.
/// - Helper methods to invalidate a single entry or clear all.
/// - Deterministic keys across environments.
///
/// **Example**
/// ```dart
/// final manager = CacheManager(store, DefaultCacheKeyStrategy(), SimpleTimeToLiveCachePolicy());
/// final cached = await manager.tryRead('GET', url, query);
/// if (cached == null) { /* perform network, then tryWrite */ }
/// ```
///
// ────────────────────────────────────────────────
class CacheManager {
  CacheManager(this.storage, this.keyStrategy, this.policy);

  /// **storage**
  ///
  /// Concrete storage backend (memory, disk, etc.).
  final CacheStore storage;

  /// **keyStrategy**
  ///
  /// Builds deterministic keys from request components.
  final CacheKeyStrategy keyStrategy;

  /// **policy**
  ///
  /// Governs read/write decisions and TTL.
  final CachePolicy policy;

  /// **tryRead**
  ///
  /// Attempt to return a cached raw string for a request when permitted by policy.
  ///
  /// **Parameters**
  /// - `method`: HTTP method.
  /// - `url`: Full request URL.
  /// - `query`: Query parameters.
  /// - `forceRefresh`: When true, bypass cache reads.
  /// - `headers`: Optional headers that some strategies may include in keys.
  ///
  /// **Returns**
  /// - `String?`: Raw cached payload or `null` when absent/expired/not allowed.
  ///
  // ────────────────────────────────────────────────
  Future<String?> tryRead(
    String method,
    String url,
    Map<String, dynamic>? query, {
    bool forceRefresh = false,
    Map<String, String>? headers,
  }) async {
    if (!policy.canRead(method, url, query, forceRefresh: forceRefresh)) return null;
    final key = keyStrategy.buildKey(url, query, method: method, headers: headers);
    return storage.get(key);
  }

  /// **tryWrite**
  ///
  /// Conditionally persist a response body string according to the policy.
  ///
  /// **Parameters**
  /// - `method`: HTTP method.
  /// - `url`: Full request URL.
  /// - `query`: Query parameters.
  /// - `statusCode`: Response status used for write gating.
  /// - `bodyString`: Raw string payload (typically `Response.bodyString`).
  /// - `headers`: Optional headers for key building.
  ///
  /// **Side Effects**
  /// - Writes to [storage] if permitted.
  ///
  // ────────────────────────────────────────────────
  Future<void> tryWrite(
    String method,
    String url,
    Map<String, dynamic>? query, {
    required int? statusCode,
    required String? bodyString,
    Map<String, String>? headers,
  }) async {
    if (!policy.canWrite(method, url, statusCode)) return;
    if (bodyString == null) return;
    final key = keyStrategy.buildKey(url, query, method: method, headers: headers);
    final ttl = policy.timeToLiveFor(method, url, statusCode);
    await storage.put(key, bodyString, ttl: ttl);
  }

  /// **invalidate**
  ///
  /// Remove a specific cache entry corresponding to a request.
  // ────────────────────────────────────────────────
  Future<void> invalidate(
    String method,
    String url,
    Map<String, dynamic>? query, {
    Map<String, String>? headers,
  }) async {
    final key = keyStrategy.buildKey(url, query, method: method, headers: headers);
    await storage.remove(key);
  }

  /// **clear**
  ///
  /// Remove all entries from the cache.
  // ────────────────────────────────────────────────
  Future<void> clear() => storage.clear();
}
