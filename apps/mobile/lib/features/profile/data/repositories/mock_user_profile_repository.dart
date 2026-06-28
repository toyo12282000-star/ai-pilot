import 'package:ai_pilot/features/profile/domain/entities/user_profile.dart';
import 'package:ai_pilot/features/profile/domain/repositories/user_profile_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';

/// [UserProfileRepository] の Mock 実装。
///
/// 固定の Mock ユーザーを返す。UI 開発用。
class MockUserProfileRepository implements UserProfileRepository {
  @override
  Future<UserProfile?> fetchCurrentUserProfile() async {
    await Future<void>.delayed(mockNetworkDelay);
    return mockCurrentUser;
  }

  @override
  Future<UserProfile?> fetchUserProfileById(String userId) async {
    await Future<void>.delayed(mockNetworkDelay);
    if (mockCurrentUser.id == userId) {
      return mockCurrentUser;
    }
    return null;
  }
}
