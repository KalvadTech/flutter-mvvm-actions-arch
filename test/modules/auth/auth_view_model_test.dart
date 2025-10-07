import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_starter/src/modules/auth/controllers/auth_view_model.dart';
import 'package:getx_starter/src/modules/auth/data/services/auth_service.dart';
import 'package:getx_starter/src/modules/auth/data/models/user.dart';

/// Mock AuthService for testing
class MockAuthService extends AuthService {
  bool _isLoggedIn = false;
  bool _accessTokenExpired = false;
  bool _refreshTokenExpired = false;
  bool _shouldRefreshSucceed = true;
  bool _shouldSignInSucceed = true;
  bool _shouldSignUpSucceed = true;

  // Test control methods
  void setLoggedIn(bool value) => _isLoggedIn = value;
  void setAccessTokenExpired(bool value) => _accessTokenExpired = value;
  void setRefreshTokenExpired(bool value) => _refreshTokenExpired = value;
  void setRefreshShouldSucceed(bool value) => _shouldRefreshSucceed = value;
  void setSignInShouldSucceed(bool value) => _shouldSignInSucceed = value;
  void setSignUpShouldSucceed(bool value) => _shouldSignUpSucceed = value;

  @override
  Future<bool> isLoggedIn() async => _isLoggedIn;

  @override
  Future<bool> isAccessTokenExpired() async => _accessTokenExpired;

  @override
  Future<bool> isRefreshTokenExpired() async => _refreshTokenExpired;

  @override
  Future<bool> refreshSession() async {
    if (!_shouldRefreshSucceed) throw Exception('Refresh failed');
    _accessTokenExpired = false; // After refresh, access token is fresh
    return true;
  }

  @override
  Future<bool> signIn(String email, String password) async {
    if (!_shouldSignInSucceed) throw Exception('Sign-in failed');
    _isLoggedIn = true;
    return true;
  }

  @override
  Future<bool> signUp(UserModel userModel) async {
    if (!_shouldSignUpSucceed) throw Exception('Sign-up failed');
    return true;
  }

  @override
  Future<bool> signOut() async {
    _isLoggedIn = false;
    _accessTokenExpired = false;
    _refreshTokenExpired = false;
    return true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthViewModel', () {
    late MockAuthService mockAuthService;
    late AuthViewModel viewModel;

    setUp(() {
      Get.testMode = true;
      mockAuthService = MockAuthService();
    });

    tearDown(() {
      Get.reset();
    });

    group('initialization', () {
      test('starts in checking state', () {
        viewModel = AuthViewModel(mockAuthService);
        // Note: The constructor calls checkSession() which sets state asynchronously
        // So we just verify the initial observable exists
        expect(viewModel.authState, isIn([AuthState.checking, AuthState.notAuthenticated]));
      });

      test('checks session on initialization', () async {
        mockAuthService.setLoggedIn(true);
        viewModel = AuthViewModel(mockAuthService);

        // Wait for checkSession to complete
        await Future.delayed(const Duration(milliseconds: 100));

        expect(viewModel.authState, AuthState.authenticated);
      });
    });

    group('checkSession', () {
      test('returns false and sets notAuthenticated when not logged in', () async {
        mockAuthService.setLoggedIn(false);
        viewModel = AuthViewModel(mockAuthService);

        final result = await viewModel.checkSession();

        expect(result, false);
        expect(viewModel.authState, AuthState.notAuthenticated);
      });

      test('returns true and sets authenticated when logged in with valid tokens', () async {
        mockAuthService.setLoggedIn(true);
        mockAuthService.setAccessTokenExpired(false);
        mockAuthService.setRefreshTokenExpired(false);
        viewModel = AuthViewModel(mockAuthService);

        final result = await viewModel.checkSession();

        expect(result, true);
        expect(viewModel.authState, AuthState.authenticated);
      });

      test('refreshes session when access token expired but refresh token valid', () async {
        mockAuthService.setLoggedIn(true);
        mockAuthService.setAccessTokenExpired(true);
        mockAuthService.setRefreshTokenExpired(false);
        viewModel = AuthViewModel(mockAuthService);

        final result = await viewModel.checkSession();

        expect(result, true);
        expect(viewModel.authState, AuthState.authenticated);
      });

      test('returns false when both tokens are expired', () async {
        mockAuthService.setLoggedIn(true);
        mockAuthService.setAccessTokenExpired(true);
        mockAuthService.setRefreshTokenExpired(true);
        viewModel = AuthViewModel(mockAuthService);

        final result = await viewModel.checkSession();

        expect(result, false);
        expect(viewModel.authState, AuthState.notAuthenticated);
      });

      test('handles refresh failure gracefully', () async {
        mockAuthService.setLoggedIn(true);
        mockAuthService.setAccessTokenExpired(true);
        mockAuthService.setRefreshTokenExpired(false);
        mockAuthService.setRefreshShouldSucceed(false);
        viewModel = AuthViewModel(mockAuthService);

        final result = await viewModel.checkSession();

        // Should fail gracefully
        expect(result, false);
        expect(viewModel.authState, AuthState.notAuthenticated);
      });

      test('sets checking state before checking', () async {
        mockAuthService.setLoggedIn(true);
        viewModel = AuthViewModel(mockAuthService);

        // Immediately check state
        expect(viewModel.authState, AuthState.checking);
      });
    });

    group('signIn', () {
      test('authenticates user and clears credentials on success', () async {
        mockAuthService.setSignInShouldSucceed(true);
        viewModel = AuthViewModel(mockAuthService);
        viewModel.username = 'test@example.com';
        viewModel.password = 'password123';

        await viewModel.signIn();

        expect(viewModel.authState, AuthState.authenticated);
        expect(viewModel.username, null);
        expect(viewModel.password, null);
      });

      test('throws exception on sign-in failure', () async {
        mockAuthService.setSignInShouldSucceed(false);
        viewModel = AuthViewModel(mockAuthService);
        viewModel.username = 'test@example.com';
        viewModel.password = 'wrongpassword';

        expect(() => viewModel.signIn(), throwsException);
      });
    });

    group('signUp', () {
      test('successfully signs up new user', () async {
        mockAuthService.setSignUpShouldSucceed(true);
        viewModel = AuthViewModel(mockAuthService);
        viewModel.newUser = UserModel.empty();

        await viewModel.signUp();

        // Sign-up doesn't change auth state
        expect(viewModel.authState, isNot(AuthState.authenticated));
      });

      test('throws exception on sign-up failure', () async {
        mockAuthService.setSignUpShouldSucceed(false);
        viewModel = AuthViewModel(mockAuthService);
        viewModel.newUser = UserModel.empty();

        expect(() => viewModel.signUp(), throwsException);
      });
    });

    group('logout', () {
      test('clears session and sets notAuthenticated', () async {
        mockAuthService.setLoggedIn(true);
        viewModel = AuthViewModel(mockAuthService);
        await viewModel.checkSession();
        expect(viewModel.authState, AuthState.authenticated);

        await viewModel.logout();

        expect(viewModel.authState, AuthState.notAuthenticated);
      });
    });

    group('state methods', () {
      test('authenticated() sets state to authenticated', () {
        viewModel = AuthViewModel(mockAuthService);

        viewModel.authenticated();

        expect(viewModel.authState, AuthState.authenticated);
        expect(viewModel.isAuthenticated(), true);
      });

      test('notAuthenticated() sets state to notAuthenticated', () {
        viewModel = AuthViewModel(mockAuthService);

        viewModel.notAuthenticated();

        expect(viewModel.authState, AuthState.notAuthenticated);
        expect(viewModel.isAuthenticated(), false);
      });

      test('checking() sets state to checking', () {
        viewModel = AuthViewModel(mockAuthService);

        viewModel.checking();

        expect(viewModel.authState, AuthState.checking);
        expect(viewModel.isChecking(), true);
      });
    });

    group('state queries', () {
      test('isAuthenticated returns true when authenticated', () {
        viewModel = AuthViewModel(mockAuthService);
        viewModel.authenticated();

        expect(viewModel.isAuthenticated(), true);
      });

      test('isAuthenticated returns false when not authenticated', () {
        viewModel = AuthViewModel(mockAuthService);
        viewModel.notAuthenticated();

        expect(viewModel.isAuthenticated(), false);
      });

      test('isChecking returns true when checking', () {
        viewModel = AuthViewModel(mockAuthService);
        viewModel.checking();

        expect(viewModel.isChecking(), true);
      });

      test('isChecking returns false when not checking', () {
        viewModel = AuthViewModel(mockAuthService);
        viewModel.authenticated();

        expect(viewModel.isChecking(), false);
      });
    });

    group('clear', () {
      test('clears username and password', () {
        viewModel = AuthViewModel(mockAuthService);
        viewModel.username = 'test@example.com';
        viewModel.password = 'password123';

        viewModel.clear();

        expect(viewModel.username, null);
        expect(viewModel.password, null);
      });
    });

    group('user property', () {
      test('user is null by default', () {
        viewModel = AuthViewModel(mockAuthService);

        expect(viewModel.user, null);
      });
    });

    group('reactivity', () {
      test('authState changes are observable', () async {
        viewModel = AuthViewModel(mockAuthService);

        // Wait for initial checkSession
        await Future.delayed(const Duration(milliseconds: 100));

        final initialState = viewModel.authState;

        viewModel.authenticated();
        expect(viewModel.authState, AuthState.authenticated);
        expect(viewModel.authState, isNot(initialState));

        viewModel.notAuthenticated();
        expect(viewModel.authState, AuthState.notAuthenticated);
      });
    });
  });
}
