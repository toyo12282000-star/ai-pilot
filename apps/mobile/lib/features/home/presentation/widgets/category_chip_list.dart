import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/animations.dart';
import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_browse_category.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_content_layout.dart';
import 'package:ai_pilot/features/workflow/domain/entities/category.dart';

/// カテゴリ横スクロールチップ一覧（Apple 風）。
class CategoryChipList extends StatelessWidget {
  const CategoryChipList({
    super.key,
    this.categories = const [],
    this.chips,
    required this.selectedCategoryId,
    required this.onSelected,
  });

  final List<Category> categories;
  final List<HomeBrowseCategory>? chips;
  final String? selectedCategoryId;
  final ValueChanged<String?> onSelected;

  static const double chipHeight = 40;

  @override
  Widget build(BuildContext context) {
    final browseChips = chips ?? const <HomeBrowseCategory>[];

    return HomeContentLayout.constrain(
      context: context,
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: chipHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: HomeContentLayout.horizontalPadding(context),
          itemCount: browseChips.isNotEmpty ? browseChips.length + 1 : categories.length + 1,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.s8),
          itemBuilder: (context, index) {
            if (index == 0) {
              return _CategoryChip(
                label: 'すべて',
                selected: selectedCategoryId == null,
                onTap: () => onSelected(null),
              );
            }

            if (browseChips.isNotEmpty) {
              final chip = browseChips[index - 1];
              return _CategoryChip(
                label: chip.label,
                selected: selectedCategoryId == chip.categoryId,
                onTap: () => onSelected(chip.categoryId),
              );
            }

            final category = categories[index - 1];
            return _CategoryChip(
              label: category.name,
              selected: selectedCategoryId == category.id,
              onTap: () => onSelected(category.id),
            );
          },
        ),
      ),
    );
  }
}

class _CategoryChip extends StatefulWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<_CategoryChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.selected
        ? AppColors.primarySoft
        : _hovered
            ? AppColors.surfaceMuted
            : AppColors.surface;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: AppRadius.pill,
          child: AnimatedContainer(
            duration: AppAnimations.interactive,
            curve: AppAnimations.easeOut,
            height: CategoryChipList.chipHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: AppRadius.pill,
              color: backgroundColor,
              border: Border.all(
                color: widget.selected
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : AppColors.border,
              ),
            ),
            child: Text(
              widget.label,
              style: AppTypography.labelLarge.copyWith(
                color: widget.selected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: widget.selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
