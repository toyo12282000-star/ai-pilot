/// 再利用可能なプロンプトテンプレート。
///
/// ## 責務
/// - AI への入力文（プロンプト）の雛形を保持する
/// - 変数プレースホルダーを通じて、ステップごとに内容を差し替え可能にする
/// - 推奨 AI ツールのヒントを提供する
///
/// ## 保持する値
/// - [id]: 一意識別子
/// - [title]: テンプレート名
/// - [content]: プロンプト本文（`{{variable}}` 形式のプレースホルダーを含みうる）
/// - [description]: テンプレートの説明・使い方
/// - [recommendedAiToolId]: 推奨 [AITool] の ID
/// - [variableNames]: 差し替え可能な変数名一覧
/// - [tags]: 検索・分類用タグ
/// - [createdAt]: 作成日時
/// - [updatedAt]: 更新日時
///
/// ## 他 Entity との関係
/// - [WorkflowStep] から参照される（任意）
/// - [AITool] を推奨ツールとして参照する（任意、ID 参照）
class PromptTemplate {
  /// [id] をキーに [PromptTemplate] を生成する。
  PromptTemplate({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.recommendedAiToolId,
    List<String> variableNames = const [],
    List<String> tags = const [],
  })  : variableNames = List.unmodifiable(variableNames),
        tags = List.unmodifiable(tags);

  /// 一意識別子。
  final String id;

  /// テンプレート名。
  final String title;

  /// プロンプト本文。
  final String content;

  /// テンプレートの説明・使い方。
  final String? description;

  /// 推奨 [AITool] の ID。
  final String? recommendedAiToolId;

  /// 差し替え可能な変数名一覧。
  final List<String> variableNames;

  /// 検索・分類用タグ。
  final List<String> tags;

  /// 作成日時。
  final DateTime createdAt;

  /// 更新日時。
  final DateTime updatedAt;

  /// 指定フィールドのみ差し替えた新しいインスタンスを返す。
  PromptTemplate copyWith({
    String? id,
    String? title,
    String? content,
    String? description,
    String? recommendedAiToolId,
    List<String>? variableNames,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PromptTemplate(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      description: description ?? this.description,
      recommendedAiToolId: recommendedAiToolId ?? this.recommendedAiToolId,
      variableNames: variableNames ?? this.variableNames,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
