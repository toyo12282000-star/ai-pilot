import 'package:flutter/material.dart';

import 'package:ai_pilot/app/app_text_styles.dart';
import 'package:ai_pilot/core/constants/app_spacing.dart';
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

  static const double cardWidth = 240;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: cardWidth,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: AppSpacing.card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workflow.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.appText.cardTitle,
                ),
                const Spacer(),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    if (workflow.estimatedMinutes != null)
                      _InfoChip(
                        icon: Icons.schedule,
                        label: '約${workflow.estimatedMinutes}分',
                        color: colorScheme.secondary,
                      ),
                    _InfoChip(
                      icon: Icons.format_list_numbered,
                      label: '${workflow.steps.length}ステップ',
                      color: colorScheme.primary,
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

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
