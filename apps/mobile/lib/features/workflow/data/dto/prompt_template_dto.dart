import 'package:ai_pilot/features/workflow/data/dto/json_helpers.dart';
import 'package:ai_pilot/features/workflow/domain/entities/prompt_template.dart';

/// Supabase `prompt_templates` 行の DTO。
class PromptTemplateDto {
  PromptTemplateDto({
    required this.id,
    required this.title,
    required this.content,
    required this.variableNames,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.recommendedAiToolId,
  });

  factory PromptTemplateDto.fromJson(Map<String, dynamic> json) {
    return PromptTemplateDto(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      description: parseNullableString(json['description']),
      recommendedAiToolId: parseNullableString(json['recommended_ai_tool_id']),
      variableNames: parseStringList(json['variable_names']),
      tags: parseStringList(json['tags']),
      createdAt: parseTimestamp(json['created_at']),
      updatedAt: parseTimestamp(json['updated_at']),
    );
  }

  final String id;
  final String title;
  final String content;
  final String? description;
  final String? recommendedAiToolId;
  final List<String> variableNames;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  PromptTemplate toEntity() {
    return PromptTemplate(
      id: id,
      title: title,
      content: content,
      description: description,
      recommendedAiToolId: recommendedAiToolId,
      variableNames: variableNames,
      tags: tags,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
