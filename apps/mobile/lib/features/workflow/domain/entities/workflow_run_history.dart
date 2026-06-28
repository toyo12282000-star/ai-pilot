/// ワークフロー実行履歴。
///
/// ## 責務
/// - ユーザーが Workflow を開始・進行・完了した記録を表現する
/// - 再開・最近使った Workflow 表示のデータ源となる
///
/// ## 保持する値
/// - [id]: 一意識別子
/// - [userId]: 実行した [UserProfile] の ID
/// - [workflowId]: 対象 [Workflow] の ID
/// - [lastStepIndex]: 最後に到達したステップ index（0 始まり）
/// - [isCompleted]: 完了済みかどうか
/// - [startedAt]: 実行開始日時
/// - [completedAt]: 完了日時（未完了は null）
/// - [updatedAt]: 最終更新日時
class WorkflowRunHistory {
  /// [id] をキーに [WorkflowRunHistory] を生成する。
  WorkflowRunHistory({
    required this.id,
    required this.userId,
    required this.workflowId,
    required this.lastStepIndex,
    required this.isCompleted,
    required this.startedAt,
    this.completedAt,
    required this.updatedAt,
  });

  /// 一意識別子。
  final String id;

  /// 実行したユーザーの ID。
  final String userId;

  /// 対象 [Workflow] の ID。
  final String workflowId;

  /// 最後に到達したステップ index（0 始まり）。
  final int lastStepIndex;

  /// 完了済みかどうか。
  final bool isCompleted;

  /// 実行開始日時。
  final DateTime startedAt;

  /// 完了日時。未完了の場合は null。
  final DateTime? completedAt;

  /// 最終更新日時。
  final DateTime updatedAt;

  /// 指定フィールドのみ差し替えた新しいインスタンスを返す。
  WorkflowRunHistory copyWith({
    String? id,
    String? userId,
    String? workflowId,
    int? lastStepIndex,
    bool? isCompleted,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? updatedAt,
    bool clearCompletedAt = false,
  }) {
    return WorkflowRunHistory(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      workflowId: workflowId ?? this.workflowId,
      lastStepIndex: lastStepIndex ?? this.lastStepIndex,
      isCompleted: isCompleted ?? this.isCompleted,
      startedAt: startedAt ?? this.startedAt,
      completedAt:
          clearCompletedAt ? null : (completedAt ?? this.completedAt),
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
