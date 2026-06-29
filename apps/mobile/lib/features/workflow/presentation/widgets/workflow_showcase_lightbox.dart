import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/domain/entities/showcase_asset.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_showcase_gallery.dart';

/// ギャラリーアイテムの拡大表示。
abstract final class WorkflowShowcaseLightbox {
  static Future<void> show(
    BuildContext context,
    WorkflowGalleryItem item,
  ) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.82),
      builder: (context) => _LightboxDialog(item: item),
    );
  }
}

class _LightboxDialog extends StatelessWidget {
  const _LightboxDialog({required this.item});

  final WorkflowGalleryItem item;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF111827),
      insetPadding: const EdgeInsets.all(AppSpacing.s16),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 640),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s24,
                AppSpacing.s24,
                AppSpacing.s8,
                AppSpacing.s12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.showcase.title,
                          style: AppTypography.titleMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s4),
                        Text(
                          item.title,
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.72),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s24,
                  0,
                  AppSpacing.s24,
                  AppSpacing.s24,
                ),
                child: _LightboxContent(item: item),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LightboxContent extends StatelessWidget {
  const _LightboxContent({required this.item});

  final WorkflowGalleryItem item;

  @override
  Widget build(BuildContext context) {
    switch (item.type) {
      case ShowcaseAssetType.image:
        return _ImageContent(url: item.previewUrl ?? item.contentUrl);
      case ShowcaseAssetType.video:
        return _VideoContent(
          previewUrl: item.previewUrl,
          videoUrl: item.contentUrl ?? item.showcase.previewVideoUrl,
        );
      case ShowcaseAssetType.article:
      case ShowcaseAssetType.prompt:
        return _ArticleContent(
          title: item.title,
          body: item.showcase.completedOutput ??
              item.showcase.description ??
              '完成記事のプレビュー',
          url: item.contentUrl,
        );
      case ShowcaseAssetType.slide:
        return _ImageContent(url: item.previewUrl ?? item.contentUrl);
    }
  }
}

class _ImageContent extends StatelessWidget {
  const _ImageContent({this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return _Placeholder(message: '画像プレビューを表示できません');
    }

    return ClipRRect(
      borderRadius: AppRadius.medium,
      child: Image.network(
        url!,
        fit: BoxFit.contain,
        width: double.infinity,
        errorBuilder: (_, __, ___) =>
            const _Placeholder(message: '画像の読み込みに失敗しました'),
      ),
    );
  }
}

class _VideoContent extends StatelessWidget {
  const _VideoContent({
    this.previewUrl,
    this.videoUrl,
  });

  final String? previewUrl;
  final String? videoUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: AppRadius.medium,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (previewUrl != null)
                  Image.network(
                    previewUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  )
                else
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                    ),
                  ),
                Center(
                  child: Icon(
                    Icons.play_circle_fill_rounded,
                    size: 72,
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s12),
        Text(
          videoUrl ?? '完成動画プレビュー',
          style: AppTypography.bodySmall.copyWith(
            color: Colors.white.withValues(alpha: 0.72),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ArticleContent extends StatelessWidget {
  const _ArticleContent({
    required this.title,
    required this.body,
    this.url,
  });

  final String title;
  final String body;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.s24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: AppRadius.medium,
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.titleSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            Text(
              body,
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.86),
                height: 1.7,
              ),
            ),
            if (url != null) ...[
              const SizedBox(height: AppSpacing.s12),
              Text(
                url!,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary.withValues(alpha: 0.9),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: AppTypography.bodyMedium.copyWith(
          color: Colors.white.withValues(alpha: 0.72),
        ),
      ),
    );
  }
}
