import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/features/favorite/presentation/providers/favorite_providers.dart';
import 'package:ai_pilot/features/home/domain/entities/recent_workflow_activity.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_run_history_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_social_proof_providers.dart';
import 'package:ai_pilot/shared/providers/authenticated_user_provider.dart';

/// Home「最近使った」の activity 一覧（ログイン時のみ）。
final recentHomeWorkflowActivitiesProvider =
    FutureProvider<List<RecentWorkflowActivity>>((ref) {
  if (!ref.watch(isAuthenticatedProvider)) {
    return Future.value(const []);
  }

  final userId = ref.watch(authenticatedUserIdProvider)!;
  return ref
      .watch(workflowRunHistoryRepositoryProvider)
      .fetchRecentActivities(userId, limit: 6);
});

/// Home「最近使った」の Workflow 一覧。
final recentHomeWorkflowsProvider = FutureProvider<List<Workflow>>((ref) async {
  if (!ref.watch(isAuthenticatedProvider)) {
    return const [];
  }

  final activities =
      await ref.watch(recentHomeWorkflowActivitiesProvider.future);
  if (activities.isEmpty) {
    return const [];
  }

  final workflows = await ref.watch(workflowsProvider.future);
  final workflowsById = {for (final workflow in workflows) workflow.id: workflow};

  return activities
      .map((activity) => workflowsById[activity.workflowId])
      .whereType<Workflow>()
      .toList();
});

/// Home「お気に入り」の Workflow 一覧（既存 provider のエイリアス）。
final favoriteHomeWorkflowsProvider = favoriteWorkflowsProvider;

/// Home「すべてのWorkflow」向け人気順一覧（Social Proof スコア降順）。
final popularHomeWorkflowsProvider = FutureProvider<List<Workflow>>((ref) async {
  final workflows = await ref.watch(workflowsProvider.future);
  if (workflows.isEmpty) {
    return workflows;
  }

  final socialProofRepository = ref.watch(workflowSocialProofRepositoryProvider);
  final scored = await Future.wait(
    workflows.map((workflow) async {
      final stats = await socialProofRepository.fetchStats(workflow.id);
      return (
        workflow: workflow,
        score: stats.favoriteCount + stats.startedUserCount,
      );
    }),
  );

  scored.sort((a, b) {
    final scoreCompare = b.score.compareTo(a.score);
    if (scoreCompare != 0) {
      return scoreCompare;
    }
    return a.workflow.title.compareTo(b.workflow.title);
  });

  return scored.map((entry) => entry.workflow).toList();
});

/// Home ダッシュボード関連 Provider を再取得する。
void invalidateHomeDashboard(WidgetRef ref) {
  invalidateHomeRecentWorkflows(ref);
  invalidateFavorites(ref);
  invalidateHomePopularWorkflows(ref);
}

/// Home「最近使った」を再取得する。
void invalidateHomeRecentWorkflows(WidgetRef ref) {
  ref.invalidate(recentHomeWorkflowActivitiesProvider);
  ref.invalidate(recentHomeWorkflowsProvider);
}

/// Home 人気順一覧を再取得する。
void invalidateHomePopularWorkflows(WidgetRef ref) {
  ref.invalidate(popularHomeWorkflowsProvider);
}
