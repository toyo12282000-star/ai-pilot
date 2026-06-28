import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/advisor/presentation/widgets/advisor_example_chips.dart';
import 'package:ai_pilot/shared/widgets/state_icon.dart';

/// Advisor で Workflow が見つからなかったときの導線。
class AdvisorEmptySection extends StatelessWidget {
  const AdvisorEmptySection({
    super.key,
    required this.controller,
    required this.isLoading,
    this.onExampleSelected,
  });

  final TextEditingController controller;
  final bool isLoading;
  final ValueChanged<String>? onExampleSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: AppSpacing.pageHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Column(
              children: [
                StateIcon(
                  icon: Icons.search_off_rounded,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: AppSpacing.s16),
                Text(
                  '近いWorkflowが見つかりませんでした',
                  textAlign: TextAlign.center,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  '別の言葉で入力するか、カテゴリから探してみてください',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          FilledButton.tonal(
            onPressed: () => context.go('/'),
            child: const Text('ホームで探す'),
          ),
          const SizedBox(height: AppSpacing.s24),
          Text(
            '例文から試す',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          AdvisorExampleChips(
            controller: controller,
            isLoading: isLoading,
            onExampleSelected: onExampleSelected,
          ),
        ],
      ),
    );
  }
}
