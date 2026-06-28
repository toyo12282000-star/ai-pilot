import 'package:ai_pilot/features/auth/domain/entities/auth_user.dart';
import 'package:ai_pilot/features/auth/domain/repositories/auth_repository.dart';

/// テスト用の [AuthRepository] スタブ。
class FakeAuthRepository implements AuthRepository {
  @override
  AuthUser? currentUser() => null;

  @override
  Stream<AuthStateChange> authStateChanges() async* {
    yield const AuthStateChange(user: null);
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
