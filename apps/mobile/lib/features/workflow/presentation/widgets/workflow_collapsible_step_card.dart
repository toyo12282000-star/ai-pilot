import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/design_system/animations.dart';
import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/icons.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/domain/entities/prompt_variant.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_step.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/outcome_providers.dart';
import 'package:ai_pilot/shared/widgets/skeleton_box.dart';

/// 折りたたみ可能な Workflow 詳細ステップカード。
class WorkflowCollapsibleStepCard extends ConsumerStatefulWidget {
  const WorkflowCollapsibleStepCard({
    super.key,
    required this.step,
    required this.index,
  });

  final WorkflowStep step;
  final int index;

  static const tabVariants = [
    PromptVariantType.beginner,
    PromptVariantType.highQuality,
    PromptVariantType.shortTime,
  ];

  @override
  ConsumerState<WorkflowCollapsibleStepCard> createState() =>
      _WorkflowCollapsibleStepCardState();
}

class _WorkflowCollapsibleStepCardState
    extends ConsumerState<WorkflowCollapsibleStepCard> {
  bool _expanded = false;
  PromptVariantType _selectedVariant = PromptVariantType.beginner;

  @override
  Widget build(BuildContext context) {
    final variantsAsync = ref.watch(promptVariantsProvider(widget.step.id));
    final toolOptionsAsync =
        ref.watch(workflowStepToolOptionsProvider(widget.step.id));

    final variantCount = variantsAsync.value?.length ?? 0;
    final toolCount = toolOptionsAsync.value?.length ?? 0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.large,
        border: Border.all(
          color: _expanded
              ? AppColors.primary.withValues(alpha: 0.35)
              : AppColors.outline.withValues(alpha: 0.55),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: AppRadius.large,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _StepBadge(order: widget.step.order),
                      const SizedBox(width: AppSpacing.s12),
                      Expanded(
                        child: Text(
                          widget.step.title,
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: AppAnimations.fast,
                        child: Icon(
                          Icons.expand_more_rounded,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  if (widget.step.goal != null) ...[
                    const SizedBox(height: AppSpacing.s12),
                    Text(
                      widget.step.goal!,
                      maxLines: _expanded ? null : 2,
                      overflow: _expanded ? null : TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.55,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.s12),
                  Wrap(
                    spacing: AppSpacing.s8,
                    runSpacing: AppSpacing.s8,
                    children: [
                      _CountChip(
                        icon: Icons.auto_awesome_outlined,
                        label: 'Prompt $variantCount',
                      ),
                      _CountChip(
                        icon: Icons.build_outlined,
                        label: 'Tool $toolCount',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s24,
                0,
                AppSpacing.s24,
                AppSpacing.s24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.step.outputExample != null) ...[
                    _SectionLabel(title: 'Output Example'),
                    const SizedBox(height: AppSpacing.s8),
                    _OutputExampleCard(content: widget.step.outputExample!),
                    const SizedBox(height: AppSpacing.s24),
                  ],
                  if (widget.step.completionCriteria != null) ...[
                    _SectionLabel(title: 'Completion Criteria'),
                    const SizedBox(height: AppSpacing.s8),
                    Text(
                      widget.step.completionCriteria!,
                      style: AppTypography.bodyMedium.copyWith(
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s24),
                  ],
                  if (widget.step.tips.isNotEmpty) ...[
                    _SectionLabel(title: 'Tips'),
                    const SizedBox(height: AppSpacing.s8),
                    _BulletList(items: widget.step.tips),
                    const SizedBox(height: AppSpacing.s24),
                  ],
                  if (widget.step.commonMistakes.isNotEmpty) ...[
                    _SectionLabel(title: 'Common Mistakes'),
                    const SizedBox(height: AppSpacing.s8),
                    _BulletList(
                      items: widget.step.commonMistakes,
                      icon: Icons.warning_amber_rounded,
                      iconColor: AppColors.error.withValues(alpha: 0.85),
                    ),
                    const SizedBox(height: AppSpacing.s24),
                  ],
                  _SectionLabel(title: 'Prompt'),
                  const SizedBox(height: AppSpacing.s8),
                  variantsAsync.when(
                    loading: () => const SkeletonBox(
                      height: 120,
                      borderRadius: AppRadius.medium,
                    ),
                    error: (_, _) => Text(
                      'プロンプトの読み込みに失敗しました',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    data: (variants) => _PromptTabsSection(
                      variants: variants,
                      selected: _selectedVariant,
                      onSelected: (type) {
                        setState(() => _selectedVariant = type);
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _StepBadge extends StatelessWidget {
  const _StepBadge({required this.order});

  final int order;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(alpha: 0.08),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Text(
        '$order',
        style: AppTypography.labelLarge.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CountChip extends StatelessWidget {
  const _CountChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
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
        borderRadius: AppRadius.pill,
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.s4),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.labelLarge.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.1,
      ),
    );
  }
}

class _OutputExampleCard extends StatelessWidget {
  const _OutputExampleCard({required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.03),
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.45)),
      ),
      child: Text(
        content,
        style: AppTypography.bodySmall.copyWith(
          fontFamily: 'monospace',
          height: 1.65,
        ),
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({
    required this.items,
    this.icon = Icons.check_circle_outline_rounded,
    this.iconColor,
  });

  final List<String> items;
  final IconData icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: iconColor ?? AppColors.primary.withValues(alpha: 0.75),
                ),
                const SizedBox(width: AppSpacing.s8),
                Expanded(
                  child: Text(
                    item,
                    style: AppTypography.bodySmall.copyWith(
                      height: 1.55,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _PromptTabsSection extends StatelessWidget {
  const _PromptTabsSection({
    required this.variants,
    required this.selected,
    required this.onSelected,
  });

  final List<PromptVariant> variants;
  final PromptVariantType selected;
  final ValueChanged<PromptVariantType> onSelected;

  @override
  Widget build(BuildContext context) {
    PromptVariant? display;
    for (final variant in variants) {
      if (variant.variantType == selected) {
        display = variant;
        break;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedButton<PromptVariantType>(
          segments: [
            for (final type in WorkflowCollapsibleStepCard.tabVariants)
              ButtonSegment(
                value: type,
                label: Text(_variantLabel(type)),
              ),
          ],
          selected: {selected},
          onSelectionChanged: (values) => onSelected(values.first),
          showSelectedIcon: false,
          style: ButtonStyle(
            visualDensity: VisualDensity.compact,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(height: AppSpacing.s12),
        if (display == null)
          Text(
            'このタブ用のプロンプトはありません',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          )
        else
          _PromptContentCard(variant: display),
      ],
    );
  }

  static String _variantLabel(PromptVariantType type) {
    switch (type) {
      case PromptVariantType.beginner:
        return '初心者';
      case PromptVariantType.highQuality:
        return '高品質';
      case PromptVariantType.shortTime:
        return '時短';
      case PromptVariantType.viral:
        return 'バズ';
      case PromptVariantType.professional:
        return 'プロ';
      case PromptVariantType.seo:
        return 'SEO';
      case PromptVariantType.sns:
        return 'SNS';
    }
  }
}

class _PromptContentCard extends StatelessWidget {
  const _PromptContentCard({required this.variant});

  final PromptVariant variant;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: variant.content));
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('プロンプトをコピーしました')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            variant.title,
            style: AppTypography.labelLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            variant.content,
            style: AppTypography.bodySmall.copyWith(
              height: 1.65,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _copy(context),
              icon: const Icon(AppIcons.copy, size: AppIcons.sizeSm),
              label: const Text('コピー'),
            ),
          ),
        ],
      ),
    );
  }
}
