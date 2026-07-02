/// Advisor 相談セッション内の Workflow 提案 1 件（順位付き）。
class AdvisorSessionSuggestion {
  const AdvisorSessionSuggestion({
    required this.sessionId,
    required this.workflowId,
    required this.rank,
  });

  final String sessionId;
  final String workflowId;
  final int rank;
}
