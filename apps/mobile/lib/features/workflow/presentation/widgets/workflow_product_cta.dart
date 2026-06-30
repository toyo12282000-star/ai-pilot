import 'package:flutter/material.dart';

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
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          minimumSize: Size.fromHeight(compact ? 44 : 52),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.s16,
            vertical: compact ? AppSpacing.s8 : AppSpacing.s12,
          ),
          textStyle: AppTypography.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        child: const Text(label),
      ),
    );
  }
}
