import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/responsive.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';

/// 画面下部の固定アクションバー。
class BottomActionBar extends StatelessWidget {
  const BottomActionBar({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  static const double _buttonHeight = 52;

  /// ListView 等の末尾に確保する bottom padding。
  static double contentBottomInset(BuildContext context) {
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    const verticalPadding = AppSpacing.s8 * 2;
    return _buttonHeight + verticalPadding + safeBottom;
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = FilledButton.styleFrom(
      minimumSize: Size.fromHeight(_buttonHeight),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s12,
      ),
      textStyle: AppTypography.labelLarge.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: context.isMobile ? 15 : 16,
        color: AppColors.surface,
      ),
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.surface,
      disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.45),
      disabledForegroundColor: AppColors.surface.withValues(alpha: 0.85),
    );

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s16,
            AppSpacing.s8,
            AppSpacing.s16,
            AppSpacing.s8,
          ),
          child: SizedBox(
            width: double.infinity,
            child: icon != null
                ? FilledButton.icon(
                    onPressed: onPressed,
                    style: buttonStyle,
                    icon: Icon(icon, color: AppColors.surface),
                    label: Text(label),
                  )
                : FilledButton(
                    onPressed: onPressed,
                    style: buttonStyle,
                    child: Text(label),
                  ),
          ),
        ),
      ),
    );
  }
}
