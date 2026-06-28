import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/domain/entities/ai_tool.dart';
import 'package:ai_pilot/features/workflow/domain/entities/prompt_template.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_step.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_step_card.dart';
import 'package:ai_pilot/shared/widgets/fade_slide_in.dart';

/// ステップ一覧のタイムライン表示。
class WorkflowStepTimeline extends StatelessWidget {
  const WorkflowStepTimeline({
    super.key,
    required this.steps,
    required this.toolsById,
    required this.templatesById,
  });

  final List<WorkflowStep> steps;
  final Map<String, AITool> toolsById;
  final Map<String, PromptTemplate> templatesById;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.s16),
          child: Text(
            'ステップ',
            style: AppTypography.titleMedium,
          ),
        ),
        for (var index = 0; index < steps.length; index++)
          FadeSlideIn(
            index: index + 1,
            child: _TimelineRow(
              step: steps[index],
              isLast: index == steps.length - 1,
              aiToolName: _resolveAiToolName(steps[index]),
              aiToolId: steps[index].aiToolId,
              promptContent: _resolvePromptContent(steps[index]),
            ),
          ),
      ],
    );
  }

  String? _resolveAiToolName(WorkflowStep step) {
    final aiToolId = step.aiToolId;
    if (aiToolId == null) {
      return null;
    }
    return toolsById[aiToolId]?.name ?? 'AIツール情報を取得できませんでした';
  }

  String? _resolvePromptContent(WorkflowStep step) {
    final promptTemplateId = step.promptTemplateId;
    if (promptTemplateId == null) {
      return null;
    }
    return templatesById[promptTemplateId]?.content ??
        'プロンプト情報を取得できませんでした';
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.step,
    required this.isLast,
    required this.aiToolName,
    required this.aiToolId,
    required this.promptContent,
  });

  final WorkflowStep step;
  final bool isLast;
  final String? aiToolName;
  final String? aiToolId;
  final String? promptContent;

  static const double _indicatorWidth = 40;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.s16),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: _indicatorWidth,
              child: Column(
                children: [
                  _StepIndicator(order: step.order),
                  if (!isLast)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.s4,
                        ),
                        child: Container(
                          width: 2,
                          color: AppColors.outline,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: WorkflowStepCard(
                step: step,
                aiToolId: aiToolId,
                aiToolName: aiToolName,
                promptContent: promptContent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.order});

  final int order;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(alpha: 0.1),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      child: Text(
        '$order',
        style: AppTypography.labelLarge.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
