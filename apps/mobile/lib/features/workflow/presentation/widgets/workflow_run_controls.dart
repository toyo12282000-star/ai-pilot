import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/responsive.dart';
import 'package:ai_pilot/design_system/spacing.dart';

/// 実行画面の操作ボタン（前へ / 次へ / 完了）。
class WorkflowRunControls extends StatelessWidget {
  const WorkflowRunControls({
    super.key,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.isLastStep,
    required this.onPrevious,
    required this.onNext,
    required this.onComplete,
  });

  final bool canGoPrevious;
  final bool canGoNext;
  final bool isLastStep;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final buttonHeight = context.isMobile ? 48.0 : 44.0;

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s16,
            AppSpacing.s8,
            AppSpacing.s16,
            AppSpacing.s8,
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: canGoPrevious ? onPrevious : null,
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.fromHeight(buttonHeight),
                    foregroundColor: AppColors.primary,
                    disabledForegroundColor: AppColors.muted,
                  ),
                  child: const Text('前へ'),
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                flex: 2,
                child: isLastStep
                    ? FilledButton(
                        onPressed: onComplete,
                        style: FilledButton.styleFrom(
                          minimumSize: Size.fromHeight(buttonHeight),
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.surface,
                          disabledBackgroundColor:
                              AppColors.primary.withValues(alpha: 0.45),
                          disabledForegroundColor:
                              AppColors.surface.withValues(alpha: 0.85),
                        ),
                        child: const Text('完了'),
                      )
                    : FilledButton(
                        onPressed: canGoNext ? onNext : null,
                        style: FilledButton.styleFrom(
                          minimumSize: Size.fromHeight(buttonHeight),
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.surface,
                          disabledBackgroundColor:
                              AppColors.primary.withValues(alpha: 0.45),
                          disabledForegroundColor:
                              AppColors.surface.withValues(alpha: 0.85),
                        ),
                        child: const Text('次へ'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
