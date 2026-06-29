import 'package:ai_pilot/features/workflow/data/repositories/mock_outcome_seed_data.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';
import 'package:ai_pilot/features/workflow/domain/entities/prompt_variant.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/prompt_variant_repository.dart';

/// [PromptVariantRepository] の Mock 実装。
class MockPromptVariantRepository implements PromptVariantRepository {
  @override
  Future<List<PromptVariant>> fetchPromptVariantsByStepId(
    String workflowStepId,
  ) async {
    await Future<void>.delayed(mockNetworkDelay);
    return mockPromptVariants
        .where((variant) => variant.workflowStepId == workflowStepId)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }
}
