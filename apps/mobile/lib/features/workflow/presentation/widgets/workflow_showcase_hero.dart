import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/icons.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_showcase.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_favorite_button.dart';
import 'package:ai_pilot/shared/widgets/meta_badge.dart';

/// 完成作品 Hero（Workflow 詳細最上部）。
class WorkflowShowcaseHero extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final title = showcase?.title ?? workflow.title;
    final description = showcase?.description ?? workflow.description;
    final category = showcase?.category;
    final imageUrl =
        showcase?.previewImageUrl ?? showcase?.thumbnailUrl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: AppRadius.large,
          child: AspectRatio(
            aspectRatio: compact ? 21 / 9 : 16 / 10,
            child: _HeroImage(imageUrl: imageUrl),
          ),
        ),
        SizedBox(height: compact ? AppSpacing.s16 : AppSpacing.s24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (category != null) ...[
                    Text(
                      category,
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                  ],
                  Text(
                    title,
                    style: (compact
                            ? AppTypography.titleLarge
                            : AppTypography.headlineSmall)
                        .copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            if (!compact)
              WorkflowFavoriteButton(workflowId: workflowId),
          ],
        ),
        const SizedBox(height: AppSpacing.s12),
        Text(
          description,
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: AppSpacing.s16),
        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          children: [
            if (showcase?.difficulty != null)
              MetaBadge(
                icon: Icons.speed_rounded,
                label: _difficultyLabel(showcase!.difficulty!),
              ),
            MetaBadge(
              icon: AppIcons.schedule,
              label: '約${_resolveMinutes()}分',
            ),
          ],
        ),
        if (!compact) ...[
          const SizedBox(height: AppSpacing.s24),
          FilledButton(
            onPressed: onStart,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
            ),
            child: const Text('この作品を作る'),
          ),
        ],
      ],
    );
  }

  int _resolveMinutes() {
    return showcase?.estimatedTime ?? workflow.estimatedMinutes ?? 30;
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
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const _HeroPlaceholder(),
      );
    }
    return const _HeroPlaceholder();
  }
}

class _HeroPlaceholder extends StatelessWidget {
  const _HeroPlaceholder();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.18),
            const Color(0xFF0F172A).withValues(alpha: 0.92),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.auto_awesome_rounded,
          size: 56,
          color: Colors.white.withValues(alpha: 0.75),
        ),
      ),
    );
  }
}
