import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';

/// 設定画面のセクションカード。
class SettingsSectionCard extends StatelessWidget {
  const SettingsSectionCard({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s8,
        AppSpacing.s16,
        AppSpacing.s8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.s4,
              bottom: AppSpacing.s8,
            ),
            child: Text(
              title,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.large,
              border: Border.all(color: AppColors.outline),
            ),
            child: Column(
              children: _buildChildrenWithDividers(children),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildChildrenWithDividers(List<Widget> items) {
    if (items.isEmpty) {
      return const [];
    }

    final result = <Widget>[];
    for (var index = 0; index < items.length; index++) {
      result.add(items[index]);
      if (index < items.length - 1) {
        result.add(const Divider(height: 1, color: AppColors.outline));
      }
    }
    return result;
  }
}

/// 設定画面のリスト項目。
class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.icon,
    this.onTap,
    this.showChevron = false,
  });

  final String title;
  final String? subtitle;
  final String? trailing;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.large,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s16,
            vertical: AppSpacing.s12,
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: AppColors.textSecondary),
                const SizedBox(width: AppSpacing.s12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.bodyMedium),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.s4),
                      Text(
                        subtitle!,
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null)
                Text(
                  trailing!,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              if (showChevron) ...[
                if (trailing != null) const SizedBox(width: AppSpacing.s8),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 設定画面のアカウント操作ボタン行。
class SettingsActionTile extends StatelessWidget {
  const SettingsActionTile({
    super.key,
    required this.label,
    required this.onPressed,
    this.destructive = false,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final bool destructive;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? AppColors.error : AppColors.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadius.large,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s16,
            vertical: AppSpacing.s16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: color),
                const SizedBox(width: AppSpacing.s8),
              ],
              Text(
                label,
                style: AppTypography.labelLarge.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
