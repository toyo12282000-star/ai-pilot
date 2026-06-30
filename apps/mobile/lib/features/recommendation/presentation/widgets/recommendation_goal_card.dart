import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/recommendation/domain/entities/recommendation.dart';
import 'package:ai_pilot/features/recommendation/presentation/widgets/recommendation_icon.dart';
import 'package:ai_pilot/shared/widgets/hover_scale_surface.dart';

/// AI おすすめ目的の横スクロールカード（白背景 · Gold アクセント）。
class RecommendationGoalCard extends StatelessWidget {
  const RecommendationGoalCard({
    super.key,
    required this.recommendation,
    required this.selected,
    required this.onTap,
  });

  final Recommendation recommendation;
  final bool selected;
  final VoidCallback onTap;

  static const double cardWidth = 220;
  static const double cardHeight = 156;

  @override
  Widget build(BuildContext context) {
    final icon = recommendationIconFromName(recommendation.icon);

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: HoverScaleSurface(
        onTap: onTap,
        backgroundColor: AppColors.surface,
        borderColor: selected
            ? AppColors.primary
            : AppColors.border,
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primarySoft : AppColors.surfaceMuted,
                border: Border.all(
                  color: selected
                      ? AppColors.primary.withValues(alpha: 0.35)
                      : AppColors.border,
                ),
              ),
              child: Icon(
                icon,
                size: 18,
                color: selected ? AppColors.primary : AppColors.charcoal,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            Text(
              recommendation.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.titleSmall.copyWith(
                height: 1.35,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s4),
            Expanded(
              child: Text(
                recommendation.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.caption.copyWith(height: 1.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
