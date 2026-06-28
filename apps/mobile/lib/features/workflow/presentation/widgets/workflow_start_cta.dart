import 'package:flutter/material.dart';

import 'package:ai_pilot/shared/widgets/bottom_action_bar.dart';

/// ワークフロー詳細画面の開始 CTA。
class WorkflowStartCta extends StatelessWidget {
  const WorkflowStartCta({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BottomActionBar(
      label: 'このWorkflowを開始する',
      onPressed: onPressed,
    );
  }
}
