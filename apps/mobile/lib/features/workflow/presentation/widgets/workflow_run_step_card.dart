import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/icons.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_step.dart';
import 'package:ai_pilot/shared/widgets/hero_gradient_card.dart';

/// 実行画面の現在ステップ表示カード。
class WorkflowRunStepCard extends StatelessWidget {
  const WorkflowRunStepCard({
    super.key,
    required this.step,
    this.aiToolId,
    this.aiToolName,
    this.promptContent,
  });

  final WorkflowStep step;
  final String? aiToolId;
  final String? aiToolName;
  final String? promptContent;

  Future<void> _copyPrompt(BuildContext context) async {
    final content = promptContent;
    if (content == null || content.isEmpty) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: content));
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('プロンプトをコピーしました')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasPrompt = promptContent != null && promptContent!.isNotEmpty;

    return HeroGradientCard(
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            step.title,
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(
            step.instruction,
            style: AppTypography.bodyLarge.copyWith(
              fontWeight: FontWeight.w500,
              height: 1.55,
            ),
          ),
          if (step.description != null && step.description!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s12),
            Text(
              step.description!,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.s24),
          Text(
            '使用AIツール',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          _AiToolChip(
            aiToolId: aiToolId,
            aiToolName: aiToolName,
          ),
          const SizedBox(height: AppSpacing.s24),
          Row(
            children: [
              Text(
                'プロンプト',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              if (hasPrompt)
                TextButton.icon(
                  onPressed: () => _copyPrompt(context),
                  icon: const Icon(AppIcons.copy, size: AppIcons.sizeSm),
                  label: const Text('コピーする'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s8,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.s8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.s16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.medium,
              border: Border.all(color: AppColors.outline),
            ),
            child: Text(
              hasPrompt ? promptContent! : '未設定',
              style: AppTypography.bodySmall.copyWith(
                color: hasPrompt
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AiToolChip extends StatelessWidget {
  const _AiToolChip({
    required this.aiToolId,
    required this.aiToolName,
  });

  final String? aiToolId;
  final String? aiToolName;

  @override
  Widget build(BuildContext context) {
    final displayName = aiToolName ?? '未設定';
    final canNavigate = aiToolId != null;

    final chip = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s8,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: AppRadius.pill,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome,
            size: AppIcons.sizeSm,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.s8),
          Text(
            displayName,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (canNavigate) ...[
            const SizedBox(width: AppSpacing.s4),
            Icon(
              Icons.chevron_right_rounded,
              size: AppIcons.sizeSm,
              color: AppColors.primary.withValues(alpha: 0.7),
            ),
          ],
        ],
      ),
    );

    if (!canNavigate) {
      return chip;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/ai-tools/$aiToolId'),
        borderRadius: AppRadius.pill,
        child: chip,
      ),
    );
  }
}
