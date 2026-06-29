import 'package:ai_pilot/features/workflow/domain/entities/workflow_step_tool_option.dart';

/// [WorkflowStepToolOption] の読み取り Repository。
abstract class WorkflowStepToolOptionRepository {
  Future<List<WorkflowStepToolOption>> fetchToolOptionsByStepId(
    String workflowStepId,
  );
}
