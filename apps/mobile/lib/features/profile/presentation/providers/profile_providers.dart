import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/features/profile/domain/services/user_display_name_resolver.dart';
import 'package:ai_pilot/features/profile/data/repositories/supabase_user_profile_repository.dart';
import 'package:ai_pilot/features/auth/presentation/providers/auth_providers.dart';
import 'package:ai_pilot/features/profile/domain/entities/user_profile.dart';
import 'package:ai_pilot/features/profile/domain/repositories/user_profile_repository.dart';

// ---------------------------------------------------------------------------
// Repository Provider
// ---------------------------------------------------------------------------

/// [UserProfileRepository] を提供する（Supabase 実装）。
final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return SupabaseUserProfileRepository();
});

// ---------------------------------------------------------------------------
// AsyncValue Providers（UI 向け）
// ---------------------------------------------------------------------------

/// 現在ログイン中のユーザープロフィール。
final currentUserProfileProvider = FutureProvider<UserProfile?>((ref) {
  return ref.watch(userProfileRepositoryProvider).fetchCurrentUserProfile();
});

/// 解決済みの現在ユーザー表示名（フォールバックルール統一）。
final resolvedCurrentUserDisplayNameProvider = Provider<String>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return UserDisplayNameResolver.defaultName;
  }

  final profile = ref.watch(currentUserProfileProvider).valueOrNull;

  return UserDisplayNameResolver.resolve(
    profileDisplayName: profile?.displayName,
    userMetadata: user.userMetadata,
    email: user.email ?? profile?.email,
  );
});

/// 表示名更新後にプロフィールを再取得する。
Future<UserProfile> updateCurrentUserDisplayName(
  WidgetRef ref,
  String displayName,
) async {
  final profile =
      await ref.read(userProfileRepositoryProvider).updateDisplayName(displayName);
  ref.invalidate(currentUserProfileProvider);
  return profile;
}
