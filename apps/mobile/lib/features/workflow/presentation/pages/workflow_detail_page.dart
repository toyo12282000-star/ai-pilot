import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/app/app_text_styles.dart';
import 'package:ai_pilot/core/constants/app_spacing.dart';
import 'package:ai_pilot/features/workflow/domain/entities/ai_tool.dart';
import 'package:ai_pilot/features/workflow/domain/entities/prompt_template.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_step.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_favorite_button.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_step_card.dart';
import 'package:ai_pilot/shared/widgets/empty_view.dart';
import 'package:ai_pilot/shared/widgets/error_view.dart';
import 'package:ai_pilot/shared/widgets/loading_view.dart';

/// ワークフロー詳細画面。
class WorkflowDetailPage extends ConsumerWidget {
  const WorkflowDetailPage({
    super.key,
    required this.workflowId,
  });

  final String workflowId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workflowAsync = ref.watch(workflowByIdProvider(workflowId));

    final appBarTitle = workflowAsync.maybeWhen(
      data: (workflow) => workflow?.title ?? 'ワークフロー詳細',
      orElse: () => 'ワークフロー詳細',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        actions: [
          WorkflowFavoriteButton(workflowId: workflowId),
        ],
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
          return _WorkflowDetailBody(workflow: workflow);
        },
      ),
    );
  }
}

class _WorkflowDetailBody extends ConsumerWidget {
  const _WorkflowDetailBody({
    required this.workflow,
  });

  final Workflow workflow;

  void _retryStepResources(WidgetRef ref) {
    ref.invalidate(aiToolsProvider);
    ref.invalidate(promptTemplatesProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final aiToolsAsync = ref.watch(aiToolsProvider);
    final promptTemplatesAsync = ref.watch(promptTemplatesProvider);
    final sortedSteps = List.of(workflow.steps)
      ..sort((a, b) => a.order.compareTo(b.order));

    return ListView(
      padding: AppSpacing.page,
      children: [
        Text(
          workflow.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          workflow.description,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            if (workflow.estimatedMinutes != null)
              Chip(
                avatar: Icon(
                  Icons.schedule,
                  size: 18,
                  color: colorScheme.primary,
                ),
                label: Text('約${workflow.estimatedMinutes}分'),
              ),
            Chip(
              avatar: Icon(
                Icons.format_list_numbered,
                size: 18,
                color: colorScheme.primary,
              ),
              label: Text('${workflow.steps.length}ステップ'),
            ),
          ],
        ),
        if (workflow.tags.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md - AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final tag in workflow.tags)
                Chip(
                  label: Text(tag),
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        Text(
          'ステップ',
          style: theme.appText.sectionTitle,
        ),
        const SizedBox(height: AppSpacing.md - AppSpacing.xs),
        if (sortedSteps.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Text(
              'ステップがありません',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else
          _StepsSection(
            steps: sortedSteps,
            aiToolsAsync: aiToolsAsync,
            promptTemplatesAsync: promptTemplatesAsync,
            onRetry: () => _retryStepResources(ref),
          ),
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
        padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
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
    final promptTemplates = promptTemplatesAsync.value ?? const <PromptTemplate>[];

    if (aiTools.isEmpty && promptTemplates.isEmpty) {
      return const EmptyView(message: 'ステップ情報がありません');
    }

    final toolsById = {for (final tool in aiTools) tool.id: tool};
    final templatesById = {
      for (final template in promptTemplates) template.id: template,
    };

    return Column(
      children: [
        for (final step in steps)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.listItemGap),
            child: WorkflowStepCard(
              step: step,
              aiToolName: _resolveAiToolName(step, toolsById),
              promptContent: _resolvePromptContent(step, templatesById),
            ),
          ),
      ],
    );
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
}
