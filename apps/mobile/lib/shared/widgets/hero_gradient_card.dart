import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';

/// Warm White / Beige ベースの Hero コンテナ。
class HeroGradientCard extends StatelessWidget {
  const HeroGradientCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.s24,
      AppSpacing.s24,
      AppSpacing.s24,
      AppSpacing.s24,
    ),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppRadius.hero,
        color: AppColors.surfaceMuted,
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
