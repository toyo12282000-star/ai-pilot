import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_step.dart';

/// 今後のステップを折りたたみ表示する。
class WorkflowRunUpcomingSteps extends StatelessWidget {
  const WorkflowRunUpcomingSteps({
    super.key,
    required this.steps,
    required this.currentStepIndex,
  });

  final List<WorkflowStep> steps;
  final int currentStepIndex;

  @override
  Widget build(BuildContext context) {
    final upcoming = <WorkflowStep>[];
    for (var i = currentStepIndex + 1; i < steps.length; i++) {
      upcoming.add(steps[i]);
    }

    if (upcoming.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'このあとのステップ',
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.s12),
        for (final step in upcoming)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s8),
            child: _CollapsedStepTile(step: step),
          ),
      ],
    );
  }
}

class _CollapsedStepTile extends StatelessWidget {
  const _CollapsedStepTile({required this.step});

  final WorkflowStep step;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: AppColors.surfaceMuted,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s16,
              vertical: AppSpacing.s4,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(
              AppSpacing.s16,
              0,
              AppSpacing.s16,
              AppSpacing.s16,
            ),
            leading: Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.small,
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                '${step.order}',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            title: Text(
              step.title,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: step.goal != null
                ? Text(
                    step.goal!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.muted,
                    ),
                  )
                : null,
            children: [
              if (step.instruction.isNotEmpty)
                Text(
                  step.instruction,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.55,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
