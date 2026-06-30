import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/animations.dart';
import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/domain/entities/ai_tool_alternative.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/outcome_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_detail_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/ai_tool_icon.dart';
import 'package:ai_pilot/shared/widgets/error_view.dart';
import 'package:ai_pilot/shared/widgets/skeleton_box.dart';

/// Workflow 詳細の「この Workflow で使う AI」セクション。
class WorkflowAiToolsSection extends ConsumerWidget {
  const WorkflowAiToolsSection({
    super.key,
    required this.workflowId,
  });

  final String workflowId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toolsAsync = ref.watch(workflowAiToolsProvider(workflowId));

    return toolsAsync.when(
      loading: () => const SkeletonAiToolCards(),
      error: (error, _) => ErrorView(
        title: 'AIツール情報の読み込みに失敗しました',
        description: '通信状況を確認して、もう一度お試しください',
        onRetry: () => ref.invalidate(workflowAiToolsProvider(workflowId)),
        debugDetails: error,
      ),
      data: (entries) {
        if (entries.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            for (var i = 0; i < entries.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.s12),
              _AiToolCard(entry: entries[i]),
            ],
          ],
        );
      },
    );
  }
}

class _AiToolCard extends ConsumerStatefulWidget {
  const _AiToolCard({required this.entry});

  final WorkflowAiToolEntry entry;

  @override
  ConsumerState<_AiToolCard> createState() => _AiToolCardState();
}

class _AiToolCardState extends ConsumerState<_AiToolCard> {
  bool _showAlternatives = false;

  @override
  Widget build(BuildContext context) {
    final tool = widget.entry.tool;
    final alternativesAsync =
        ref.watch(aiToolAlternativesProvider(tool.id));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s24),
      decoration: BoxDecoration(
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AIToolIconAvatar(
                iconName: tool.iconName,
                type: tool.type,
                size: 48,
              ),
              const SizedBox(width: AppSpacing.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            tool.name,
                            style: AppTypography.titleSmall.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (widget.entry.isRecommended)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.s8,
                              vertical: AppSpacing.s4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: AppRadius.pill,
                            ),
                            child: Text(
                              'おすすめ',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (widget.entry.pricingNote != null) ...[
                      const SizedBox(height: AppSpacing.s4),
                      Text(
                        widget.entry.pricingNote!,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (widget.entry.recommendationReason != null) ...[
            const SizedBox(height: AppSpacing.s12),
            Text(
              widget.entry.recommendationReason!,
              style: AppTypography.bodyMedium.copyWith(
                height: 1.55,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.s12),
          Row(
            children: [
              TextButton(
                onPressed: () => context.push('/ai-tools/${tool.id}'),
                child: const Text('詳細を見る'),
              ),
              TextButton(
                onPressed: () {
                  setState(() => _showAlternatives = !_showAlternatives);
                },
                child: Text(
                  _showAlternatives ? '代替ツールを閉じる' : '代替ツールを見る',
                ),
              ),
            ],
          ),
          AnimatedCrossFade(
            duration: AppAnimations.normal,
            sizeCurve: AppAnimations.easeInOut,
            crossFadeState: _showAlternatives
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity),
            secondChild: alternativesAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.only(top: AppSpacing.s8),
                child: SkeletonBox(height: 48, borderRadius: AppRadius.small),
              ),
              error: (_, _) => const SizedBox.shrink(),
              data: (alternatives) => _AlternativesList(
                alternatives: alternatives,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlternativesList extends ConsumerWidget {
  const _AlternativesList({required this.alternatives});

  final List<AIToolAlternative> alternatives;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (alternatives.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: AppSpacing.s8),
        child: Text(
          '代替ツールは登録されていません',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.s8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final alternative in alternatives)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.s8),
              child: InkWell(
                onTap: () =>
                    context.push('/ai-tools/${alternative.alternativeAiToolId}'),
                borderRadius: AppRadius.medium,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.s8,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.swap_horiz_rounded,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppSpacing.s8),
                      Expanded(
                        child: Text(
                          alternative.reason ?? '代替ツール',
                          style: AppTypography.bodySmall.copyWith(
                            height: 1.45,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class SkeletonAiToolCards extends StatelessWidget {
  const SkeletonAiToolCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SkeletonBox(height: 140, borderRadius: AppRadius.large),
        SizedBox(height: AppSpacing.s12),
        SkeletonBox(height: 140, borderRadius: AppRadius.large),
      ],
    );
  }
}
