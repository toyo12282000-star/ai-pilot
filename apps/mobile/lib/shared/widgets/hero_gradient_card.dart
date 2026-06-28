import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';

/// 白ベース + Primary/Secondary グラデーションの Hero コンテナ。
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
        borderRadius: AppRadius.pill,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.primary.withValues(alpha: 0.06),
            AppColors.secondary.withValues(alpha: 0.08),
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
        border: Border.all(color: AppColors.outline),
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
