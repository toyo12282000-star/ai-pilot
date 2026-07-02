import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';

/// Quick Reply ピルボタン群。
class AdvisorQuickReplyChips extends StatelessWidget {
  const AdvisorQuickReplyChips({
    super.key,
    required this.replies,
    required this.onSelected,
    this.enabled = true,
  });

  final List<String> replies;
  final ValueChanged<String> onSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (replies.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.s32,
        top: AppSpacing.s8,
      ),
      child: Wrap(
        spacing: AppSpacing.s8,
        runSpacing: AppSpacing.s8,
        children: [
          for (final reply in replies)
            Material(
              color: AppColors.surface,
              borderRadius: AppRadius.pill,
              child: InkWell(
                onTap: enabled ? () => onSelected(reply) : null,
                borderRadius: AppRadius.pill,
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.pill,
                    border: Border.all(color: AppColors.border),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s12,
                    vertical: AppSpacing.s8,
                  ),
                  child: Text(
                    reply,
                    style: AppTypography.labelLarge.copyWith(
                      color: enabled
                          ? AppColors.charcoal
                          : AppColors.muted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
