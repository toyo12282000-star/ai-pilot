import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_run_history.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/workflow_run_history_repository.dart';

/// [WorkflowRunHistoryRepository] の Mock 実装。
///
/// メモリ上で実行履歴を保持する。UI 開発用。
class MockWorkflowRunHistoryRepository implements WorkflowRunHistoryRepository {
  final List<WorkflowRunHistory> _histories = [];
  int _nextId = 1;

  int _indexOf(String userId, String workflowId) {
    return _histories.indexWhere(
      (history) =>
          history.userId == userId && history.workflowId == workflowId,
    );
  }

  @override
  Future<List<WorkflowRunHistory>> fetchRecentHistories(String userId) async {
    await Future<void>.delayed(mockNetworkDelay);
    final results =
        _histories.where((history) => history.userId == userId).toList()
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return results;
  }

  @override
  Future<WorkflowRunHistory?> fetchHistoryByWorkflow(
    String userId,
    String workflowId,
  ) async {
    await Future<void>.delayed(mockNetworkDelay);
    final index = _indexOf(userId, workflowId);
    if (index < 0) {
      return null;
    }
    return _histories[index];
  }

  @override
  Future<WorkflowRunHistory> startWorkflow(
    String userId,
    String workflowId,
  ) async {
    await Future<void>.delayed(mockNetworkDelay);
    final now = DateTime.now();
    final index = _indexOf(userId, workflowId);

    if (index >= 0) {
      final restarted = _histories[index].copyWith(
        lastStepIndex: 0,
        isCompleted: false,
        startedAt: now,
        updatedAt: now,
        clearCompletedAt: true,
      );
      _histories[index] = restarted;
      return restarted;
    }

    final history = WorkflowRunHistory(
      id: 'run-history-$_nextId',
      userId: userId,
      workflowId: workflowId,
      lastStepIndex: 0,
      isCompleted: false,
      startedAt: now,
      updatedAt: now,
    );
    _nextId++;
    _histories.add(history);
    return history;
  }

  @override
  Future<void> updateProgress(
    String userId,
    String workflowId,
    int stepIndex,
  ) async {
    await Future<void>.delayed(mockNetworkDelay);
    final index = _indexOf(userId, workflowId);
    if (index < 0) {
      return;
    }

    _histories[index] = _histories[index].copyWith(
      lastStepIndex: stepIndex,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<void> completeWorkflow(String userId, String workflowId) async {
    await Future<void>.delayed(mockNetworkDelay);
    final index = _indexOf(userId, workflowId);
    if (index < 0) {
      return;
    }

    final now = DateTime.now();
    _histories[index] = _histories[index].copyWith(
      isCompleted: true,
      completedAt: now,
      updatedAt: now,
    );
  }
}
