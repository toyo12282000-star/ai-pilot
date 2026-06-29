import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_content_layout.dart';

/// 「AI相談」誘導カードセクション。
class HomeAdvisorSection extends StatelessWidget {
  const HomeAdvisorSection({
    super.key,
    required this.onAdvisorTap,
  });

  final VoidCallback onAdvisorTap;

  @override
  Widget build(BuildContext context) {
    return HomeContentLayout.constrain(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: AppRadius.pill,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withValues(alpha: 0.06),
                  AppColors.secondary.withValues(alpha: 0.08),
                ],
              ),
              border: Border.all(
                color: AppColors.outline.withValues(alpha: 0.45),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '何を作ればいいか迷っていますか？',
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    '作りたいものを伝えるだけで、最適な Workflow を提案します。',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  FilledButton.icon(
                    onPressed: onAdvisorTap,
                    icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                    label: const Text('AIに相談する'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.medium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s32),
        ],
      ),
    );
  }
}
