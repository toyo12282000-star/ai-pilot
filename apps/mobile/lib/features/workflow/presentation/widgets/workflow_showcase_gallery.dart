import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/design_system/breakpoints.dart';
import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/responsive.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_showcase.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/showcase_image_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/showcase_image_placeholder.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/showcase_network_image.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_showcase_lightbox.dart';
import 'package:ai_pilot/shared/widgets/hover_scale_surface.dart';

/// 同 Workflow の完成作品ギャラリー（グリッド · 眺めたくなるレイアウト）。
class WorkflowShowcaseGallery extends ConsumerWidget {
  const WorkflowShowcaseGallery({
    super.key,
    required this.showcases,
  });

  final List<WorkflowShowcase> showcases;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolver = ref.watch(showcaseImageResolverProvider);
    if (showcases.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= AppBreakpoints.desktopMin
            ? 3
            : width >= AppBreakpoints.tabletMin
                ? 2
                : 1;
        final spacing = context.isMobile ? AppSpacing.s12 : AppSpacing.s16;
        final tileWidth =
            (width - spacing * (crossAxisCount - 1)) / crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final showcase in showcases)
              SizedBox(
                width: tileWidth,
                child: _GalleryTile(
                  showcase: showcase,
                  previewUrl: resolver.resolvePreviewUrl(showcase),
                  onTap: () => WorkflowShowcaseLightbox.show(
                    context,
                    WorkflowGalleryItem(
                      showcase: showcase,
                      previewUrl: resolver.resolvePreviewUrl(showcase),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class WorkflowGalleryItem {
  const WorkflowGalleryItem({
    required this.showcase,
    this.asset,
    this.previewUrl,
  });

  final WorkflowShowcase showcase;
  final dynamic asset;
  final String? previewUrl;

  String get title => showcase.title;

  String? get contentUrl => showcase.previewVideoUrl;
}

class _GalleryTile extends StatelessWidget {
  const _GalleryTile({
    required this.showcase,
    required this.previewUrl,
    required this.onTap,
  });

  final WorkflowShowcase showcase;
  final String? previewUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final compact = context.isMobile;
    final imageAspect = compact ? 16 / 9 : 16 / 10;

    return HoverScaleSurface(
      onTap: onTap,
      padding: EdgeInsets.zero,
      borderRadius: AppRadius.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: imageAspect,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.r20),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ShowcaseNetworkImage(
                    imageUrl: previewUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: 720,
                    placeholder: ShowcaseImagePlaceholder(compact: compact),
                  ),
                  Positioned(
                    right: compact ? AppSpacing.s8 : AppSpacing.s12,
                    bottom: compact ? AppSpacing.s8 : AppSpacing.s12,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: AppRadius.pill,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(compact ? AppSpacing.s4 : AppSpacing.s8),
                        child: Icon(
                          Icons.zoom_out_map_rounded,
                          size: compact ? 14 : 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(compact ? AppSpacing.s12 : AppSpacing.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showcase.category != null)
                  Text(
                    showcase.category!,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (showcase.category != null)
                  const SizedBox(height: AppSpacing.s4),
                Text(
                  showcase.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleSmall.copyWith(
                    height: 1.3,
                    fontSize: compact ? 13 : 14,
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  _metaLabel(showcase),
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _metaLabel(WorkflowShowcase showcase) {
    final parts = <String>[];
    if (showcase.estimatedTime != null) {
      parts.add('約${showcase.estimatedTime}分');
    }
    if (showcase.difficulty != null) {
      parts.add(switch (showcase.difficulty!) {
        ShowcaseDifficulty.easy => 'かんたん',
        ShowcaseDifficulty.normal => 'ふつう',
        ShowcaseDifficulty.hard => 'むずかしい',
      });
    }
    return parts.join(' · ');
  }
}
