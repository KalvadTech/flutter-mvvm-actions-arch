import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// A singleton service to manage local storage using GetStorage.
class MemoryService extends GetConnect {
  // Singleton instance of MemoryService.
  static final MemoryService _mInstance = MemoryService._();

  // Provides global access to the singleton instance.
  static MemoryService get instance => _mInstance;

  // Instance of GetStorage to handle key-value storage.
  late GetStorage _storage;

  // Private constructor to implement the singleton pattern.
  MemoryService._() {
    // Initialize the storage with a specific app name (replace 'appName').
    _storage = GetStorage('appName-app');
  }

  /// Initializes the storage. Call this method at the start of the app.
  Future<void> initialize() async {
    // Initialize GetStorage with the same app name (replace 'appName').
    await GetStorage.init('appName-app');
  }

  /// Gets the theme mode from local storage.
  String? get themeMode => _storage.read("themeMode");

  /// Sets the theme mode in local storage.
  set themeMode(String? value) => _storage.write("themeMode", value);

  /// Gets the language code from local storage.
  String? get languageCode => _storage.read("languageCode");

  /// Sets the language code in local storage.
  set languageCode(String? value) => _storage.write("languageCode", value);

  /// Gets the user ID from local storage.
  String? get userId => _storage.read("userId");

  /// Sets the user ID in local storage.
  set userId(String? value) => _storage.write("userId", value);

  /// Gets the access token from local storage.
  String? get accessToken => _storage.read("accessToken");

  /// Sets the access token in local storage.
  set accessToken(String? value) => _storage.write("accessToken", value);

  /// Gets the refresh token from local storage.
  String? get refreshToken => _storage.read("refreshToken");

  /// Sets the refresh token in local storage.
  set refreshToken(String? value) => _storage.write("refreshToken", value);
}
