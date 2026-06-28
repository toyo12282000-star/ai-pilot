import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/icons.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/advisor/domain/entities/advisor_suggestion.dart';
import 'package:ai_pilot/shared/widgets/meta_badge.dart';

/// Advisor の提案結果カード。
class AdvisorSuggestionCard extends StatelessWidget {
  const AdvisorSuggestionCard({
    super.key,
    required this.suggestion,
    required this.rank,
    required this.onOpenWorkflow,
    required this.onStartWorkflow,
  });

  final AdvisorSuggestion suggestion;
  final int rank;
  final VoidCallback onOpenWorkflow;
  final VoidCallback onStartWorkflow;

  bool get _isTopPick => rank == 1;

  String get _matchLabel {
    return switch (rank) {
      1 => 'おすすめ度：高',
      2 => 'おすすめ度：中',
      _ => 'おすすめ度：低',
    };
  }

  @override
  Widget build(BuildContext context) {
    final workflow = suggestion.workflow;
    final borderColor = _isTopPick ? AppColors.primary : AppColors.outline;
    final backgroundColor = _isTopPick
        ? AppColors.primary.withValues(alpha: 0.04)
        : AppColors.surface;

    return Material(
      color: backgroundColor,
      borderRadius: AppRadius.large,
      elevation: _isTopPick ? 1 : 0,
      shadowColor: AppColors.primary.withValues(alpha: 0.12),
      child: InkWell(
        onTap: onOpenWorkflow,
        borderRadius: AppRadius.large,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: AppRadius.large,
            border: Border.all(
              color: borderColor,
              width: _isTopPick ? 1.5 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _isTopPick
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: AppRadius.small,
                      ),
                      child: Text(
                        '$rank',
                        style: AppTypography.labelLarge.copyWith(
                          color: _isTopPick
                              ? AppColors.surface
                              : AppColors.primary,
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
                            workflow.title,
                            style: AppTypography.titleMedium.copyWith(
                              color: _isTopPick ? AppColors.primary : null,
                              fontWeight:
                                  _isTopPick ? FontWeight.w700 : FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.s8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.s8,
                              vertical: AppSpacing.s4,
                            ),
                            decoration: BoxDecoration(
                              color: _isTopPick
                                  ? AppColors.primary.withValues(alpha: 0.12)
                                  : AppColors.primary.withValues(alpha: 0.06),
                              borderRadius: AppRadius.small,
                            ),
                            child: Text(
                              _matchLabel,
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.s8),
                          Text(
                            suggestion.reason,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s16),
                Wrap(
                  spacing: AppSpacing.s8,
                  runSpacing: AppSpacing.s8,
                  children: [
                    MetaBadge(
                      icon: Icons.auto_awesome_rounded,
                      label: suggestion.difficulty,
                    ),
                    if (workflow.estimatedMinutes != null)
                      MetaBadge(
                        icon: AppIcons.schedule,
                        label: '約${workflow.estimatedMinutes}分',
                      ),
                    MetaBadge(
                      icon: AppIcons.steps,
                      label: '${workflow.steps.length}ステップ',
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s16),
                OutlinedButton(
                  onPressed: onOpenWorkflow,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                  ),
                  child: const Text('詳細を見る'),
                ),
                const SizedBox(height: AppSpacing.s8),
                FilledButton(
                  onPressed: onStartWorkflow,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text('このWorkflowを開始する'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
