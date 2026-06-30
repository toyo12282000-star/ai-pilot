import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/icons.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/showcase_image_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/showcase_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/showcase_network_image.dart';
import 'package:ai_pilot/shared/widgets/hover_scale_surface.dart';

/// おすすめ Workflow 用の横スクロールカード。
class RecommendedWorkflowCard extends ConsumerWidget {
  const RecommendedWorkflowCard({
    super.key,
    required this.workflow,
    required this.onTap,
  });

  final Workflow workflow;
  final VoidCallback onTap;

  static const double cardWidth = 280;
  static const double cardHeight = 120;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showcases = ref.watch(workflowShowcasesProvider(workflow.id)).valueOrNull;
    final primaryShowcase =
        showcases != null && showcases.isNotEmpty ? showcases.first : null;
    final resolver = ref.watch(showcaseImageResolverProvider);
    final thumbnailUrl = primaryShowcase == null
        ? resolver.resolveHeroUrl(null, workflowId: workflow.id)
        : resolver.resolveThumbnailUrl(primaryShowcase) ??
            resolver.resolvePreviewUrl(primaryShowcase);

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: HoverScaleSurface(
        onTap: onTap,
        padding: const EdgeInsets.all(AppSpacing.s12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: AppRadius.medium,
              child: SizedBox(
                width: 72,
                height: 72 * 10 / 16,
                child: thumbnailUrl != null && thumbnailUrl.isNotEmpty
                    ? ShowcaseNetworkImage(
                        imageUrl: thumbnailUrl,
                        fit: BoxFit.cover,
                        memCacheWidth: 144,
                        placeholder: const _ThumbPlaceholder(),
                      )
                    : const _ThumbPlaceholder(),
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    workflow.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.titleSmall.copyWith(height: 1.35),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  if (workflow.estimatedMinutes != null)
                    Text(
                      '約${workflow.estimatedMinutes}分',
                      style: AppTypography.caption,
                    ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_rounded,
              size: AppIcons.sizeSm,
              color: AppColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}

class _ThumbPlaceholder extends StatelessWidget {
  const _ThumbPlaceholder();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceMuted,
      child: const Center(
        child: Icon(Icons.image_outlined, size: 18, color: AppColors.muted),
      ),
    );
  }
}
