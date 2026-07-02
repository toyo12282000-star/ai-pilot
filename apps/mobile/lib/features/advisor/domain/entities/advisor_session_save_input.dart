/// Advisor 相談完了時に保存する入力。
class AdvisorSessionSaveInput {
  const AdvisorSessionSaveInput({
    required this.userId,
    required this.query,
    required this.selectedAnswers,
    required this.suggestedWorkflowIds,
    this.path,
  });

  final String userId;
  final String query;

  /// 会話 path（enum 名文字列 · 例: `youtube`）。
  final String? path;
  final List<String> selectedAnswers;
  final List<String> suggestedWorkflowIds;

  String? get primaryWorkflowId =>
      suggestedWorkflowIds.isEmpty ? null : suggestedWorkflowIds.first;
}
