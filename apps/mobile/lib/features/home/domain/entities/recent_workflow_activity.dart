import 'package:ai_pilot/features/workflow/domain/entities/workflow_run_history.dart';

/// Home「最近使った」向けの Workflow 利用サマリ。
class RecentWorkflowActivity {
  const RecentWorkflowActivity({
    required this.workflowId,
    required this.lastUsedAt,
    required this.isCompleted,
    required this.startedAt,
    this.completedAt,
  });

  final String workflowId;
  final DateTime lastUsedAt;
  final bool isCompleted;
  final DateTime startedAt;
  final DateTime? completedAt;

  factory RecentWorkflowActivity.fromHistory(WorkflowRunHistory history) {
    return RecentWorkflowActivity(
      workflowId: history.workflowId,
      lastUsedAt: history.completedAt ?? history.updatedAt,
      isCompleted: history.isCompleted,
      startedAt: history.startedAt,
      completedAt: history.completedAt,
    );
  }

  /// workflow ごとに最新の activity だけ残し、lastUsedAt 降順で返す。
  static List<RecentWorkflowActivity> dedupeAndSort(
    Iterable<WorkflowRunHistory> histories, {
    int limit = 6,
  }) {
    final byWorkflow = <String, RecentWorkflowActivity>{};

    for (final history in histories) {
      final activity = RecentWorkflowActivity.fromHistory(history);
      final existing = byWorkflow[activity.workflowId];
      if (existing == null ||
          activity.lastUsedAt.isAfter(existing.lastUsedAt)) {
        byWorkflow[activity.workflowId] = activity;
      }
    }

    final sorted = byWorkflow.values.toList()
      ..sort((a, b) => b.lastUsedAt.compareTo(a.lastUsedAt));
    return sorted.take(limit).toList();
  }
}
