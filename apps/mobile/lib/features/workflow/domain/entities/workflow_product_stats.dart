/// Workflow 詳細の人気・メタ情報（Social Proof + Workflow メタ）。
class WorkflowProductStats {
  const WorkflowProductStats({
    required this.popularityScore,
    required this.saveCount,
    required this.userCount,
    required this.estimatedMinutes,
    required this.difficultyLabel,
    required this.pricingLabel,
    required this.category,
  });

  /// 5段階評価（例: 4.5）。
  final double popularityScore;
  final int saveCount;
  final int userCount;
  final int estimatedMinutes;
  final String difficultyLabel;
  final String pricingLabel;
  final String category;
}
