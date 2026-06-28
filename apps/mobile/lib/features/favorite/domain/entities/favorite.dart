/// ユーザーがワークフローをお気に入り登録した記録。
///
/// ## 責務
/// - 特定ユーザーが特定ワークフローをお気に入りした事実を表現する
/// - お気に入り一覧の取得・追加・解除のドメイン単位となる
///
/// ## 保持する値
/// - [id]: 一意識別子
/// - [userId]: お気に入り登録した [UserProfile] の ID
/// - [workflowId]: お気に入り対象 [Workflow] の ID
/// - [createdAt]: お気に入り登録日時
///
/// ## 他 Entity との関係
/// - [UserProfile] に属する（N:1）
/// - [Workflow] を参照する（N:1）
/// - 同一 userId + workflowId の組み合わせは一意であるべき（ドメイン制約）
class Favorite {
  /// [id] をキーに [Favorite] を生成する。
  Favorite({
    required this.id,
    required this.userId,
    required this.workflowId,
    required this.createdAt,
  });

  /// 一意識別子。
  final String id;

  /// お気に入り登録した [UserProfile] の ID。
  final String userId;

  /// お気に入り対象 [Workflow] の ID。
  final String workflowId;

  /// お気に入り登録日時。
  final DateTime createdAt;

  /// 指定フィールドのみ差し替えた新しいインスタンスを返す。
  Favorite copyWith({
    String? id,
    String? userId,
    String? workflowId,
    DateTime? createdAt,
  }) {
    return Favorite(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      workflowId: workflowId ?? this.workflowId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
