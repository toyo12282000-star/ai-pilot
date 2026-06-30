import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_showcase.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/showcase_image_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/showcase_cta_copy.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/showcase_image_placeholder.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/showcase_network_image.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_favorite_button.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_product_cta.dart';

/// 完成作品 Hero（Workflow 詳細最上部 · 作品紹介ページ）。
class WorkflowShowcaseHero extends ConsumerWidget {
  const WorkflowShowcaseHero({
    super.key,
    required this.workflow,
    required this.workflowId,
    required this.showcase,
    required this.onStart,
    this.compact = false,
  });

  final Workflow workflow;
  final String workflowId;
  final WorkflowShowcase? showcase;
  final VoidCallback onStart;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolver = ref.watch(showcaseImageResolverProvider);
    final title = showcase?.title ?? workflow.title;
    final category = showcase?.category;
    final imageUrl = resolver.resolveHeroUrl(
      showcase,
      workflowId: workflowId,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: AppRadius.hero,
          child: AspectRatio(
            aspectRatio: compact ? 21 / 9 : 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ShowcaseNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  memCacheWidth: 1440,
                  placeholder: const ShowcaseImagePlaceholder(
                    icon: Icons.auto_awesome_rounded,
                    iconSize: 56,
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.charcoal.withValues(alpha: 0.62),
                      ],
                    ),
                  ),
                ),
                if (category != null)
                  Positioned(
                    left: AppSpacing.s16,
                    bottom: AppSpacing.s16,
                    right: AppSpacing.s16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category,
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.primarySoft.withValues(alpha: 0.95),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s4),
                        Text(
                          title,
                          maxLines: compact ? 1 : 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.headlineSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.35,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (!compact) ...[
          const SizedBox(height: AppSpacing.s24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.35,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Text(
                      ShowcaseCtaCopy.heroSubtitle(showcase),
                      style: AppTypography.captionMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              WorkflowFavoriteButton(workflowId: workflowId),
            ],
          ),
          const SizedBox(height: AppSpacing.s24),
          WorkflowProductCta(onPressed: onStart),
        ],
      ],
    );
  }
}
