import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_content_layout.dart';
import 'package:ai_pilot/shared/widgets/hover_scale_surface.dart';

/// 「Advisor 相談」誘導カードセクション。
class HomeAdvisorSection extends StatelessWidget {
  const HomeAdvisorSection({
    super.key,
    required this.onAdvisorTap,
    this.showFirstTimeHint = false,
  });

  final VoidCallback onAdvisorTap;
  final bool showFirstTimeHint;

  @override
  Widget build(BuildContext context) {
    return HomeContentLayout.constrain(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HoverScaleSurface(
            padding: const EdgeInsets.all(AppSpacing.card),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showFirstTimeHint) ...[
                  Text(
                    'おすすめの次の一歩',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                ],
                Text(
                  '何を作ればいいか迷っていますか？',
                  style: AppTypography.titleMedium.copyWith(
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  '何を作るか迷ったら、Advisorが目的に合うWorkflowを案内します',
                  style: AppTypography.caption.copyWith(height: 1.5),
                ),
                const SizedBox(height: AppSpacing.s16),
                OutlinedButton.icon(
                  onPressed: onAdvisorTap,
                  icon: const Icon(
                    Icons.auto_awesome_outlined,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  label: const Text('Advisorに相談する'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.charcoal,
                    side: const BorderSide(color: AppColors.primary),
                    backgroundColor: AppColors.surface,
                    minimumSize: const Size.fromHeight(44),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: HomeContentLayout.sectionSpacing(context)),
        ],
      ),
    );
  }
}
