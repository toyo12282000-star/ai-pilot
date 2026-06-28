import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';
import 'package:ai_pilot/features/workflow/domain/entities/prompt_template.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/prompt_template_repository.dart';

/// [PromptTemplateRepository] の Mock 実装。
class MockPromptTemplateRepository implements PromptTemplateRepository {
  @override
  Future<List<PromptTemplate>> fetchPromptTemplates() async {
    await Future<void>.delayed(mockNetworkDelay);
    return List<PromptTemplate>.from(mockPromptTemplates);
  }

  @override
  Future<PromptTemplate?> fetchPromptTemplateById(String id) async {
    await Future<void>.delayed(mockNetworkDelay);
    return findMockPromptTemplateById(id);
  }
}
