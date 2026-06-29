import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_content_layout.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_search_bar.dart';
import 'package:ai_pilot/shared/widgets/hero_gradient_card.dart';

/// ホーム上部の Hero セクション（AI相談 + 検索）。
class HomeHeroSection extends StatelessWidget {
  const HomeHeroSection({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onSearchClear,
    required this.showClearButton,
    required this.onAdvisorTap,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchClear;
  final bool showClearButton;
  final VoidCallback onAdvisorTap;

  @override
  Widget build(BuildContext context) {
    return HomeContentLayout.constrain(
      context: context,
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
              '何を作りたいですか？',
              style: AppTypography.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              '完成イメージからAIワークフローを選べます',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            FilledButton.tonalIcon(
              onPressed: onAdvisorTap,
              icon: const Icon(Icons.auto_awesome_rounded),
              label: const Text('AIに相談する'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                alignment: Alignment.centerLeft,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
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
