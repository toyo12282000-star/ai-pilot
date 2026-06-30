import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_showcase_seed_data.dart';
import 'package:ai_pilot/features/workflow/data/repositories/showcase_library_catalog.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_showcase.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/workflow_showcase_repository.dart';

/// [WorkflowShowcaseRepository] の Mock 実装。
class MockWorkflowShowcaseRepository implements WorkflowShowcaseRepository {
  @override
  Future<List<WorkflowShowcase>> fetchShowcases() async {
    await Future<void>.delayed(mockNetworkDelay);
    return List<WorkflowShowcase>.from(mockWorkflowShowcases)
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  @override
  Future<List<WorkflowShowcase>> fetchFeaturedShowcases() async {
    await Future<void>.delayed(mockNetworkDelay);
    final catalogOrder = {
      for (var i = 0; i < showcaseLibraryCatalog.length; i++)
        showcaseLibraryCatalog[i].id: i,
    };
    return mockWorkflowShowcases
        .where((showcase) => showcase.isFeatured)
        .toList()
      ..sort((a, b) {
        final orderCompare = catalogOrder[a.id]!.compareTo(catalogOrder[b.id]!);
        if (orderCompare != 0) {
          return orderCompare;
        }
        return a.sortOrder.compareTo(b.sortOrder);
      });
  }

  @override
  Future<List<WorkflowShowcase>> fetchByWorkflow(String workflowId) async {
    await Future<void>.delayed(mockNetworkDelay);
    return mockWorkflowShowcases
        .where((showcase) => showcase.workflowId == workflowId)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }
}
