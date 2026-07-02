import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/responsive.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/advisor/domain/services/advisor_example_query_resolver.dart';

/// Advisor 下部の入力エリア（SafeArea 対応）。
class AdvisorChatInputBar extends StatelessWidget {
  const AdvisorChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onExampleSelected,
    this.enabled = true,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final ValueChanged<String> onExampleSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppResponsiveSpacing.pageHorizontal(context),
            AppSpacing.s8,
            AppResponsiveSpacing.pageHorizontal(context),
            AppSpacing.s8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final example
                        in AdvisorExampleQueryResolver.exampleQueries)
                      Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.s8),
                        child: ActionChip(
                          label: Text(
                            example,
                            style: AppTypography.labelMedium.copyWith(
                              fontSize: 12,
                            ),
                          ),
                          onPressed: enabled
                              ? () {
                                  controller.text = example;
                                  onExampleSelected(example);
                                }
                              : null,
                          backgroundColor: AppColors.surface,
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.pill,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      enabled: enabled,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: enabled ? (_) => onSend() : null,
                      decoration: InputDecoration(
                        hintText: 'メッセージを入力...',
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s12,
                          vertical: AppSpacing.s8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: AppRadius.medium,
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: AppRadius.medium,
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: AppRadius.medium,
                          borderSide: BorderSide(
                            color: AppColors.primary.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  SizedBox(
                    height: 44,
                    width: 44,
                    child: FilledButton(
                      onPressed: enabled ? onSend : null,
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.surface,
                        disabledBackgroundColor:
                            AppColors.primary.withValues(alpha: 0.45),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.medium,
                        ),
                      ),
                      child: const Icon(Icons.arrow_upward_rounded, size: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
