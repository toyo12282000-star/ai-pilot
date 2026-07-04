import 'package:ai_pilot/features/auth/domain/entities/auth_user.dart';
import 'package:ai_pilot/features/auth/domain/repositories/auth_repository.dart';

/// ログイン済みユーザーを返すテスト用 [AuthRepository]。
class AuthenticatedFakeAuthRepository implements AuthRepository {
  AuthenticatedFakeAuthRepository({
    this.user = const AuthUser(
      id: 'user-1',
      email: 'demo@ai-pilot.app',
    ),
  });

  final AuthUser user;

  @override
  AuthUser? currentUser() => user;

  @override
  Stream<AuthStateChange> authStateChanges() async* {
    yield AuthStateChange(user: user);
  }

  @override
  Future<void> signInWithApple() async {}

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<void> signUp({
    required String email,
    required String password,
  }) async {}
}
