import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_pilot/features/workflow/presentation/providers/workflow_social_proof_providers.dart';
import 'helpers/workflow_detail_overrides.dart';

void main() {
  const workflowId = 'wf_research';
  const userId = 'user-1';
  final seedNow = DateTime(2026, 6, 28, 12);

  late MockWorkflowTestFixtures fixtures;
  late ProviderContainer container;

  setUp(() {
    fixtures = MockWorkflowTestFixtures(seedNow: seedNow);
    container = ProviderContainer(
      overrides: fixtures.repositoryOverrides,
    );
  });

  tearDown(() {
    container.dispose();
  });

  Future<int> readFavoriteCount() async {
    container.invalidate(workflowSocialProofCountsProvider(workflowId));
    final stats = await container.read(
      workflowSocialProofCountsProvider(workflowId).future,
    );
    return stats.favoriteCount;
  }

  Future<int> readStartedUserCount() async {
    container.invalidate(workflowSocialProofCountsProvider(workflowId));
    final stats = await container.read(
      workflowSocialProofCountsProvider(workflowId).future,
    );
    return stats.startedUserCount;
  }

  Future<int> readCompletedUserCount() async {
    container.invalidate(workflowSocialProofCountsProvider(workflowId));
    final stats = await container.read(
      workflowSocialProofCountsProvider(workflowId).future,
    );
    return stats.completedUserCount;
  }

  test('favorite add/remove updates social proof favorite count', () async {
    final before = await readFavoriteCount();

    await fixtures.favoriteRepository.addFavorite(userId, workflowId);
    invalidateWorkflowSocialProofForContainer(container, workflowId);

    final afterAdd = await readFavoriteCount();
    expect(afterAdd, before + 1);

    await fixtures.favoriteRepository.removeFavorite(userId, workflowId);
    invalidateWorkflowSocialProofForContainer(container, workflowId);

    final afterRemove = await readFavoriteCount();
    expect(afterRemove, before);
  });

  test('run start/complete updates social proof user counts', () async {
    final startedBefore = await readStartedUserCount();
    final completedBefore = await readCompletedUserCount();

    await fixtures.runHistoryRepository.startWorkflow(userId, workflowId);
    invalidateWorkflowSocialProofForContainer(container, workflowId);

    final startedAfterStart = await readStartedUserCount();
    expect(startedAfterStart, startedBefore + 1);

    await fixtures.runHistoryRepository.completeWorkflow(userId, workflowId);
    invalidateWorkflowSocialProofForContainer(container, workflowId);

    final completedAfterComplete = await readCompletedUserCount();
    expect(completedAfterComplete, completedBefore + 1);

    container.invalidate(workflowRecentCreationsProvider(workflowId));
    final creations = await container.read(
      workflowRecentCreationsProvider(workflowId).future,
    );
    expect(
      creations.any((creation) => creation.userId == userId),
      isTrue,
    );
  });
}

/// ProviderContainer 向け Social Proof invalidate ヘルパー。
void invalidateWorkflowSocialProofForContainer(
  ProviderContainer container,
  String workflowId,
) {
  container.invalidate(workflowSocialProofCountsProvider(workflowId));
  container.invalidate(workflowRecentCreationsProvider(workflowId));
  container.invalidate(workflowProductStatsProvider(workflowId));
}
