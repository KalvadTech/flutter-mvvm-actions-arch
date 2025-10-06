import 'package:flutter/material.dart';
import '/src/infrastructure/storage/app_storage_service.dart';
import '/src/utils/route_manager.dart';
import 'app.dart';
import '/src/modules/connections/connection_bindings.dart';
import '/src/infrastructure/cache/cache_manager.dart';
import 'infrastructure/cache/contracts/cache_store.dart';
import 'infrastructure/cache/contracts/cache_key_strategy.dart';
import '/src/infrastructure/cache/default_cache_key_strategy.dart';
import 'infrastructure/cache/contracts/cache_policy.dart';
import '/src/infrastructure/cache/simple_ttl_cache_policy.dart';
import '/src/infrastructure/cache/get_storage_cache_store.dart';
import '/src/infrastructure/http/api_service.dart';

Future<void> main() async {
  RouteManager.instance.initialize();
  await AppStorageService.instance.initialize();
  // Ensure connectivity VM is available before building the app/overlay.
  ConnectionBindings().dependencies();
  // 1) Create a CacheStore backed by GetStorage (async factory ensures init)
  final CacheStore store = await GetStorageCacheStorage.create(
    container: AppStorageService.container, // aligned with preferences container
  );

  // 2) Choose key strategy and policy (defaults: cache GET only, 2xx, fixed TTL)
  const keyStrategy = DefaultCacheKeyStrategy();
  final policy = SimpleTimeToLiveCachePolicy(
    timeToLive: const Duration(hours: 6), // adjust TTL to your needs
    // cacheGetRequestsOnly: true, // default
  );

  // 3) Compose the manager and register it globally with ApiService
  final cacheManager = CacheManager(store, keyStrategy, policy);
  ApiService.configureCache(cacheManager);

  runApp(const App());
}


