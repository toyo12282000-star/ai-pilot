import 'package:ai_pilot/features/advisor/domain/entities/advisor_history.dart';

/// Advisor 相談履歴の取得・保存・削除を担当する Repository。
abstract class AdvisorHistoryRepository {
  /// 指定ユーザーの最近の相談履歴を取得する（新しい順、最大 10 件）。
  Future<List<AdvisorHistory>> fetchRecentHistories(String userId);

  /// 相談内容と提案 Workflow ID を保存する。
  Future<void> addHistory(
    String userId,
    String query,
    List<String> workflowIds,
  );

  /// 指定履歴を削除する。
  Future<void> deleteHistory(String userId, String historyId);
}
