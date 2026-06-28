import 'package:ai_pilot/features/auth/domain/entities/auth_user.dart';

/// 認証処理を担当する Repository インターフェース。
abstract class AuthRepository {
  /// Google アカウントでサインインする。
  Future<void> signInWithGoogle();

  /// Apple アカウントでサインインする。
  Future<void> signInWithApple();

  /// メールアドレスでサインインする。
  Future<void> signInWithEmail({
    required String email,
    required String password,
  });

  /// メールアドレスで新規登録する。
  Future<void> signUp({
    required String email,
    required String password,
  });

  /// サインアウトする。
  Future<void> signOut();

  /// 現在ログイン中のユーザーを返す。
  AuthUser? currentUser();

  /// 認証状態の変更を監視する Stream。
  Stream<AuthStateChange> authStateChanges();
}
