import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/domain/entities/showcase_tag.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_showcase.dart';

/// 完成作品サンプル用の横スクロールカード。
class ShowcaseCard extends StatelessWidget {
  const ShowcaseCard({
    super.key,
    required this.showcase,
    required this.onTap,
  });

  final WorkflowShowcase showcase;
  final VoidCallback onTap;

  static const double cardWidth = 300;
  static const double imageHeight = 168;
  static const double cardHeight = 420;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.large,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: AppRadius.large,
              color: const Color(0xFF0F172A).withValues(alpha: 0.03),
              border: Border.all(
                color: AppColors.outline.withValues(alpha: 0.7),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: SizedBox(
                    height: imageHeight,
                    child: _ShowcasePreviewImage(showcase: showcase),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.s12,
                      AppSpacing.s12,
                      AppSpacing.s12,
                      AppSpacing.s12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showcase.category != null) ...[
                          Text(
                            showcase.category!,
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.s8),
                        ],
                        Text(
                          showcase.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.titleMedium.copyWith(
                            height: 1.3,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (showcase.description != null) ...[
                          const SizedBox(height: AppSpacing.s8),
                          Text(
                            showcase.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.45,
                            ),
                          ),
                        ],
                        const Spacer(),
                        _ShowcaseMetaRow(showcase: showcase),
                        if (showcase.tags.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.s8),
                          _ShowcaseTagRow(tags: showcase.tags),
                        ],
                        const SizedBox(height: AppSpacing.s12),
                        _ShowcaseCta(onTap: onTap),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShowcasePreviewImage extends StatelessWidget {
  const _ShowcasePreviewImage({required this.showcase});

  final WorkflowShowcase showcase;

  String? get _imageUrl =>
      showcase.previewImageUrl ?? showcase.thumbnailUrl;

  @override
  Widget build(BuildContext context) {
    final imageUrl = _imageUrl;
    if (imageUrl == null || imageUrl.isEmpty) {
      return _ShowcaseGradientPlaceholder(showcase: showcase);
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) =>
          _ShowcaseGradientPlaceholder(showcase: showcase),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Stack(
          fit: StackFit.expand,
          children: [
            _ShowcaseGradientPlaceholder(showcase: showcase),
            Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white.withValues(alpha: 0.8),
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ShowcaseGradientPlaceholder extends StatelessWidget {
  const _ShowcaseGradientPlaceholder({required this.showcase});

  final WorkflowShowcase showcase;

  @override
  Widget build(BuildContext context) {
    final seed = showcase.id.hashCode.abs();
    final hue = (seed % 360).toDouble();

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            HSLColor.fromAHSL(1, hue, 0.45, 0.18).toColor(),
            HSLColor.fromAHSL(1, (hue + 40) % 360, 0.55, 0.28).toColor(),
            AppColors.primary.withValues(alpha: 0.35),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            top: -24,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Center(
            child: Icon(
              showcase.previewVideoUrl != null
                  ? Icons.play_circle_outline_rounded
                  : Icons.auto_awesome_rounded,
              size: 44,
              color: Colors.white.withValues(alpha: 0.82),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShowcaseMetaRow extends StatelessWidget {
  const _ShowcaseMetaRow({required this.showcase});

  final WorkflowShowcase showcase;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];

    if (showcase.difficulty != null) {
      items.add(_MetaChip(label: _difficultyLabel(showcase.difficulty!)));
    }
    if (showcase.estimatedTime != null) {
      items.add(_MetaChip(label: '約${showcase.estimatedTime}分'));
    }

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: AppSpacing.s8,
      runSpacing: AppSpacing.s8,
      children: items,
    );
  }

  static String _difficultyLabel(ShowcaseDifficulty difficulty) {
    switch (difficulty) {
      case ShowcaseDifficulty.easy:
        return 'かんたん';
      case ShowcaseDifficulty.normal:
        return '普通';
      case ShowcaseDifficulty.hard:
        return 'むずかしい';
    }
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label});

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
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.8)),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ShowcaseTagRow extends StatelessWidget {
  const _ShowcaseTagRow({required this.tags});

  final List<ShowcaseTag> tags;

  @override
  Widget build(BuildContext context) {
    final tagLabels = tags.map((tag) => tag.tag).take(3).toList();

    return Wrap(
      spacing: AppSpacing.s8,
      runSpacing: AppSpacing.s8,
      children: [
        for (final label in tagLabels)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s8,
              vertical: AppSpacing.s4,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: AppRadius.pill,
            ),
            child: Text(
              '#$label',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}

class _ShowcaseCta extends StatelessWidget {
  const _ShowcaseCta({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'この作品を作る',
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: AppSpacing.s4),
        Icon(
          Icons.arrow_forward_rounded,
          size: 16,
          color: AppColors.primary.withValues(alpha: 0.85),
        ),
      ],
    );
  }
}
