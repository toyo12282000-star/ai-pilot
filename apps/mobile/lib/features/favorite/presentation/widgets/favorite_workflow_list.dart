import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/core/constants/app_spacing.dart';
import 'package:ai_pilot/features/home/presentation/widgets/workflow_card.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';

/// お気に入りワークフロー一覧。
class FavoriteWorkflowList extends StatelessWidget {
  const FavoriteWorkflowList({
    super.key,
    required this.workflows,
  });

  final List<Workflow> workflows;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: AppSpacing.page,
      itemCount: workflows.length,
      separatorBuilder: (_, _) =>
          const SizedBox(height: AppSpacing.listItemGap),
      itemBuilder: (context, index) {
        final workflow = workflows[index];
        return WorkflowCard(
          workflow: workflow,
          onTap: () => context.push('/workflows/${workflow.id}'),
        );
      },
    );
  }
}
