import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/app/app_text_styles.dart';
import 'package:ai_pilot/core/constants/app_spacing.dart';
import 'package:ai_pilot/features/home/presentation/widgets/recommended_workflow_card.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';

/// おすすめ Workflow 横スクロールセクション。
class RecommendedWorkflowSection extends StatelessWidget {
  const RecommendedWorkflowSection({
    super.key,
    required this.workflows,
  });

  final List<Workflow> workflows;

  static const double _listHeight = 132;

  @override
  Widget build(BuildContext context) {
    if (workflows.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: Text(
            'おすすめWorkflow',
            style: Theme.of(context).appText.sectionTitle,
          ),
        ),
        SizedBox(
          height: _listHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: AppSpacing.pageHorizontal,
            itemCount: workflows.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final workflow = workflows[index];
              return RecommendedWorkflowCard(
                workflow: workflow,
                onTap: () => context.push('/workflows/${workflow.id}'),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
