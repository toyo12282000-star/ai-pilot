import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/animations.dart';
import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/icons.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_step.dart';

/// ワークフロー詳細画面のステップカード。
class WorkflowStepCard extends StatefulWidget {
  const WorkflowStepCard({
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

  @override
  State<WorkflowStepCard> createState() => _WorkflowStepCardState();
}

class _WorkflowStepCardState extends State<WorkflowStepCard> {
  bool _isPromptExpanded = false;

  bool get _hasPrompt =>
      widget.promptContent != null && widget.promptContent!.isNotEmpty;

  Future<void> _copyPrompt() async {
    final content = widget.promptContent;
    if (content == null || content.isEmpty) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: content));
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('プロンプトをコピーしました')),
    );
  }

  void _togglePrompt() {
    setState(() => _isPromptExpanded = !_isPromptExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
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
              Text(
                'Step ${widget.step.order}',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.s4),
              Text(
                widget.step.title,
                style: AppTypography.titleSmall,
              ),
              const SizedBox(height: AppSpacing.s12),
              Text(
                widget.step.instruction,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
              if (widget.step.description != null) ...[
                const SizedBox(height: AppSpacing.s8),
                Text(
                  widget.step.description!,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.s16),
              _AiToolChip(
                aiToolId: widget.aiToolId,
                aiToolName: widget.aiToolName,
              ),
              if (_hasPrompt) ...[
                const SizedBox(height: AppSpacing.s16),
                _PromptSection(
                  isExpanded: _isPromptExpanded,
                  promptContent: widget.promptContent!,
                  onToggle: _togglePrompt,
                  onCopy: _copyPrompt,
                ),
              ],
            ],
          ),
        ),
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

class _PromptSection extends StatelessWidget {
  const _PromptSection({
    required this.isExpanded,
    required this.promptContent,
    required this.onToggle,
    required this.onCopy,
  });

  final bool isExpanded;
  final String promptContent;
  final VoidCallback onToggle;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: onToggle,
          icon: AnimatedRotation(
            turns: isExpanded ? 0.5 : 0,
            duration: AppAnimations.fast,
            curve: AppAnimations.easeInOut,
            child: const Icon(Icons.expand_more, size: AppIcons.sizeMd),
          ),
          label: Text(isExpanded ? 'プロンプトを閉じる' : 'プロンプトを見る'),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        AnimatedCrossFade(
          duration: AppAnimations.normal,
          sizeCurve: AppAnimations.easeInOut,
          firstCurve: AppAnimations.easeOut,
          secondCurve: AppAnimations.easeOut,
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: const SizedBox(width: double.infinity),
          secondChild: AnimatedSize(
            duration: AppAnimations.normal,
            curve: AppAnimations.easeInOut,
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.s8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.s12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: AppRadius.medium,
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: Text(
                    promptContent,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: onCopy,
                    icon: const Icon(AppIcons.copy, size: AppIcons.sizeSm),
                    label: const Text('コピー'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s8,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
