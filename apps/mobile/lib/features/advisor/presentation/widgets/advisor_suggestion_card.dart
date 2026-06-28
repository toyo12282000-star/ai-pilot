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

  @override
  Widget build(BuildContext context) {
    final workflow = suggestion.workflow;

    return Material(
      color: AppColors.surface,
      borderRadius: AppRadius.large,
      child: InkWell(
        onTap: onOpenWorkflow,
        borderRadius: AppRadius.large,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: AppRadius.large,
            border: Border.all(color: AppColors.outline),
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
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: AppRadius.small,
                      ),
                      child: Text(
                        '$rank',
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
                            workflow.title,
                            style: AppTypography.titleMedium,
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
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onOpenWorkflow,
                        child: const Text('詳細を見る'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s12),
                    Expanded(
                      child: FilledButton(
                        onPressed: onStartWorkflow,
                        child: const Text('開始する'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
