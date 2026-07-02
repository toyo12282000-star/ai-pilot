import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/responsive.dart';

/// Showcase 未登録時の共通プレースホルダー。
class ShowcaseImagePlaceholder extends StatelessWidget {
  const ShowcaseImagePlaceholder({
    super.key,
    this.icon = Icons.auto_awesome_outlined,
    this.iconSize,
    this.borderRadius,
    this.compact = false,
  });

  final IconData icon;
  final double? iconSize;
  final BorderRadius? borderRadius;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final resolvedIconSize = iconSize ??
        (compact || context.isMobile ? 24 : 32);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: AppColors.surfaceMuted,
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Icon(
          icon,
          size: resolvedIconSize,
          color: AppColors.primary.withValues(alpha: 0.45),
        ),
      ),
    );
  }
}
