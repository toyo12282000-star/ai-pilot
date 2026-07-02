import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/responsive.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/presentation/mock/workflow_product_page_mock_data.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_detail_layout.dart';

/// Before → After 比較セクション。
class WorkflowBeforeAfterSection extends StatelessWidget {
  const WorkflowBeforeAfterSection({
    super.key,
    required this.workflowId,
  });

  final String workflowId;

  @override
  Widget build(BuildContext context) {
    final pairs = beforeAfterPairsForWorkflow(workflowId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WorkflowDetailSectionHeader(
          title: 'Before → After',
          subtitle: 'この Workflow でどう変わるか',
        ),
        const SizedBox(height: AppSpacing.s12),
        Column(
          children: [
            for (var i = 0; i < pairs.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.s8),
              _BeforeAfterCard(pair: pairs[i]),
            ],
          ],
        ),
      ],
    );
  }
}

class _BeforeAfterCard extends StatelessWidget {
  const _BeforeAfterCard({required this.pair});

  final WorkflowBeforeAfterPair pair;

  @override
  Widget build(BuildContext context) {
    final compact = context.isMobile;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: EdgeInsets.all(compact ? AppSpacing.s12 : AppSpacing.s16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final stackVertically = constraints.maxWidth < 340;

            if (stackVertically) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _BeforeAfterColumn(
                    label: 'Before',
                    text: pair.before,
                    muted: true,
                    compact: compact,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.arrow_downward_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  _BeforeAfterColumn(
                    label: 'After',
                    text: pair.after,
                    muted: false,
                    compact: compact,
                  ),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _BeforeAfterColumn(
                    label: 'Before',
                    text: pair.before,
                    muted: true,
                    compact: compact,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    compact ? AppSpacing.s4 : AppSpacing.s8,
                    AppSpacing.s24,
                    compact ? AppSpacing.s4 : AppSpacing.s8,
                    0,
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: compact ? 16 : 18,
                    color: AppColors.primary,
                  ),
                ),
                Expanded(
                  child: _BeforeAfterColumn(
                    label: 'After',
                    text: pair.after,
                    muted: false,
                    compact: compact,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BeforeAfterColumn extends StatelessWidget {
  const _BeforeAfterColumn({
    required this.label,
    required this.text,
    required this.muted,
    required this.compact,
  });

  final String label;
  final String text;
  final bool muted;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: muted ? AppColors.muted : AppColors.primary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
            fontSize: compact ? 10 : 11,
          ),
        ),
        SizedBox(height: compact ? AppSpacing.s4 : AppSpacing.s8),
        Text(
          text,
          style: AppResponsiveTypography.body(context).copyWith(
            color: muted ? AppColors.textSecondary : AppColors.textPrimary,
            fontWeight: muted ? FontWeight.w400 : FontWeight.w600,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
