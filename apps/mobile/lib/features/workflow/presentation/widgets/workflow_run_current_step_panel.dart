import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_step.dart';

/// Run 画面の現在ステップ詳細（Goal / 完成条件 / Tips）。
class WorkflowRunCurrentStepPanel extends StatelessWidget {
  const WorkflowRunCurrentStepPanel({
    super.key,
    required this.step,
  });

  final WorkflowStep step;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.large,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StepBadge(order: step.order),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Text(
                  step.title,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (step.instruction.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s12),
            Text(
              step.instruction,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.s24),
          if (step.goal != null && step.goal!.isNotEmpty)
            _Section(
              title: 'Goal',
              child: Text(
                step.goal!,
                style: AppTypography.bodyMedium.copyWith(height: 1.55),
              ),
            ),
          if (step.completionCriteria != null &&
              step.completionCriteria!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s16),
            _Section(
              title: '完成条件',
              child: Text(
                step.completionCriteria!,
                style: AppTypography.bodyMedium.copyWith(height: 1.55),
              ),
            ),
          ],
          if (step.tips.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s16),
            _Section(
              title: 'Tips',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final tip in step.tips)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.s8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.lightbulb_outline_rounded,
                            size: 16,
                            color: AppColors.primary.withValues(alpha: 0.75),
                          ),
                          const SizedBox(width: AppSpacing.s8),
                          Expanded(
                            child: Text(
                              tip,
                              style: AppTypography.bodySmall.copyWith(
                                height: 1.55,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StepBadge extends StatelessWidget {
  const _StepBadge({required this.order});

  final int order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s8,
      ),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: AppRadius.pill,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Text(
        'Step $order',
        style: AppTypography.labelMedium.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        child,
      ],
    );
  }
}
