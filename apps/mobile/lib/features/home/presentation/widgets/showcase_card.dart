import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_showcase.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/showcase_image_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/showcase_cta_copy.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/showcase_image_placeholder.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/showcase_network_image.dart';
import 'package:ai_pilot/shared/widgets/hover_scale_surface.dart';

/// 人気完成作品用の横スクロール大カード（Apple Store 風 · 画像主役）。
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
  static const double bodyExtent = 152;

  /// 横スクロール ListView の高さ目安。
  static double get listExtent => imageHeight + bodyExtent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth,
      child: HoverScaleSurface(
        onTap: onTap,
        borderRadius: AppRadius.card,
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.r16),
              ),
              child: SizedBox(
                height: imageHeight,
                child: _ShowcasePreviewImage(showcase: showcase),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showcase.category != null)
                    Text(
                      showcase.category!,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.muted,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.15,
                      ),
                    ),
                  if (showcase.category != null)
                    const SizedBox(height: AppSpacing.s4),
                  Text(
                    showcase.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.titleMedium.copyWith(
                      letterSpacing: -0.15,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  _ShowcaseMetaRow(showcase: showcase),
                  const SizedBox(height: AppSpacing.s12),
                  _ShowcaseCta(showcase: showcase, onTap: onTap),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShowcasePreviewImage extends ConsumerWidget {
  const _ShowcasePreviewImage({required this.showcase});

  final WorkflowShowcase showcase;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolver = ref.watch(showcaseImageResolverProvider);
    final imageUrl = resolver.resolvePreviewUrl(showcase);

    return ShowcaseNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      memCacheWidth: 640,
      placeholder: ShowcaseImagePlaceholder(
        icon: showcase.previewVideoUrl != null
            ? Icons.play_circle_outline_rounded
            : Icons.auto_awesome_outlined,
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
      style: AppTypography.caption,
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

class _ShowcaseCta extends StatelessWidget {
  const _ShowcaseCta({
    required this.showcase,
    required this.onTap,
  });

  final WorkflowShowcase showcase;
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
          textStyle: AppTypography.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Text(ShowcaseCtaCopy.cardLabel(showcase)),
      ),
    );
  }
}
