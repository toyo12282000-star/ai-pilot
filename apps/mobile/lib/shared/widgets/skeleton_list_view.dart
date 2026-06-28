import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/shared/widgets/skeleton_box.dart';
import 'package:ai_pilot/shared/widgets/skeleton_card.dart';

/// 縦方向の Skeleton カード一覧。
class SkeletonListView extends StatelessWidget {
  const SkeletonListView({
    super.key,
    this.itemCount = 4,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.s16,
      AppSpacing.s8,
      AppSpacing.s16,
      AppSpacing.s32,
    ),
    this.showSectionHeader = true,
  });

  final int itemCount;
  final EdgeInsetsGeometry padding;
  final bool showSectionHeader;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount + (showSectionHeader ? 1 : 0),
      separatorBuilder: (context, index) {
        if (showSectionHeader && index == 0) {
          return const SizedBox(height: AppSpacing.s4);
        }
        return const SizedBox(height: AppSpacing.s16);
      },
      itemBuilder: (context, index) {
        if (showSectionHeader && index == 0) {
          return const Row(
            children: [
              Expanded(
                child: SkeletonBox(height: 20, borderRadius: AppRadius.small),
              ),
              SizedBox(width: AppSpacing.s16),
              SkeletonBox(
                width: 40,
                height: 16,
                borderRadius: AppRadius.small,
              ),
            ],
          );
        }
        return const SkeletonCard();
      },
    );
  }
}
