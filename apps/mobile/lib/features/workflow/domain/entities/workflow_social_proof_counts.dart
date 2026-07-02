/// Workflow 詳細 Social Proof の集計値。
class WorkflowSocialProofCounts {
  const WorkflowSocialProofCounts({
    required this.favoriteCount,
    required this.startedUserCount,
    this.completedUserCount = 0,
  });

  final int favoriteCount;
  final int startedUserCount;
  final int completedUserCount;

  static const empty = WorkflowSocialProofCounts(
    favoriteCount: 0,
    startedUserCount: 0,
    completedUserCount: 0,
  );
}
