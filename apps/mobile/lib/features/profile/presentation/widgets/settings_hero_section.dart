import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/icons.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/shared/widgets/hero_gradient_card.dart';
import 'package:ai_pilot/shared/widgets/meta_badge.dart';

/// 設定画面の Hero セクション。
class SettingsHeroSection extends StatelessWidget {
  const SettingsHeroSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isGuest,
  });

  final String title;
  final String subtitle;
  final bool isGuest;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              subtitle,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            MetaBadge(
              icon: isGuest ? Icons.person_outline : Icons.verified_user_outlined,
              label: isGuest ? 'ゲストモード' : 'ログイン済み',
            ),
          ],
        ),
      ),
    );
  }
}

/// 設定画面下部の開発中ラベル。
class SettingsPreviewBadge extends StatelessWidget {
  const SettingsPreviewBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s24,
      ),
      child: Center(
        child: MetaBadge(
          icon: AppIcons.schedule,
          label: 'MVP Preview',
        ),
      ),
    );
  }
}
