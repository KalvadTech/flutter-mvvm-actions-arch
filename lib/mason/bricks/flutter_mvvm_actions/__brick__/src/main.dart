import 'package:flutter/material.dart';
import '/src/infrastructure/storage/app_storage_service.dart';
import 'core/routing/route_manager.dart';
import 'app.dart';
import 'modules/connections/connections_bindings.dart';
import 'modules/locale/data/services/localization_service.dart';
import 'infrastructure/cache/cache_manager.dart';
import 'infrastructure/cache/contracts/cache_store.dart';
import 'infrastructure/cache/default_cache_key_strategy.dart';
import 'infrastructure/cache/simple_ttl_cache_policy.dart';
import 'infrastructure/cache/get_storage_cache_store.dart';
import 'infrastructure/http/api_service.dart';
import 'modules/theme/theme.dart';

Future<void> main() async {
  RouteManager.instance.initialize();
  await AppStorageService.instance.initialize();

  // Initialize localization with saved preference
  LocalizationService.init();

  // Ensure connectivity VM is available before building the app/overlay.
  ConnectionsBindings().dependencies();
  ThemeBindings().dependencies();
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


