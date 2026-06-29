import 'package:ai_pilot/features/workflow/data/dto/json_helpers.dart';
import 'package:ai_pilot/features/workflow/domain/entities/ai_tool_alternative.dart';

/// Supabase `ai_tool_alternatives` 行の DTO。
class AIToolAlternativeDto {
  AIToolAlternativeDto({
    required this.aiToolId,
    required this.alternativeAiToolId,
    this.reason,
    this.sortOrder = 0,
  });

  factory AIToolAlternativeDto.fromJson(Map<String, dynamic> json) {
    return AIToolAlternativeDto(
      aiToolId: json['ai_tool_id'] as String,
      alternativeAiToolId: json['alternative_ai_tool_id'] as String,
      reason: parseNullableString(json['reason']),
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  final String aiToolId;
  final String alternativeAiToolId;
  final String? reason;
  final int sortOrder;

  AIToolAlternative toEntity() {
    return AIToolAlternative(
      aiToolId: aiToolId,
      alternativeAiToolId: alternativeAiToolId,
      reason: reason,
      sortOrder: sortOrder,
    );
  }
}
