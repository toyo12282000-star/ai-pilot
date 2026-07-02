import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/icons.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/domain/entities/prompt_variant.dart';
import 'package:ai_pilot/features/workflow/presentation/mock/workflow_run_ui_mock_data.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/outcome_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_collapsible_step_card.dart';
import 'package:ai_pilot/shared/widgets/skeleton_box.dart';

/// Run 画面のプロンプトパネル（タブ・コピー・編集・お気に入り）。
class WorkflowRunPromptPanel extends ConsumerStatefulWidget {
  const WorkflowRunPromptPanel({
    super.key,
    required this.stepId,
    this.fallbackContent,
  });

  final String stepId;
  final String? fallbackContent;

  @override
  ConsumerState<WorkflowRunPromptPanel> createState() =>
      _WorkflowRunPromptPanelState();
}

class _WorkflowRunPromptPanelState extends ConsumerState<WorkflowRunPromptPanel> {
  PromptVariantType _selectedVariant = PromptVariantType.beginner;
  bool _isEditing = false;
  bool _isFavorite = false;
  bool _hasCopied = false;
  late TextEditingController _editController;
  String? _editedContent;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController();
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant WorkflowRunPromptPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stepId != widget.stepId) {
      _isEditing = false;
      _isFavorite = false;
      _hasCopied = false;
      _editedContent = null;
      _selectedVariant = PromptVariantType.beginner;
      _editController.clear();
    }
  }

  Future<void> _copy(BuildContext context, String content) async {
    if (content.isEmpty) {
      return;
    }
    await Clipboard.setData(ClipboardData(text: content));
    if (!context.mounted) {
      return;
    }
    setState(() => _hasCopied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('プロンプトをコピーしました')),
    );
  }

  void _toggleEdit(String currentContent) {
    setState(() {
      if (_isEditing) {
        _editedContent = _editController.text;
        _isEditing = false;
      } else {
        _editController.text = _editedContent ?? currentContent;
        _isEditing = true;
      }
    });
  }

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite ? 'お気に入りに追加しました' : 'お気に入りから外しました',
        ),
      ),
    );
  }

  String _purposeLabel(PromptVariantType type) {
    switch (type) {
      case PromptVariantType.beginner:
        return '初心者向け';
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

  String _variantLabel(PromptVariantType type) {
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

  String _recommendationLabel(PromptVariantType type) {
    final score = WorkflowRunUiMockData.recommendationScore(type);
    return 'おすすめ度 ${'★' * score}${'☆' * (5 - score)}';
  }

  Widget _buildStatusBadges({
    required bool hasCopied,
    required bool isEdited,
    required String recommendationLabel,
  }) {
    return Wrap(
      spacing: AppSpacing.s8,
      runSpacing: AppSpacing.s8,
      children: [
        if (hasCopied)
          _PromptStatusBadge(
            label: 'コピー済み',
            icon: Icons.check_rounded,
          ),
        if (isEdited)
          _PromptStatusBadge(
            label: '編集済み',
            icon: Icons.edit_outlined,
          ),
        _PromptStatusBadge(
          label: recommendationLabel,
          icon: Icons.star_outline_rounded,
          muted: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final variantsAsync = ref.watch(promptVariantsProvider(widget.stepId));

    return variantsAsync.when(
      loading: () => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(height: 20, width: 80),
          SizedBox(height: AppSpacing.s12),
          SkeletonBox(height: 36),
          SizedBox(height: AppSpacing.s12),
          SkeletonBox(height: 140),
        ],
      ),
      error: (_, _) => _FallbackPromptPanel(
        content: widget.fallbackContent,
        isEditing: _isEditing,
        isFavorite: _isFavorite,
        hasCopied: _hasCopied,
        isEdited: _editedContent != null,
        recommendationLabel: _recommendationLabel(_selectedVariant),
        editController: _editController,
        editedContent: _editedContent,
        onCopy: (content) => _copy(context, content),
        onToggleEdit: (content) => _toggleEdit(content),
        onToggleFavorite: _toggleFavorite,
      ),
      data: (variants) {
        PromptVariant? selectedVariant;
        for (final variant in variants) {
          if (variant.variantType == _selectedVariant) {
            selectedVariant = variant;
            break;
          }
        }
        selectedVariant ??= variants.isNotEmpty ? variants.first : null;

        final baseContent =
            selectedVariant?.content ?? widget.fallbackContent ?? '';
        final displayContent = _editedContent ?? baseContent;
        final isEdited = _editedContent != null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Prompt',
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  '${displayContent.characters.length}文字',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s8),
            _buildStatusBadges(
              hasCopied: _hasCopied,
              isEdited: isEdited,
              recommendationLabel: _recommendationLabel(_selectedVariant),
            ),
            const SizedBox(height: AppSpacing.s12),
            SegmentedButton<PromptVariantType>(
              segments: [
                for (final type in WorkflowCollapsibleStepCard.tabVariants)
                  ButtonSegment(
                    value: type,
                    label: Text(_variantLabel(type)),
                  ),
              ],
              selected: {_selectedVariant},
              onSelectionChanged: (values) {
                setState(() {
                  _selectedVariant = values.first;
                  _editedContent = null;
                  _isEditing = false;
                  _hasCopied = false;
                });
              },
              showSelectedIcon: false,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            Row(
              children: [
                Text(
                  '用途',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: AppSpacing.s8),
                Text(
                  _purposeLabel(_selectedVariant),
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.s16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: AppRadius.medium,
                border: Border.all(color: AppColors.border),
              ),
              child: _isEditing
                  ? TextField(
                      controller: _editController,
                      maxLines: 8,
                      style: AppTypography.bodySmall.copyWith(height: 1.6),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    )
                  : Text(
                      displayContent.isEmpty
                          ? 'このタブ用のプロンプトはありません'
                          : displayContent,
                      style: AppTypography.bodySmall.copyWith(
                        color: displayContent.isEmpty
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                        height: 1.6,
                      ),
                    ),
            ),
            const SizedBox(height: AppSpacing.s8),
            Row(
              children: [
                TextButton.icon(
                  onPressed: displayContent.isEmpty
                      ? null
                      : () => _copy(context, displayContent),
                  icon: const Icon(AppIcons.copy, size: AppIcons.sizeSm),
                  label: const Text('コピー'),
                ),
                TextButton.icon(
                  onPressed: displayContent.isEmpty
                      ? null
                      : () => _toggleEdit(baseContent),
                  icon: Icon(
                    _isEditing ? Icons.check_rounded : Icons.edit_outlined,
                    size: AppIcons.sizeSm,
                  ),
                  label: Text(_isEditing ? '確定' : '編集'),
                ),
                TextButton.icon(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    _isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: AppIcons.sizeSm,
                    color: _isFavorite ? AppColors.primary : null,
                  ),
                  label: const Text('お気に入り'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _FallbackPromptPanel extends StatelessWidget {
  const _FallbackPromptPanel({
    required this.content,
    required this.isEditing,
    required this.isFavorite,
    required this.hasCopied,
    required this.isEdited,
    required this.recommendationLabel,
    required this.editController,
    required this.editedContent,
    required this.onCopy,
    required this.onToggleEdit,
    required this.onToggleFavorite,
  });

  final String? content;
  final bool isEditing;
  final bool isFavorite;
  final bool hasCopied;
  final bool isEdited;
  final String recommendationLabel;
  final TextEditingController editController;
  final String? editedContent;
  final ValueChanged<String> onCopy;
  final ValueChanged<String> onToggleEdit;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final baseContent = content ?? '';
    final displayContent = editedContent ?? baseContent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Prompt',
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              '${displayContent.characters.length}文字',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s8),
        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          children: [
            if (hasCopied)
              _PromptStatusBadge(
                label: 'コピー済み',
                icon: Icons.check_rounded,
              ),
            if (isEdited)
              _PromptStatusBadge(
                label: '編集済み',
                icon: Icons.edit_outlined,
              ),
            _PromptStatusBadge(
              label: recommendationLabel,
              icon: Icons.star_outline_rounded,
              muted: true,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.s16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: AppRadius.medium,
            border: Border.all(color: AppColors.border),
          ),
          child: isEditing
              ? TextField(
                  controller: editController,
                  maxLines: 8,
                  style: AppTypography.bodySmall.copyWith(height: 1.6),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                )
              : Text(
                  displayContent.isEmpty ? '未設定' : displayContent,
                  style: AppTypography.bodySmall.copyWith(
                    color: displayContent.isEmpty
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                    height: 1.6,
                  ),
                ),
        ),
        const SizedBox(height: AppSpacing.s8),
        Row(
          children: [
            TextButton.icon(
              onPressed:
                  displayContent.isEmpty ? null : () => onCopy(displayContent),
              icon: const Icon(AppIcons.copy, size: AppIcons.sizeSm),
              label: const Text('コピー'),
            ),
            TextButton.icon(
              onPressed: displayContent.isEmpty
                  ? null
                  : () => onToggleEdit(baseContent),
              icon: Icon(
                isEditing ? Icons.check_rounded : Icons.edit_outlined,
                size: AppIcons.sizeSm,
              ),
              label: Text(isEditing ? '確定' : '編集'),
            ),
            TextButton.icon(
              onPressed: onToggleFavorite,
              icon: Icon(
                isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                size: AppIcons.sizeSm,
                color: isFavorite ? AppColors.primary : null,
              ),
              label: const Text('お気に入り'),
            ),
          ],
        ),
      ],
    );
  }
}

class _PromptStatusBadge extends StatelessWidget {
  const _PromptStatusBadge({
    required this.label,
    required this.icon,
    this.muted = false,
  });

  final String label;
  final IconData icon;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: muted ? AppColors.surface : AppColors.primarySoft,
        borderRadius: AppRadius.pill,
        border: Border.all(
          color: muted
              ? AppColors.border
              : AppColors.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: muted ? AppColors.textSecondary : AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.s4),
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: muted ? AppColors.textSecondary : AppColors.charcoal,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
