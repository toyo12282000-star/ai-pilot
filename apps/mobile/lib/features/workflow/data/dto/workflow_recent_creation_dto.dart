import 'package:ai_pilot/features/workflow/data/dto/json_helpers.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_recent_creation.dart';

/// Supabase `get_workflow_recent_creations` RPC 行の DTO。
class WorkflowRecentCreationDto {
  WorkflowRecentCreationDto({
    required this.userId,
    required this.displayName,
    required this.activityAt,
  });

  factory WorkflowRecentCreationDto.fromJson(Map<String, dynamic> json) {
    return WorkflowRecentCreationDto(
      userId: json['user_id'] as String,
      displayName: json['display_name'] as String? ?? 'ユーザー',
      activityAt: parseTimestamp(json['activity_at']),
    );
  }

  final String userId;
  final String displayName;
  final DateTime activityAt;

  WorkflowRecentCreation toEntity() {
    return WorkflowRecentCreation(
      userId: userId,
      displayName: displayName,
      activityAt: activityAt,
    );
  }
}
