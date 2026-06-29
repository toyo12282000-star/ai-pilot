/// AI ツールの代替候補。
class AIToolAlternative {
  AIToolAlternative({
    required this.aiToolId,
    required this.alternativeAiToolId,
    this.reason,
    this.sortOrder = 0,
  });

  final String aiToolId;
  final String alternativeAiToolId;
  final String? reason;
  final int sortOrder;
}
