import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';

/// Run 画面の Step チェックリスト（UI のみ · 状態はローカル）。
class WorkflowRunStepChecklist extends StatefulWidget {
  const WorkflowRunStepChecklist({
    super.key,
    required this.items,
  });

  final List<String> items;

  @override
  State<WorkflowRunStepChecklist> createState() =>
      _WorkflowRunStepChecklistState();
}

class _WorkflowRunStepChecklistState extends State<WorkflowRunStepChecklist> {
  final Set<int> _checked = {};

  @override
  void didUpdateWidget(covariant WorkflowRunStepChecklist oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _checked.clear();
    }
  }

  void _toggle(int index) {
    setState(() {
      if (_checked.contains(index)) {
        _checked.remove(index);
      } else {
        _checked.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'やること',
            style: AppTypography.labelLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          for (var i = 0; i < widget.items.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.s8),
            _ChecklistRow(
              label: widget.items[i],
              checked: _checked.contains(i),
              onChanged: () => _toggle(i),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({
    required this.label,
    required this.checked,
    required this.onChanged,
  });

  final String label;
  final bool checked;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged,
      borderRadius: AppRadius.small,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s4),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: checked ? AppColors.primarySoft : AppColors.surface,
                borderRadius: AppRadius.small,
                border: Border.all(
                  color: checked
                      ? AppColors.primary.withValues(alpha: 0.5)
                      : AppColors.border,
                ),
              ),
              child: checked
                  ? Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: AppColors.primary,
                    )
                  : null,
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  color: checked ? AppColors.textSecondary : AppColors.charcoal,
                  decoration: checked ? TextDecoration.lineThrough : null,
                  decorationColor: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
