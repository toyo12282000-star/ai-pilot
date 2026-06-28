import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
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
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.outline),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s16,
            AppSpacing.s12,
            AppSpacing.s16,
            AppSpacing.s12,
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: canGoPrevious ? onPrevious : null,
                  child: const Text('前へ'),
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                flex: 2,
                child: isLastStep
                    ? FilledButton(
                        onPressed: onComplete,
                        child: const Text('完了'),
                      )
                    : FilledButton(
                        onPressed: canGoNext ? onNext : null,
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
