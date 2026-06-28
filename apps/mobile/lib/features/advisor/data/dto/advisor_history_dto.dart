import 'package:ai_pilot/features/advisor/domain/entities/advisor_history.dart';
import 'package:ai_pilot/features/workflow/data/dto/json_helpers.dart';

/// Supabase `advisor_histories` 行の DTO。
class AdvisorHistoryDto {
  AdvisorHistoryDto({
    required this.id,
    required this.userId,
    required this.query,
    required this.suggestedWorkflowIds,
    required this.createdAt,
  });

  factory AdvisorHistoryDto.fromJson(Map<String, dynamic> json) {
    return AdvisorHistoryDto(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      query: json['query'] as String,
      suggestedWorkflowIds: parseStringList(json['suggested_workflow_ids']),
      createdAt: parseTimestamp(json['created_at']),
    );
  }

  final String id;
  final String userId;
  final String query;
  final List<String> suggestedWorkflowIds;
  final DateTime createdAt;

  AdvisorHistory toEntity() {
    return AdvisorHistory(
      id: id,
      userId: userId,
      query: query,
      suggestedWorkflowIds: suggestedWorkflowIds,
      createdAt: createdAt,
    );
  }
}
