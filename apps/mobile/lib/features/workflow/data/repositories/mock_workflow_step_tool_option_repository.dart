import 'package:ai_pilot/features/workflow/data/repositories/mock_outcome_seed_data.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_step_tool_option.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/workflow_step_tool_option_repository.dart';

/// [WorkflowStepToolOptionRepository] の Mock 実装。
class MockWorkflowStepToolOptionRepository
    implements WorkflowStepToolOptionRepository {
  @override
  Future<List<WorkflowStepToolOption>> fetchToolOptionsByStepId(
    String workflowStepId,
  ) async {
    await Future<void>.delayed(mockNetworkDelay);
    return mockWorkflowStepToolOptions
        .where((option) => option.workflowStepId == workflowStepId)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }
}
