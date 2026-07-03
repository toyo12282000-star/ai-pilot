import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_content_layout.dart';

/// Home 下部の β版フィードバック導線。
class HomeFeedbackSection extends StatelessWidget {
  const HomeFeedbackSection({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeContentLayout.constrain(
      context: context,
      child: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.s8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: AppRadius.large,
            border: Border.all(color: AppColors.border),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.push('/beta-feedback'),
              borderRadius: AppRadius.large,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Row(
                  children: [
                    Icon(
                      Icons.feedback_outlined,
                      color: AppColors.primary.withValues(alpha: 0.85),
                    ),
                    const SizedBox(width: AppSpacing.s12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'β版の感想・要望を送る',
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.s4),
                          Text(
                            '不具合報告や欲しい Workflow のリクエストも歓迎です',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
