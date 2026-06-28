import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/icons.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';

/// おすすめ Workflow 用の横スクロールカード。
class RecommendedWorkflowCard extends StatelessWidget {
  const RecommendedWorkflowCard({
    super.key,
    required this.workflow,
    required this.onTap,
  });

  final Workflow workflow;
  final VoidCallback onTap;

  static const double cardWidth = 280;
  static const double cardHeight = 168;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Material(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: AppRadius.large,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.large,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: AppRadius.large,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      workflow.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.titleMedium.copyWith(
                        height: 1.35,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: AppSpacing.s12,
                          runSpacing: AppSpacing.s8,
                          children: [
                            if (workflow.estimatedMinutes != null)
                              _MetaItem(
                                icon: AppIcons.schedule,
                                label: '約${workflow.estimatedMinutes}分',
                              ),
                            _MetaItem(
                              icon: AppIcons.steps,
                              label: '${workflow.steps.length}ステップ',
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: AppIcons.sizeMd,
                        color: AppColors.primary.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: AppIcons.sizeSm,
          color: AppColors.primary,
        ),
        const SizedBox(width: AppSpacing.s4),
        Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
