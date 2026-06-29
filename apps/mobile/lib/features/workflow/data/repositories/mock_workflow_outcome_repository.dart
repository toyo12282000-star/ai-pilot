import 'package:ai_pilot/features/workflow/data/repositories/mock_outcome_seed_data.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_outcome.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/workflow_outcome_repository.dart';

/// [WorkflowOutcomeRepository] の Mock 実装。
class MockWorkflowOutcomeRepository implements WorkflowOutcomeRepository {
  @override
  Future<List<WorkflowOutcome>> fetchOutcomesByWorkflowId(
    String workflowId,
  ) async {
    await Future<void>.delayed(mockNetworkDelay);
    return mockWorkflowOutcomes
        .where((outcome) => outcome.workflowId == workflowId)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }
}
