import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_step_enrichment_data.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_step.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/workflow_repository.dart';

Workflow _withStepEnrichment(Workflow workflow) {
  final enrichedSteps = workflow.steps.map(_enrichStep).toList();
  return workflow.copyWith(steps: enrichedSteps);
}

WorkflowStep _enrichStep(WorkflowStep step) {
  final enrichment = mockStepEnrichmentById[step.id];
  if (enrichment == null) {
    return step;
  }
  return step.copyWith(
    goal: enrichment.goal,
    outputExample: enrichment.outputExample,
    completionCriteria: enrichment.completionCriteria,
    tips: enrichment.tips,
    commonMistakes: enrichment.commonMistakes,
  );
}

/// [WorkflowRepository] の Mock 実装。
///
/// メモリ上の固定ワークフローデータを返す。UI 開発用。
class MockWorkflowRepository implements WorkflowRepository {
  @override
  Future<List<Workflow>> fetchWorkflows() async {
    await Future<void>.delayed(mockNetworkDelay);
    return mockWorkflows.map(_withStepEnrichment).toList();
  }

  @override
  Future<List<Workflow>> fetchWorkflowsByCategory(String categoryId) async {
    await Future<void>.delayed(mockNetworkDelay);
    return mockWorkflows
        .where((workflow) => workflow.categoryId == categoryId)
        .map(_withStepEnrichment)
        .toList();
  }

  @override
  Future<Workflow?> fetchWorkflowById(String id) async {
    await Future<void>.delayed(mockNetworkDelay);
    for (final workflow in mockWorkflows) {
      if (workflow.id == id) {
        return _withStepEnrichment(workflow);
      }
    }
    return null;
  }

  @override
  Future<List<Workflow>> searchWorkflows(String query) async {
    await Future<void>.delayed(mockNetworkDelay);

    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return List<Workflow>.from(mockWorkflows);
    }

    return mockWorkflows.where((workflow) {
      final titleMatch = workflow.title.toLowerCase().contains(normalizedQuery);
      final descriptionMatch =
          workflow.description.toLowerCase().contains(normalizedQuery);
      final tagMatch = workflow.tags.any(
        (tag) => tag.toLowerCase().contains(normalizedQuery),
      );
      return titleMatch || descriptionMatch || tagMatch;
    }).map(_withStepEnrichment).toList();
  }
}
