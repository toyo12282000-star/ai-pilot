import 'package:ai_pilot/features/workflow/data/dto/workflow_dto.dart';
import 'package:ai_pilot/features/workflow/data/dto/workflow_step_dto.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';

/// [WorkflowDto] と [WorkflowStepDto] から [Workflow] 集約を組み立てる。
class WorkflowMapper {
  const WorkflowMapper._();

  static Workflow assembleOne(
    WorkflowDto workflow,
    List<WorkflowStepDto> steps,
  ) {
    final entitySteps = steps.map((step) => step.toEntity()).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    return workflow.toEntity(steps: entitySteps);
  }

  static List<Workflow> assembleMany(
    List<WorkflowDto> workflows,
    List<WorkflowStepDto> steps,
  ) {
    final stepsByWorkflowId = <String, List<WorkflowStepDto>>{};
    for (final step in steps) {
      stepsByWorkflowId.putIfAbsent(step.workflowId, () => []).add(step);
    }

    return workflows
        .map(
          (workflow) => assembleOne(
            workflow,
            stepsByWorkflowId[workflow.id] ?? const [],
          ),
        )
        .toList();
  }
}
