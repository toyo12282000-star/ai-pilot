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
    this.minimal = false,
  });

  final IconData icon;
  final double? iconSize;
  final BorderRadius? borderRadius;
  final bool compact;

  /// ギャラリー等の小さなタイル向け（より薄い背景 · 小さなアイコン）。
  final bool minimal;

  @override
  Widget build(BuildContext context) {
    final resolvedIconSize = iconSize ??
        switch ((minimal, compact, context.isMobile)) {
          (true, _, _) => 16.0,
          (_, true, true) => 18.0,
          (_, true, false) => 24.0,
          _ => context.isMobile ? 28.0 : 32.0,
        };

    final backgroundColor = minimal
        ? AppColors.surfaceMuted.withValues(alpha: 0.55)
        : AppColors.surfaceMuted;

    final iconAlpha = minimal ? 0.28 : (compact ? 0.35 : 0.45);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: backgroundColor,
        border: minimal
            ? null
            : Border.all(
                color: AppColors.border.withValues(alpha: compact ? 0.65 : 1),
              ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: resolvedIconSize,
          color: AppColors.primary.withValues(alpha: iconAlpha),
        ),
      ),
    );
  }
}
