import 'package:ai_pilot/features/workflow/data/dto/json_helpers.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_step_tool_option.dart';

/// Supabase `workflow_step_tool_options` 行の DTO。
class WorkflowStepToolOptionDto {
  WorkflowStepToolOptionDto({
    required this.id,
    required this.workflowStepId,
    required this.aiToolId,
    required this.createdAt,
    required this.updatedAt,
    this.isRecommended = false,
    this.recommendationReason,
    this.difficulty,
    this.pricingNote,
    this.sortOrder = 0,
  });

  factory WorkflowStepToolOptionDto.fromJson(Map<String, dynamic> json) {
    return WorkflowStepToolOptionDto(
      id: json['id'] as String,
      workflowStepId: json['workflow_step_id'] as String,
      aiToolId: json['ai_tool_id'] as String,
      isRecommended: json['is_recommended'] as bool? ?? false,
      recommendationReason: parseNullableString(json['recommendation_reason']),
      difficulty: parseNullableString(json['difficulty']),
      pricingNote: parseNullableString(json['pricing_note']),
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: parseTimestamp(json['created_at']),
      updatedAt: parseTimestamp(json['updated_at']),
    );
  }

  final String id;
  final String workflowStepId;
  final String aiToolId;
  final bool isRecommended;
  final String? recommendationReason;
  final String? difficulty;
  final String? pricingNote;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  WorkflowStepToolOption toEntity() {
    return WorkflowStepToolOption(
      id: id,
      workflowStepId: workflowStepId,
      aiToolId: aiToolId,
      isRecommended: isRecommended,
      recommendationReason: recommendationReason,
      difficulty: _parseDifficulty(difficulty),
      pricingNote: pricingNote,
      sortOrder: sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static StepToolDifficulty? _parseDifficulty(String? value) {
    switch (value) {
      case 'easy':
        return StepToolDifficulty.easy;
      case 'normal':
        return StepToolDifficulty.normal;
      case 'hard':
        return StepToolDifficulty.hard;
      default:
        return null;
    }
  }
}
