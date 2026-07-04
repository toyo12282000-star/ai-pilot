import 'package:ai_pilot/features/profile/data/repositories/mock_profile_store.dart';
import 'package:ai_pilot/features/profile/domain/entities/user_profile.dart';
import 'package:ai_pilot/features/profile/domain/repositories/user_profile_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';

/// [UserProfileRepository] の Mock 実装。
///
/// 固定の Mock ユーザーを返す。UI 開発用。
class MockUserProfileRepository implements UserProfileRepository {
  MockProfileStore get _store => MockProfileStore.instance;

  @override
  Future<UserProfile?> fetchCurrentUserProfile() async {
    await Future<void>.delayed(mockNetworkDelay);
    return _store.current;
  }

  @override
  Future<UserProfile?> fetchUserProfileById(String userId) async {
    await Future<void>.delayed(mockNetworkDelay);
    if (_store.current.id == userId) {
      return _store.current;
    }
    return null;
  }

  @override
  Future<UserProfile> updateDisplayName(String displayName) async {
    await Future<void>.delayed(mockNetworkDelay);
    return _store.updateDisplayName(displayName);
  }
}
