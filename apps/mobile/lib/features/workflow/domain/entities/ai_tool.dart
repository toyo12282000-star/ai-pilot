/// AIツールの種別。
///
/// [AITool] の分類に使用し、UIでのグルーピングや
/// ワークフローステップへのツール割り当て時の絞り込みに使う。
enum AIToolType {
  /// テキスト生成・対話型（ChatGPT, Claude 等）
  chat,

  /// 画像生成（Midjourney, DALL-E 等）
  image,

  /// コード生成・補完（GitHub Copilot 等）
  code,

  /// 音声・文字起こし
  audio,

  /// 上記に当てはまらないツール
  other,
}

/// 利用可能な AI ツールの定義。
///
/// ## 責務
/// - アプリ内で参照可能な AI ツールのメタ情報を表現する
/// - ワークフローステップやプロンプトテンプレートから参照される
///
/// ## 保持する値
/// - [id]: 一意識別子
/// - [name]: ツール名（例: ChatGPT, Claude）
/// - [description]: ツールの説明
/// - [url]: 公式サイトまたは起動 URL
/// - [type]: ツール種別
/// - [iconName]: アイコン識別子（UI 表示用）
///
/// ## 他 Entity との関係
/// - [WorkflowStep] から参照される（任意）
/// - [PromptTemplate] から推奨ツールとして参照される（任意）
class AITool {
  /// [id] をキーに [AITool] を生成する。
  AITool({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    this.url,
    this.iconName,
  });

  /// 一意識別子。
  final String id;

  /// ツール名。
  final String name;

  /// ツールの説明。
  final String? description;

  /// 公式サイトまたは起動 URL。
  final String? url;

  /// ツール種別。
  final AIToolType type;

  /// アイコン識別子（UI 表示用）。
  final String? iconName;

  /// 指定フィールドのみ差し替えた新しいインスタンスを返す。
  AITool copyWith({
    String? id,
    String? name,
    String? description,
    String? url,
    AIToolType? type,
    String? iconName,
  }) {
    return AITool(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      url: url ?? this.url,
      type: type ?? this.type,
      iconName: iconName ?? this.iconName,
    );
  }
}
