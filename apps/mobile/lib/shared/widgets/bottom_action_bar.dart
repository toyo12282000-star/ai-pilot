import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/spacing.dart';

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

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.outline),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s16,
            AppSpacing.s12,
            AppSpacing.s16,
            AppSpacing.s12,
          ),
          child: SizedBox(
            width: double.infinity,
            child: icon != null
                ? FilledButton.icon(
                    onPressed: onPressed,
                    icon: Icon(icon),
                    label: Text(label),
                  )
                : FilledButton(
                    onPressed: onPressed,
                    child: Text(label),
                  ),
          ),
        ),
      ),
    );
  }
}
