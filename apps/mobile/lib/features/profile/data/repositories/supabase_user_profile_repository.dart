import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ai_pilot/features/profile/data/dto/user_profile_dto.dart';
import 'package:ai_pilot/features/profile/domain/entities/user_profile.dart';
import 'package:ai_pilot/features/profile/domain/repositories/user_profile_repository.dart';

/// [UserProfileRepository] の Supabase 実装。
class SupabaseUserProfileRepository implements UserProfileRepository {
  SupabaseUserProfileRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<UserProfile?> fetchCurrentUserProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      return null;
    }

    return fetchUserProfileById(user.id);
  }

  @override
  Future<UserProfile?> fetchUserProfileById(String userId) async {
    final response =
        await _client.from('profiles').select().eq('id', userId).maybeSingle();

    if (response == null) {
      return null;
    }

    final authUser = _client.auth.currentUser;
    final email = authUser?.id == userId ? authUser?.email : null;

    return UserProfileDto.fromJson(response).toEntity(email: email);
  }
}
