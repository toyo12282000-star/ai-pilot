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

/// ホーム Hero セクション形状の Skeleton。
class SkeletonHomeHero extends StatelessWidget {
  const SkeletonHomeHero({super.key});

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
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s24,
          AppSpacing.s32,
          AppSpacing.s24,
          AppSpacing.s24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(
              width: 240,
              height: 26,
              borderRadius: AppRadius.small,
            ),
            const SizedBox(height: AppSpacing.s8),
            SkeletonBox(height: 14, borderRadius: AppRadius.small),
            const SizedBox(height: AppSpacing.s8),
            SkeletonBox(
              width: 280,
              height: 14,
              borderRadius: AppRadius.small,
            ),
            const SizedBox(height: AppSpacing.s24),
            SkeletonBox(
              height: 48,
              borderRadius: AppRadius.medium,
            ),
            const SizedBox(height: AppSpacing.s16),
            SkeletonBox(
              height: 48,
              borderRadius: AppRadius.medium,
            ),
          ],
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
          for (var index = 0; index < 5; index++) ...[
            if (index > 0) const SizedBox(width: AppSpacing.s8),
            SkeletonBox(
              width: index == 0 ? 56 : 72 + index * 8.0,
              height: 36,
              borderRadius: AppRadius.pill,
            ),
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
