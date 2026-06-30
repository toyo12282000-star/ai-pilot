import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_product_cta.dart';

/// 中間 / 最下部用 CTA ブロック。
class WorkflowProductCtaSection extends StatelessWidget {
  const WorkflowProductCtaSection({
    super.key,
    required this.onPressed,
    this.subtitle,
    this.compact = false,
  });

  final VoidCallback onPressed;
  final String? subtitle;
  final bool compact;

  @override
  Widget build(BuildContext context) {
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
            if (subtitle != null) ...[
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
            ],
            WorkflowProductCta(
              onPressed: onPressed,
              compact: compact,
            ),
          ],
        ),
      ),
    );
  }
}
