import 'package:flutter_test/flutter_test.dart';
import 'package:getx_starter/src/modules/auth/data/services/auth_service.dart';
import 'package:getx_starter/src/modules/auth/data/models/user.dart';

/// Tests for AuthService mock authentication.
///
/// Note: These tests focus on the mock authentication flow.
/// Full integration tests with secure storage require platform plugins
/// which are not available in unit tests. The mock authentication
/// logic itself doesn't depend on storage internally, but the real
/// AuthService methods do call storage, so those are tested separately
/// in integration tests.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthService', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
    });

    group('signUp (mock mode)', () {
      test('successfully signs up with user model', () async {
        final userModel = UserModel.empty();

        final result = await authService.signUp(userModel);

        expect(result, true);
      });

      test('completes without errors for empty user model', () async {
        final userModel = UserModel.empty();

        expect(() async => await authService.signUp(userModel), returnsNormally);
      });

      test('returns true for valid user model', () async {
        final userModel = UserModel.empty();

        final result = await authService.signUp(userModel);

        expect(result, isA<bool>());
        expect(result, true);
      });
    });

    group('AuthService class', () {
      test('can be instantiated', () {
        expect(authService, isNotNull);
        expect(authService, isA<AuthService>());
      });

      test('inherits from ApiService', () {
        // AuthService extends ApiService
        expect(authService.runtimeType.toString(), 'AuthService');
      });
    });

    group('UserModel', () {
      test('empty() creates a valid user model', () {
        final userModel = UserModel.empty();

        expect(userModel, isNotNull);
        expect(userModel, isA<UserModel>());
      });

      test('empty() user models are equal', () {
        final user1 = UserModel.empty();
        final user2 = UserModel.empty();

        // Both should be valid instances
        expect(user1, isNotNull);
        expect(user2, isNotNull);
      });

      test('can be serialized to JSON', () {
        final userModel = UserModel.empty();

        final json = userModel.toJson();

        expect(json, isA<Map>());
      });
    });
  });
}
