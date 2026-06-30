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

/// ワークフロー一覧のカード表示。
class WorkflowCard extends ConsumerWidget {
  const WorkflowCard({
    super.key,
    required this.workflow,
    this.onTap,
  });

  final Workflow workflow;
  final VoidCallback? onTap;

  static const double thumbnailSize = 88;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showcasesAsync = ref.watch(workflowShowcasesProvider(workflow.id));
    final showcases = showcasesAsync.valueOrNull;
    final primaryShowcase =
        showcases != null && showcases.isNotEmpty ? showcases.first : null;
    final resolver = ref.watch(showcaseImageResolverProvider);
    final thumbnailUrl = primaryShowcase == null
        ? resolver.resolveHeroUrl(null, workflowId: workflow.id)
        : resolver.resolveThumbnailUrl(primaryShowcase) ??
            resolver.resolvePreviewUrl(primaryShowcase);

    return HoverScaleSurface(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _WorkflowThumbnail(imageUrl: thumbnailUrl),
          const SizedBox(width: AppSpacing.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  workflow.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleMedium.copyWith(
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  workflow.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(height: 1.5),
                ),
                const SizedBox(height: AppSpacing.s12),
                Wrap(
                  spacing: AppSpacing.s8,
                  runSpacing: AppSpacing.s8,
                  children: [
                    if (workflow.estimatedMinutes != null)
                      _MetaBadge(
                        icon: AppIcons.schedule,
                        label: '約${workflow.estimatedMinutes}分',
                      ),
                    _MetaBadge(
                      icon: Icons.speed_outlined,
                      label: _difficultyLabel(workflow),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _difficultyLabel(Workflow workflow) {
    final stepCount = workflow.steps.length;
    final minutes = workflow.estimatedMinutes ?? 0;

    if (stepCount <= 2 && minutes <= 40) {
      return 'かんたん';
    }
    if (stepCount <= 3 && minutes <= 60) {
      return 'ふつう';
    }
    return 'ステップ多め';
  }
}

class _WorkflowThumbnail extends StatelessWidget {
  const _WorkflowThumbnail({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.medium,
      child: SizedBox(
        width: WorkflowCard.thumbnailSize,
        height: WorkflowCard.thumbnailSize * 10 / 16,
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? ShowcaseNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                memCacheWidth: 176,
                placeholder: const _ThumbnailPlaceholder(),
              )
            : const _ThumbnailPlaceholder(),
      ),
    );
  }
}

class _ThumbnailPlaceholder extends StatelessWidget {
  const _ThumbnailPlaceholder();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.medium,
      ),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: 22,
          color: AppColors.muted,
        ),
      ),
    );
  }
}

class _MetaBadge extends StatelessWidget {
  const _MetaBadge({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppRadius.pill,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.muted),
          const SizedBox(width: AppSpacing.s4),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
