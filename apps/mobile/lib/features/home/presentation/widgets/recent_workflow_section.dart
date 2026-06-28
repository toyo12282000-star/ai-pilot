import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_section_header.dart';
import 'package:ai_pilot/features/home/presentation/widgets/recommended_workflow_card.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_run_history.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_run_history_providers.dart';
import 'package:ai_pilot/shared/providers/authenticated_user_provider.dart';

/// 最近使った Workflow 横スクロールセクション。
class RecentWorkflowSection extends ConsumerWidget {
  const RecentWorkflowSection({super.key});

  static const int _maxItems = 3;

  List<Workflow> _resolveWorkflows(
    List<WorkflowRunHistory> histories,
    List<Workflow> allWorkflows,
  ) {
    final workflowsById = {for (final workflow in allWorkflows) workflow.id: workflow};

    return histories
        .take(_maxItems)
        .map((history) => workflowsById[history.workflowId])
        .whereType<Workflow>()
        .toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    if (!isAuthenticated) {
      return const SizedBox.shrink();
    }

    final historiesAsync = ref.watch(recentWorkflowHistoriesProvider);
    final allWorkflows =
        ref.watch(workflowsProvider).valueOrNull ?? const <Workflow>[];

    return historiesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (histories) {
        final workflows = _resolveWorkflows(histories, allWorkflows);
        if (workflows.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeSectionHeader(title: '最近使ったWorkflow'),
            SizedBox(
              height: RecommendedWorkflowCard.cardHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: AppSpacing.pageHorizontal,
                itemCount: workflows.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.s12),
                itemBuilder: (context, index) {
                  final workflow = workflows[index];
                  return RecommendedWorkflowCard(
                    workflow: workflow,
                    onTap: () => context.push('/workflows/${workflow.id}'),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
          ],
        );
      },
    );
  }
}
