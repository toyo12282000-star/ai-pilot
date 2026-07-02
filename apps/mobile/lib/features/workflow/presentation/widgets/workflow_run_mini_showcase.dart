import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/showcase_image_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_detail_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/showcase_image_placeholder.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/showcase_network_image.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_showcase_gallery.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_showcase_lightbox.dart';

/// Run 画面上部の完成イメージ（コンパクト · タップで拡大）。
class WorkflowRunMiniShowcase extends ConsumerWidget {
  const WorkflowRunMiniShowcase({
    super.key,
    required this.workflow,
  });

  static const _cardHeight = 112.0;

  final Workflow workflow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showcaseAsync = ref.watch(workflowPrimaryShowcaseProvider(workflow.id));

    return showcaseAsync.when(
      loading: () => const SizedBox(
        height: _cardHeight,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (_, _) => _MiniShowcaseCard(
        title: workflow.title,
        subtitle: '完成イメージ',
        imageUrl: null,
        onTap: null,
      ),
      data: (showcase) {
        final resolver = ref.watch(showcaseImageResolverProvider);
        final title = showcase?.title ?? workflow.title;
        final imageUrl = showcase != null
            ? (resolver.resolvePreviewUrl(showcase) ??
                resolver.resolveThumbnailUrl(showcase))
            : resolver.resolveHeroUrl(null, workflowId: workflow.id);

        return _MiniShowcaseCard(
          title: title,
          subtitle: '完成イメージ',
          imageUrl: imageUrl,
          onTap: showcase == null
              ? null
              : () {
                  WorkflowShowcaseLightbox.show(
                    context,
                    WorkflowGalleryItem(
                      showcase: showcase,
                      previewUrl: resolver.resolvePreviewUrl(showcase),
                    ),
                  );
                },
        );
      },
    );
  }
}

class _MiniShowcaseCard extends StatelessWidget {
  const _MiniShowcaseCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String? imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: AppRadius.medium,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.medium,
        child: Ink(
          height: WorkflowRunMiniShowcase._cardHeight,
          decoration: BoxDecoration(
            borderRadius: AppRadius.medium,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(12),
                ),
                child: SizedBox(
                  width: 112,
                  height: WorkflowRunMiniShowcase._cardHeight,
                  child: ShowcaseNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: 320,
                    placeholder: ShowcaseImagePlaceholder(
                      icon: Icons.auto_awesome_rounded,
                      iconSize: 24,
                      compact: true,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s12,
                    vertical: AppSpacing.s8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        subtitle,
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s4),
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (onTap != null) ...[
                        const SizedBox(height: AppSpacing.s4),
                        Text(
                          'タップで拡大',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (onTap != null)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.s12),
                  child: Icon(
                    Icons.open_in_full_rounded,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
