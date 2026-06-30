import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/icons.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';

/// ワークフロー検索入力欄。
class WorkflowSearchBar extends StatelessWidget {
  const WorkflowSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.showClearButton,
    this.embedded = false,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final bool showClearButton;

  /// Hero 内に埋め込む場合は true（外側パディングなし）。
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final searchBar = SearchBar(
      controller: controller,
      hintText: 'ワークフローを検索',
      leading: const Icon(AppIcons.search, size: AppIcons.sizeMd),
      trailing: [
        if (showClearButton)
          IconButton(
            onPressed: onClear,
            tooltip: 'クリア',
            icon: const Icon(AppIcons.clear, size: AppIcons.sizeMd),
          ),
      ],
      onChanged: onChanged,
      backgroundColor: WidgetStatePropertyAll(AppColors.surface),
      elevation: const WidgetStatePropertyAll(0),
      side: WidgetStatePropertyAll(
        BorderSide(color: AppColors.border),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: AppRadius.pill),
      ),
      textStyle: WidgetStatePropertyAll(AppTypography.bodyLarge),
      hintStyle: WidgetStatePropertyAll(
        AppTypography.bodyLarge.copyWith(color: AppColors.muted),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: AppSpacing.s12),
      ),
    );

    if (embedded) {
      return searchBar;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s16,
        AppSpacing.s16,
        AppSpacing.s8,
      ),
      child: searchBar,
    );
  }
}
