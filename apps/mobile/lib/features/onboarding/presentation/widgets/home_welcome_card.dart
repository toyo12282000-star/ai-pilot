import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_content_layout.dart';
import 'package:ai_pilot/features/onboarding/presentation/providers/onboarding_providers.dart';

/// 初回ユーザー向け Welcome カード（dismiss 可能）。
class HomeWelcomeCard extends ConsumerWidget {
  const HomeWelcomeCard({
    super.key,
    required this.onAdvisorTap,
    required this.onBrowseShowcases,
    required this.onStartPopularWorkflow,
  });

  final VoidCallback onAdvisorTap;
  final VoidCallback onBrowseShowcases;
  final VoidCallback onStartPopularWorkflow;

  static const steps = [
    (
      icon: Icons.collections_outlined,
      title: '完成作品を見る',
      subtitle: '人気の完成作品から、作りたい成果物を選びます',
    ),
    (
      icon: Icons.auto_awesome_outlined,
      title: 'Advisorに相談する',
      subtitle: '2〜3問でおすすめWorkflowを提案',
    ),
    (
      icon: Icons.play_circle_outline_rounded,
      title: 'Workflowを始める',
      subtitle: '手順に沿って、最初の1作品を作ってみましょう',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAsync = ref.watch(showHomeWelcomeProvider);

    return showAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (show) {
        if (!show) {
          return const SizedBox.shrink();
        }

        return HomeContentLayout.constrain(
          context: context,
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s8),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.large,
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.s8,
                                  vertical: AppSpacing.s4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primarySoft,
                                  borderRadius: AppRadius.small,
                                ),
                                child: Text(
                                  'はじめての方へ',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.s8),
                              Text(
                                'AI Pilot へようこそ',
                                style: AppTypography.titleMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.s4),
                              Text(
                                '作りたい成果物から、AI 活用手順まで案内するアプリです。'
                                'まずは次の3ステップから始めてみましょう。',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: '閉じる',
                          onPressed: () {
                            ref
                                .read(homeWelcomeDismissedProvider.notifier)
                                .dismiss();
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            size: 20,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    for (var index = 0; index < steps.length; index++) ...[
                      if (index > 0) const SizedBox(height: AppSpacing.s8),
                      _WelcomeStepTile(
                        stepNumber: index + 1,
                        icon: steps[index].icon,
                        title: steps[index].title,
                        subtitle: steps[index].subtitle,
                        onTap: switch (index) {
                          0 => onBrowseShowcases,
                          1 => onAdvisorTap,
                          _ => onStartPopularWorkflow,
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WelcomeStepTile extends StatelessWidget {
  const _WelcomeStepTile({
    required this.stepNumber,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final int stepNumber;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      borderRadius: AppRadius.medium,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.medium,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: AppRadius.medium,
            border: Border.all(color: AppColors.outline),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s12),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: AppRadius.small,
                  ),
                  child: Text(
                    '$stepNumber',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s12),
                Icon(icon, size: 20, color: AppColors.primary),
                const SizedBox(width: AppSpacing.s8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
