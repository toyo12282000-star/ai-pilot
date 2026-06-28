import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/shared/widgets/skeleton_list_view.dart';

/// Advisor の提案中ローディング表示。
class AdvisorLoadingSection extends StatelessWidget {
  const AdvisorLoadingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.pageHorizontal.copyWith(top: AppSpacing.s8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Text(
                  'AI Pilotが最適なWorkflowを探しています...',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s16),
          const SkeletonListView(
            itemCount: 2,
            showSectionHeader: false,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
