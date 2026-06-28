import 'package:ai_pilot/features/workflow/data/dto/json_helpers.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_step.dart';

/// Supabase `workflow_steps` 行の DTO。
class WorkflowStepDto {
  WorkflowStepDto({
    required this.id,
    required this.workflowId,
    required this.stepOrder,
    required this.title,
    required this.instruction,
    this.description,
    this.aiToolId,
    this.promptTemplateId,
    this.notes,
  });

  factory WorkflowStepDto.fromJson(Map<String, dynamic> json) {
    return WorkflowStepDto(
      id: json['id'] as String,
      workflowId: json['workflow_id'] as String,
      stepOrder: json['step_order'] as int,
      title: json['title'] as String,
      instruction: json['instruction'] as String? ?? '',
      description: parseNullableString(json['description']),
      aiToolId: parseNullableString(json['ai_tool_id']),
      promptTemplateId: parseNullableString(json['prompt_template_id']),
      notes: parseNullableString(json['notes']),
    );
  }

  final String id;
  final String workflowId;
  final int stepOrder;
  final String title;
  final String instruction;
  final String? description;
  final String? aiToolId;
  final String? promptTemplateId;
  final String? notes;

  WorkflowStep toEntity() {
    return WorkflowStep(
      id: id,
      workflowId: workflowId,
      order: stepOrder,
      title: title,
      instruction: instruction,
      description: description,
      aiToolId: aiToolId,
      promptTemplateId: promptTemplateId,
      notes: notes,
    );
  }
}
