import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/features/auth/data/repositories/supabase_auth_repository.dart';
import 'package:ai_pilot/features/auth/domain/entities/auth_user.dart';
import 'package:ai_pilot/features/auth/domain/repositories/auth_repository.dart';
import 'package:ai_pilot/shared/providers/guest_mode_provider.dart';

/// [AuthRepository] を提供する。
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return SupabaseAuthRepository();
});

/// 現在ログイン中のユーザー。
final currentUserProvider = Provider<AuthUser?>((ref) {
  ref.watch(authStateProvider);
  return ref.watch(authRepositoryProvider).currentUser();
});

/// 認証状態の変更 Stream。
final authStateProvider = StreamProvider<AuthStateChange>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

/// アプリへのアクセス可否（ログイン済み or ゲスト）。
final canAccessAppProvider = Provider<bool>((ref) {
  if (ref.watch(guestModeProvider)) {
    return true;
  }
  return ref.watch(currentUserProvider) != null;
});

/// 認証状態の読み込み中かどうか。
final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isLoading;
});
