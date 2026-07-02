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

/// 同 Workflow の完成作品ギャラリー（モバイル 2 列 · lazy grid）。
class WorkflowShowcaseGallery extends ConsumerWidget {
  const WorkflowShowcaseGallery({
    super.key,
    required this.showcases,
  });

  final List<WorkflowShowcase> showcases;

  static int crossAxisCountForWidth(double width) {
    if (width >= AppBreakpoints.desktopMin) {
      return 3;
    }
    return 2;
  }

  static double gridSpacingForContext(BuildContext context) {
    return context.isMobile ? AppSpacing.s12 : AppSpacing.s16;
  }

  static double childAspectRatio({
    required double tileWidth,
    required bool compactScreen,
  }) {
    final textBlockHeight = compactScreen ? 52.0 : 64.0;
    const imageAspect = 4 / 3;
    final imageHeight = tileWidth / imageAspect;
    final totalHeight = imageHeight + textBlockHeight + 6;
    return tileWidth / totalHeight;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolver = ref.watch(showcaseImageResolverProvider);
    if (showcases.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = crossAxisCountForWidth(width);
        final spacing = gridSpacingForContext(context);
        final tileWidth =
            (width - spacing * (crossAxisCount - 1)) / crossAxisCount;
        final compactScreen =
            context.isMobile || tileWidth < AppBreakpoints.tabletMin;
        final aspectRatio = childAspectRatio(
          tileWidth: tileWidth,
          compactScreen: compactScreen,
        );

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: aspectRatio,
          ),
          itemCount: showcases.length,
          itemBuilder: (context, index) {
            final showcase = showcases[index];
            final thumbnailUrl = resolver.resolveThumbnailUrl(showcase);
            final previewUrl = resolver.resolvePreviewUrl(showcase);
            final galleryImageUrl = compactScreen
                ? (thumbnailUrl ?? previewUrl)
                : previewUrl;

            return _GalleryTile(
              key: ValueKey(showcase.id),
              showcase: showcase,
              imageUrl: galleryImageUrl,
              compactScreen: compactScreen,
              memCacheWidth: compactScreen ? 360 : 720,
              onTap: () => WorkflowShowcaseLightbox.show(
                context,
                WorkflowGalleryItem(
                  showcase: showcase,
                  previewUrl: previewUrl ?? thumbnailUrl,
                ),
              ),
            );
          },
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
    super.key,
    required this.showcase,
    required this.imageUrl,
    required this.compactScreen,
    required this.memCacheWidth,
    required this.onTap,
  });

  final WorkflowShowcase showcase;
  final String? imageUrl;
  final bool compactScreen;
  final int memCacheWidth;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const imageAspect = 4 / 3;
    final borderRadius = compactScreen ? AppRadius.medium : AppRadius.card;

    final card = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: imageAspect,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ShowcaseNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                memCacheWidth: memCacheWidth,
                memCacheHeight: compactScreen ? (memCacheWidth * 3 ~/ 4) : null,
                borderRadius: BorderRadius.vertical(
                  top: borderRadius.topLeft,
                ),
                placeholder: ShowcaseImagePlaceholder(
                  compact: compactScreen,
                  minimal: compactScreen,
                ),
              ),
              if (!compactScreen)
                Positioned(
                  right: AppSpacing.s8,
                  bottom: AppSpacing.s8,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: AppRadius.pill,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(AppSpacing.s4),
                      child: Icon(
                        Icons.zoom_out_map_rounded,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(compactScreen ? AppSpacing.s8 : AppSpacing.s12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!compactScreen && showcase.category != null) ...[
                Text(
                  showcase.category!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),
              ],
              Text(
                showcase.title,
                maxLines: compactScreen ? 1 : 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.titleSmall.copyWith(
                  height: 1.25,
                  fontSize: compactScreen ? 12 : 13,
                ),
              ),
              if (!compactScreen &&
                  _metaLabel(showcase).isNotEmpty) ...[
                const SizedBox(height: AppSpacing.s4),
                Text(
                  _metaLabel(showcase),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption,
                ),
              ],
            ],
          ),
        ),
      ],
    );

    return Material(
      color: AppColors.surface,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: borderRadius,
          ),
          child: card,
        ),
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
