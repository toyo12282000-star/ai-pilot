import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/features/workflow/domain/entities/ai_tool.dart';
import 'package:ai_pilot/features/workflow/domain/entities/prompt_template.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_step.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_detail_hero.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_start_cta.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_step_timeline.dart';
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
    ref.invalidate(aiToolsProvider);
    ref.invalidate(promptTemplatesProvider);
    await Future.wait([
      ref.read(workflowByIdProvider(workflowId).future),
      ref.read(aiToolsProvider.future),
      ref.read(promptTemplatesProvider.future),
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
        SkeletonHeroCard(),
        SizedBox(height: AppSpacing.s32),
        SkeletonStepTimeline(),
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

  void _retryStepResources(WidgetRef ref) {
    ref.invalidate(aiToolsProvider);
    ref.invalidate(promptTemplatesProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiToolsAsync = ref.watch(aiToolsProvider);
    final promptTemplatesAsync = ref.watch(promptTemplatesProvider);
    final sortedSteps = List.of(workflow.steps)
      ..sort((a, b) => a.order.compareTo(b.order));

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: onRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s16,
                kToolbarHeight + AppSpacing.s8,
                AppSpacing.s16,
                AppSpacing.s16,
              ),
              children: [
                FadeSlideIn(
                  index: 0,
                  child: WorkflowDetailHero(
                    workflow: workflow,
                    workflowId: workflowId,
                  ),
                ),
                const SizedBox(height: AppSpacing.s32),
                if (sortedSteps.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.s32),
                    child: EmptyView(message: 'ステップがありません'),
                  )
                else
                  _StepsSection(
                    steps: sortedSteps,
                    aiToolsAsync: aiToolsAsync,
                    promptTemplatesAsync: promptTemplatesAsync,
                    onRetry: () => _retryStepResources(ref),
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

class _StepsSection extends StatelessWidget {
  const _StepsSection({
    required this.steps,
    required this.aiToolsAsync,
    required this.promptTemplatesAsync,
    required this.onRetry,
  });

  final List<WorkflowStep> steps;
  final AsyncValue<List<AITool>> aiToolsAsync;
  final AsyncValue<List<PromptTemplate>> promptTemplatesAsync;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (aiToolsAsync.isLoading || promptTemplatesAsync.isLoading) {
      return const SkeletonStepTimeline();
    }

    if (aiToolsAsync.hasError || promptTemplatesAsync.hasError) {
      return ErrorView(
        title: 'ステップ情報の読み込みに失敗しました',
        description: '通信状況を確認して、もう一度お試しください',
        onRetry: onRetry,
        debugDetails: aiToolsAsync.hasError
            ? aiToolsAsync.error
            : promptTemplatesAsync.error,
      );
    }

    final aiTools = aiToolsAsync.value ?? const <AITool>[];
    final promptTemplates =
        promptTemplatesAsync.value ?? const <PromptTemplate>[];

    if (aiTools.isEmpty && promptTemplates.isEmpty) {
      return const EmptyView(message: 'ステップ情報がありません');
    }

    final toolsById = {for (final tool in aiTools) tool.id: tool};
    final templatesById = {
      for (final template in promptTemplates) template.id: template,
    };

    return WorkflowStepTimeline(
      steps: steps,
      toolsById: toolsById,
      templatesById: templatesById,
    );
  }
}
