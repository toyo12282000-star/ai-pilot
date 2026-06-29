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

  static const double _controlHeight = 48;

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
          borderRadius: AppRadius.card,
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surface,
              AppColors.primarySoft.withValues(alpha: 0.35),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '今日は何を作りますか？',
                style: AppTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.35,
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              Text(
                '完成作品から選んで、AI・プロンプト・手順まで一気通貫で進められます。',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              SizedBox(
                height: _controlHeight,
                child: WorkflowSearchBar(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  onClear: onSearchClear,
                  showClearButton: showClearButton,
                  embedded: true,
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              SizedBox(
                height: _controlHeight,
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onAdvisorTap,
                  icon: const Icon(Icons.auto_awesome_outlined, size: 18),
                  label: const Text('AIに相談する'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
