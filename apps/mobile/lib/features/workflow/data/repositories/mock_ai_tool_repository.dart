import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';
import 'package:ai_pilot/features/workflow/domain/entities/ai_tool.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/ai_tool_repository.dart';

/// [AIToolRepository] の Mock 実装。
///
/// メモリ上の固定 AI ツールデータを返す。UI 開発用。
class MockAIToolRepository implements AIToolRepository {
  @override
  Future<List<AITool>> fetchAITools() async {
    await Future<void>.delayed(mockNetworkDelay);
    return List<AITool>.from(mockAITools);
  }

  @override
  Future<AITool?> fetchAIToolById(String id) async {
    await Future<void>.delayed(mockNetworkDelay);
    for (final tool in mockAITools) {
      if (tool.id == id) {
        return tool;
      }
    }
    return null;
  }
}
