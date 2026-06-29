import 'package:ai_pilot/features/workflow/data/dto/json_helpers.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_outcome.dart';

/// Supabase `workflow_outcomes` 行の DTO。
class WorkflowOutcomeDto {
  WorkflowOutcomeDto({
    required this.id,
    required this.workflowId,
    required this.title,
    required this.outcomeType,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.previewImageUrl,
    this.previewUrl,
    this.expectedResult,
    this.targetUsers = const [],
    this.useCases = const [],
    this.sortOrder = 0,
  });

  factory WorkflowOutcomeDto.fromJson(Map<String, dynamic> json) {
    return WorkflowOutcomeDto(
      id: json['id'] as String,
      workflowId: json['workflow_id'] as String,
      title: json['title'] as String,
      description: parseNullableString(json['description']),
      outcomeType: json['outcome_type'] as String,
      previewImageUrl: parseNullableString(json['preview_image_url']),
      previewUrl: parseNullableString(json['preview_url']),
      expectedResult: parseNullableString(json['expected_result']),
      targetUsers: parseStringList(json['target_users']),
      useCases: parseStringList(json['use_cases']),
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: parseTimestamp(json['created_at']),
      updatedAt: parseTimestamp(json['updated_at']),
    );
  }

  final String id;
  final String workflowId;
  final String title;
  final String? description;
  final String outcomeType;
  final String? previewImageUrl;
  final String? previewUrl;
  final String? expectedResult;
  final List<String> targetUsers;
  final List<String> useCases;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  WorkflowOutcome toEntity() {
    return WorkflowOutcome(
      id: id,
      workflowId: workflowId,
      title: title,
      description: description,
      outcomeType: _parseOutcomeType(outcomeType),
      previewImageUrl: previewImageUrl,
      previewUrl: previewUrl,
      expectedResult: expectedResult,
      targetUsers: targetUsers,
      useCases: useCases,
      sortOrder: sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static OutcomeType _parseOutcomeType(String value) {
    switch (value) {
      case 'video':
        return OutcomeType.video;
      case 'article':
        return OutcomeType.article;
      case 'image':
        return OutcomeType.image;
      case 'slide':
        return OutcomeType.slide;
      case 'sns_post':
        return OutcomeType.snsPost;
      case 'app':
        return OutcomeType.app;
      case 'other':
        return OutcomeType.other;
      default:
        return OutcomeType.other;
    }
  }
}
