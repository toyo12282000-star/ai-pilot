import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/responsive.dart';
import 'package:ai_pilot/design_system/spacing.dart';

/// Advisor 画面上部のコンパクト Header。
class AdvisorChatHeader extends StatelessWidget {
  const AdvisorChatHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppResponsiveSpacing.pageHorizontal(context),
        AppSpacing.s8,
        AppResponsiveSpacing.pageHorizontal(context),
        AppSpacing.s12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Advisorに相談',
            style: AppResponsiveTypography.detailHeadline(context),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            '2〜3問に答えるだけで、あなたに合うWorkflowを提案します',
            style: AppResponsiveTypography.body(context).copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
