import 'package:get_storage/get_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// **MemoryService**
///
/// Persistent key–value storage for app preferences and session metadata.
/// Wraps `GetStorage` for lightweight preferences and `FlutterSecureStorage`
/// (Keychain/Keystore) for sensitive tokens.
///
/// **Why**
/// - Centralize reading/writing of frequently used keys (theme, language, user id, tokens).
/// - Provide a single initialization path and consistent container name.
///
/// **Key Features**
/// - Singleton access via [instance].
/// - Async initialization of the underlying GetStorage container.
/// - Simple getters and fire-and-forget setters for preferences and tokens.
/// - Helpers to clear tokens or the entire storage, and to listen to key changes.
///
/// **Notes**
/// - Security: `GetStorage` is plaintext. Consider migrating tokens to a secure
///   storage (Keychain/Keystore) for production apps in the future.
///
/// **Example**
/// ```dart
/// await MemoryService.instance.initialize();
/// MemoryService.instance.languageCode = 'en';
/// ```
///
// ────────────────────────────────────────────────
@Deprecated('Use AppStorageService for preferences and tokens. Will be removed in a future release.')
class MemoryService {
  MemoryService._internal();

  // Singleton instance of MemoryService.
  static final MemoryService _mInstance = MemoryService._internal();

  // Provides global access to the singleton instance.
  static MemoryService get instance => _mInstance;

  // Centralized container name to keep consistency across the app and cache store.
  static const String storageContainer = 'appName-app';

  // Keys (single source of truth)
  static const String _kThemeMode = 'themeMode';
  static const String _kLanguageCode = 'languageCode';
  static const String _kUserId = 'userId';
  static const String _kAccessToken = 'accessToken';
  static const String _kRefreshToken = 'refreshToken';

  // Instance of GetStorage to handle key-value storage.
  late GetStorage _storage;

  /// Secure storage for sensitive tokens (Keychain/Keystore-backed).
  late final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // In-memory caches for sync getters
  String? _accessTokenCache;
  String? _refreshTokenCache;

  /// **initialize**
  ///
  /// Initializes the storage container. Call this at the start of the app.
  ///
  /// **Side Effects**
  /// - Opens/creates the GetStorage box named [storageContainer].
  // ────────────────────────────────────────────────
  Future<void> initialize() async {
    await GetStorage.init(storageContainer);
    _storage = GetStorage(storageContainer);

    // If this is a new project that never stored tokens in GetStorage,
    // you can safely remove the migration call below.
    await _migrateLegacyTokensToSecureStorage();
  }

  /// **_migrateLegacyTokensToSecureStorage**
  ///
  /// Migrate tokens from legacy GetStorage to platform secure storage (Keychain/Keystore)
  /// when secure storage does not already contain values. Safe to remove in new projects
  /// that never stored tokens in GetStorage.
  ///
  /// **Side Effects**
  /// - Reads from legacy GetStorage keys and writes to secure storage when needed.
  /// - Updates in-memory caches for access and refresh tokens.
  ///
  /// **Notes**
  /// - If secure storage access fails, falls back to legacy values in memory.
  // ────────────────────────────────────────────────
  Future<void> _migrateLegacyTokensToSecureStorage() async {
    // Migrate tokens from legacy GetStorage to secure storage if needed.
    try {
      final secureAccess = await _secureStorage.read(key: _kAccessToken);
      final secureRefresh = await _secureStorage.read(key: _kRefreshToken);

      String? legacyAccess = _storage.read<String>(_kAccessToken);
      String? legacyRefresh = _storage.read<String>(_kRefreshToken);

      // If secure storage is empty but legacy has values, migrate them.
      if ((secureAccess == null || secureAccess.isEmpty) && legacyAccess != null && legacyAccess.isNotEmpty) {
        await _secureStorage.write(key: _kAccessToken, value: legacyAccess);
        await _storage.remove(_kAccessToken);
        _accessTokenCache = legacyAccess;
      } else {
        _accessTokenCache = secureAccess;
      }

      if ((secureRefresh == null || secureRefresh.isEmpty) && legacyRefresh != null && legacyRefresh.isNotEmpty) {
        await _secureStorage.write(key: _kRefreshToken, value: legacyRefresh);
        await _storage.remove(_kRefreshToken);
        _refreshTokenCache = legacyRefresh;
      } else {
        _refreshTokenCache = secureRefresh;
      }
    } catch (_) {
      // If secure storage is unavailable, fall back to legacy values in memory
      _accessTokenCache = _storage.read<String>(_kAccessToken);
      _refreshTokenCache = _storage.read<String>(_kRefreshToken);
    }
  }

  // ---------- Theme Mode ----------

  /// **themeMode**
  ///
  /// Gets the theme mode from local storage.
  String? get themeMode => _storage.read(_kThemeMode);

  /// **themeMode**
  ///
  /// Sets the theme mode in local storage (fire-and-forget write).
  set themeMode(String? value) {
    _storage.write(_kThemeMode, value);
  }

  // ---------- Language Code ----------

  /// **languageCode**
  ///
  /// Gets the language code from local storage.
  String? get languageCode => _storage.read(_kLanguageCode);

  /// **languageCode**
  ///
  /// Sets the language code in local storage (fire-and-forget write).
  set languageCode(String? value) {
    _storage.write(_kLanguageCode, value);
  }

  // ---------- User ID ----------

  /// **userId**
  ///
  /// Gets the user ID from local storage.
  String? get userId => _storage.read(_kUserId);

  /// **userId**
  ///
  /// Sets the user ID in local storage (fire-and-forget write).
  set userId(String? value) {
    _storage.write(_kUserId, value);
  }

  // ---------- Tokens (secure storage) ----------

  /// **accessToken**
  ///
  /// Returns the cached access token loaded during [initialize].
  /// Backed by secure storage; synchronous for call sites.
  String? get accessToken => _accessTokenCache;

  /// **accessToken**
  ///
  /// Updates the access token. Writes to secure storage (fire-and-forget)
  /// and updates the in-memory cache. Passing `null` deletes the key.
  set accessToken(String? value) {
    _accessTokenCache = value;
    if (value == null || value.isEmpty) {
      _secureStorage.delete(key: _kAccessToken);
      // Also remove any legacy persisted value
      _storage.remove(_kAccessToken);
    } else {
      _secureStorage.write(key: _kAccessToken, value: value);
    }
  }

  /// **refreshToken**
  ///
  /// Returns the cached refresh token loaded during [initialize].
  /// Backed by secure storage; synchronous for call sites.
  String? get refreshToken => _refreshTokenCache;

  /// **refreshToken**
  ///
  /// Updates the refresh token. Writes to secure storage (fire-and-forget)
  /// and updates the in-memory cache. Passing `null` deletes the key.
  set refreshToken(String? value) {
    _refreshTokenCache = value;
    if (value == null || value.isEmpty) {
      _secureStorage.delete(key: _kRefreshToken);
      _storage.remove(_kRefreshToken);
    } else {
      _secureStorage.write(key: _kRefreshToken, value: value);
    }
  }

  /// **clearTokens**
  ///
  /// Remove access and refresh tokens from storage.
  // ────────────────────────────────────────────────
  Future<void> clearTokens() async {
    _accessTokenCache = null;
    _refreshTokenCache = null;
    // Remove from secure storage and legacy storage
    await _secureStorage.delete(key: _kAccessToken);
    await _secureStorage.delete(key: _kRefreshToken);
    await _storage.remove(_kAccessToken);
    await _storage.remove(_kRefreshToken);
  }

  /// **remove**
  ///
  /// Remove a single entry by key.
  // ────────────────────────────────────────────────
  Future<void> remove(String key) => _storage.remove(key);

  /// **clearAll**
  ///
  /// Clear all keys in this container.
  // ────────────────────────────────────────────────
  Future<void> clearAll() => _storage.erase();

  /// **listenKey**
  ///
  /// Listen for changes to a specific key. Returns a cancel function.
  // ────────────────────────────────────────────────
  void Function() listenKey(String key, void Function(dynamic) onChange) {
    return _storage.listenKey(key, onChange);
  }
}
