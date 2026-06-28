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
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_run_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_run_controls.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_run_header.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_run_step_card.dart';
import 'package:ai_pilot/shared/widgets/empty_view.dart';
import 'package:ai_pilot/shared/widgets/error_view.dart';
import 'package:ai_pilot/shared/widgets/fade_slide_in.dart';
import 'package:ai_pilot/shared/widgets/loading_view.dart';

/// ワークフロー実行画面。
class WorkflowRunPage extends ConsumerWidget {
  const WorkflowRunPage({
    super.key,
    required this.workflowId,
  });

  final String workflowId;

  void _completeWorkflow(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workflowを完了しました')),
    );
    context.go('/');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workflowAsync = ref.watch(workflowByIdProvider(workflowId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Workflow実行'),
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: workflowAsync.when(
        loading: () => const LoadingView(message: 'Workflowを読み込み中...'),
        error: (_, _) => ErrorView(
          message: 'Workflowの読み込みに失敗しました',
          onRetry: () => ref.invalidate(workflowByIdProvider(workflowId)),
        ),
        data: (workflow) {
          if (workflow == null) {
            return const EmptyView(message: 'Workflowが見つかりません');
          }

          final sortedSteps = List.of(workflow.steps)
            ..sort((a, b) => a.order.compareTo(b.order));

          if (sortedSteps.isEmpty) {
            return const EmptyView(message: '実行できるステップがありません');
          }

          return _WorkflowRunBody(
            workflow: workflow,
            steps: sortedSteps,
            onComplete: () => _completeWorkflow(context),
          );
        },
      ),
    );
  }
}

class _WorkflowRunBody extends ConsumerWidget {
  const _WorkflowRunBody({
    required this.workflow,
    required this.steps,
    required this.onComplete,
  });

  final Workflow workflow;
  final List<WorkflowStep> steps;
  final VoidCallback onComplete;

  void _retryResources(WidgetRef ref) {
    ref.invalidate(aiToolsProvider);
    ref.invalidate(promptTemplatesProvider);
  }

  String? _resolveAiToolName(
    WorkflowStep step,
    Map<String, AITool> toolsById,
  ) {
    final aiToolId = step.aiToolId;
    if (aiToolId == null) {
      return null;
    }
    return toolsById[aiToolId]?.name ?? 'AIツール情報を取得できませんでした';
  }

  String? _resolvePromptContent(
    WorkflowStep step,
    Map<String, PromptTemplate> templatesById,
  ) {
    final promptTemplateId = step.promptTemplateId;
    if (promptTemplateId == null) {
      return null;
    }
    return templatesById[promptTemplateId]?.content ??
        'プロンプト情報を取得できませんでした';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiToolsAsync = ref.watch(aiToolsProvider);
    final promptTemplatesAsync = ref.watch(promptTemplatesProvider);
    final stepIndex = ref.watch(workflowRunStepIndexProvider(workflow.id));
    final lastIndex = steps.length - 1;
    final currentStep = steps[stepIndex.clamp(0, lastIndex)];
    final runNotifier =
        ref.read(workflowRunStepIndexProvider(workflow.id).notifier);

    return aiToolsAsync.when(
      loading: () => const LoadingView(message: 'ステップ情報を読み込み中...'),
      error: (_, _) => ErrorView(
        message: 'ステップ情報の読み込みに失敗しました',
        onRetry: () => _retryResources(ref),
      ),
      data: (aiTools) => promptTemplatesAsync.when(
        loading: () => const LoadingView(message: 'ステップ情報を読み込み中...'),
        error: (_, _) => ErrorView(
          message: 'ステップ情報の読み込みに失敗しました',
          onRetry: () => _retryResources(ref),
        ),
        data: (promptTemplates) {
          if (aiTools.isEmpty && promptTemplates.isEmpty) {
            return const EmptyView(message: 'ステップ情報がありません');
          }

          final toolsById = {for (final tool in aiTools) tool.id: tool};
          final templatesById = {
            for (final template in promptTemplates) template.id: template,
          };

          final progress = (stepIndex + 1) / steps.length;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.s16,
                    AppSpacing.s8,
                    AppSpacing.s16,
                    AppSpacing.s16,
                  ),
                  children: [
                    FadeSlideIn(
                      index: 0,
                      child: WorkflowRunHeader(
                        workflowTitle: workflow.title,
                        currentStepNumber: currentStep.order,
                        totalSteps: steps.length,
                        progress: progress,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    FadeSlideIn(
                      index: 1,
                      key: ValueKey(currentStep.id),
                      child: WorkflowRunStepCard(
                        step: currentStep,
                        aiToolId: currentStep.aiToolId,
                        aiToolName: _resolveAiToolName(currentStep, toolsById),
                        promptContent:
                            _resolvePromptContent(currentStep, templatesById),
                      ),
                    ),
                  ],
                ),
              ),
              WorkflowRunControls(
                canGoPrevious: stepIndex > 0,
                canGoNext: stepIndex < lastIndex,
                isLastStep: stepIndex >= lastIndex,
                onPrevious: runNotifier.previous,
                onNext: () => runNotifier.next(lastIndex),
                onComplete: onComplete,
              ),
            ],
          );
        },
      ),
    );
  }
}
