import '/src/infrastructure/storage/preferences_storage.dart';
import '/src/infrastructure/storage/secure_token_storage.dart';

/// **AppStorageService**
///
/// Facade that exposes both user preferences (GetStorage) and
/// authentication tokens (secure storage) from a single access point.
///
/// **Why**
/// - Give the application one storage entry point for common operations.
/// - Hide storage details (preferences vs. secure) behind a clear API.
///
/// **Key Features**
/// - Single `initialize()` to set up both storage backends.
/// - Synchronous token getters via secure storage in-memory caches.
/// - Preference getters/setters remain simple, synchronous.
///
/// **Example**
/// ```dart
/// await AppStorageService.instance.initialize();
/// AppStorageService.instance.languageCode = 'en';
/// await AppStorageService.instance.setAccessToken('jwt');
/// ```
///
// ────────────────────────────────────────────────
class AppStorageService {
  AppStorageService._internal();
  static final AppStorageService _instance = AppStorageService._internal();
  static AppStorageService get instance => _instance;

  /// **initialize**
  ///
  /// Initialize both preferences and secure token storage.
  ///
  /// **Side Effects**
  /// - Opens/creates GetStorage container and hydrates secure token caches.
  // ────────────────────────────────────────────────
  Future<void> initialize() async {
    await PreferencesStorage.instance.initialize();
    await SecureTokenStorage.instance.initialize();
  }

  // ---------- Container / namespacing ----------

  /// Central container name for preferences/caching stores.
  static String get container => PreferencesStorage.container;

  // ---------- Preferences (GetStorage-backed) ----------

  /// Current theme mode string (e.g., 'light' | 'dark' | 'system').
  String? get themeMode => PreferencesStorage.instance.themeMode;
  set themeMode(String? value) => PreferencesStorage.instance.themeMode = value;

  /// Current language code (e.g., 'en', 'ar').
  String? get languageCode => PreferencesStorage.instance.languageCode;
  set languageCode(String? value) => PreferencesStorage.instance.languageCode = value;

  /// Optional user identifier tied to the local session/profile.
  String? get userId => PreferencesStorage.instance.userId;
  set userId(String? value) => PreferencesStorage.instance.userId = value;

  /// Remove all preferences from the container (does not remove tokens).
  Future<void> clearAllPreferences() => PreferencesStorage.instance.clearAll();

  // ---------- Tokens (Secure storage-backed) ----------

  /// Synchronous access token (from secure storage cache hydrated on init).
  String? get accessToken => SecureTokenStorage.instance.readAccessTokenSync;

  /// Synchronous refresh token (from secure storage cache hydrated on init).
  String? get refreshToken => SecureTokenStorage.instance.readRefreshTokenSync;

  /// Persist/clear the access token in secure storage and update cache.
  Future<void> setAccessToken(String? value) =>
      SecureTokenStorage.instance.writeAccessToken(value);

  /// Persist/clear the refresh token in secure storage and update cache.
  Future<void> setRefreshToken(String? value) =>
      SecureTokenStorage.instance.writeRefreshToken(value);

  /// Remove both tokens from secure storage and caches.
  Future<void> clearTokens() => SecureTokenStorage.instance.clearTokens();
}
