import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;

import 'package:ai_pilot/features/auth/domain/entities/auth_user.dart';
import 'package:ai_pilot/features/auth/domain/repositories/auth_repository.dart';

/// [AuthRepository] の Supabase 実装。
class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<void> signInWithGoogle() {
    return _client.auth.signInWithOAuth(OAuthProvider.google);
  }

  @override
  Future<void> signInWithApple() {
    return _client.auth.signInWithOAuth(OAuthProvider.apple);
  }

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _client.auth
        .signInWithPassword(email: email, password: password)
        .then((_) {});
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
  }) {
    return _client.auth
        .signUp(email: email, password: password)
        .then((_) {});
  }

  @override
  Future<void> signOut() {
    return _client.auth.signOut();
  }

  @override
  AuthUser? currentUser() {
    return _mapUser(_client.auth.currentUser);
  }

  @override
  Stream<AuthStateChange> authStateChanges() {
    return _client.auth.onAuthStateChange.map(
      (data) => AuthStateChange(user: _mapUser(data.session?.user)),
    );
  }

  AuthUser? _mapUser(User? user) {
    if (user == null) {
      return null;
    }
    return AuthUser(
      id: user.id,
      email: user.email,
      userMetadata: user.userMetadata,
    );
  }
}
