import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/domain/entities/showcase_asset.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_showcase.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_showcase_lightbox.dart';

/// 同 Workflow の完成作品ギャラリー（横スクロール）。
class WorkflowShowcaseGallery extends StatelessWidget {
  const WorkflowShowcaseGallery({
    super.key,
    required this.showcases,
  });

  final List<WorkflowShowcase> showcases;

  static const double tileWidth = 220;
  static const double tileHeight = 280;

  @override
  Widget build(BuildContext context) {
    final items = _collectGalleryItems(showcases);
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: tileHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.s12),
        itemBuilder: (context, index) {
          final item = items[index];
          return _GalleryTile(
            item: item,
            onTap: () => WorkflowShowcaseLightbox.show(context, item),
          );
        },
      ),
    );
  }

  static List<WorkflowGalleryItem> _collectGalleryItems(
    List<WorkflowShowcase> showcases,
  ) {
    final items = <WorkflowGalleryItem>[];

    for (final showcase in showcases) {
      if (showcase.assets.isNotEmpty) {
        for (final asset in showcase.assets) {
          items.add(
            WorkflowGalleryItem(
              showcase: showcase,
              asset: asset,
              previewUrl: _resolvePreviewUrl(showcase, asset),
            ),
          );
        }
      } else {
        items.add(
          WorkflowGalleryItem(
            showcase: showcase,
            previewUrl: showcase.previewImageUrl ?? showcase.thumbnailUrl,
          ),
        );
      }
    }

    return items;
  }

  static String? _resolvePreviewUrl(
    WorkflowShowcase showcase,
    ShowcaseAsset asset,
  ) {
    if (asset.assetType == ShowcaseAssetType.image) {
      return asset.url ?? showcase.previewImageUrl ?? showcase.thumbnailUrl;
    }
    if (asset.assetType == ShowcaseAssetType.video) {
      return showcase.previewImageUrl ?? showcase.thumbnailUrl;
    }
    return showcase.previewImageUrl ?? showcase.thumbnailUrl;
  }
}

class WorkflowGalleryItem {
  const WorkflowGalleryItem({
    required this.showcase,
    this.asset,
    this.previewUrl,
  });

  final WorkflowShowcase showcase;
  final ShowcaseAsset? asset;
  final String? previewUrl;

  ShowcaseAssetType get type =>
      asset?.assetType ??
      (showcase.previewVideoUrl != null
          ? ShowcaseAssetType.video
          : ShowcaseAssetType.image);

  String get title =>
      asset?.title ?? showcase.title;

  String? get contentUrl => asset?.url ?? showcase.previewVideoUrl;
}

class _GalleryTile extends StatelessWidget {
  const _GalleryTile({
    required this.item,
    required this.onTap,
  });

  final WorkflowGalleryItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: WorkflowShowcaseGallery.tileWidth,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.large,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: AppRadius.large,
              border: Border.all(
                color: AppColors.outline.withValues(alpha: 0.55),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _PreviewImage(url: item.previewUrl),
                        Center(
                          child: Icon(
                            _typeIcon(item.type),
                            size: 40,
                            color: Colors.white.withValues(alpha: 0.88),
                          ),
                        ),
                        Positioned(
                          top: AppSpacing.s8,
                          left: AppSpacing.s8,
                          child: _TypeChip(type: item.type),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.s12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.showcase.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s4),
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
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

  static IconData _typeIcon(ShowcaseAssetType type) {
    switch (type) {
      case ShowcaseAssetType.image:
        return Icons.image_outlined;
      case ShowcaseAssetType.video:
        return Icons.play_circle_outline_rounded;
      case ShowcaseAssetType.article:
        return Icons.article_outlined;
      case ShowcaseAssetType.slide:
        return Icons.slideshow_outlined;
      case ShowcaseAssetType.prompt:
        return Icons.description_outlined;
    }
  }
}

class _PreviewImage extends StatelessWidget {
  const _PreviewImage({this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.25),
              const Color(0xFF0F172A),
            ],
          ),
        ),
      );
    }

    return Image.network(
      url!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.type});

  final ShowcaseAssetType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: AppRadius.pill,
      ),
      child: Text(
        _label(type),
        style: AppTypography.labelSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static String _label(ShowcaseAssetType type) {
    switch (type) {
      case ShowcaseAssetType.image:
        return '画像';
      case ShowcaseAssetType.video:
        return '動画';
      case ShowcaseAssetType.article:
        return '記事';
      case ShowcaseAssetType.slide:
        return 'スライド';
      case ShowcaseAssetType.prompt:
        return 'プロンプト';
    }
  }
}
