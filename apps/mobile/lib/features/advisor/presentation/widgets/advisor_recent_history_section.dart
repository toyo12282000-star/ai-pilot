import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/advisor/domain/entities/advisor_history.dart';
import 'package:ai_pilot/features/advisor/presentation/providers/advisor_history_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';
import 'package:ai_pilot/shared/providers/authenticated_user_provider.dart';

/// Advisor 画面の「最近の相談」セクション（ログイン済みのみ）。
class AdvisorRecentHistorySection extends ConsumerWidget {
  const AdvisorRecentHistorySection({
    super.key,
    required this.queryController,
    required this.onHistorySelected,
    required this.isLoading,
  });

  static const displayLimit = 5;

  final TextEditingController queryController;
  final ValueChanged<String> onHistorySelected;
  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authenticatedUserIdProvider);
    if (userId == null) {
      return const SizedBox.shrink();
    }

    final historiesAsync = ref.watch(advisorHistoriesProvider(userId));
    ref.watch(workflowsProvider);

    return historiesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
      data: (histories) {
        return Padding(
          padding: AppSpacing.pageHorizontal.copyWith(top: AppSpacing.s8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '最近の相談',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              if (histories.isEmpty)
                const _AdvisorHistoryEmptyState()
              else ...[
                for (final history in histories.take(displayLimit)) ...[
                  _AdvisorHistoryCard(
                    history: history,
                    isLoading: isLoading,
                    onTap: () => onHistorySelected(history.query),
                    onDelete: () => _deleteHistory(ref, userId, history.id),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                ],
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteHistory(
    WidgetRef ref,
    String userId,
    String historyId,
  ) async {
    await ref.read(advisorHistoryRepositoryProvider).deleteHistory(
          userId,
          historyId,
        );
    invalidateAdvisorHistories(ref, userId);
  }
}

class _AdvisorHistoryEmptyState extends StatelessWidget {
  const _AdvisorHistoryEmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'まだ相談履歴がありません',
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            'AI Pilot に作りたいものを相談してみましょう',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdvisorHistoryCard extends ConsumerWidget {
  const _AdvisorHistoryCard({
    required this.history,
    required this.isLoading,
    required this.onTap,
    required this.onDelete,
  });

  final AdvisorHistory history;
  final bool isLoading;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryWorkflowId = history.primaryWorkflowId ??
        (history.suggestedWorkflowIds.isNotEmpty
            ? history.suggestedWorkflowIds.first
            : null);
    final primaryWorkflowTitle = ref.watch(workflowsProvider).maybeWhen(
          data: (workflows) {
            if (primaryWorkflowId == null) {
              return null;
            }
            for (final workflow in workflows) {
              if (workflow.id == primaryWorkflowId) {
                return workflow.title;
              }
            }
            return null;
          },
          orElse: () => null,
        );
    final suggestionLabel = primaryWorkflowTitle ??
        (history.suggestedWorkflowIds.isEmpty
            ? null
            : '${history.suggestedWorkflowIds.length}件のWorkflowを提案');

    return Material(
      color: AppColors.surface,
      borderRadius: AppRadius.medium,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: AppRadius.medium,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: AppRadius.medium,
            border: Border.all(color: AppColors.outline),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s12,
              vertical: AppSpacing.s8,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.history_rounded,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        history.displayQuery,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodyMedium,
                      ),
                      if (history.pathLabel.isNotEmpty || suggestionLabel != null) ...[
                        const SizedBox(height: AppSpacing.s4),
                        Wrap(
                          spacing: AppSpacing.s8,
                          runSpacing: AppSpacing.s4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            if (history.pathLabel.isNotEmpty)
                              _HistoryMetaChip(label: history.pathLabel),
                            if (suggestionLabel != null)
                              Text(
                                suggestionLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                          ],
                        ),
                      ],
                      const SizedBox(height: AppSpacing.s4),
                      Text(
                        _formatHistoryDate(history.createdAt),
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: '削除',
                  onPressed: isLoading ? null : onDelete,
                  icon: Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: AppColors.textSecondary,
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

class _HistoryMetaChip extends StatelessWidget {
  const _HistoryMetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.small,
        border: Border.all(color: AppColors.outline),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

String _formatHistoryDate(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);
  if (diff.inDays == 0) {
    if (diff.inHours == 0) {
      if (diff.inMinutes < 1) {
        return 'たった今';
      }
      return '${diff.inMinutes}分前';
    }
    return '${diff.inHours}時間前';
  }
  if (diff.inDays < 7) {
    return '${diff.inDays}日前';
  }
  return '${date.month}/${date.day}';
}
