/// Workflow が生み出す成果物の種別。
enum OutcomeType {
  video,
  article,
  image,
  slide,
  snsPost,
  app,
  other,
}

/// Workflow の完成イメージ（Outcome）。
class WorkflowOutcome {
  WorkflowOutcome({
    required this.id,
    required this.workflowId,
    required this.title,
    required this.outcomeType,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.previewImageUrl,
    this.previewUrl,
    this.expectedResult,
    List<String> targetUsers = const [],
    List<String> useCases = const [],
    this.sortOrder = 0,
  })  : targetUsers = List.unmodifiable(targetUsers),
        useCases = List.unmodifiable(useCases);

  final String id;
  final String workflowId;
  final String title;
  final String? description;
  final OutcomeType outcomeType;
  final String? previewImageUrl;
  final String? previewUrl;
  final String? expectedResult;
  final List<String> targetUsers;
  final List<String> useCases;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
}
