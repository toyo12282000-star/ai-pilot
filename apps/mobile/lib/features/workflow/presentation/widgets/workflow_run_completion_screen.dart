import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/showcase_image_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_detail_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/showcase_image_placeholder.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/showcase_network_image.dart';

/// Run 完了後に表示する完成画面（Sprint 15.1 · 強化版 Mock UI）。
class WorkflowRunCompletionScreen extends ConsumerWidget {
  const WorkflowRunCompletionScreen({
    super.key,
    required this.workflowId,
    required this.workflowTitle,
    required this.elapsedMinutes,
    required this.aiToolNames,
    required this.onShare,
    required this.onAddFavorite,
    required this.onViewOutcome,
    required this.onGoHome,
  });

  final String workflowId;
  final String workflowTitle;
  final int elapsedMinutes;
  final List<String> aiToolNames;
  final VoidCallback onShare;
  final VoidCallback onAddFavorite;
  final VoidCallback onViewOutcome;
  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showcaseAsync = ref.watch(workflowPrimaryShowcaseProvider(workflowId));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.s16),
          showcaseAsync.when(
            loading: () => _ThumbnailPlaceholder(title: workflowTitle),
            error: (_, _) => _ThumbnailPlaceholder(title: workflowTitle),
            data: (showcase) {
              final resolver = ref.watch(showcaseImageResolverProvider);
              final imageUrl = showcase != null
                  ? (resolver.resolvePreviewUrl(showcase) ??
                      resolver.resolveThumbnailUrl(showcase))
                  : resolver.resolveHeroUrl(null, workflowId: workflowId);
              return _CompletionThumbnail(
                imageUrl: imageUrl,
                title: showcase?.title ?? workflowTitle,
              );
            },
          ),
          const SizedBox(height: AppSpacing.s24),
          Text(
            '完成おめでとう！',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            workflowTitle,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s24),
          _InfoRow(
            icon: Icons.schedule_outlined,
            label: '制作時間',
            value: '約$elapsedMinutes分',
          ),
          if (aiToolNames.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s12),
            _InfoRow(
              icon: Icons.auto_awesome_outlined,
              label: '使用AI',
              value: aiToolNames.join(' · '),
            ),
          ],
          const SizedBox(height: AppSpacing.s32),
          _ActionButton(
            label: '共有',
            icon: Icons.share_outlined,
            onPressed: onShare,
            filled: true,
          ),
          const SizedBox(height: AppSpacing.s12),
          _ActionButton(
            label: 'お気に入りに追加',
            icon: Icons.favorite_border_rounded,
            onPressed: onAddFavorite,
          ),
          const SizedBox(height: AppSpacing.s12),
          _ActionButton(
            label: '完成作品を見る',
            icon: Icons.play_circle_outline_rounded,
            onPressed: onViewOutcome,
          ),
          const SizedBox(height: AppSpacing.s12),
          _ActionButton(
            label: 'ホームへ戻る',
            icon: Icons.home_outlined,
            onPressed: onGoHome,
          ),
        ],
      ),
    );
  }
}

class _CompletionThumbnail extends StatelessWidget {
  const _CompletionThumbnail({
    required this.imageUrl,
    required this.title,
  });

  final String? imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.large,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ShowcaseNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              memCacheWidth: 960,
              placeholder: ShowcaseImagePlaceholder(
                icon: Icons.auto_awesome_rounded,
                iconSize: 36,
                compact: false,
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.charcoal.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.s16,
              right: AppSpacing.s16,
              bottom: AppSpacing.s12,
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.surface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThumbnailPlaceholder extends StatelessWidget {
  const _ThumbnailPlaceholder({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.large,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ShowcaseImagePlaceholder(
          icon: Icons.celebration_rounded,
          iconSize: 36,
          compact: false,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  value,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.filled = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: filled
          ? FilledButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 20),
              label: Text(label),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.s16),
              ),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 20),
              label: Text(label),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.s16),
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.medium,
                ),
              ),
            ),
    );
  }
}
