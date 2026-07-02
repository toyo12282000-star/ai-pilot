import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/responsive.dart';
import 'package:ai_pilot/design_system/spacing.dart';

/// Workflow 詳細画面の最大コンテンツ幅。
abstract final class WorkflowDetailLayout {
  static const double maxWidth = 720;

  static EdgeInsets horizontalPadding(BuildContext context) {
    return AppResponsiveSpacing.pagePadding(context);
  }

  static Widget constrain({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ?? horizontalPadding(context),
          child: child,
        ),
      ),
    );
  }
}

/// セクション見出し（Material カードなし）。
class WorkflowDetailSectionHeader extends StatelessWidget {
  const WorkflowDetailSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppResponsiveTypography.beforeAfterTitle(context),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.s8),
          Text(
            subtitle!,
            style: AppResponsiveTypography.body(context).copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.62),
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }
}
