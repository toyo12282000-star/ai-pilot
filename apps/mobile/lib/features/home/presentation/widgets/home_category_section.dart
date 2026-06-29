import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/features/home/presentation/widgets/category_chip_list.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_browse_category.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_content_layout.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_section_header.dart';

/// カテゴリ横スクロールセクション。
class HomeCategorySection extends StatelessWidget {
  const HomeCategorySection({
    super.key,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  final String? selectedCategoryId;
  final ValueChanged<String?> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeContentLayout.constrain(
          context: context,
          child: const HomeSectionHeader(title: 'カテゴリ'),
        ),
        CategoryChipList(
          chips: HomeBrowseCategory.items,
          selectedCategoryId: selectedCategoryId,
          onSelected: onCategorySelected,
        ),
        const SizedBox(height: AppSpacing.s32),
      ],
    );
  }
}
