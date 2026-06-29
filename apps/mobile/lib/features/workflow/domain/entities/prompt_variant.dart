/// プロンプトの用途別バリエーション種別。
enum PromptVariantType {
  beginner,
  highQuality,
  shortTime,
  viral,
  professional,
  seo,
  sns,
}

/// Step ごとの用途別プロンプト。
class PromptVariant {
  PromptVariant({
    required this.id,
    required this.workflowStepId,
    required this.title,
    required this.variantType,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.promptTemplateId,
    this.expectedOutput,
    this.usageTips,
    List<String> variables = const [],
    this.sortOrder = 0,
  }) : variables = List.unmodifiable(variables);

  final String id;
  final String workflowStepId;
  final String? promptTemplateId;
  final String title;
  final PromptVariantType variantType;
  final String content;
  final String? expectedOutput;
  final String? usageTips;
  final List<String> variables;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
}
