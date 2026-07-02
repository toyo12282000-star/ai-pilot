import 'package:ai_pilot/features/favorite/domain/entities/favorite.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_run_history.dart';

/// Mock Social Proof 用の追加ユーザー表示名。
const mockSocialProofDisplayNames = <String, String>{
  'user-sp-1': 'ゆうき',
  'user-sp-2': 'みさき',
  'user-sp-3': 'たくや',
  'user-sp-4': 'あやか',
  'user-sp-5': 'りな',
  'user-sp-6': 'そうた',
  'user-sp-7': 'めい',
  'user-sp-8': 'ひろ',
  'user-sp-9': 'さくら',
  'user-sp-10': 'だいすけ',
  'user-sp-11': 'けん',
  'user-sp-12': 'はなこ',
};

List<Favorite> buildMockSocialProofFavorites(DateTime now) {
  return [
    for (var i = 0; i < 8; i++)
      Favorite(
        id: 'fav-sp-yt-$i',
        userId: 'user-sp-${i + 1}',
        workflowId: 'wf_youtube_short',
        createdAt: now.subtract(Duration(days: i)),
      ),
    for (var i = 0; i < 6; i++)
      Favorite(
        id: 'fav-sp-sns-$i',
        userId: 'user-sp-${i + 5}',
        workflowId: 'wf_sns',
        createdAt: now.subtract(Duration(days: i + 1)),
      ),
    for (var i = 0; i < 5; i++)
      Favorite(
        id: 'fav-sp-blog-$i',
        userId: 'user-sp-${i + 8}',
        workflowId: 'wf_blog',
        createdAt: now.subtract(Duration(days: i + 2)),
      ),
  ];
}

List<WorkflowRunHistory> buildMockSocialProofRunHistories(DateTime now) {
  WorkflowRunHistory history({
    required String id,
    required String userId,
    required String workflowId,
    required DateTime startedAt,
    bool isCompleted = false,
    DateTime? completedAt,
  }) {
    return WorkflowRunHistory(
      id: id,
      userId: userId,
      workflowId: workflowId,
      lastStepIndex: isCompleted ? 3 : 1,
      isCompleted: isCompleted,
      startedAt: startedAt,
      completedAt: completedAt,
      updatedAt: completedAt ?? startedAt,
    );
  }

  return [
    history(
      id: 'run-demo-user-1',
      userId: 'user-1',
      workflowId: 'wf_research',
      startedAt: now.subtract(const Duration(hours: 3)),
      isCompleted: true,
      completedAt: now.subtract(const Duration(hours: 1)),
    ),
    history(
      id: 'run-sp-yt-1',
      userId: 'user-sp-1',
      workflowId: 'wf_youtube_short',
      startedAt: now.subtract(const Duration(hours: 2)),
      isCompleted: true,
      completedAt: now.subtract(const Duration(hours: 1)),
    ),
    history(
      id: 'run-sp-yt-2',
      userId: 'user-sp-2',
      workflowId: 'wf_youtube_short',
      startedAt: now.subtract(const Duration(hours: 4)),
      isCompleted: true,
      completedAt: now.subtract(const Duration(hours: 3)),
    ),
    history(
      id: 'run-sp-yt-3',
      userId: 'user-sp-3',
      workflowId: 'wf_youtube_short',
      startedAt: now.subtract(const Duration(days: 1, hours: 2)),
    ),
    history(
      id: 'run-sp-yt-4',
      userId: 'user-sp-4',
      workflowId: 'wf_youtube_short',
      startedAt: now.subtract(const Duration(days: 1, hours: 5)),
      isCompleted: true,
      completedAt: now.subtract(const Duration(days: 1)),
    ),
    history(
      id: 'run-sp-sns-1',
      userId: 'user-sp-5',
      workflowId: 'wf_sns',
      startedAt: now.subtract(const Duration(hours: 1)),
      isCompleted: true,
      completedAt: now,
    ),
    history(
      id: 'run-sp-sns-2',
      userId: 'user-sp-6',
      workflowId: 'wf_sns',
      startedAt: now.subtract(const Duration(days: 1)),
    ),
    history(
      id: 'run-sp-sns-3',
      userId: 'user-sp-7',
      workflowId: 'wf_sns',
      startedAt: now.subtract(const Duration(days: 2)),
      isCompleted: true,
      completedAt: now.subtract(const Duration(days: 1, hours: 12)),
    ),
    history(
      id: 'run-sp-blog-1',
      userId: 'user-sp-8',
      workflowId: 'wf_blog',
      startedAt: now.subtract(const Duration(hours: 3)),
      isCompleted: true,
      completedAt: now.subtract(const Duration(hours: 1)),
    ),
    history(
      id: 'run-sp-blog-2',
      userId: 'user-sp-9',
      workflowId: 'wf_blog',
      startedAt: now.subtract(const Duration(days: 1, hours: 4)),
    ),
    history(
      id: 'run-sp-blog-3',
      userId: 'user-sp-10',
      workflowId: 'wf_blog',
      startedAt: now.subtract(const Duration(days: 3)),
      isCompleted: true,
      completedAt: now.subtract(const Duration(days: 2, hours: 6)),
    ),
  ];
}
