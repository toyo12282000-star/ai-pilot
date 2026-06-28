import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/advisor/domain/entities/advisor_history.dart';
import 'package:ai_pilot/features/advisor/presentation/providers/advisor_history_providers.dart';
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

    return historiesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
      data: (histories) {
        if (histories.isEmpty) {
          return const SizedBox.shrink();
        }

        final visibleHistories = histories.take(displayLimit).toList();

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
              for (final history in visibleHistories) ...[
                _AdvisorHistoryCard(
                  history: history,
                  isLoading: isLoading,
                  onTap: () => onHistorySelected(history.query),
                  onDelete: () => _deleteHistory(ref, userId, history.id),
                ),
                const SizedBox(height: AppSpacing.s8),
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

class _AdvisorHistoryCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
                        history.query,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodyMedium,
                      ),
                      if (history.suggestedWorkflowIds.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.s4),
                          child: Text(
                            '${history.suggestedWorkflowIds.length}件のWorkflowを提案',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
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
