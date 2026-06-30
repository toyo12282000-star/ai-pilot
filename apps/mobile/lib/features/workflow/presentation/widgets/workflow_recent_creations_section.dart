import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/presentation/mock/workflow_product_page_mock_data.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_detail_layout.dart';

/// 「最近作られた作品」Social Proof セクション。
class WorkflowRecentCreationsSection extends StatelessWidget {
  const WorkflowRecentCreationsSection({
    super.key,
    required this.workflowId,
  });

  final String workflowId;

  @override
  Widget build(BuildContext context) {
    final items = recentCreationsForWorkflow(workflowId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WorkflowDetailSectionHeader(
          title: '最近作られた作品',
          subtitle: 'この Workflow で今も作品が作られています',
        ),
        const SizedBox(height: AppSpacing.s16),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.card,
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 1,
                    color: AppColors.border.withValues(alpha: 0.85),
                  ),
                _RecentCreationRow(item: items[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RecentCreationRow extends StatelessWidget {
  const _RecentCreationRow({required this.item});

  final WorkflowRecentCreation item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s12,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primarySoft,
            child: Text(
              item.userLabel.isNotEmpty ? item.userLabel[0] : '?',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.userLabel,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  item.timeLabel,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.check_circle_outline_rounded,
            size: 18,
            color: AppColors.success.withValues(alpha: 0.85),
          ),
        ],
      ),
    );
  }
}
