import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/responsive.dart';
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

  static const double _desktopCardWidth = 340;
  static const double _mobileCardWidth = 280;
  static const double _bodyExtentDesktop = 220;
  static const double _bodyExtentMobile = 188;

  static double cardWidth(BuildContext context) =>
      context.isMobile ? _mobileCardWidth : _desktopCardWidth;

  static double imageHeight(BuildContext context) =>
      cardWidth(context) * (context.isMobile ? 9 / 16 : 10 / 16);

  static double listExtent(BuildContext context) =>
      imageHeight(context) +
      (context.isMobile ? _bodyExtentMobile : _bodyExtentDesktop);

  @override
  Widget build(BuildContext context) {
    final width = cardWidth(context);
    final compact = context.isMobile;

    return SizedBox(
      width: width,
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
                top: Radius.circular(AppRadius.r20),
              ),
              child: SizedBox(
                height: imageHeight(context),
                child: _ShowcasePreviewImage(
                  showcase: showcase,
                  compact: compact,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(compact ? AppSpacing.s12 : AppSpacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showcase.category != null)
                        Flexible(
                          child: _CategoryPill(label: showcase.category!),
                        ),
                      const Spacer(),
                      Icon(
                        Icons.bookmark_border_rounded,
                        size: compact ? 18 : 20,
                        color: AppColors.muted,
                      ),
                    ],
                  ),
                  if (showcase.category != null)
                    SizedBox(height: compact ? AppSpacing.s8 : AppSpacing.s12),
                  Text(
                    showcase.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.titleMedium.copyWith(
                      fontSize: compact ? 15 : 16,
                      letterSpacing: -0.12,
                      height: 1.3,
                    ),
                  ),
                  if (showcase.description != null &&
                      showcase.description!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      showcase.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.s8),
                  _ShowcaseMetaRow(showcase: showcase),
                  SizedBox(height: compact ? AppSpacing.s8 : AppSpacing.s12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton(
                      onPressed: onTap,
                      style: FilledButton.styleFrom(
                        minimumSize: Size(0, compact ? 34 : 36),
                        padding: EdgeInsets.symmetric(
                          horizontal: compact ? AppSpacing.s12 : AppSpacing.s12,
                          vertical: AppSpacing.s4,
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.surface,
                        textStyle: AppTypography.labelLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.surface,
                          fontSize: compact ? 13 : 14,
                        ),
                      ),
                      child: Text(ShowcaseCtaCopy.cardLabel(showcase)),
                    ),
                  ),
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
  const _ShowcasePreviewImage({
    required this.showcase,
    required this.compact,
  });

  final WorkflowShowcase showcase;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolver = ref.watch(showcaseImageResolverProvider);
    final imageUrl = resolver.resolvePreviewUrl(showcase);

    return ShowcaseNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      memCacheWidth: 680,
      placeholder: ShowcaseImagePlaceholder(
        icon: showcase.previewVideoUrl != null
            ? Icons.play_circle_outline_rounded
            : Icons.auto_awesome_outlined,
        compact: compact,
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: AppRadius.pill,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.22),
        ),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
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
    final aiCount = _aiToolCountHint(showcase.workflowId);
    if (aiCount != null) {
      parts.add('AI $aiCount種類');
    }

    if (parts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Text(
      parts.join(' · '),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTypography.caption.copyWith(color: AppColors.muted),
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

  static int? _aiToolCountHint(String workflowId) {
    return switch (workflowId) {
      'wf_youtube_short' => 5,
      'wf_blog' => 3,
      'wf_sns' => 3,
      _ => null,
    };
  }
}
