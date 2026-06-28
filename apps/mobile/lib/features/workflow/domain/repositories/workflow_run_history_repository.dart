import 'package:ai_pilot/features/workflow/domain/entities/workflow_run_history.dart';

/// ワークフロー実行履歴の取得・更新を担当する Repository インターフェース。
abstract class WorkflowRunHistoryRepository {
  /// 指定ユーザーの最近の実行履歴を取得する（新しい順）。
  Future<List<WorkflowRunHistory>> fetchRecentHistories(String userId);

  /// 指定 Workflow の実行履歴を 1 件取得する。
  ///
  /// 存在しない場合は null を返す。
  Future<WorkflowRunHistory?> fetchHistoryByWorkflow(
    String userId,
    String workflowId,
  );

  /// Workflow の実行を開始する。
  Future<WorkflowRunHistory> startWorkflow(String userId, String workflowId);

  /// 現在のステップ index を更新する。
  Future<void> updateProgress(
    String userId,
    String workflowId,
    int stepIndex,
  );

  /// Workflow の実行を完了として記録する。
  Future<void> completeWorkflow(String userId, String workflowId);
}
