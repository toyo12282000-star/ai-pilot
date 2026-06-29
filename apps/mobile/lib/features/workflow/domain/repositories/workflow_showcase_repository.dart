import 'package:ai_pilot/features/workflow/domain/entities/workflow_showcase.dart';

/// [WorkflowShowcase] の読み取り Repository。
abstract class WorkflowShowcaseRepository {
  Future<List<WorkflowShowcase>> fetchShowcases();

  Future<List<WorkflowShowcase>> fetchFeaturedShowcases();

  Future<List<WorkflowShowcase>> fetchByWorkflow(String workflowId);
}
