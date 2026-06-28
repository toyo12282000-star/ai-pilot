import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/home/presentation/widgets/workflow_card.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/shared/widgets/fade_slide_in.dart';

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
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s8,
        AppSpacing.s16,
        AppSpacing.s32,
      ),
      itemCount: workflows.length + 1,
      separatorBuilder: (context, index) {
        if (index == 0) {
          return const SizedBox(height: AppSpacing.s4);
        }
        return const SizedBox(height: AppSpacing.s16);
      },
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '保存一覧',
                    style: AppTypography.titleMedium,
                  ),
                ),
                Text(
                  '${workflows.length}件',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        final workflow = workflows[index - 1];
        return FadeSlideIn(
          index: index,
          child: WorkflowCard(
            workflow: workflow,
            onTap: () => context.push('/workflows/${workflow.id}'),
          ),
        );
      },
    );
  }
}
