import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/domain/entities/category.dart';

/// カテゴリ横スクロールチップ一覧。
class CategoryChipList extends StatelessWidget {
  const CategoryChipList({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelected,
  });

  final List<Category> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: AppSpacing.pageHorizontal,
        children: [
          _CategoryChip(
            label: 'すべて',
            selected: selectedCategoryId == null,
            onTap: () => onSelected(null),
          ),
          for (final category in categories)
            _CategoryChip(
              label: category.name,
              selected: selectedCategoryId == category.id,
              onTap: () => onSelected(category.id),
            ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.s8),
      child: Material(
        color: selected ? AppColors.primary : AppColors.surface,
        borderRadius: AppRadius.pill,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.pill,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: AppRadius.pill,
              border: selected
                  ? null
                  : Border.all(color: AppColors.outline),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s16,
                vertical: AppSpacing.s8,
              ),
              child: Text(
                label,
                style: AppTypography.labelLarge.copyWith(
                  color: selected ? AppColors.surface : AppColors.textPrimary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
