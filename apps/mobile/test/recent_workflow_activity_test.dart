import 'package:flutter_test/flutter_test.dart';

import 'package:ai_pilot/features/home/domain/entities/recent_workflow_activity.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_run_history.dart';

void main() {
  test('dedupeAndSort keeps latest activity per workflow', () {
    final histories = [
      WorkflowRunHistory(
        id: '1',
        userId: 'user-1',
        workflowId: 'wf_a',
        lastStepIndex: 1,
        isCompleted: false,
        startedAt: DateTime(2026, 6, 20),
        updatedAt: DateTime(2026, 6, 21),
      ),
      WorkflowRunHistory(
        id: '2',
        userId: 'user-1',
        workflowId: 'wf_a',
        lastStepIndex: 3,
        isCompleted: true,
        startedAt: DateTime(2026, 6, 22),
        completedAt: DateTime(2026, 6, 28),
        updatedAt: DateTime(2026, 6, 28),
      ),
      WorkflowRunHistory(
        id: '3',
        userId: 'user-1',
        workflowId: 'wf_b',
        lastStepIndex: 0,
        isCompleted: false,
        startedAt: DateTime(2026, 6, 27),
        updatedAt: DateTime(2026, 6, 27),
      ),
    ];

    final activities =
        RecentWorkflowActivity.dedupeAndSort(histories, limit: 6);

    expect(activities, hasLength(2));
    expect(activities.first.workflowId, 'wf_a');
    expect(activities.first.isCompleted, isTrue);
    expect(activities.last.workflowId, 'wf_b');
  });
}
