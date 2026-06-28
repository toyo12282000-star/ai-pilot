import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_section_header.dart';
import 'package:ai_pilot/features/recommendation/domain/entities/recommendation.dart';
import 'package:ai_pilot/features/recommendation/presentation/providers/recommendation_providers.dart';
import 'package:ai_pilot/features/recommendation/presentation/widgets/recommendation_goal_card.dart';
import 'package:ai_pilot/shared/widgets/error_view.dart';

/// 「何をしたいですか？」AI おすすめ目的セクション。
class AiRecommendationSection extends ConsumerWidget {
  const AiRecommendationSection({
    super.key,
    required this.selectedRecommendationId,
    required this.onRecommendationSelected,
  });

  final String? selectedRecommendationId;
  final ValueChanged<Recommendation?> onRecommendationSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendationsAsync = ref.watch(recommendationsProvider);

    return recommendationsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => Padding(
        padding: AppSpacing.pageHorizontal,
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
            const HomeSectionHeader(title: '何をしたいですか？'),
            SizedBox(
              height: RecommendationGoalCard.cardHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: AppSpacing.pageHorizontal,
                itemCount: recommendations.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.s12),
                itemBuilder: (context, index) {
                  final recommendation = recommendations[index];
                  final selected =
                      selectedRecommendationId == recommendation.id;

                  return RecommendationGoalCard(
                    recommendation: recommendation,
                    selected: selected,
                    onTap: () {
                      if (selected) {
                        onRecommendationSelected(null);
                      } else {
                        onRecommendationSelected(recommendation);
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
          ],
        );
      },
    );
  }
}
