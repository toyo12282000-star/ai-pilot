import 'package:ai_pilot/features/workflow/data/dto/json_helpers.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_step.dart';

/// Supabase `workflows` 行の DTO。
class WorkflowDto {
  WorkflowDto({
    required this.id,
    required this.title,
    required this.description,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
    this.categoryId,
    this.estimatedMinutes,
  });

  factory WorkflowDto.fromJson(Map<String, dynamic> json) {
    return WorkflowDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      categoryId: parseNullableString(json['category_id']),
      estimatedMinutes: json['estimated_minutes'] as int?,
      tags: parseStringList(json['tags']),
      createdAt: parseTimestamp(json['created_at']),
      updatedAt: parseTimestamp(json['updated_at']),
    );
  }

  final String id;
  final String title;
  final String description;
  final String? categoryId;
  final int? estimatedMinutes;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  Workflow toEntity({List<WorkflowStep> steps = const []}) {
    return Workflow(
      id: id,
      title: title,
      description: description,
      categoryId: categoryId ?? '',
      estimatedMinutes: estimatedMinutes,
      tags: tags,
      steps: steps,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
