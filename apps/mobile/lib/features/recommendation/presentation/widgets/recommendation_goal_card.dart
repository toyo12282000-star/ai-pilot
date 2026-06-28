import 'package:flutter/material.dart';

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
    final accentColor = recommendationColorFromHex(recommendation.color);
    final icon = recommendationIconFromName(recommendation.icon);

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Material(
        color: selected
            ? accentColor.withValues(alpha: 0.12)
            : accentColor.withValues(alpha: 0.06),
        borderRadius: AppRadius.large,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.large,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: AppRadius.large,
              border: Border.all(
                color: selected
                    ? accentColor.withValues(alpha: 0.45)
                    : accentColor.withValues(alpha: 0.18),
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor.withValues(alpha: 0.14),
                    ),
                    child: Icon(
                      icon,
                      size: 22,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  Text(
                    recommendation.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.titleSmall.copyWith(
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Expanded(
                    child: Text(
                      recommendation.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        color: accentColor.withValues(alpha: 0.85),
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
