import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/responsive.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/shared/providers/authenticated_user_provider.dart';
import 'package:ai_pilot/features/workflow/domain/entities/ai_tool.dart';
import 'package:ai_pilot/features/workflow/domain/entities/prompt_template.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_step.dart';
import 'package:ai_pilot/features/workflow/presentation/mock/workflow_run_ui_mock_data.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_run_history_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_run_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_run_achievement.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_run_ai_companion.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_run_ai_tool_cta.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_run_companion_mock_data.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_run_completion_screen.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_run_controls.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_run_current_step_panel.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_run_hint_card.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_run_mini_showcase.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_run_prompt_panel.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_run_step_checklist.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_run_sticky_progress.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_run_upcoming_steps.dart';
import 'package:ai_pilot/shared/widgets/empty_view.dart';
import 'package:ai_pilot/shared/widgets/error_view.dart';
import 'package:ai_pilot/shared/widgets/fade_slide_in.dart';
import 'package:ai_pilot/shared/widgets/skeleton_card.dart';

/// ワークフロー実行画面（Sprint 15.1 · AI 制作アシスタント UI）。
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
        title: workflowAsync.maybeWhen(
          data: (workflow) => Text(workflow?.title ?? '制作中'),
          orElse: () => const Text('制作中'),
        ),
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
  bool _showCompletion = false;
  bool _showAchievement = false;
  WorkflowRunAchievementCopy? _achievementCopy;
  Timer? _achievementTimer;
  late final DateTime _runStartedAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startWorkflowHistory();
    });
  }

  @override
  void dispose() {
    _achievementTimer?.cancel();
    super.dispose();
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

  Future<bool> _persistWorkflowCompletion() async {
    final userId = ref.read(authenticatedUserIdProvider);
    if (userId == null) {
      return true;
    }

    try {
      final repository = ref.read(workflowRunHistoryRepositoryProvider);
      await repository.completeWorkflow(userId, widget.workflow.id);
      invalidateWorkflowRunHistoryForWorkflow(ref, widget.workflow.id);
      return true;
    } catch (_) {
      if (!mounted) {
        return false;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('完了状態の保存に失敗しました。もう一度お試しください'),
        ),
      );
      return false;
    }
  }

  Future<void> _onCompletePressed() async {
    final saved = await _persistWorkflowCompletion();
    if (!saved || !mounted) {
      return;
    }

    final isAuthenticated = ref.read(isAuthenticatedProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isAuthenticated
              ? 'Workflowを完了しました'
              : 'Workflowを完了しました。履歴を保存するにはログインすると便利です',
        ),
      ),
    );

    setState(() => _showCompletion = true);
  }

  void _retryResources() {
    ref.invalidate(aiToolsProvider);
    ref.invalidate(promptTemplatesProvider);
  }

  void _showStepAchievement(int completedStepIndex) {
    _achievementTimer?.cancel();
    setState(() {
      _achievementCopy = WorkflowRunUiMockData.achievementFor(
        completedStepIndex: completedStepIndex,
        totalSteps: widget.steps.length,
      );
      _showAchievement = true;
    });

    _achievementTimer = Timer(const Duration(milliseconds: 2600), () {
      if (mounted) {
        setState(() => _showAchievement = false);
      }
    });
  }

  void _hideAchievement() {
    _achievementTimer?.cancel();
    if (_showAchievement) {
      setState(() => _showAchievement = false);
    }
  }

  AITool? _resolveAiTool(
    WorkflowStep step,
    Map<String, AITool> toolsById,
  ) {
    final aiToolId = step.aiToolId;
    if (aiToolId == null) {
      return null;
    }
    return toolsById[aiToolId];
  }

  String? _resolvePromptContent(
    WorkflowStep step,
    Map<String, PromptTemplate> templatesById,
  ) {
    final promptTemplateId = step.promptTemplateId;
    if (promptTemplateId == null) {
      return null;
    }
    return templatesById[promptTemplateId]?.content;
  }

  List<String> _collectAiToolNames(Map<String, AITool> toolsById) {
    final names = <String>[];
    final seen = <String>{};
    for (final step in widget.steps) {
      final tool = _resolveAiTool(step, toolsById);
      if (tool != null && seen.add(tool.id)) {
        names.add(tool.name);
      }
    }
    return names;
  }

  int _elapsedMinutes() {
    final elapsed = DateTime.now().difference(_runStartedAt).inMinutes;
    return elapsed < 1 ? 1 : elapsed;
  }

  void _mockAction(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showCompletion) {
      final aiTools = ref.read(aiToolsProvider).valueOrNull ?? [];
      final toolsById = {for (final tool in aiTools) tool.id: tool};

      return WorkflowRunCompletionScreen(
        workflowId: widget.workflow.id,
        workflowTitle: widget.workflow.title,
        elapsedMinutes: _elapsedMinutes(),
        aiToolNames: _collectAiToolNames(toolsById),
        onShare: () => _mockAction('共有しました（Mock）'),
        onAddFavorite: () => _mockAction('お気に入りに追加しました（Mock）'),
        onViewOutcome: () => _mockAction('完成作品ギャラリーを表示します（Mock）'),
        onGoHome: () => context.go('/'),
      );
    }

    final aiToolsAsync = ref.watch(aiToolsProvider);
    final promptTemplatesAsync = ref.watch(promptTemplatesProvider);
    final stepIndex = ref.watch(workflowRunStepIndexProvider(widget.workflow.id));
    final lastIndex = widget.steps.length - 1;
    final currentStep = widget.steps[stepIndex.clamp(0, lastIndex)];
    final runNotifier =
        ref.read(workflowRunStepIndexProvider(widget.workflow.id).notifier);
    final companionMessages = WorkflowRunCompanionMockData.messagesFor(
      currentStep,
      stepIndex,
    );
    final remainingMinutes = WorkflowRunUiMockData.remainingMinutes(
      totalEstimatedMinutes: widget.workflow.estimatedMinutes,
      currentStepIndex: stepIndex,
      totalSteps: widget.steps.length,
    );
    final hintMessage = WorkflowRunUiMockData.hintFor(currentStep, stepIndex);

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
          final currentAiTool = _resolveAiTool(currentStep, toolsById);
          final fallbackPrompt =
              _resolvePromptContent(currentStep, templatesById);
          final checklistItems = WorkflowRunUiMockData.checklistFor(
            currentStep,
            aiToolName: currentAiTool?.name,
          );

          return Column(
            children: [
              WorkflowRunStickyProgress(
                currentStepIndex: stepIndex,
                totalSteps: widget.steps.length,
                remainingMinutes: remainingMinutes,
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    AppResponsiveSpacing.pageHorizontal(context),
                    AppResponsiveSpacing.cardGap(context),
                    AppResponsiveSpacing.pageHorizontal(context),
                    AppSpacing.s16,
                  ),
                  children: [
                    FadeSlideIn(
                      index: 0,
                      child: WorkflowRunMiniShowcase(workflow: widget.workflow),
                    ),
                    if (_achievementCopy != null) ...[
                      const SizedBox(height: AppSpacing.s12),
                      WorkflowRunAchievement(
                        copy: _achievementCopy!,
                        visible: _showAchievement,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.s16),
                    FadeSlideIn(
                      index: 1,
                      key: ValueKey('companion-${currentStep.id}'),
                      child: WorkflowRunAiCompanion(
                        messages: companionMessages,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    FadeSlideIn(
                      index: 2,
                      key: ValueKey('step-${currentStep.id}'),
                      child: WorkflowRunCurrentStepPanel(step: currentStep),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    FadeSlideIn(
                      index: 3,
                      key: ValueKey('checklist-${currentStep.id}'),
                      child: WorkflowRunStepChecklist(items: checklistItems),
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    FadeSlideIn(
                      index: 4,
                      key: ValueKey('prompt-${currentStep.id}'),
                      child: WorkflowRunPromptPanel(
                        stepId: currentStep.id,
                        fallbackContent: fallbackPrompt,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    FadeSlideIn(
                      index: 5,
                      child: WorkflowRunAiToolCta(aiTool: currentAiTool),
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    FadeSlideIn(
                      index: 6,
                      key: ValueKey('hint-${currentStep.id}'),
                      child: WorkflowRunHintCard(message: hintMessage),
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    FadeSlideIn(
                      index: 7,
                      child: WorkflowRunUpcomingSteps(
                        steps: widget.steps,
                        currentStepIndex: stepIndex,
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
                  _hideAchievement();
                  runNotifier.previous();
                  _updateProgress(
                    ref.read(workflowRunStepIndexProvider(widget.workflow.id)),
                  );
                },
                onNext: () {
                  _showStepAchievement(stepIndex);
                  runNotifier.next(lastIndex);
                  _updateProgress(
                    ref.read(workflowRunStepIndexProvider(widget.workflow.id)),
                  );
                },
                onComplete: _onCompletePressed,
              ),
            ],
          );
        },
      ),
    );
  }
}
