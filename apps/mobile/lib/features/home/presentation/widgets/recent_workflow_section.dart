import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_content_layout.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_section_header.dart';
import 'package:ai_pilot/features/home/presentation/widgets/recommended_workflow_card.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_run_history.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_run_history_providers.dart';
import 'package:ai_pilot/shared/providers/authenticated_user_provider.dart';

/// 最近使った Workflow 横スクロールセクション（ログイン時のみ）。
class RecentWorkflowSection extends ConsumerWidget {
  const RecentWorkflowSection({super.key});

  static const int _maxItems = 3;
  static const double _listHeight = RecommendedWorkflowCard.cardHeight;

  List<Workflow> _resolveWorkflows(
    List<WorkflowRunHistory> histories,
    List<Workflow> allWorkflows,
  ) {
    final workflowsById = {
      for (final workflow in allWorkflows) workflow.id: workflow,
    };

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
            HomeContentLayout.constrain(
              context: context,
              child: const HomeSectionHeader(title: '最近使った'),
            ),
            SizedBox(
              height: _listHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: HomeContentLayout.horizontalPadding(context),
                scrollCacheExtent: ScrollCacheExtent.pixels(360),
                itemCount: workflows.length,
                itemBuilder: (context, index) {
                  final workflow = workflows[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < workflows.length - 1 ? AppSpacing.s12 : 0,
                    ),
                    child: RecommendedWorkflowCard(
                      workflow: workflow,
                      onTap: () => context.push('/workflows/${workflow.id}'),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: HomeContentLayout.sectionSpacing(context)),
          ],
        );
      },
    );
  }
}
