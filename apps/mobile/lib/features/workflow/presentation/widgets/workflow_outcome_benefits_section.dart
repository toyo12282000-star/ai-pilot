import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/presentation/mock/workflow_product_page_mock_data.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_detail_layout.dart';

/// 「この Workflow で完成すると」成果物メリットセクション。
class WorkflowOutcomeBenefitsSection extends StatelessWidget {
  const WorkflowOutcomeBenefitsSection({
    super.key,
    required this.workflowId,
  });

  final String workflowId;

  @override
  Widget build(BuildContext context) {
    final benefits = outcomeBenefitsForWorkflow(workflowId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WorkflowDetailSectionHeader(
          title: 'このWorkflowで完成すると',
          subtitle: '完成後に手に入る成果をチェック',
        ),
        const SizedBox(height: AppSpacing.s16),
        LayoutBuilder(
          builder: (context, constraints) {
            final twoColumns = constraints.maxWidth >= 520;
            final cardWidth = twoColumns
                ? (constraints.maxWidth - AppSpacing.s12) / 2
                : constraints.maxWidth;

            return Wrap(
              spacing: AppSpacing.s12,
              runSpacing: AppSpacing.s12,
              children: [
                for (final benefit in benefits)
                  SizedBox(
                    width: cardWidth,
                    child: _BenefitCard(label: benefit),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({required this.label});

  final String label;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.25),
                ),
              ),
              child: Icon(
                Icons.check_rounded,
                size: 14,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
