import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/showcase_network_image.dart';
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
    final showcase = item.showcase;
    final hasVideo = showcase.previewVideoUrl != null;

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
                        if (showcase.category != null)
                          Text(
                            showcase.category!,
                            style: AppTypography.labelSmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.72),
                            ),
                          ),
                        Text(
                          showcase.title,
                          style: AppTypography.titleMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
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
                child: ClipRRect(
                  borderRadius: AppRadius.medium,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ShowcaseNetworkImage(
                        imageUrl: item.previewUrl,
                        fit: BoxFit.contain,
                        memCacheWidth: 1440,
                        placeholder: const _Placeholder(
                          message: '画像プレビューを表示できません',
                        ),
                      ),
                      if (hasVideo)
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
            ),
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
