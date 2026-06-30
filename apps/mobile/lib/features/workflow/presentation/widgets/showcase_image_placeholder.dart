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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkNavy.withValues(alpha: 0.88),
            AppColors.primary.withValues(alpha: 0.28),
            AppColors.surfaceMuted,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: iconSize,
          color: Colors.white.withValues(alpha: 0.72),
        ),
      ),
    );
  }
}
