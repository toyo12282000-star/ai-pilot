import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_pilot/features/workflow/presentation/providers/workflow_social_proof_providers.dart';
import 'helpers/workflow_detail_overrides.dart';

void main() {
  const favoriteWorkflowId = 'wf_sns';
  const runWorkflowId = 'wf_flutter_app';
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
    container.invalidate(workflowSocialProofCountsProvider(favoriteWorkflowId));
    final stats = await container.read(
      workflowSocialProofCountsProvider(favoriteWorkflowId).future,
    );
    return stats.favoriteCount;
  }

  Future<int> readStartedUserCount() async {
    container.invalidate(workflowSocialProofCountsProvider(runWorkflowId));
    final stats = await container.read(
      workflowSocialProofCountsProvider(runWorkflowId).future,
    );
    return stats.startedUserCount;
  }

  Future<int> readCompletedUserCount() async {
    container.invalidate(workflowSocialProofCountsProvider(runWorkflowId));
    final stats = await container.read(
      workflowSocialProofCountsProvider(runWorkflowId).future,
    );
    return stats.completedUserCount;
  }

  test('favorite add/remove updates social proof favorite count', () async {
    final before = await readFavoriteCount();

    await fixtures.favoriteRepository.addFavorite(userId, favoriteWorkflowId);
    invalidateWorkflowSocialProofForContainer(container, favoriteWorkflowId);

    final afterAdd = await readFavoriteCount();
    expect(afterAdd, before + 1);

    await fixtures.favoriteRepository.removeFavorite(userId, favoriteWorkflowId);
    invalidateWorkflowSocialProofForContainer(container, favoriteWorkflowId);

    final afterRemove = await readFavoriteCount();
    expect(afterRemove, before);
  });

  test('run start/complete updates social proof user counts', () async {
    final startedBefore = await readStartedUserCount();
    final completedBefore = await readCompletedUserCount();

    await fixtures.runHistoryRepository.startWorkflow(userId, runWorkflowId);
    invalidateWorkflowSocialProofForContainer(container, runWorkflowId);

    final startedAfterStart = await readStartedUserCount();
    expect(startedAfterStart, startedBefore + 1);

    await fixtures.runHistoryRepository.completeWorkflow(userId, runWorkflowId);
    invalidateWorkflowSocialProofForContainer(container, runWorkflowId);

    final completedAfterComplete = await readCompletedUserCount();
    expect(completedAfterComplete, completedBefore + 1);

    container.invalidate(workflowRecentCreationsProvider(runWorkflowId));
    final creations = await container.read(
      workflowRecentCreationsProvider(runWorkflowId).future,
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
