import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';

/// Run 完了後に表示する完成画面（Mock UI）。
class WorkflowRunCompletionScreen extends StatelessWidget {
  const WorkflowRunCompletionScreen({
    super.key,
    required this.workflowTitle,
    required this.onSave,
    required this.onViewOutcome,
    required this.onCreateAnother,
    required this.onGoHome,
  });

  final String workflowTitle;
  final VoidCallback onSave;
  final VoidCallback onViewOutcome;
  final VoidCallback onCreateAnother;
  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.35),
                ),
              ),
              child: Icon(
                Icons.celebration_rounded,
                size: 36,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            Text(
              '完成しました！',
              style: AppTypography.headlineSmall.copyWith(
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s12),
            Text(
              workflowTitle,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s32),
            _ActionButton(
              label: '保存',
              icon: Icons.bookmark_outline_rounded,
              onPressed: onSave,
              filled: true,
            ),
            const SizedBox(height: AppSpacing.s12),
            _ActionButton(
              label: '完成作品を見る',
              icon: Icons.play_circle_outline_rounded,
              onPressed: onViewOutcome,
            ),
            const SizedBox(height: AppSpacing.s12),
            _ActionButton(
              label: 'もう一作品作る',
              icon: Icons.add_circle_outline_rounded,
              onPressed: onCreateAnother,
            ),
            const SizedBox(height: AppSpacing.s12),
            _ActionButton(
              label: 'Homeへ戻る',
              icon: Icons.home_outlined,
              onPressed: onGoHome,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.filled = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: filled
          ? FilledButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 20),
              label: Text(label),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.s16),
              ),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 20),
              label: Text(label),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.s16),
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.medium,
                ),
              ),
            ),
    );
  }
}
