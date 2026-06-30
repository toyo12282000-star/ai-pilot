import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_content_layout.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_search_bar.dart';

/// ホーム上部の Hero セクション（Linear 風 · 検索 + AI相談）。
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

  static const String subtitle =
      '完成作品から選ぶだけで\n'
      '必要なAI・プロンプト・手順まで\n'
      'まとめて案内します。';

  @override
  Widget build(BuildContext context) {
    return HomeContentLayout.constrain(
      context: context,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.hero,
        AppSpacing.s16,
        AppSpacing.section,
      ),
      child: ClipRRect(
        borderRadius: AppRadius.hero,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surface,
                AppColors.primarySoft.withValues(alpha: 0.4),
                const Color(0xFFEFF6FF).withValues(alpha: 0.55),
              ],
            ),
            border: Border.all(color: AppColors.border),
          ),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.82),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.7),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.card),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '今日は何を作りますか？',
                        style: AppTypography.heroTitle.copyWith(
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s12),
                      Text(
                        subtitle,
                        style: AppTypography.captionMedium.copyWith(
                          height: 1.65,
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
                        child: OutlinedButton.icon(
                          onPressed: onAdvisorTap,
                          icon: const Icon(Icons.auto_awesome_outlined, size: 18),
                          label: const Text('AIに相談する'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
