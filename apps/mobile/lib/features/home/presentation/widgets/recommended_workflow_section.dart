import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_section_header.dart';
import 'package:ai_pilot/features/home/presentation/widgets/recommended_workflow_card.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';

/// おすすめ Workflow 横スクロールセクション。
class RecommendedWorkflowSection extends StatelessWidget {
  const RecommendedWorkflowSection({
    super.key,
    required this.workflows,
  });

  final List<Workflow> workflows;

  @override
  Widget build(BuildContext context) {
    if (workflows.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeSectionHeader(title: 'おすすめWorkflow'),
        SizedBox(
          height: RecommendedWorkflowCard.cardHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: AppSpacing.pageHorizontal,
            itemCount: workflows.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.s12),
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
  }
}
