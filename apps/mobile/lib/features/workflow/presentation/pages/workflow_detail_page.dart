import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_step.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/showcase_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_detail_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_ai_tools_section.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_before_after_section.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_collapsible_step_card.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_detail_layout.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_outcome_benefits_section.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_product_cta_section.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_product_stats_panel.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_recent_creations_section.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_showcase_gallery.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_showcase_hero.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_start_cta.dart';
import 'package:ai_pilot/shared/widgets/empty_view.dart';
import 'package:ai_pilot/shared/widgets/error_view.dart';
import 'package:ai_pilot/shared/widgets/fade_slide_in.dart';
import 'package:ai_pilot/shared/widgets/skeleton_card.dart';

/// ワークフロー詳細画面。
class WorkflowDetailPage extends ConsumerWidget {
  const WorkflowDetailPage({
    super.key,
    required this.workflowId,
  });

  final String workflowId;

  void _startWorkflow(BuildContext context) {
    context.push('/workflows/$workflowId/run');
  }

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(workflowByIdProvider(workflowId));
    ref.invalidate(workflowShowcasesProvider(workflowId));
    ref.invalidate(workflowPrimaryShowcaseProvider(workflowId));
    ref.invalidate(workflowAiToolsProvider(workflowId));
    await Future.wait([
      ref.read(workflowByIdProvider(workflowId).future),
      ref.read(workflowShowcasesProvider(workflowId).future),
    ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workflowAsync = ref.watch(workflowByIdProvider(workflowId));

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: workflowAsync.when(
        loading: () => const _WorkflowDetailSkeleton(),
        error: (error, _) => ErrorView(
          title: 'ワークフローの読み込みに失敗しました',
          description: '通信状況を確認して、もう一度お試しください',
          onRetry: () => ref.invalidate(workflowByIdProvider(workflowId)),
          debugDetails: error,
        ),
        data: (workflow) {
          if (workflow == null) {
            return const EmptyView(
              message: 'ワークフローが見つかりません',
            );
          }
          return _WorkflowDetailBody(
            workflow: workflow,
            workflowId: workflowId,
            onStartWorkflow: () => _startWorkflow(context),
            onRefresh: () => _refresh(ref),
          );
        },
      ),
    );
  }
}

class _WorkflowDetailSkeleton extends StatelessWidget {
  const _WorkflowDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        kToolbarHeight + AppSpacing.s8,
        AppSpacing.s16,
        AppSpacing.s16,
      ),
      children: const [
        SkeletonWorkflowDetailHero(),
        SizedBox(height: AppSpacing.s48),
        SkeletonWorkflowDetailGallery(),
        SizedBox(height: AppSpacing.s48),
        SkeletonAiToolCards(),
        SizedBox(height: AppSpacing.s48),
        SkeletonWorkflowDetailSteps(),
      ],
    );
  }
}

class _WorkflowDetailBody extends ConsumerWidget {
  const _WorkflowDetailBody({
    required this.workflow,
    required this.workflowId,
    required this.onStartWorkflow,
    required this.onRefresh,
  });

  final Workflow workflow;
  final String workflowId;
  final VoidCallback onStartWorkflow;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showcaseAsync = ref.watch(workflowPrimaryShowcaseProvider(workflowId));
    final showcasesAsync = ref.watch(workflowShowcasesProvider(workflowId));
    final sortedSteps = List<WorkflowStep>.of(workflow.steps)
      ..sort((a, b) => a.order.compareTo(b.order));

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: onRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                0,
                kToolbarHeight + AppSpacing.s8,
                0,
                AppSpacing.s32,
              ),
              children: [
                WorkflowDetailLayout.constrain(
                  context: context,
                  child: showcaseAsync.when(
                    loading: () => const SkeletonWorkflowDetailHero(),
                    error: (_, _) => WorkflowShowcaseHero(
                      workflow: workflow,
                      workflowId: workflowId,
                      showcase: null,
                      onStart: onStartWorkflow,
                    ),
                    data: (showcase) => FadeSlideIn(
                      index: 0,
                      child: WorkflowShowcaseHero(
                        workflow: workflow,
                        workflowId: workflowId,
                        showcase: showcase,
                        onStart: onStartWorkflow,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s24),
                WorkflowDetailLayout.constrain(
                  context: context,
                  child: FadeSlideIn(
                    index: 1,
                    child: WorkflowProductStatsPanel(workflowId: workflowId),
                  ),
                ),
                const SizedBox(height: AppSpacing.s48),
                WorkflowDetailLayout.constrain(
                  context: context,
                  child: FadeSlideIn(
                    index: 2,
                    child: WorkflowRecentCreationsSection(
                      workflowId: workflowId,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s48),
                WorkflowDetailLayout.constrain(
                  context: context,
                  child: FadeSlideIn(
                    index: 3,
                    child: WorkflowOutcomeBenefitsSection(
                      workflowId: workflowId,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s48),
                WorkflowDetailLayout.constrain(
                  context: context,
                  child: FadeSlideIn(
                    index: 4,
                    child: WorkflowBeforeAfterSection(
                      workflowId: workflowId,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s48),
                WorkflowDetailLayout.constrain(
                  context: context,
                  child: FadeSlideIn(
                    index: 5,
                    child: WorkflowProductCtaSection(
                      onPressed: onStartWorkflow,
                      subtitle: 'ステップを見る前に、まず無料で始められます',
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s48),
                WorkflowDetailLayout.constrain(
                  context: context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const WorkflowDetailSectionHeader(
                        title: '完成作品ギャラリー',
                        subtitle: '同じ Workflow で作られた作品例',
                      ),
                      const SizedBox(height: AppSpacing.s16),
                      showcasesAsync.when(
                        loading: () => const SkeletonWorkflowDetailGallery(),
                        error: (_, _) => const SizedBox.shrink(),
                        data: (showcases) => FadeSlideIn(
                          index: 6,
                          child: WorkflowShowcaseGallery(showcases: showcases),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s48),
                WorkflowDetailLayout.constrain(
                  context: context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const WorkflowDetailSectionHeader(
                        title: 'このWorkflowで使うAI',
                        subtitle: '各ステップで選べるおすすめツール',
                      ),
                      const SizedBox(height: AppSpacing.s16),
                      FadeSlideIn(
                        index: 7,
                        child: WorkflowAiToolsSection(workflowId: workflowId),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s48),
                WorkflowDetailLayout.constrain(
                  context: context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const WorkflowDetailSectionHeader(
                        title: 'ステップ',
                        subtitle: 'Goal・出力例・プロンプトを確認できます',
                      ),
                      const SizedBox(height: AppSpacing.s16),
                      if (sortedSteps.isEmpty)
                        const EmptyView(message: 'ステップがありません')
                      else
                        for (var i = 0; i < sortedSteps.length; i++) ...[
                          if (i > 0) const SizedBox(height: AppSpacing.s12),
                          FadeSlideIn(
                            index: i + 8,
                            child: WorkflowCollapsibleStepCard(
                              step: sortedSteps[i],
                              index: i,
                            ),
                          ),
                        ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s48),
                WorkflowDetailLayout.constrain(
                  context: context,
                  child: FadeSlideIn(
                    index: sortedSteps.length + 8,
                    child: WorkflowProductCtaSection(
                      onPressed: onStartWorkflow,
                      subtitle: '準備ができたら、無料でこの作品を作りましょう',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        WorkflowStartCta(onPressed: onStartWorkflow),
      ],
    );
  }
}
