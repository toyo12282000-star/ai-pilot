import 'package:ai_pilot/features/workflow/domain/entities/ai_tool_alternative.dart';

/// [AIToolAlternative] の読み取り Repository。
abstract class AIToolAlternativeRepository {
  Future<List<AIToolAlternative>> fetchAlternativesByToolId(String aiToolId);
}
