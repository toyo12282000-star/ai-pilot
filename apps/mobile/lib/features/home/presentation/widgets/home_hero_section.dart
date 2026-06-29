import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_content_layout.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_search_bar.dart';

/// ホーム上部の Hero セクション（検索 + AI相談）。
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
        AppSpacing.s24,
        AppSpacing.s16,
        AppSpacing.s16,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: AppRadius.pill,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surface,
              AppColors.primary.withValues(alpha: 0.05),
              AppColors.secondary.withValues(alpha: 0.07),
            ],
            stops: const [0.0, 0.55, 1.0],
          ),
          border: Border.all(
            color: AppColors.outline.withValues(alpha: 0.45),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s32,
            AppSpacing.s32,
            AppSpacing.s32,
            AppSpacing.s32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '今日は何を作りますか？',
                style: AppTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              Text(
                '完成作品から選ぶだけで、必要なAI・プロンプト・手順までまとめて案内します。',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.55,
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
              const SizedBox(height: AppSpacing.s12),
              OutlinedButton.icon(
                onPressed: onAdvisorTap,
                icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                label: const Text('AIに相談する'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.medium,
                  ),
                  side: BorderSide(
                    color: AppColors.outline.withValues(alpha: 0.55),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
