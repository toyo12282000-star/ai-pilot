import 'package:ai_pilot/features/favorite/domain/entities/favorite.dart';
import 'package:ai_pilot/features/profile/data/repositories/mock_profile_store.dart';
import 'package:ai_pilot/features/profile/domain/services/user_display_name_resolver.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_social_proof_seed_data.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_run_history.dart';

/// Mock の favorites / run histories を Social Proof と共有するストア。
class MockSocialProofDataStore {
  MockSocialProofDataStore({DateTime? seedNow}) {
    final now = seedNow ?? DateTime.now();
    favorites.addAll(mockInitialFavorites);
    favorites.addAll(buildMockSocialProofFavorites(now));
    runHistories.addAll(buildMockSocialProofRunHistories(now));
  }

  final List<Favorite> favorites = [];
  final List<WorkflowRunHistory> runHistories = [];
  int nextFavoriteId = 100;
  int nextRunHistoryId = 1000;
}

/// Mock Social Proof 表示名を解決する。
String resolveMockSocialProofDisplayName(String userId) {
  if (userId == mockCurrentUser.id) {
    final profile = MockProfileStore.instance.current;
    return UserDisplayNameResolver.resolve(
      profileDisplayName: profile.displayName,
      email: profile.email,
    );
  }
  return mockSocialProofDisplayNames[userId] ?? 'ユーザー';
}
