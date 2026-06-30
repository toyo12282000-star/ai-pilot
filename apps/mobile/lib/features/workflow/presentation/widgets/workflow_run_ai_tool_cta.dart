import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/icons.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/workflow/domain/entities/ai_tool.dart';

/// 現在ステップで使う AI ツールを開く大きな CTA。
class WorkflowRunAiToolCta extends StatelessWidget {
  const WorkflowRunAiToolCta({
    super.key,
    required this.aiTool,
  });

  final AITool? aiTool;

  Future<void> _openTool(BuildContext context) async {
    final tool = aiTool;
    if (tool == null) {
      return;
    }

    final url = tool.url;
    if (url == null || url.isEmpty) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${tool.name}のURLが設定されていません')),
      );
      return;
    }

    final uri = Uri.tryParse(url);
    if (uri == null) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('URLを開けませんでした')),
      );
      return;
    }

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('URLを開けませんでした')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tool = aiTool;
    final label = tool != null ? '${tool.name}を開く' : 'AIツール未設定';

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: tool != null ? () => _openTool(context) : null,
        icon: Icon(
          Icons.open_in_new_rounded,
          size: AppIcons.sizeSm,
        ),
        label: Text(
          label,
          style: AppTypography.labelLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.s16,
            horizontal: AppSpacing.s24,
          ),
          backgroundColor: AppColors.charcoal,
          foregroundColor: AppColors.surface,
        ),
      ),
    );
  }
}
