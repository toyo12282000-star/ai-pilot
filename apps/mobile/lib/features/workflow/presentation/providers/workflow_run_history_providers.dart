import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_run_history_repository.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_run_history.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/workflow_run_history_repository.dart';

/// 実行履歴取得用のパラメータ。
typedef WorkflowRunHistoryKey = ({String userId, String workflowId});

/// [WorkflowRunHistoryRepository] を提供する（Mock 実装）。
final workflowRunHistoryRepositoryProvider =
    Provider<WorkflowRunHistoryRepository>((ref) {
  return MockWorkflowRunHistoryRepository();
});

/// 指定ユーザーの最近の実行履歴一覧。
final recentWorkflowHistoriesProvider =
    FutureProvider.family<List<WorkflowRunHistory>, String>(
  (ref, userId) {
    return ref
        .watch(workflowRunHistoryRepositoryProvider)
        .fetchRecentHistories(userId);
  },
);

/// 指定 Workflow の実行履歴を 1 件取得する。
final workflowRunHistoryProvider =
    FutureProvider.family<WorkflowRunHistory?, WorkflowRunHistoryKey>(
  (ref, params) {
    return ref.watch(workflowRunHistoryRepositoryProvider).fetchHistoryByWorkflow(
          params.userId,
          params.workflowId,
        );
  },
);

/// 実行履歴関連 Provider を再取得する。
void invalidateWorkflowRunHistory(WidgetRef ref, String userId) {
  ref.invalidate(recentWorkflowHistoriesProvider(userId));
}

/// 指定 Workflow の実行履歴 Provider を再取得する。
void invalidateWorkflowRunHistoryForWorkflow(
  WidgetRef ref,
  String userId,
  String workflowId,
) {
  invalidateWorkflowRunHistory(ref, userId);
  ref.invalidate(
    workflowRunHistoryProvider((userId: userId, workflowId: workflowId)),
  );
}
