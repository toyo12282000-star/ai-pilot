import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_content_layout.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_section_header.dart';
import 'package:ai_pilot/features/recommendation/domain/entities/recommendation.dart';
import 'package:ai_pilot/features/recommendation/presentation/providers/recommendation_providers.dart';
import 'package:ai_pilot/features/recommendation/presentation/widgets/recommendation_goal_card.dart';
import 'package:ai_pilot/shared/widgets/error_view.dart';

/// 「こんな人におすすめ」セクション。
class AiRecommendationSection extends ConsumerWidget {
  const AiRecommendationSection({
    super.key,
    required this.selectedRecommendationId,
    required this.onRecommendationSelected,
  });

  final String? selectedRecommendationId;
  final ValueChanged<Recommendation?> onRecommendationSelected;

  static const double _listHeight = RecommendationGoalCard.cardHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendationsAsync = ref.watch(recommendationsProvider);

    return recommendationsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => HomeContentLayout.constrain(
        context: context,
        child: ErrorView(
          title: 'おすすめの読み込みに失敗しました',
          description: '通信状況を確認して、もう一度お試しください',
          onRetry: () => ref.invalidate(recommendationsProvider),
          debugDetails: error,
        ),
      ),
      data: (recommendations) {
        if (recommendations.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeContentLayout.constrain(
              context: context,
              child: const HomeSectionHeader(title: 'こんな人におすすめ'),
            ),
            SizedBox(
              height: _listHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: HomeContentLayout.horizontalPadding(context),
                scrollCacheExtent: ScrollCacheExtent.pixels(360),
                itemCount: recommendations.length,
                itemBuilder: (context, index) {
                  final recommendation = recommendations[index];
                  final selected =
                      selectedRecommendationId == recommendation.id;

                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < recommendations.length - 1
                          ? AppSpacing.s12
                          : 0,
                    ),
                    child: RecommendationGoalCard(
                      recommendation: recommendation,
                      selected: selected,
                      onTap: () {
                        if (selected) {
                          onRecommendationSelected(null);
                        } else {
                          onRecommendationSelected(recommendation);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: HomeContentLayout.sectionSpacing(context)),
          ],
        );
      },
    );
  }
}
