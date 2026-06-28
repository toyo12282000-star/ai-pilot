import 'package:ai_pilot/features/workflow/data/dto/json_helpers.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_run_history.dart';

/// Supabase `workflow_run_histories` 行の DTO。
class WorkflowRunHistoryDto {
  WorkflowRunHistoryDto({
    required this.id,
    required this.userId,
    required this.workflowId,
    required this.lastStepIndex,
    required this.isCompleted,
    required this.startedAt,
    required this.updatedAt,
    this.completedAt,
  });

  factory WorkflowRunHistoryDto.fromJson(Map<String, dynamic> json) {
    return WorkflowRunHistoryDto(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      workflowId: json['workflow_id'] as String,
      lastStepIndex: json['last_step_index'] as int? ?? 0,
      isCompleted: json['is_completed'] as bool? ?? false,
      startedAt: parseTimestamp(json['started_at']),
      completedAt: json['completed_at'] == null
          ? null
          : parseTimestamp(json['completed_at']),
      updatedAt: parseTimestamp(json['updated_at']),
    );
  }

  final String id;
  final String userId;
  final String workflowId;
  final int lastStepIndex;
  final bool isCompleted;
  final DateTime startedAt;
  final DateTime? completedAt;
  final DateTime updatedAt;

  WorkflowRunHistory toEntity() {
    return WorkflowRunHistory(
      id: id,
      userId: userId,
      workflowId: workflowId,
      lastStepIndex: lastStepIndex,
      isCompleted: isCompleted,
      startedAt: startedAt,
      completedAt: completedAt,
      updatedAt: updatedAt,
    );
  }
}
