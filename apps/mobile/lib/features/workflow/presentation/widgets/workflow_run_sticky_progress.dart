import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';

/// Run 画面上部に固定する進捗バー（スクロールしても残る）。
class WorkflowRunStickyProgress extends StatelessWidget {
  const WorkflowRunStickyProgress({
    super.key,
    required this.currentStepIndex,
    required this.totalSteps,
    this.remainingMinutes,
  });

  final int currentStepIndex;
  final int totalSteps;
  final int? remainingMinutes;

  double get _completionRate {
    if (totalSteps <= 0) {
      return 0;
    }
    return ((currentStepIndex + 1) / totalSteps).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final rate = _completionRate;
    final percent = (rate * 100).round();
    final stepNumber = (currentStepIndex + 1).clamp(1, totalSteps);

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s16,
            AppSpacing.s12,
            AppSpacing.s16,
            AppSpacing.s12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(
                    '完成まで',
                    style: AppTypography.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$percent%',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s12),
              _SegmentedProgressBar(filledRatio: rate),
              const SizedBox(height: AppSpacing.s8),
              Row(
                children: [
                  Text(
                    'Step$stepNumber / $totalSteps',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (remainingMinutes != null) ...[
                    const Spacer(),
                    Text(
                      '残り約$remainingMinutes分',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SegmentedProgressBar extends StatelessWidget {
  const _SegmentedProgressBar({required this.filledRatio});

  final double filledRatio;

  static const int _segmentCount = 8;

  @override
  Widget build(BuildContext context) {
    final filledSegments =
        (filledRatio * _segmentCount).round().clamp(0, _segmentCount);

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
