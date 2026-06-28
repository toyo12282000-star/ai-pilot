import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';

/// 実行画面のヘッダー（タイトル + 進捗）。
class WorkflowRunHeader extends StatelessWidget {
  const WorkflowRunHeader({
    super.key,
    required this.workflowTitle,
    required this.currentStepNumber,
    required this.totalSteps,
    required this.progress,
  });

  final String workflowTitle;
  final int currentStepNumber;
  final int totalSteps;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          workflowTitle,
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.s16),
        Row(
          children: [
            Text(
              'Step $currentStepNumber',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              ' / $totalSteps',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s12),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.s4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: AppColors.outline,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
