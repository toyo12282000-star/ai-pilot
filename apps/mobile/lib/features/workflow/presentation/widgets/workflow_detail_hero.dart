import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/icons.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_favorite_button.dart';
import 'package:ai_pilot/shared/widgets/hero_gradient_card.dart';
import 'package:ai_pilot/shared/widgets/meta_badge.dart';

/// ワークフロー詳細画面の Hero ヘッダー。
class WorkflowDetailHero extends StatelessWidget {
  const WorkflowDetailHero({
    super.key,
    required this.workflow,
    required this.workflowId,
  });

  final Workflow workflow;
  final String workflowId;

  @override
  Widget build(BuildContext context) {
    return HeroGradientCard(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s24,
        AppSpacing.s24,
        AppSpacing.s16,
        AppSpacing.s24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  workflow.title,
                  style: AppTypography.headlineSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              WorkflowFavoriteButton(workflowId: workflowId),
            ],
          ),
          const SizedBox(height: AppSpacing.s12),
          Text(
            workflow.description,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            children: [
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
          if (workflow.tags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s12),
            Wrap(
              spacing: AppSpacing.s8,
              runSpacing: AppSpacing.s8,
              children: [
                for (final tag in workflow.tags)
                  Container(
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
                      tag,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
