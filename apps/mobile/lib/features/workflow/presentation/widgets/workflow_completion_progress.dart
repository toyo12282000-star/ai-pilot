import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';

/// Workflow 実行中の進捗表示（Sprint 14.0 · UI のみ · 機能未接続）。
class WorkflowCompletionProgress extends StatelessWidget {
  const WorkflowCompletionProgress({
    super.key,
    required this.steps,
    required this.currentStepIndex,
  });

  final List<String> steps;
  final int currentStepIndex;

  double get _completionRate {
    if (steps.isEmpty) {
      return 0;
    }
    return ((currentStepIndex + 1) / steps.length).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final rate = _completionRate;
    final percent = (rate * 100).round();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  '進捗',
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  '$percent% 完了',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s16),
            _ProgressBar(filledRatio: rate),
            const SizedBox(height: AppSpacing.s16),
            Wrap(
              spacing: AppSpacing.s8,
              runSpacing: AppSpacing.s8,
              children: [
                for (var i = 0; i < steps.length; i++)
                  _StepChip(
                    label: steps[i],
                    index: i,
                    isCurrent: i == currentStepIndex,
                    isCompleted: i < currentStepIndex,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.filledRatio});

  final double filledRatio;

  static const int _segmentCount = 8;

  @override
  Widget build(BuildContext context) {
    final filledSegments = (filledRatio * _segmentCount).round().clamp(0, _segmentCount);

    return Row(
      children: [
        for (var i = 0; i < _segmentCount; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.s4),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 8,
              decoration: BoxDecoration(
                color: i < filledSegments
                    ? AppColors.primary
                    : AppColors.surfaceMuted,
                borderRadius: AppRadius.small,
                border: Border.all(
                  color: i < filledSegments
                      ? AppColors.primary.withValues(alpha: 0.4)
                      : AppColors.border,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _StepChip extends StatelessWidget {
  const _StepChip({
    required this.label,
    required this.index,
    required this.isCurrent,
    required this.isCompleted,
  });

  final String label;
  final int index;
  final bool isCurrent;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isCurrent
        ? AppColors.primarySoft
        : isCompleted
            ? AppColors.surfaceMuted
            : AppColors.surface;
    final borderColor = isCurrent
        ? AppColors.primary
        : isCompleted
            ? AppColors.border
            : AppColors.border;
    final textColor = isCurrent
        ? AppColors.primary
        : isCompleted
            ? AppColors.textSecondary
            : AppColors.muted;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s8,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.pill,
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: AppTypography.labelMedium.copyWith(
          color: textColor,
          fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }
}
