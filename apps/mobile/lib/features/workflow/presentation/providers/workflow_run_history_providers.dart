import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/features/workflow/data/repositories/supabase_workflow_run_history_repository.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_run_history.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/workflow_run_history_repository.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_social_proof_providers.dart';
import 'package:ai_pilot/shared/providers/authenticated_user_provider.dart';

/// [WorkflowRunHistoryRepository] を提供する（Supabase 実装）。
final workflowRunHistoryRepositoryProvider =
    Provider<WorkflowRunHistoryRepository>((ref) {
  return SupabaseWorkflowRunHistoryRepository();
});

/// 認証済みユーザーの最近の実行履歴一覧。ゲストは空リスト。
final recentWorkflowHistoriesProvider =
    FutureProvider<List<WorkflowRunHistory>>((ref) {
  final userId = ref.watch(authenticatedUserIdProvider);
  if (userId == null) {
    return Future.value(const []);
  }

  return ref
      .watch(workflowRunHistoryRepositoryProvider)
      .fetchRecentHistories(userId);
});

/// 指定 Workflow の実行履歴を 1 件取得する。ゲストは null。
final workflowRunHistoryProvider =
    FutureProvider.family<WorkflowRunHistory?, String>(
  (ref, workflowId) {
    final userId = ref.watch(authenticatedUserIdProvider);
    if (userId == null) {
      return Future.value(null);
    }

    return ref.watch(workflowRunHistoryRepositoryProvider).fetchHistoryByWorkflow(
          userId,
          workflowId,
        );
  },
);

/// 実行履歴関連 Provider を再取得する。
void invalidateWorkflowRunHistory(WidgetRef ref) {
  ref.invalidate(recentWorkflowHistoriesProvider);
}

/// 指定 Workflow の実行履歴 Provider を再取得する。
void invalidateWorkflowRunHistoryForWorkflow(
  WidgetRef ref,
  String workflowId,
) {
  invalidateWorkflowRunHistory(ref);
  ref.invalidate(workflowRunHistoryProvider(workflowId));
  invalidateWorkflowSocialProof(ref, workflowId);
}
