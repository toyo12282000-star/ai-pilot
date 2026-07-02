import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/icons.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/responsive.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/advisor/domain/entities/advisor_suggestion.dart';
import 'package:ai_pilot/features/advisor/presentation/models/advisor_chat_message.dart';
import 'package:ai_pilot/features/advisor/presentation/widgets/advisor_chat_bubble.dart';
import 'package:ai_pilot/features/advisor/presentation/widgets/advisor_quick_reply_chips.dart';
import 'package:ai_pilot/features/workflow/domain/entities/ai_tool.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/showcase_image_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_detail_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/showcase_image_placeholder.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/showcase_network_image.dart';
import 'package:ai_pilot/shared/widgets/meta_badge.dart';

/// チャットタイムライン + Quick Reply。
class AdvisorChatTimeline extends StatelessWidget {
  const AdvisorChatTimeline({
    super.key,
    required this.messages,
    required this.onQuickReply,
    this.interactionEnabled = true,
  });

  final List<AdvisorChatMessage> messages;
  final ValueChanged<String> onQuickReply;
  final bool interactionEnabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsiveSpacing.pageHorizontal(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final message in messages) ...[
            const SizedBox(height: AppSpacing.s12),
            AdvisorChatBubble(message: message),
            if (message.quickReplies.isNotEmpty)
              AdvisorQuickReplyChips(
                replies: message.quickReplies,
                onSelected: onQuickReply,
                enabled: interactionEnabled,
              ),
          ],
        ],
      ),
    );
  }
}

/// 推薦結果セクション（1位強調 · 2/3位控えめ）。
class AdvisorRecommendationResultSection extends ConsumerWidget {
  const AdvisorRecommendationResultSection({
    super.key,
    required this.suggestions,
    required this.onOpenWorkflow,
    required this.onStartWorkflow,
    this.showAllRanks = true,
    this.onShowMore,
  });

  final List<AdvisorSuggestion> suggestions;
  final void Function(AdvisorSuggestion suggestion) onOpenWorkflow;
  final void Function(AdvisorSuggestion suggestion) onStartWorkflow;
  final bool showAllRanks;
  final VoidCallback? onShowMore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    final secondarySuggestions =
        showAllRanks ? suggestions.skip(1).toList() : const <AdvisorSuggestion>[];

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppResponsiveSpacing.pageHorizontal(context),
        AppSpacing.s16,
        AppResponsiveSpacing.pageHorizontal(context),
        AppSpacing.s8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'おすすめWorkflow',
            style: AppResponsiveTypography.sectionTitle(context),
          ),
          const SizedBox(height: AppSpacing.s12),
          _AdvisorResultCard(
            suggestion: suggestions.first,
            rank: 1,
            emphasized: true,
            onOpenWorkflow: () => onOpenWorkflow(suggestions.first),
            onStartWorkflow: () => onStartWorkflow(suggestions.first),
          ),
          if (secondarySuggestions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s12),
            for (var i = 0; i < secondarySuggestions.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.s8),
              _AdvisorResultCard(
                suggestion: secondarySuggestions[i],
                rank: i + 2,
                emphasized: false,
                onOpenWorkflow: () => onOpenWorkflow(secondarySuggestions[i]),
                onStartWorkflow: () => onStartWorkflow(secondarySuggestions[i]),
              ),
            ],
          ],
          if (!showAllRanks && suggestions.length > 1 && onShowMore != null) ...[
            const SizedBox(height: AppSpacing.s12),
            TextButton(
              onPressed: onShowMore,
              child: const Text('他の候補を見る'),
            ),
          ],
        ],
      ),
    );
  }
}

class _AdvisorResultCard extends ConsumerWidget {
  const _AdvisorResultCard({
    required this.suggestion,
    required this.rank,
    required this.emphasized,
    required this.onOpenWorkflow,
    required this.onStartWorkflow,
  });

  final AdvisorSuggestion suggestion;
  final int rank;
  final bool emphasized;
  final VoidCallback onOpenWorkflow;
  final VoidCallback onStartWorkflow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workflow = suggestion.workflow;
    final aiToolsAsync = ref.watch(aiToolsProvider);
    final showcaseAsync =
        ref.watch(workflowPrimaryShowcaseProvider(workflow.id));
    final imageResolver = ref.watch(showcaseImageResolverProvider);

    final toolNames = aiToolsAsync.maybeWhen(
      data: (tools) => _resolveToolNames(workflow, tools),
      orElse: () => <String>[],
    );

    final imageUrl = showcaseAsync.maybeWhen(
      data: (showcase) {
        if (showcase == null) {
          return null;
        }
        return imageResolver.resolvePreviewUrl(showcase) ??
            imageResolver.resolveHeroUrl(showcase, workflowId: workflow.id);
      },
      orElse: () => null,
    );

    final borderColor = emphasized ? AppColors.primary : AppColors.border;
    final backgroundColor =
        emphasized ? AppColors.primarySoft.withValues(alpha: 0.35) : AppColors.surface;

    return Material(
      color: backgroundColor,
      borderRadius: AppRadius.large,
      child: InkWell(
        onTap: onOpenWorkflow,
        borderRadius: AppRadius.large,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: AppRadius.large,
            border: Border.all(
              color: borderColor,
              width: emphasized ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.r16),
                ),
                child: AspectRatio(
                  aspectRatio: emphasized ? 16 / 7 : 16 / 8,
                  child: ShowcaseNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: 720,
                    placeholder: ShowcaseImagePlaceholder(
                      compact: context.isMobile,
                      iconSize: emphasized ? 28 : 22,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                  emphasized ? AppSpacing.s16 : AppSpacing.s12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: emphasized
                                ? AppColors.primary
                                : AppColors.surfaceMuted,
                            borderRadius: AppRadius.small,
                            border: Border.all(
                              color: emphasized
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                          child: Text(
                            '$rank',
                            style: AppTypography.labelMedium.copyWith(
                              color: emphasized
                                  ? AppColors.surface
                                  : AppColors.textSecondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s8),
                        Expanded(
                          child: Text(
                            workflow.title,
                            style: AppTypography.titleSmall.copyWith(
                              fontWeight: FontWeight.w700,
                              color: emphasized ? AppColors.charcoal : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Text(
                      suggestion.reason,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Wrap(
                      spacing: AppSpacing.s8,
                      runSpacing: AppSpacing.s8,
                      children: [
                        if (toolNames.isNotEmpty)
                          MetaBadge(
                            icon: Icons.auto_awesome_outlined,
                            label: toolNames.take(2).join(' · '),
                          ),
                        MetaBadge(
                          icon: Icons.auto_awesome_rounded,
                          label: suggestion.difficulty,
                        ),
                        if (workflow.estimatedMinutes != null)
                          MetaBadge(
                            icon: AppIcons.schedule,
                            label: '約${workflow.estimatedMinutes}分',
                          ),
                      ],
                    ),
                    if (emphasized) ...[
                      const SizedBox(height: AppSpacing.s12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: onStartWorkflow,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.surface,
                          ),
                          child: const Text('このWorkflowを始める'),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s8),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: onOpenWorkflow,
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size.fromHeight(emphasized ? 44 : 40),
                        ),
                        child: const Text('詳細を見る'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static List<String> _resolveToolNames(
    Workflow workflow,
    List<AITool> tools,
  ) {
    final ids = <String>{};
    for (final step in workflow.steps) {
      final toolId = step.aiToolId;
      if (toolId != null) {
        ids.add(toolId);
      }
    }
    final names = <String>[];
    for (final tool in tools) {
      if (ids.contains(tool.id)) {
        names.add(tool.name);
      }
    }
    return names;
  }
}

/// 推薦 0 件 / エラー表示。
class AdvisorChatEmptyResult extends StatelessWidget {
  const AdvisorChatEmptyResult({
    super.key,
    required this.onRetry,
    required this.onGoHome,
  });

  final VoidCallback onRetry;
  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsiveSpacing.pageHorizontal(context),
      ),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.s8),
          Text(
            '近いWorkflowが見つかりませんでした',
            textAlign: TextAlign.center,
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            '別の言葉で試すか、ホームから探してみてください',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          OutlinedButton(
            onPressed: onRetry,
            child: const Text('もう一度相談する'),
          ),
          const SizedBox(height: AppSpacing.s8),
          TextButton(
            onPressed: onGoHome,
            child: const Text('ホームで探す'),
          ),
        ],
      ),
    );
  }
}

class AdvisorChatErrorBanner extends StatelessWidget {
  const AdvisorChatErrorBanner({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsiveSpacing.pageHorizontal(context),
        vertical: AppSpacing.s8,
      ),
      child: Material(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        child: InkWell(
          onTap: onRetry,
          borderRadius: AppRadius.medium,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: AppRadius.medium,
              border: Border.all(color: AppColors.error.withValues(alpha: 0.35)),
            ),
            padding: const EdgeInsets.all(AppSpacing.s12),
            child: Row(
              children: [
                Icon(Icons.error_outline_rounded, color: AppColors.error, size: 18),
                const SizedBox(width: AppSpacing.s8),
                Expanded(
                  child: Text(
                    message,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
