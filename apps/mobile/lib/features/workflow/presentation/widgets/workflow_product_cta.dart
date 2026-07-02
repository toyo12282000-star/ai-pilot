import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/responsive.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';

/// Workflow 詳細の統一 CTA（Hero / 中間 / 最下部）。
class WorkflowProductCta extends StatelessWidget {
  const WorkflowProductCta({
    super.key,
    required this.onPressed,
    this.compact = false,
  });

  static const String label = '無料でこの作品を作る';

  final VoidCallback onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final height = compact ? 44.0 : (context.isMobile ? 48.0 : 52.0);

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          minimumSize: Size.fromHeight(height),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.s16,
            vertical: compact ? AppSpacing.s8 : AppSpacing.s12,
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.45),
          disabledForegroundColor: AppColors.surface.withValues(alpha: 0.85),
          textStyle: AppTypography.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: context.isMobile ? 15 : 16,
            color: AppColors.surface,
          ),
        ),
        child: const Text(label),
      ),
    );
  }
}
