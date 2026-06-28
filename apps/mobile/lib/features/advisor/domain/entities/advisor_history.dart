/// Advisor の相談履歴 1 件。
class AdvisorHistory {
  AdvisorHistory({
    required this.id,
    required this.userId,
    required this.query,
    required this.suggestedWorkflowIds,
    required this.createdAt,
  });

  /// 一意識別子。
  final String id;

  /// 相談したユーザー ID。
  final String userId;

  /// 入力した相談内容。
  final String query;

  /// 提案された Workflow ID 一覧。
  final List<String> suggestedWorkflowIds;

  /// 保存日時。
  final DateTime createdAt;

  AdvisorHistory copyWith({
    String? id,
    String? userId,
    String? query,
    List<String>? suggestedWorkflowIds,
    DateTime? createdAt,
  }) {
    return AdvisorHistory(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      query: query ?? this.query,
      suggestedWorkflowIds: suggestedWorkflowIds ?? this.suggestedWorkflowIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
