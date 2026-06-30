import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/icons.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';

/// PC 幅向けの左サイドバーナビゲーション。
class AppSidebar extends StatelessWidget {
  const AppSidebar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  static const double width = 240;

  static const _items = [
    (icon: AppIcons.home, selectedIcon: AppIcons.homeFilled, label: 'ホーム'),
    (icon: AppIcons.favorite, selectedIcon: AppIcons.favoriteFilled, label: 'お気に入り'),
    (icon: AppIcons.settings, selectedIcon: AppIcons.settingsFilled, label: '設定'),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          right: BorderSide(color: AppColors.border),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s16,
            vertical: AppSpacing.s24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s8,
                  vertical: AppSpacing.s8,
                ),
                child: Text(
                  'AI Pilot',
                  style: AppTypography.titleMedium.copyWith(
                    letterSpacing: -0.2,
                    color: AppColors.charcoal,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              Text(
                'プロ向け AI ワークスペース',
                style: AppTypography.caption.copyWith(
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: AppSpacing.s32),
              for (var index = 0; index < _items.length; index++)
                _SidebarItem(
                  icon: selectedIndex == index
                      ? _items[index].selectedIcon
                      : _items[index].icon,
                  label: _items[index].label,
                  selected: selectedIndex == index,
                  onTap: () => onDestinationSelected(index),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.selected
        ? AppColors.primarySoft
        : _hovered
            ? AppColors.surfaceMuted
            : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s4),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s12,
                vertical: AppSpacing.s12,
              ),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: widget.selected
                    ? Border.all(
                        color: AppColors.primary.withValues(alpha: 0.25),
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    widget.icon,
                    size: AppIcons.sizeMd,
                    color: widget.selected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: AppTypography.labelLarge.copyWith(
                        color: widget.selected
                            ? AppColors.primary
                            : AppColors.charcoal,
                        fontWeight:
                            widget.selected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
