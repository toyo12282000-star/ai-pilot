import 'package:ai_pilot/features/workflow/data/repositories/mock_outcome_seed_data.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';
import 'package:ai_pilot/features/workflow/domain/entities/ai_tool_alternative.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/ai_tool_alternative_repository.dart';

/// [AIToolAlternativeRepository] の Mock 実装。
class MockAIToolAlternativeRepository implements AIToolAlternativeRepository {
  @override
  Future<List<AIToolAlternative>> fetchAlternativesByToolId(
    String aiToolId,
  ) async {
    await Future<void>.delayed(mockNetworkDelay);
    return mockAIToolAlternatives
        .where((alternative) => alternative.aiToolId == aiToolId)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }
}
