import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/responsive.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_product_stats.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_social_proof_providers.dart';
import 'package:ai_pilot/shared/widgets/error_view.dart';
import 'package:ai_pilot/shared/widgets/skeleton_box.dart';

/// Hero 直下の人気・メタ情報パネル。
class WorkflowProductStatsPanel extends ConsumerWidget {
  const WorkflowProductStatsPanel({
    super.key,
    required this.workflowId,
  });

  final String workflowId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(workflowProductStatsProvider(workflowId));

    return statsAsync.when(
      loading: () => const _WorkflowProductStatsSkeleton(),
      error: (error, _) => ErrorView(
        title: '人気情報の読み込みに失敗しました',
        description: '通信状況を確認して、もう一度お試しください',
        onRetry: () => ref.invalidate(workflowProductStatsProvider(workflowId)),
        debugDetails: error,
      ),
      data: (stats) {
        if (stats == null) {
          return const SizedBox.shrink();
        }
        return _WorkflowProductStatsContent(stats: stats);
      },
    );
  }
}

class _WorkflowProductStatsContent extends StatelessWidget {
  const _WorkflowProductStatsContent({required this.stats});

  final WorkflowProductStats stats;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final items = [
      _StatItem(label: '保存数', value: _formatCount(stats.saveCount)),
      _StatItem(label: '使用者', value: '${_formatCount(stats.userCount)}人'),
      _StatItem(label: '制作時間', value: '${stats.estimatedMinutes}分'),
      _StatItem(label: '難易度', value: stats.difficultyLabel),
      _StatItem(
        label: '料金',
        value: stats.pricingLabel,
        highlight: true,
      ),
      if (isMobile)
        _StatItem(
          label: 'カテゴリ',
          value: stats.category,
        ),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          isMobile ? AppSpacing.s12 : AppSpacing.s16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _StarRating(score: stats.popularityScore),
                const SizedBox(width: AppSpacing.s8),
                Text(
                  '人気作品',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (!isMobile)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s12,
                      vertical: AppSpacing.s4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: AppRadius.pill,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.22),
                      ),
                    ),
                    child: Text(
                      stats.category,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: isMobile ? AppSpacing.s12 : AppSpacing.s16),
            LayoutBuilder(
              builder: (context, constraints) {
                final useTwoColumns = isMobile || constraints.maxWidth >= 480;
                final gap = isMobile ? AppSpacing.s8 : AppSpacing.s12;

                if (useTwoColumns) {
                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      for (final item in items)
                        SizedBox(
                          width: (constraints.maxWidth - gap) / 2,
                          child: item,
                        ),
                    ],
                  );
                }

                return Column(
                  children: [
                    for (var i = 0; i < items.length; i++) ...[
                      if (i > 0) SizedBox(height: gap),
                      items[i],
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static String _formatCount(int value) {
    return value.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        );
  }
}

class _WorkflowProductStatsSkeleton extends StatelessWidget {
  const _WorkflowProductStatsSkeleton();

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          isMobile ? AppSpacing.s12 : AppSpacing.s16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SkeletonBox(width: 160, height: 20),
            SizedBox(height: isMobile ? AppSpacing.s12 : AppSpacing.s16),
            Wrap(
              spacing: AppSpacing.s8,
              runSpacing: AppSpacing.s8,
              children: const [
                SkeletonBox(width: 150, height: 56),
                SkeletonBox(width: 150, height: 56),
                SkeletonBox(width: 150, height: 56),
                SkeletonBox(width: 150, height: 56),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  const _StarRating({required this.score});

  final double score;

  @override
  Widget build(BuildContext context) {
    final fullStars = score.floor().clamp(0, 5);
    final hasHalf = score - fullStars >= 0.25 && fullStars < 5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 5; i++)
          Icon(
            i < fullStars
                ? Icons.star_rounded
                : (i == fullStars && hasHalf)
                    ? Icons.star_half_rounded
                    : Icons.star_outline_rounded,
            size: 16,
            color: AppColors.primary,
          ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final compact = context.isMobile;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.s12,
          vertical: compact ? AppSpacing.s8 : AppSpacing.s12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTypography.caption.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: AppSpacing.s4),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.titleSmall.copyWith(
                color: highlight ? AppColors.primary : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: compact ? 13 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
