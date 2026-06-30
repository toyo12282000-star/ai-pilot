import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/presentation/mock/workflow_product_page_mock_data.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_detail_layout.dart';

/// Before → After 比較セクション。
class WorkflowBeforeAfterSection extends StatelessWidget {
  const WorkflowBeforeAfterSection({
    super.key,
    required this.workflowId,
  });

  final String workflowId;

  @override
  Widget build(BuildContext context) {
    final pairs = beforeAfterPairsForWorkflow(workflowId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WorkflowDetailSectionHeader(
          title: 'Before → After',
          subtitle: 'この Workflow でどう変わるか',
        ),
        const SizedBox(height: AppSpacing.s16),
        Column(
          children: [
            for (var i = 0; i < pairs.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.s12),
              _BeforeAfterCard(pair: pairs[i]),
            ],
          ],
        ),
      ],
    );
  }
}

class _BeforeAfterCard extends StatelessWidget {
  const _BeforeAfterCard({required this.pair});

  final WorkflowBeforeAfterPair pair;

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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _BeforeAfterColumn(
                label: 'Before',
                text: pair.before,
                muted: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 20,
                color: AppColors.primary,
              ),
            ),
            Expanded(
              child: _BeforeAfterColumn(
                label: 'After',
                text: pair.after,
                muted: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BeforeAfterColumn extends StatelessWidget {
  const _BeforeAfterColumn({
    required this.label,
    required this.text,
    required this.muted,
  });

  final String label;
  final String text;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: muted ? AppColors.muted : AppColors.primary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        Text(
          text,
          style: AppTypography.bodyMedium.copyWith(
            color: muted ? AppColors.textSecondary : AppColors.textPrimary,
            fontWeight: muted ? FontWeight.w400 : FontWeight.w600,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
