import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_content_layout.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_section_header.dart';
import 'package:ai_pilot/features/home/presentation/widgets/recommended_workflow_card.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/shared/widgets/skeleton_box.dart';

/// Home 向け Workflow 横スクロールセクション（最近使った / お気に入り共通）。
class HomeWorkflowCarouselSection extends StatelessWidget {
  const HomeWorkflowCarouselSection({
    super.key,
    required this.title,
    required this.workflows,
    required this.onWorkflowTap,
    required this.emptyTitle,
    required this.emptySubtitle,
    this.emptyActionLabel,
    this.onEmptyAction,
    this.isLoading = false,
  });

  final String title;
  final List<Workflow> workflows;
  final ValueChanged<Workflow> onWorkflowTap;
  final String emptyTitle;
  final String emptySubtitle;
  final String? emptyActionLabel;
  final VoidCallback? onEmptyAction;
  final bool isLoading;

  static const double _listHeight = RecommendedWorkflowCard.cardHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeContentLayout.constrain(
          context: context,
          child: HomeSectionHeader(title: title),
        ),
        if (isLoading)
          HomeContentLayout.constrain(
            context: context,
            child: const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.s12),
              child: SkeletonBox(width: double.infinity, height: _listHeight),
            ),
          )
        else if (workflows.isEmpty)
          HomeContentLayout.constrain(
            context: context,
            child: _HomeSectionEmptyCard(
              title: emptyTitle,
              subtitle: emptySubtitle,
              actionLabel: emptyActionLabel,
              onAction: onEmptyAction,
            ),
          )
        else
          SizedBox(
            height: _listHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: HomeContentLayout.horizontalPadding(context),
              itemCount: workflows.length,
              itemBuilder: (context, index) {
                final workflow = workflows[index];
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < workflows.length - 1 ? AppSpacing.s12 : 0,
                  ),
                  child: RecommendedWorkflowCard(
                    workflow: workflow,
                    onTap: () => onWorkflowTap(workflow),
                  ),
                );
              },
            ),
          ),
        SizedBox(height: HomeContentLayout.sectionSpacing(context)),
      ],
    );
  }
}

class _HomeSectionEmptyCard extends StatelessWidget {
  const _HomeSectionEmptyCard({
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s24,
        ),
        child: Column(
          children: [
            Text(
              title,
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              subtitle,
              style: AppTypography.bodySmall.copyWith(color: AppColors.muted),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.s16),
              TextButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
