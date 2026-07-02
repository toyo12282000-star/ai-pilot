import 'package:ai_pilot/features/workflow/domain/entities/workflow_recent_creation.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_social_proof_counts.dart';

/// Workflow 詳細 Social Proof 用 Repository。
abstract interface class WorkflowSocialProofRepository {
  /// 保存数 / 使用者数などを取得する。
  Future<WorkflowSocialProofCounts> fetchStats(String workflowId);

  /// 最近作られた作品一覧（新しい順）。
  Future<List<WorkflowRecentCreation>> fetchRecentCreations(
    String workflowId, {
    int limit = 5,
  });
}
