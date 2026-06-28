import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/features/profile/data/repositories/supabase_user_profile_repository.dart';
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
