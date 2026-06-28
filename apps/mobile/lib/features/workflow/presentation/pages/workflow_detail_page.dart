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
import 'package:ai_pilot/shared/widgets/loading_view.dart';

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
        loading: () => const LoadingView(),
        error: (_, _) => ErrorView(
          message: 'ワークフローの読み込みに失敗しました',
          onRetry: () => ref.invalidate(workflowByIdProvider(workflowId)),
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
          );
        },
      ),
    );
  }
}

class _WorkflowDetailBody extends ConsumerWidget {
  const _WorkflowDetailBody({
    required this.workflow,
    required this.workflowId,
    required this.onStartWorkflow,
  });

  final Workflow workflow;
  final String workflowId;
  final VoidCallback onStartWorkflow;

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
          child: ListView(
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
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.s32),
        child: LoadingView(message: 'ステップ情報を読み込み中...'),
      );
    }

    if (aiToolsAsync.hasError || promptTemplatesAsync.hasError) {
      return ErrorView(
        message: 'ステップ情報の読み込みに失敗しました',
        onRetry: onRetry,
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
