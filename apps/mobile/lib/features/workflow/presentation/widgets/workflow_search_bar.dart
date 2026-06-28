import 'package:flutter/material.dart';

import 'package:ai_pilot/core/constants/app_spacing.dart';

/// ワークフロー検索入力欄。
class WorkflowSearchBar extends StatelessWidget {
  const WorkflowSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.showClearButton,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final bool showClearButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: SearchBar(
        controller: controller,
        hintText: 'ワークフローを検索',
        leading: const Icon(Icons.search),
        trailing: [
          if (showClearButton)
            IconButton(
              onPressed: onClear,
              tooltip: 'クリア',
              icon: const Icon(Icons.clear),
            ),
        ],
        onChanged: onChanged,
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        ),
      ),
    );
  }
}
