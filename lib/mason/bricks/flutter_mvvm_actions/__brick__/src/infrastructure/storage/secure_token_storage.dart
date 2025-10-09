import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'contracts/token_storage.dart';

/// **SecureTokenStorage**
///
/// Singleton implementation of [TokenStorage] backed by platform secure
/// storage (Keychain on iOS, Android Keystore on Android).
///
/// **Why**
/// - Keep authentication tokens out of plaintext preferences.
/// - Provide synchronous reads via in-memory caches after initialization.
///
/// **Key Features**
/// - `initialize()` hydrates in-memory caches from secure storage.
/// - Synchronous getters for common hot paths (HTTP header building).
/// - Writes delete keys when a null/empty value is provided.
///
/// **Example**
/// ```dart
/// await SecureTokenStorage.instance.initialize();
/// await SecureTokenStorage.instance.writeAccessToken('jwt');
/// final token = SecureTokenStorage.instance.readAccessTokenSync;
/// ```
///
// ────────────────────────────────────────────────
class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage._internal([FlutterSecureStorage? secure])
      : _secure = secure ?? const FlutterSecureStorage();

  static final SecureTokenStorage _instance = SecureTokenStorage._internal();
  static SecureTokenStorage get instance => _instance;

  final FlutterSecureStorage _secure;

  static const String _kAccess = 'accessToken';
  static const String _kRefresh = 'refreshToken';

  String? _accessCache;
  String? _refreshCache;

  /// **initialize**
  ///
  /// Hydrate in-memory caches from secure storage.
  // ────────────────────────────────────────────────
  @override
  Future<void> initialize() async {
    _accessCache = await _secure.read(key: _kAccess);
    _refreshCache = await _secure.read(key: _kRefresh);
  }

  /// **readAccessTokenSync**
  // ────────────────────────────────────────────────
  @override
  String? get readAccessTokenSync => _accessCache;

  /// **readRefreshTokenSync**
  // ────────────────────────────────────────────────
  @override
  String? get readRefreshTokenSync => _refreshCache;

  /// **writeAccessToken**
  // ────────────────────────────────────────────────
  @override
  Future<void> writeAccessToken(String? value) async {
    _accessCache = value;
    if (value == null || value.isEmpty) {
      await _secure.delete(key: _kAccess);
    } else {
      await _secure.write(key: _kAccess, value: value);
    }
  }

  /// **writeRefreshToken**
  // ────────────────────────────────────────────────
  @override
  Future<void> writeRefreshToken(String? value) async {
    _refreshCache = value;
    if (value == null || value.isEmpty) {
      await _secure.delete(key: _kRefresh);
    } else {
      await _secure.write(key: _kRefresh, value: value);
    }
  }

  /// **clearTokens**
  // ────────────────────────────────────────────────
  @override
  Future<void> clearTokens() async {
    _accessCache = null;
    _refreshCache = null;
    await _secure.delete(key: _kAccess);
    await _secure.delete(key: _kRefresh);
  }
}