import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/shared/widgets/hero_gradient_card.dart';
import 'package:ai_pilot/shared/widgets/skeleton_box.dart';

/// ワークフロー一覧カード形状の Skeleton。
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.outline),
        color: AppColors.surface,
      ),
      child: const Padding(
        padding: EdgeInsets.all(AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: SkeletonBox(height: 20, borderRadius: AppRadius.small),
                ),
                SizedBox(width: AppSpacing.s8),
                SkeletonBox(
                  width: 24,
                  height: 24,
                  borderRadius: AppRadius.small,
                ),
              ],
            ),
            SizedBox(height: AppSpacing.s8),
            SkeletonBox(height: 14, borderRadius: AppRadius.small),
            SizedBox(height: AppSpacing.s8),
            SkeletonBox(
              width: 220,
              height: 14,
              borderRadius: AppRadius.small,
            ),
            SizedBox(height: AppSpacing.s16),
            Row(
              children: [
                SkeletonBox(
                  width: 72,
                  height: 24,
                  borderRadius: AppRadius.pill,
                ),
                SizedBox(width: AppSpacing.s8),
                SkeletonBox(
                  width: 88,
                  height: 24,
                  borderRadius: AppRadius.pill,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// HeroGradientCard 形状の Skeleton（Workflow / AIツール詳細用）。
class SkeletonHeroCard extends StatelessWidget {
  const SkeletonHeroCard({
    super.key,
    this.compact = false,
  });

  /// AIツール詳細向けのコンパクト版。
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return HeroGradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (compact) ...[
                const SkeletonBox(
                  width: 48,
                  height: 48,
                  borderRadius: AppRadius.medium,
                ),
                const SizedBox(width: AppSpacing.s16),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(
                      height: compact ? 22 : 26,
                      borderRadius: AppRadius.small,
                    ),
                    SizedBox(height: compact ? AppSpacing.s8 : AppSpacing.s12),
                    SkeletonBox(
                      width: compact ? 80 : 120,
                      height: 20,
                      borderRadius: AppRadius.pill,
                    ),
                  ],
                ),
              ),
              if (!compact)
                const SkeletonBox(
                  width: 36,
                  height: 36,
                  borderRadius: AppRadius.medium,
                ),
            ],
          ),
          SizedBox(height: compact ? AppSpacing.s16 : AppSpacing.s12),
          const SkeletonBox(height: 14, borderRadius: AppRadius.small),
          const SizedBox(height: AppSpacing.s8),
          SkeletonBox(
            width: compact ? 200 : double.infinity,
            height: 14,
            borderRadius: AppRadius.small,
          ),
          if (!compact) ...[
            const SizedBox(height: AppSpacing.s16),
            const Row(
              children: [
                SkeletonBox(
                  width: 72,
                  height: 24,
                  borderRadius: AppRadius.pill,
                ),
                SizedBox(width: AppSpacing.s8),
                SkeletonBox(
                  width: 88,
                  height: 24,
                  borderRadius: AppRadius.pill,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// 完成作品カード形状の Skeleton。
class SkeletonShowcaseCard extends StatelessWidget {
  const SkeletonShowcaseCard({super.key});

  static const double cardWidth = 340;
  static const double imageHeight = cardWidth * 10 / 16;
  static const double bodyExtent = 220;

  /// [ShowcaseCard.listExtent] と同じ高さ。
  static double get listExtent => imageHeight + bodyExtent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: AppRadius.card,
          border: Border.all(color: AppColors.border),
          color: AppColors.surface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.r20),
              ),
              child: SkeletonBox(
                height: imageHeight,
                borderRadius: AppRadius.small,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(AppSpacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(
                    width: 48,
                    height: 10,
                    borderRadius: AppRadius.small,
                  ),
                  SizedBox(height: AppSpacing.s8),
                  SkeletonBox(height: 14, borderRadius: AppRadius.small),
                  SizedBox(height: AppSpacing.s8),
                  SkeletonBox(height: 16, borderRadius: AppRadius.small),
                  SizedBox(height: AppSpacing.s8),
                  SkeletonBox(
                    width: 120,
                    height: 12,
                    borderRadius: AppRadius.small,
                  ),
                  SizedBox(height: AppSpacing.s12),
                  SkeletonBox(
                    width: 72,
                    height: 32,
                    borderRadius: AppRadius.pill,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 完成作品セクション形状の Skeleton。
class SkeletonShowcaseSection extends StatelessWidget {
  const SkeletonShowcaseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s16,
            0,
            AppSpacing.s16,
            AppSpacing.s16,
          ),
          child: SkeletonBox(
            width: 180,
            height: 18,
            borderRadius: AppRadius.small,
          ),
        ),
        SizedBox(
          height: SkeletonShowcaseCard.listExtent,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: AppSpacing.pageHorizontal,
            itemCount: 3,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.s12),
            itemBuilder: (_, _) => const SkeletonShowcaseCard(),
          ),
        ),
        const SizedBox(height: AppSpacing.section),
      ],
    );
  }
}

/// ホーム Hero セクション形状の Skeleton。
class SkeletonHomeHero extends StatelessWidget {
  const SkeletonHomeHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.hero,
        AppSpacing.s16,
        AppSpacing.section,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: AppRadius.hero,
          border: Border.all(color: AppColors.border),
          color: AppColors.surface,
        ),
        child: const Padding(
          padding: EdgeInsets.all(AppSpacing.card),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SkeletonBox(
                width: 260,
                height: 32,
                borderRadius: AppRadius.small,
              ),
              SizedBox(height: AppSpacing.s12),
              SkeletonBox(height: 14, borderRadius: AppRadius.small),
              SizedBox(height: AppSpacing.s8),
              SkeletonBox(height: 14, borderRadius: AppRadius.small),
              SizedBox(height: AppSpacing.s24),
              SkeletonBox(
                height: 48,
                borderRadius: AppRadius.pill,
              ),
              SizedBox(height: AppSpacing.s12),
              SkeletonBox(
                height: 48,
                borderRadius: AppRadius.pill,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// お気に入り Hero セクション形状の Skeleton。
class SkeletonFavoritesHero extends StatelessWidget {
  const SkeletonFavoritesHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s16,
        AppSpacing.s16,
        AppSpacing.s8,
      ),
      child: HeroGradientCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(
              width: 200,
              height: 26,
              borderRadius: AppRadius.small,
            ),
            const SizedBox(height: AppSpacing.s8),
            SkeletonBox(height: 14, borderRadius: AppRadius.small),
            const SizedBox(height: AppSpacing.s8),
            SkeletonBox(
              width: 260,
              height: 14,
              borderRadius: AppRadius.small,
            ),
            const SizedBox(height: AppSpacing.s16),
            SkeletonBox(
              width: 56,
              height: 24,
              borderRadius: AppRadius.pill,
            ),
          ],
        ),
      ),
    );
  }
}

/// カテゴリチップ行の Skeleton。
class SkeletonChipRow extends StatelessWidget {
  const SkeletonChipRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: AppSpacing.pageHorizontal,
      child: Row(
        children: [
          for (var index = 0; index < 6; index++) ...[
            if (index > 0) const SizedBox(width: AppSpacing.s8),
            SkeletonBox(
              width: index == 0 ? 56 : 64 + index * 6.0,
              height: 40,
              borderRadius: AppRadius.pill,
            ),
          ],
        ],
      ),
    );
  }
}

/// ホームカテゴリセクション形状の Skeleton。
class SkeletonHomeCategorySection extends StatelessWidget {
  const SkeletonHomeCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.s16,
            0,
            AppSpacing.s16,
            AppSpacing.s16,
          ),
          child: SkeletonBox(
            width: 72,
            height: 18,
            borderRadius: AppRadius.small,
          ),
        ),
        SkeletonChipRow(),
        SizedBox(height: AppSpacing.s32),
      ],
    );
  }
}

/// ホーム AI 相談カード形状の Skeleton。
class SkeletonHomeAdvisorSection extends StatelessWidget {
  const SkeletonHomeAdvisorSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.pageHorizontal,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: AppRadius.card,
          border: Border.all(color: AppColors.border),
          color: AppColors.surface,
        ),
        child: const Padding(
          padding: EdgeInsets.all(AppSpacing.card),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SkeletonBox(height: 18, borderRadius: AppRadius.small),
              SizedBox(height: AppSpacing.s8),
              SkeletonBox(height: 14, borderRadius: AppRadius.small),
              SizedBox(height: AppSpacing.s16),
              SkeletonBox(height: 44, borderRadius: AppRadius.pill),
            ],
          ),
        ),
      ),
    );
  }
}

/// ホームおすすめセクション形状の Skeleton。
class SkeletonHomeRecommendationSection extends StatelessWidget {
  const SkeletonHomeRecommendationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.s16,
            AppSpacing.s32,
            AppSpacing.s16,
            AppSpacing.s16,
          ),
          child: SkeletonBox(
            width: 160,
            height: 18,
            borderRadius: AppRadius.small,
          ),
        ),
        SkeletonChipRow(),
      ],
    );
  }
}

/// ホーム Workflow 一覧形状の Skeleton。
class SkeletonHomeWorkflowSection extends StatelessWidget {
  const SkeletonHomeWorkflowSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s32,
        AppSpacing.s16,
        0,
      ),
      child: Column(
        children: [
          const SkeletonBox(
            width: 140,
            height: 18,
            borderRadius: AppRadius.small,
          ),
          const SizedBox(height: AppSpacing.s16),
          for (var i = 0; i < 3; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.s12),
            const SkeletonCard(),
          ],
        ],
      ),
    );
  }
}

/// ワークフロー詳細のステップタイムライン Skeleton。
class SkeletonStepTimeline extends StatelessWidget {
  const SkeletonStepTimeline({
    super.key,
    this.stepCount = 3,
  });

  final int stepCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonBox(
          width: 72,
          height: 20,
          borderRadius: AppRadius.small,
        ),
        const SizedBox(height: AppSpacing.s16),
        for (var index = 0; index < stepCount; index++) ...[
          if (index > 0) const SizedBox(height: AppSpacing.s16),
          _SkeletonTimelineRow(isLast: index == stepCount - 1),
        ],
      ],
    );
  }
}

class _SkeletonTimelineRow extends StatelessWidget {
  const _SkeletonTimelineRow({required this.isLast});

  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const SkeletonBox(
                width: 28,
                height: 28,
                borderRadius: AppRadius.pill,
              ),
              if (!isLast)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.s4),
                    child: SkeletonBox(
                      width: 2,
                      borderRadius: AppRadius.small,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: AppRadius.large,
                border: Border.all(color: AppColors.outline),
                color: AppColors.surface,
              ),
              child: const Padding(
                padding: EdgeInsets.all(AppSpacing.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(height: 18, borderRadius: AppRadius.small),
                    SizedBox(height: AppSpacing.s12),
                    SkeletonBox(height: 14, borderRadius: AppRadius.small),
                    SizedBox(height: AppSpacing.s8),
                    SkeletonBox(
                      width: 180,
                      height: 14,
                      borderRadius: AppRadius.small,
                    ),
                    SizedBox(height: AppSpacing.s16),
                    SkeletonBox(
                      height: 64,
                      borderRadius: AppRadius.medium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 実行画面のヘッダー + ステップカード Skeleton。
class SkeletonRunStepSection extends StatelessWidget {
  const SkeletonRunStepSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonBox(height: 14, borderRadius: AppRadius.small),
        const SizedBox(height: AppSpacing.s8),
        SkeletonBox(height: 22, borderRadius: AppRadius.small),
        const SizedBox(height: AppSpacing.s12),
        SkeletonBox(
          height: 6,
          borderRadius: AppRadius.pill,
        ),
        const SizedBox(height: AppSpacing.s24),
        HeroGradientCard(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(height: 24, borderRadius: AppRadius.small),
              SizedBox(height: AppSpacing.s16),
              SkeletonBox(height: 16, borderRadius: AppRadius.small),
              SizedBox(height: AppSpacing.s8),
              SkeletonBox(height: 16, borderRadius: AppRadius.small),
              SizedBox(height: AppSpacing.s8),
              SkeletonBox(
                width: 220,
                height: 16,
                borderRadius: AppRadius.small,
              ),
              SizedBox(height: AppSpacing.s24),
              SkeletonBox(
                width: 88,
                height: 14,
                borderRadius: AppRadius.small,
              ),
              SizedBox(height: AppSpacing.s12),
              SkeletonBox(
                height: 44,
                borderRadius: AppRadius.medium,
              ),
              SizedBox(height: AppSpacing.s24),
              SkeletonBox(
                width: 96,
                height: 14,
                borderRadius: AppRadius.small,
              ),
              SizedBox(height: AppSpacing.s12),
              SkeletonBox(
                height: 120,
                borderRadius: AppRadius.medium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Workflow 詳細 Hero 形状の Skeleton。
class SkeletonWorkflowDetailHero extends StatelessWidget {
  const SkeletonWorkflowDetailHero({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SkeletonBox(
          height: compact ? 120 : 220,
          borderRadius: AppRadius.large,
        ),
        SizedBox(height: compact ? AppSpacing.s16 : AppSpacing.s24),
        const SkeletonBox(height: 14, borderRadius: AppRadius.small),
        const SizedBox(height: AppSpacing.s8),
        SkeletonBox(
          height: compact ? 22 : 28,
          borderRadius: AppRadius.small,
        ),
        const SizedBox(height: AppSpacing.s12),
        const SkeletonBox(height: 14, borderRadius: AppRadius.small),
        const SizedBox(height: AppSpacing.s8),
        SkeletonBox(
          width: compact ? 200 : double.infinity,
          height: 14,
          borderRadius: AppRadius.small,
        ),
        const SizedBox(height: AppSpacing.s16),
        const Row(
          children: [
            SkeletonBox(
              width: 72,
              height: 24,
              borderRadius: AppRadius.pill,
            ),
            SizedBox(width: AppSpacing.s8),
            SkeletonBox(
              width: 88,
              height: 24,
              borderRadius: AppRadius.pill,
            ),
          ],
        ),
        if (!compact) ...[
          const SizedBox(height: AppSpacing.s24),
          SkeletonBox(
            height: 52,
            borderRadius: AppRadius.medium,
          ),
        ],
      ],
    );
  }
}

/// Workflow 詳細ギャラリー形状の Skeleton。
class SkeletonWorkflowDetailGallery extends StatelessWidget {
  const SkeletonWorkflowDetailGallery({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    if (isMobile) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.s12,
          mainAxisSpacing: AppSpacing.s12,
          childAspectRatio: 0.92,
        ),
        itemCount: 4,
        itemBuilder: (_, _) => DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: AppRadius.medium,
            border: Border.all(color: AppColors.outline.withValues(alpha: 0.45)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              Expanded(
                child: SkeletonBox(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(AppSpacing.s8),
                child: SkeletonBox(
                  height: 12,
                  borderRadius: AppRadius.small,
                ),
              ),
            ],
          ),
        ),
      );
    }

    const tileWidth = 220.0;
    const tileHeight = 280.0;

    return SizedBox(
      height: tileHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.s12),
        itemBuilder: (_, _) => SizedBox(
          width: tileWidth,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: AppRadius.large,
              border: Border.all(color: AppColors.outline.withValues(alpha: 0.55)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                Expanded(
                  child: SkeletonBox(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(AppSpacing.s12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonBox(
                        height: 14,
                        borderRadius: AppRadius.small,
                      ),
                      SizedBox(height: AppSpacing.s8),
                      SkeletonBox(
                        height: 12,
                        borderRadius: AppRadius.small,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Workflow 詳細ステップ一覧形状の Skeleton。
class SkeletonWorkflowDetailSteps extends StatelessWidget {
  const SkeletonWorkflowDetailSteps({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SkeletonBox(height: 120, borderRadius: AppRadius.large),
        SizedBox(height: AppSpacing.s12),
        SkeletonBox(height: 120, borderRadius: AppRadius.large),
        SizedBox(height: AppSpacing.s12),
        SkeletonBox(height: 120, borderRadius: AppRadius.large),
      ],
    );
  }
}
