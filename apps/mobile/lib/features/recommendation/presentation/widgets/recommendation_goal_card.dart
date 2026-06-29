import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/recommendation/domain/entities/recommendation.dart';
import 'package:ai_pilot/features/recommendation/presentation/widgets/recommendation_icon.dart';

/// AI おすすめ目的の横スクロールカード。
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
      child: Material(
        color: selected ? AppColors.primarySoft : AppColors.surface,
        borderRadius: AppRadius.card,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.card,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: AppRadius.card,
              border: Border.all(
                color: selected ? AppColors.primary.withValues(alpha: 0.28) : AppColors.border,
              ),
            ),
            child: Padding(
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
                      color: AppColors.surfaceMuted,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Icon(
                      icon,
                      size: 18,
                      color: selected ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  Text(
                    recommendation.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.titleSmall.copyWith(
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Expanded(
                    child: Text(
                      recommendation.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
