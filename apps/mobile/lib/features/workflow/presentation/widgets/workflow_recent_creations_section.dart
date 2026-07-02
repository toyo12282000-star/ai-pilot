import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_recent_creation.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_social_proof_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_detail_layout.dart';
import 'package:ai_pilot/shared/widgets/error_view.dart';
import 'package:ai_pilot/shared/widgets/skeleton_box.dart';

/// 「最近作られた作品」Social Proof セクション。
class WorkflowRecentCreationsSection extends ConsumerWidget {
  const WorkflowRecentCreationsSection({
    super.key,
    required this.workflowId,
  });

  final String workflowId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creationsAsync = ref.watch(workflowRecentCreationsProvider(workflowId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WorkflowDetailSectionHeader(
          title: '最近作られた作品',
          subtitle: 'この Workflow で今も作品が作られています',
        ),
        const SizedBox(height: AppSpacing.s16),
        creationsAsync.when(
          loading: () => const _RecentCreationsSkeleton(),
          error: (error, _) => ErrorView(
            title: '作成履歴の読み込みに失敗しました',
            description: '通信状況を確認して、もう一度お試しください',
            onRetry: () =>
                ref.invalidate(workflowRecentCreationsProvider(workflowId)),
            debugDetails: error,
          ),
          data: (items) {
            if (items.isEmpty) {
              return const _RecentCreationsEmptyCard();
            }

            return DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.card,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < items.length; i++) ...[
                    if (i > 0)
                      Divider(
                        height: 1,
                        color: AppColors.border.withValues(alpha: 0.85),
                      ),
                    _RecentCreationRow(item: items[i]),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _RecentCreationsEmptyCard extends StatelessWidget {
  const _RecentCreationsEmptyCard();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s24,
        ),
        child: Column(
          children: [
            Icon(
              Icons.auto_awesome_outlined,
              size: 28,
              color: AppColors.muted.withValues(alpha: 0.85),
            ),
            const SizedBox(height: AppSpacing.s12),
            Text(
              'まだ作成履歴がありません',
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              '最初の1人になってみましょう',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.muted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentCreationsSkeleton extends StatelessWidget {
  const _RecentCreationsSkeleton();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.border),
      ),
      child: const Padding(
        padding: EdgeInsets.all(AppSpacing.s16),
        child: Column(
          children: [
            SkeletonBox(width: double.infinity, height: 44),
            SizedBox(height: AppSpacing.s12),
            SkeletonBox(width: double.infinity, height: 44),
          ],
        ),
      ),
    );
  }
}

class _RecentCreationRow extends StatelessWidget {
  const _RecentCreationRow({required this.item});

  final WorkflowRecentCreation item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s12,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primarySoft,
            child: Text(
              item.avatarInitial,
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.userLabel,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  item.timeLabel,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.check_circle_outline_rounded,
            size: 18,
            color: AppColors.success.withValues(alpha: 0.85),
          ),
        ],
      ),
    );
  }
}
