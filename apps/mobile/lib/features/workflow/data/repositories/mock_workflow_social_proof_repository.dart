import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_social_proof_data_store.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_recent_creation.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_social_proof_counts.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/workflow_social_proof_repository.dart';

/// [WorkflowSocialProofRepository] の Mock 実装。
class MockWorkflowSocialProofRepository implements WorkflowSocialProofRepository {
  MockWorkflowSocialProofRepository([MockSocialProofDataStore? store])
      : _store = store ?? MockSocialProofDataStore();

  final MockSocialProofDataStore _store;

  @override
  Future<WorkflowSocialProofCounts> fetchStats(String workflowId) async {
    await Future<void>.delayed(mockNetworkDelay);

    final favoriteCount = _store.favorites
        .where((favorite) => favorite.workflowId == workflowId)
        .length;
    final histories = _store.runHistories
        .where((history) => history.workflowId == workflowId)
        .toList();
    final startedUserCount =
        histories.map((history) => history.userId).toSet().length;
    final completedUserCount = histories
        .where((history) => history.isCompleted)
        .map((history) => history.userId)
        .toSet()
        .length;

    return WorkflowSocialProofCounts(
      favoriteCount: favoriteCount,
      startedUserCount: startedUserCount,
      completedUserCount: completedUserCount,
    );
  }

  @override
  Future<List<WorkflowRecentCreation>> fetchRecentCreations(
    String workflowId, {
    int limit = 5,
  }) async {
    await Future<void>.delayed(mockNetworkDelay);

    final histories = _store.runHistories
        .where((history) => history.workflowId == workflowId)
        .toList()
      ..sort((a, b) {
        final aTime = a.completedAt ?? a.startedAt;
        final bTime = b.completedAt ?? b.startedAt;
        return bTime.compareTo(aTime);
      });

    return histories.take(limit).map((history) {
      final activityAt = history.completedAt ?? history.startedAt;
      return WorkflowRecentCreation(
        userId: history.userId,
        displayName: resolveMockSocialProofDisplayName(history.userId),
        activityAt: activityAt,
      );
    }).toList();
  }
}
