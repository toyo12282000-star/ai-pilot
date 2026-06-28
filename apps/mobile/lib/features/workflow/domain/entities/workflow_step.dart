/// ワークフロー内の 1 ステップ。
///
/// ## 責務
/// - ワークフロー実行時にユーザーが行う 1 つの作業単位を表現する
/// - 使用するプロンプトテンプレート・AI ツールをステップ単位で指定する
/// - 実行順序（[order]）を保持する
///
/// ## 保持する値
/// - [id]: 一意識別子
/// - [workflowId]: 所属 [Workflow] の ID
/// - [order]: 実行順序（1 始まりを想定）
/// - [title]: ステップ名
/// - [instruction]: ユーザー向けの具体的な作業指示
/// - [description]: ステップの補足説明
/// - [promptTemplateId]: 使用する [PromptTemplate] の ID
/// - [aiToolId]: 使用する [AITool] の ID
/// - [notes]: ステップ完了時のメモ欄（ユーザー入力用の初期値ではない）
///
/// ## 他 Entity との関係
/// - 1 つの [Workflow] に複数の WorkflowStep が属する（N:1）
/// - [PromptTemplate] を参照する（任意）
/// - [AITool] を参照する（任意）
class WorkflowStep {
  /// [id] をキーに [WorkflowStep] を生成する。
  WorkflowStep({
    required this.id,
    required this.workflowId,
    required this.order,
    required this.title,
    required this.instruction,
    this.description,
    this.promptTemplateId,
    this.aiToolId,
    this.notes,
  });

  /// 一意識別子。
  final String id;

  /// 所属 [Workflow] の ID。
  final String workflowId;

  /// 実行順序（1 始まりを想定）。
  final int order;

  /// ステップ名。
  final String title;

  /// ユーザー向けの具体的な作業指示。
  final String instruction;

  /// ステップの補足説明。
  final String? description;

  /// 使用する [PromptTemplate] の ID。
  final String? promptTemplateId;

  /// 使用する [AITool] の ID。
  final String? aiToolId;

  /// ステップに関するメモ。
  final String? notes;

  /// 指定フィールドのみ差し替えた新しいインスタンスを返す。
  WorkflowStep copyWith({
    String? id,
    String? workflowId,
    int? order,
    String? title,
    String? instruction,
    String? description,
    String? promptTemplateId,
    String? aiToolId,
    String? notes,
  }) {
    return WorkflowStep(
      id: id ?? this.id,
      workflowId: workflowId ?? this.workflowId,
      order: order ?? this.order,
      title: title ?? this.title,
      instruction: instruction ?? this.instruction,
      description: description ?? this.description,
      promptTemplateId: promptTemplateId ?? this.promptTemplateId,
      aiToolId: aiToolId ?? this.aiToolId,
      notes: notes ?? this.notes,
    );
  }
}
