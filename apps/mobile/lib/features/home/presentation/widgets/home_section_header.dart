import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/responsive.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_content_layout.dart';

/// ホーム画面のセクション見出し。
class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.useLayout = false,
  });

  final String title;
  final String? trailing;

  /// [HomeContentLayout.constrain] 内で使う場合は false。
  final bool useLayout;

  @override
  Widget build(BuildContext context) {
    final header = Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppResponsiveTypography.sectionTitle(context),
            ),
          ),
          if (trailing != null)
            Text(
              trailing!,
              style: AppResponsiveTypography.caption(context).copyWith(
                color: AppColors.muted,
              ),
            ),
        ],
      ),
    );

    if (useLayout) {
      return HomeContentLayout.constrain(
        context: context,
        child: header,
      );
    }

    return header;
  }
}
