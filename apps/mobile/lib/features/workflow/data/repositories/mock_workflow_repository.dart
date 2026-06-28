import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/workflow_repository.dart';

/// [WorkflowRepository] の Mock 実装。
///
/// メモリ上の固定ワークフローデータを返す。UI 開発用。
class MockWorkflowRepository implements WorkflowRepository {
  @override
  Future<List<Workflow>> fetchWorkflows() async {
    await Future<void>.delayed(mockNetworkDelay);
    return List<Workflow>.from(mockWorkflows);
  }

  @override
  Future<List<Workflow>> fetchWorkflowsByCategory(String categoryId) async {
    await Future<void>.delayed(mockNetworkDelay);
    return mockWorkflows
        .where((workflow) => workflow.categoryId == categoryId)
        .toList();
  }

  @override
  Future<Workflow?> fetchWorkflowById(String id) async {
    await Future<void>.delayed(mockNetworkDelay);
    for (final workflow in mockWorkflows) {
      if (workflow.id == id) {
        return workflow;
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
    }).toList();
  }
}
