import 'package:ai_pilot/features/workflow/domain/entities/workflow_outcome.dart';

/// [WorkflowOutcome] の読み取り Repository。
abstract class WorkflowOutcomeRepository {
  Future<List<WorkflowOutcome>> fetchOutcomesByWorkflowId(String workflowId);
}
