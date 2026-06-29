import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/domain/entities/showcase_tag.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_showcase.dart';

/// 人気完成作品用の横スクロール大カード。
class ShowcaseCard extends StatelessWidget {
  const ShowcaseCard({
    super.key,
    required this.showcase,
    required this.onTap,
  });

  final WorkflowShowcase showcase;
  final VoidCallback onTap;

  static const double cardWidth = 320;
  static const double imageHeight = cardWidth * 10 / 16;

  /// 横スクロール ListView の高さ目安（2行タイトル + メタ + タグ + CTA を含む）。
  static double get listExtent => imageHeight + 180;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.card,
          child: Ink(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.card,
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.s16,
                    AppSpacing.s12,
                    AppSpacing.s16,
                    AppSpacing.s16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showcase.category != null)
                        Text(
                          showcase.category!,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      if (showcase.category != null)
                        const SizedBox(height: AppSpacing.s4),
                      Text(
                        showcase.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.15,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s8),
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
        return _ShowcaseGradientPlaceholder(showcase: showcase);
      },
    );
  }
}

class _ShowcaseGradientPlaceholder extends StatelessWidget {
  const _ShowcaseGradientPlaceholder({required this.showcase});

  final WorkflowShowcase showcase;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkNavy.withValues(alpha: 0.92),
            AppColors.primary.withValues(alpha: 0.35),
            AppColors.surfaceMuted,
          ],
        ),
      ),
      child: Stack(
        children: [
          if (showcase.category != null)
            Positioned(
              top: AppSpacing.s12,
              left: AppSpacing.s12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s8,
                  vertical: AppSpacing.s4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: AppRadius.pill,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.18),
                  ),
                ),
                child: Text(
                  showcase.category!,
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          Center(
            child: Icon(
              showcase.previewVideoUrl != null
                  ? Icons.play_circle_outline_rounded
                  : Icons.auto_awesome_outlined,
              size: 32,
              color: Colors.white.withValues(alpha: 0.75),
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
    final parts = <String>[];
    if (showcase.estimatedTime != null) {
      parts.add('約${showcase.estimatedTime}分');
    }
    if (showcase.difficulty != null) {
      parts.add(_difficultyLabel(showcase.difficulty!));
    }

    if (parts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Text(
      parts.join(' · '),
      style: AppTypography.labelSmall.copyWith(
        color: AppColors.textSecondary,
      ),
    );
  }

  static String _difficultyLabel(ShowcaseDifficulty difficulty) {
    switch (difficulty) {
      case ShowcaseDifficulty.easy:
        return 'かんたん';
      case ShowcaseDifficulty.normal:
        return 'ふつう';
      case ShowcaseDifficulty.hard:
        return 'むずかしい';
    }
  }
}

class _ShowcaseTagRow extends StatelessWidget {
  const _ShowcaseTagRow({required this.tags});

  final List<ShowcaseTag> tags;

  @override
  Widget build(BuildContext context) {
    final tagLabels = tags.map((tag) => tag.tag).take(2).toList();

    return Text(
      tagLabels.join(' · '),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTypography.labelSmall.copyWith(
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _ShowcaseCta extends StatelessWidget {
  const _ShowcaseCta({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 32),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s12,
            vertical: AppSpacing.s4,
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: AppTypography.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        child: const Text('作ってみる'),
      ),
    );
  }
}
