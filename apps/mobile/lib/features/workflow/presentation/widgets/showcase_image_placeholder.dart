import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';

/// Showcase 未登録時の共通プレースホルダー。
class ShowcaseImagePlaceholder extends StatelessWidget {
  const ShowcaseImagePlaceholder({
    super.key,
    this.icon = Icons.auto_awesome_outlined,
    this.iconSize = 32,
    this.borderRadius,
  });

  final IconData icon;
  final double iconSize;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: AppColors.surfaceMuted,
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Icon(
          icon,
          size: iconSize,
          color: AppColors.primary.withValues(alpha: 0.55),
        ),
      ),
    );
  }
}
