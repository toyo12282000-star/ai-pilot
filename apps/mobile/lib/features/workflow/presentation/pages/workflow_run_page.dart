import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/shared/providers/authenticated_user_provider.dart';
import 'package:ai_pilot/features/workflow/domain/entities/ai_tool.dart';
import 'package:ai_pilot/features/workflow/domain/entities/prompt_template.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_step.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_run_history_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_run_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_run_controls.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_run_header.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_run_step_card.dart';
import 'package:ai_pilot/shared/widgets/empty_view.dart';
import 'package:ai_pilot/shared/widgets/error_view.dart';
import 'package:ai_pilot/shared/widgets/fade_slide_in.dart';
import 'package:ai_pilot/shared/widgets/skeleton_card.dart';

/// ワークフロー実行画面。
class WorkflowRunPage extends ConsumerWidget {
  const WorkflowRunPage({
    super.key,
    required this.workflowId,
  });

  final String workflowId;

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
        loading: () => ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s16,
            AppSpacing.s8,
            AppSpacing.s16,
            AppSpacing.s16,
          ),
          children: const [
            SkeletonRunStepSection(),
          ],
        ),
        error: (error, _) => ErrorView(
          title: 'Workflowの読み込みに失敗しました',
          description: '通信状況を確認して、もう一度お試しください',
          onRetry: () => ref.invalidate(workflowByIdProvider(workflowId)),
          debugDetails: error,
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
          );
        },
      ),
    );
  }
}

class _WorkflowRunBody extends ConsumerStatefulWidget {
  const _WorkflowRunBody({
    required this.workflow,
    required this.steps,
  });

  final Workflow workflow;
  final List<WorkflowStep> steps;

  @override
  ConsumerState<_WorkflowRunBody> createState() => _WorkflowRunBodyState();
}

class _WorkflowRunBodyState extends ConsumerState<_WorkflowRunBody> {
  bool _historyStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startWorkflowHistory();
    });
  }

  Future<void> _startWorkflowHistory() async {
    if (_historyStarted) {
      return;
    }
    _historyStarted = true;

    final userId = ref.read(authenticatedUserIdProvider);
    if (userId == null) {
      return;
    }

    try {
      final repository = ref.read(workflowRunHistoryRepositoryProvider);
      await repository.startWorkflow(userId, widget.workflow.id);
      invalidateWorkflowRunHistoryForWorkflow(ref, widget.workflow.id);
    } catch (_) {
      // 履歴開始の失敗は実行自体を妨げない。
    }
  }

  Future<void> _updateProgress(int stepIndex) async {
    final userId = ref.read(authenticatedUserIdProvider);
    if (userId == null) {
      return;
    }

    try {
      final repository = ref.read(workflowRunHistoryRepositoryProvider);
      await repository.updateProgress(userId, widget.workflow.id, stepIndex);
      invalidateWorkflowRunHistoryForWorkflow(ref, widget.workflow.id);
    } catch (_) {
      // 進捗保存の失敗は実行自体を妨げない。
    }
  }

  Future<void> _completeWorkflow() async {
    final userId = ref.read(authenticatedUserIdProvider);
    if (userId != null) {
      try {
        final repository = ref.read(workflowRunHistoryRepositoryProvider);
        await repository.completeWorkflow(userId, widget.workflow.id);
        invalidateWorkflowRunHistoryForWorkflow(ref, widget.workflow.id);
      } catch (_) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('完了状態の保存に失敗しました。もう一度お試しください'),
          ),
        );
        return;
      }
    }

    final isAuthenticated = ref.read(isAuthenticatedProvider);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isAuthenticated
              ? 'Workflowを完了しました'
              : 'Workflowを完了しました。履歴を保存するにはログインすると便利です',
        ),
      ),
    );
    context.go('/');
  }

  void _retryResources() {
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
  Widget build(BuildContext context) {
    final aiToolsAsync = ref.watch(aiToolsProvider);
    final promptTemplatesAsync = ref.watch(promptTemplatesProvider);
    final stepIndex = ref.watch(workflowRunStepIndexProvider(widget.workflow.id));
    final lastIndex = widget.steps.length - 1;
    final currentStep = widget.steps[stepIndex.clamp(0, lastIndex)];
    final runNotifier =
        ref.read(workflowRunStepIndexProvider(widget.workflow.id).notifier);

    return aiToolsAsync.when(
      loading: () => ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s16,
          AppSpacing.s8,
          AppSpacing.s16,
          AppSpacing.s16,
        ),
        children: const [
          SkeletonRunStepSection(),
        ],
      ),
      error: (error, _) => ErrorView(
        title: 'ステップ情報の読み込みに失敗しました',
        description: '通信状況を確認して、もう一度お試しください',
        onRetry: _retryResources,
        debugDetails: error,
      ),
      data: (aiTools) => promptTemplatesAsync.when(
        loading: () => ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s16,
            AppSpacing.s8,
            AppSpacing.s16,
            AppSpacing.s16,
          ),
          children: const [
            SkeletonRunStepSection(),
          ],
        ),
        error: (error, _) => ErrorView(
          title: 'ステップ情報の読み込みに失敗しました',
          description: '通信状況を確認して、もう一度お試しください',
          onRetry: _retryResources,
          debugDetails: error,
        ),
        data: (promptTemplates) {
          if (aiTools.isEmpty && promptTemplates.isEmpty) {
            return const EmptyView(message: 'ステップ情報がありません');
          }

          final toolsById = {for (final tool in aiTools) tool.id: tool};
          final templatesById = {
            for (final template in promptTemplates) template.id: template,
          };

          final progress = (stepIndex + 1) / widget.steps.length;

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
                        workflowTitle: widget.workflow.title,
                        currentStepNumber: currentStep.order,
                        totalSteps: widget.steps.length,
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
                onPrevious: () {
                  runNotifier.previous();
                  _updateProgress(
                    ref.read(workflowRunStepIndexProvider(widget.workflow.id)),
                  );
                },
                onNext: () {
                  runNotifier.next(lastIndex);
                  _updateProgress(
                    ref.read(workflowRunStepIndexProvider(widget.workflow.id)),
                  );
                },
                onComplete: _completeWorkflow,
              ),
            ],
          );
        },
      ),
    );
  }
}
