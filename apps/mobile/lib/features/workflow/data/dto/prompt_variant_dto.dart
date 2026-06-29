import 'package:ai_pilot/features/workflow/data/dto/json_helpers.dart';
import 'package:ai_pilot/features/workflow/domain/entities/prompt_variant.dart';

/// Supabase `prompt_variants` 行の DTO。
class PromptVariantDto {
  PromptVariantDto({
    required this.id,
    required this.workflowStepId,
    required this.title,
    required this.variantType,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.promptTemplateId,
    this.expectedOutput,
    this.usageTips,
    this.variables = const [],
    this.sortOrder = 0,
  });

  factory PromptVariantDto.fromJson(Map<String, dynamic> json) {
    return PromptVariantDto(
      id: json['id'] as String,
      workflowStepId: json['workflow_step_id'] as String,
      promptTemplateId: parseNullableString(json['prompt_template_id']),
      title: json['title'] as String,
      variantType: json['variant_type'] as String,
      content: json['content'] as String,
      expectedOutput: parseNullableString(json['expected_output']),
      usageTips: parseNullableString(json['usage_tips']),
      variables: parseStringList(json['variables']),
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: parseTimestamp(json['created_at']),
      updatedAt: parseTimestamp(json['updated_at']),
    );
  }

  final String id;
  final String workflowStepId;
  final String? promptTemplateId;
  final String title;
  final String variantType;
  final String content;
  final String? expectedOutput;
  final String? usageTips;
  final List<String> variables;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  PromptVariant toEntity() {
    return PromptVariant(
      id: id,
      workflowStepId: workflowStepId,
      promptTemplateId: promptTemplateId,
      title: title,
      variantType: _parseVariantType(variantType),
      content: content,
      expectedOutput: expectedOutput,
      usageTips: usageTips,
      variables: variables,
      sortOrder: sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static PromptVariantType _parseVariantType(String value) {
    switch (value) {
      case 'beginner':
        return PromptVariantType.beginner;
      case 'high_quality':
        return PromptVariantType.highQuality;
      case 'short_time':
        return PromptVariantType.shortTime;
      case 'viral':
        return PromptVariantType.viral;
      case 'professional':
        return PromptVariantType.professional;
      case 'seo':
        return PromptVariantType.seo;
      case 'sns':
        return PromptVariantType.sns;
      default:
        return PromptVariantType.beginner;
    }
  }
}
