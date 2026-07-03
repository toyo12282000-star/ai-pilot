import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/responsive.dart';
import 'package:ai_pilot/design_system/shadows.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_content_layout.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_search_bar.dart';

/// ホーム上部の Hero セクション（Warm White / Beige · 検索 + AI相談）。
class HomeHeroSection extends StatelessWidget {
  const HomeHeroSection({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onSearchClear,
    required this.showClearButton,
    required this.onAdvisorTap,
    this.showFirstTimeHint = false,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchClear;
  final bool showClearButton;
  final VoidCallback onAdvisorTap;
  final bool showFirstTimeHint;

  static const double _controlHeight = 46;

  static const String subtitleDesktop =
      '完成作品から選ぶだけで\n'
      '必要なAI・プロンプト・手順まで\n'
      'まとめて案内します。';

  static const String subtitleMobile =
      '完成作品から選ぶだけで、AI・プロンプト・手順まで案内します。';

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return HomeContentLayout.constrain(
      context: context,
      padding: EdgeInsets.fromLTRB(
        AppResponsiveSpacing.pageHorizontal(context),
        AppResponsiveSpacing.heroVertical(context),
        AppResponsiveSpacing.pageHorizontal(context),
        AppResponsiveSpacing.section(context),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide =
              constraints.maxWidth >= HomeContentLayout.desktopBreakpoint;

          return ClipRRect(
            borderRadius: isMobile ? AppRadius.xLarge : AppRadius.hero,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                border: Border.all(color: AppColors.border),
                boxShadow: AppShadows.small,
              ),
              child: Padding(
                padding: EdgeInsets.all(AppResponsiveSpacing.card(context)),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: _HeroContent(
                              searchController: searchController,
                              onSearchChanged: onSearchChanged,
                              onSearchClear: onSearchClear,
                              showClearButton: showClearButton,
                              onAdvisorTap: onAdvisorTap,
                              showFirstTimeHint: showFirstTimeHint,
                              compact: false,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.s32),
                          const SizedBox(
                            width: 260,
                            child: _HeroVisual(),
                          ),
                        ],
                      )
                    : _HeroContent(
                        searchController: searchController,
                        onSearchChanged: onSearchChanged,
                        onSearchClear: onSearchClear,
                        showClearButton: showClearButton,
                        onAdvisorTap: onAdvisorTap,
                        showFirstTimeHint: showFirstTimeHint,
                        compact: isMobile,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HeroContent extends StatelessWidget {
  const _HeroContent({
    required this.searchController,
    required this.onSearchChanged,
    required this.onSearchClear,
    required this.showClearButton,
    required this.onAdvisorTap,
    required this.showFirstTimeHint,
    required this.compact,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchClear;
  final bool showClearButton;
  final VoidCallback onAdvisorTap;
  final bool showFirstTimeHint;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showFirstTimeHint) ...[
          Text(
            'まずはここから',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: compact ? AppSpacing.s8 : AppSpacing.s12),
        ],
        Text(
          '今日は何を作りますか？',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppResponsiveTypography.heroTitle(context),
        ),
        SizedBox(height: compact ? AppSpacing.s8 : AppSpacing.s12),
        Text(
          compact ? HomeHeroSection.subtitleMobile : HomeHeroSection.subtitleDesktop,
          maxLines: compact ? 3 : null,
          style: AppResponsiveTypography.body(context).copyWith(
            color: AppColors.textSecondary,
            height: compact ? 1.5 : 1.65,
          ),
        ),
        SizedBox(height: compact ? AppSpacing.s16 : AppSpacing.s24),
        SizedBox(
          height: HomeHeroSection._controlHeight,
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
          height: HomeHeroSection._controlHeight,
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onAdvisorTap,
            icon: const Icon(
              Icons.auto_awesome_outlined,
              size: 18,
              color: AppColors.primary,
            ),
            label: const Text('AIに相談する'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.charcoal,
              side: const BorderSide(color: AppColors.primary),
              backgroundColor: AppColors.surface,
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroVisual extends StatelessWidget {
  const _HeroVisual();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.xLarge,
          border: Border.all(color: AppColors.border),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -12,
              top: -12,
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primarySoft.withValues(alpha: 0.85),
                ),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 24,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.large,
                  color: AppColors.primarySoft,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(
                  Icons.auto_awesome_outlined,
                  color: AppColors.primary.withValues(alpha: 0.75),
                  size: 28,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.layers_outlined,
                    size: 36,
                    color: AppColors.primary.withValues(alpha: 0.55),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    '完成作品ライブラリ',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
