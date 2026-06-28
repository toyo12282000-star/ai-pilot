import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/features/advisor/domain/services/advisor_example_query_resolver.dart';

/// Advisor 画面で使う例文チップ一覧。
class AdvisorExampleChips extends StatelessWidget {
  const AdvisorExampleChips({
    super.key,
    required this.controller,
    required this.isLoading,
    this.onExampleSelected,
  });

  static const exampleQueries = AdvisorExampleQueryResolver.exampleQueries;

  final TextEditingController controller;
  final bool isLoading;
  final ValueChanged<String>? onExampleSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
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
    );
  }
}
