import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/domain/entities/ai_tool.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/ai_tool_icon.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/ai_tool_type_label.dart';
import 'package:ai_pilot/shared/widgets/hero_gradient_card.dart';

/// AI ツール詳細画面の Hero ヘッダー。
class AIToolDetailHero extends StatelessWidget {
  const AIToolDetailHero({
    super.key,
    required this.tool,
  });

  final AITool tool;

  @override
  Widget build(BuildContext context) {
    return HeroGradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AIToolIconAvatar(
                iconName: tool.iconName,
                type: tool.type,
              ),
              const SizedBox(width: AppSpacing.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tool.name,
                      style: AppTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    _TypeChip(label: tool.type.label),
                  ],
                ),
              ),
            ],
          ),
          if (tool.description != null &&
              tool.description!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s16),
            Text(
              tool.description!,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: AppRadius.pill,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        label,
        style: AppTypography.labelMedium.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
