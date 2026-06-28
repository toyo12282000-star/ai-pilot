import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';

/// Advisor の入力フォームと例文チップ。
class AdvisorInputSection extends StatelessWidget {
  const AdvisorInputSection({
    super.key,
    required this.controller,
    required this.onSubmit,
    required this.isLoading,
    this.onExampleSelected,
  });

  static const exampleQueries = [
    'YouTubeを始めたい',
    'Instagram運用したい',
    '営業資料を作りたい',
  ];

  final TextEditingController controller;
  final VoidCallback onSubmit;
  final bool isLoading;
  final ValueChanged<String>? onExampleSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          maxLines: 3,
          minLines: 3,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => onSubmit(),
          decoration: InputDecoration(
            hintText: '例: YouTubeを始めたい',
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: AppRadius.medium,
              borderSide: const BorderSide(color: AppColors.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.medium,
              borderSide: const BorderSide(color: AppColors.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.medium,
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.all(AppSpacing.s16),
          ),
        ),
        const SizedBox(height: AppSpacing.s12),
        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          children: [
            for (final example in exampleQueries)
              ActionChip(
                label: Text(example),
                onPressed: isLoading
                    ? null
                    : () {
                        controller.text = example;
                        onExampleSelected?.call(example);
                      },
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.s24),
        FilledButton(
          onPressed: isLoading ? null : onSubmit,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('提案する'),
        ),
        const SizedBox(height: AppSpacing.s8),
        Text(
          'MVP Preview: 既存のWorkflow・目的カードから最適な候補を選びます',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
