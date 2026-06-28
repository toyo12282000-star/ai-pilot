import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/features/auth/presentation/providers/auth_providers.dart';

/// Supabase Auth でログイン中のユーザー ID。未ログイン（ゲスト含む）は null。
final authenticatedUserIdProvider = Provider<String?>((ref) {
  ref.watch(authStateProvider);
  return ref.watch(currentUserProvider)?.id;
});

/// 認証済みかどうか（ゲストモードは false）。
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authenticatedUserIdProvider) != null;
});
