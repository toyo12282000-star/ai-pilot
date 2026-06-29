/// Step で選べる AI ツールの難易度。
enum StepToolDifficulty {
  easy,
  normal,
  hard,
}

/// Workflow Step ごとの AI ツール候補。
class WorkflowStepToolOption {
  WorkflowStepToolOption({
    required this.id,
    required this.workflowStepId,
    required this.aiToolId,
    required this.createdAt,
    required this.updatedAt,
    this.isRecommended = false,
    this.recommendationReason,
    this.difficulty,
    this.pricingNote,
    this.sortOrder = 0,
  });

  final String id;
  final String workflowStepId;
  final String aiToolId;
  final bool isRecommended;
  final String? recommendationReason;
  final StepToolDifficulty? difficulty;
  final String? pricingNote;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
}
