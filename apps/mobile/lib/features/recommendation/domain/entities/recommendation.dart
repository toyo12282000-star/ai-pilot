/// AI おすすめ Workflow の目的カード。
///
/// ## 責務
/// - ユーザーの目的に応じた Workflow 群への導線を表現する
/// - ホーム画面の「何をしたいですか？」セクションで使用する
///
/// ## 保持する値
/// - [id]: 一意識別子
/// - [title]: 目的タイトル（例: YouTubeを始めたい）
/// - [description]: 目的の補足説明
/// - [recommendedWorkflowIds]: おすすめ [Workflow] の ID 一覧
/// - [icon]: アイコン識別子（UI 表示用）
/// - [color]: アクセントカラー（HEX 文字列）
/// - [priority]: 表示優先度（小さいほど先頭）
class Recommendation {
  /// [id] をキーに [Recommendation] を生成する。
  Recommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.recommendedWorkflowIds,
    required this.icon,
    required this.color,
    required this.priority,
  });

  /// 一意識別子。
  final String id;

  /// 目的タイトル。
  final String title;

  /// 目的の補足説明。
  final String description;

  /// おすすめ [Workflow] の ID 一覧。
  final List<String> recommendedWorkflowIds;

  /// アイコン識別子（UI 表示用）。
  final String icon;

  /// アクセントカラー（HEX 文字列、例: `#5B5CEB`）。
  final String color;

  /// 表示優先度（小さいほど先頭）。
  final int priority;

  /// 指定フィールドのみ差し替えた新しいインスタンスを返す。
  Recommendation copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? recommendedWorkflowIds,
    String? icon,
    String? color,
    int? priority,
  }) {
    return Recommendation(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      recommendedWorkflowIds:
          recommendedWorkflowIds ?? this.recommendedWorkflowIds,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      priority: priority ?? this.priority,
    );
  }
}
