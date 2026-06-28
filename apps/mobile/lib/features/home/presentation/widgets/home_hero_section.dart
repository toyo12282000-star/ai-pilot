import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_search_bar.dart';
import 'package:ai_pilot/shared/widgets/hero_gradient_card.dart';

/// ホーム上部の Hero セクション（見出し + 検索）。
class HomeHeroSection extends StatelessWidget {
  const HomeHeroSection({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onSearchClear,
    required this.showClearButton,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchClear;
  final bool showClearButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s16,
        AppSpacing.s16,
        AppSpacing.s8,
      ),
      child: HeroGradientCard(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s24,
          AppSpacing.s32,
          AppSpacing.s24,
          AppSpacing.s24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '今日は何を作りますか？',
              style: AppTypography.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              '目的を選ぶだけで、最適なAIワークフローへ案内します',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            WorkflowSearchBar(
              controller: searchController,
              onChanged: onSearchChanged,
              onClear: onSearchClear,
              showClearButton: showClearButton,
              embedded: true,
            ),
          ],
        ),
      ),
    );
  }
}
