import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '/src/infrastructure/storage/app_storage_service.dart';
import '/src/modules/auth/data/models/user.dart';
import '/src/core/errors/app_exception.dart';
import '/src/infrastructure/storage/secure_token_storage.dart';
import '/src/config/api_config.dart';
import '/src/infrastructure/http/api_service.dart';


/// The `AuthService` class is responsible for handling all authentication-related
/// operations, such as signing in, signing out, and managing access and refresh tokens.
/// It interacts with the API to authenticate users and saves the tokens in memory for
/// session management. The class also provides methods to check whether the tokens are
/// expired and ensures the user session is maintained. It extends `ApiService` to
/// leverage HTTP request functionalities.
/// **AuthService**
///
/// Authentication service responsible for sign-in/up, token lifecycle
/// management (store/clear), and token expiry checks. Extends [ApiService]
/// to reuse hardened networking (401 refresh+retry, error mapping, logging).
///
/// Why
/// - Centralize auth HTTP calls and token persistence behind a single API.
/// - Keep controllers and views free of transport/storage concerns.
///
/// Key Features
/// - Validates sign-in response shape before saving tokens.
/// - Stores tokens via [AppStorageService] (secure storage facade).
/// - Provides access/refresh expiry checks using `jwt_decoder`.
///
/// Example
/// final ok = await authService.signIn('email', 'password');
/// if (ok) { /* proceed */ }
///
// ────────────────────────────────────────────────
class AuthService extends ApiService {
  // Handles user sign-in by sending credentials (email, password) to the API.
  // Stores the access and refresh tokens in MemoryService upon successful login.
  /// **signIn**
  ///
  /// Authenticate with credentials and persist access/refresh tokens.
  ///
  /// Parameters
  /// - `email`: User email/username required by the API.
  /// - `password`: User password.
  ///
  /// Returns
  /// - `bool`: `true` when tokens are received and saved.
  ///
  /// Errors
  /// - Throws [APIException] when the response body is malformed or any HTTP error occurs.
  ///
  /// Notes
  /// - Uses [getUnauthorizedHeader] because this endpoint should not send an Authorization header.
  ///
  // ────────────────────────────────────────────────
  Future<bool> signIn(String email, String password) async {
    final body = {"email": email, "password": password};
    final Response response = await post(
      APIConfiguration.signInUrl,
      headers: getUnauthorizedHeader(), // Uses header without authorization
      body,
    );

    final respBody = response.body;
    if (respBody is! Map || respBody['access'] is! String || respBody['refresh'] is! String) {
      throw APIException('Malformed sign-in response');
    }

    await AppStorageService.instance.setAccessToken(respBody['access'] as String);
    await AppStorageService.instance.setRefreshToken(respBody['refresh'] as String);
    return true;
  }

  // Handles user sign-up by user information to the API.
  // return true upon successful sign up.
  /// **signUp**
  ///
  /// Register a new user account.
  ///
  /// Parameters
  /// - `userModel`: Collected registration data.
  ///
  /// Returns
  /// - `bool`: `true` on HTTP success.
  ///
  /// Errors
  /// - Propagates typed exceptions from [ApiService] on HTTP errors.
  ///
  // ────────────────────────────────────────────────
  Future<bool> signUp(UserModel userModel) async {
    final body = userModel.toJson();
    await post(
      APIConfiguration.signUpUrl,
      headers: getUnauthorizedHeader(), // Uses header without authorization
      body,
    );
    return true;
  }

  // Handles user sign-out by clearing tokens and selected venue/zone from MemoryService.
  /// **signOut**
  ///
  /// Clear tokens from secure storage to terminate the session.
  ///
  /// Returns
  /// - `bool`: `true` when tokens are cleared.
  ///
  /// Side Effects
  /// - Removes access and refresh tokens via [AppStorageService].
  ///
  // ────────────────────────────────────────────────
  Future<bool> signOut() async {
    await AppStorageService.instance.clearTokens(); // Clear tokens securely via facade
    return true;
  }

  // Checks if the user is logged in by verifying if an access token is present in MemoryService.
  /// **isLoggedIn**
  ///
  /// Indicate whether an access token exists in secure storage cache.
  ///
  /// Returns
  /// - `bool`: `true` if an access token is present; otherwise `false`.
  ///
  /// Notes
  /// - Does not check expiry; pair with [isAccessTokenExpired] as needed.
  ///
  // ────────────────────────────────────────────────
  Future<bool> isLoggedIn() async {
    String? token = SecureTokenStorage.instance.readAccessTokenSync;
    return token != null; // Returns true if the token is not null
  }

  // Checks if the access token is expired by decoding and analyzing the token.
  // Throws an AppException if the token is null (no session).
  /// **isAccessTokenExpired**
  ///
  /// Check whether the access token is expired using `jwt_decoder`.
  ///
  /// Returns
  /// - `bool`: `true` when expired; `false` when still valid.
  ///
  /// Errors
  /// - Throws [AuthException] when there is no access token (no session).
  ///
  // ────────────────────────────────────────────────
  Future<bool> isAccessTokenExpired() async {
    String? token = SecureTokenStorage.instance.readAccessTokenSync;
    if (token == null) {
      throw AuthException('No Session'); // Throw exception if no token found
    }
    return JwtDecoder.isExpired(token); // Use JwtDecoder to check token expiration
  }

  // Checks if the refresh token is expired in a similar way to the access token.
  // Throws an AppException if the refresh token is null (no session).
  /// **isRefreshTokenExpired**
  ///
  /// Check whether the refresh token is expired using `jwt_decoder`.
  ///
  /// Returns
  /// - `bool`: `true` when expired; `false` when still valid.
  ///
  /// Errors
  /// - Throws [AppException] when there is no refresh token (no session).
  ///
  // ────────────────────────────────────────────────
  Future<bool> isRefreshTokenExpired() async {
    String? token = SecureTokenStorage.instance.readRefreshTokenSync;
    if (token == null) {
      throw AppException('No Session'); // Throw exception if no refresh token found
    }
    return JwtDecoder.isExpired(token); // Use JwtDecoder to check token expiration
  }
}
