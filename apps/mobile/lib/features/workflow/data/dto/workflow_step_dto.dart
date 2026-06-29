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
    this.goal,
    this.outputExample,
    this.completionCriteria,
    this.tips = const [],
    this.commonMistakes = const [],
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
      goal: parseNullableString(json['goal']),
      outputExample: parseNullableString(json['output_example']),
      completionCriteria: parseNullableString(json['completion_criteria']),
      tips: parseStringList(json['tips']),
      commonMistakes: parseStringList(json['common_mistakes']),
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
  final String? goal;
  final String? outputExample;
  final String? completionCriteria;
  final List<String> tips;
  final List<String> commonMistakes;

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
      goal: goal,
      outputExample: outputExample,
      completionCriteria: completionCriteria,
      tips: tips,
      commonMistakes: commonMistakes,
    );
  }
}
