import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/app/app_text_styles.dart';
import 'package:ai_pilot/core/constants/app_radius.dart';
import 'package:ai_pilot/core/constants/app_spacing.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_step.dart';

/// ワークフロー詳細画面のステップカード。
class WorkflowStepCard extends StatelessWidget {
  const WorkflowStepCard({
    super.key,
    required this.step,
    this.aiToolName,
    this.promptContent,
  });

  final WorkflowStep step;
  final String? aiToolName;
  final String? promptContent;

  Future<void> _copyPrompt(BuildContext context) async {
    final content = promptContent;
    if (content == null || content.isEmpty) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: content));
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('プロンプトをコピーしました')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: AppSpacing.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Text(
                    '${step.order}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md - AppSpacing.xs),
                Expanded(
                  child: Text(
                    step.title,
                    style: theme.appText.cardTitle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md - AppSpacing.xs),
            Text('説明', style: theme.appText.captionLabel),
            const SizedBox(height: AppSpacing.xs),
            Text(
              step.instruction,
              style: theme.textTheme.bodyMedium,
            ),
            if (step.description != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                step.description!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            Text('使用AIツール', style: theme.appText.captionLabel),
            const SizedBox(height: AppSpacing.xs),
            _AiToolNameLink(
              aiToolId: step.aiToolId,
              aiToolName: aiToolName,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Text('プロンプト', style: theme.appText.captionLabel),
                const Spacer(),
                if (promptContent != null && promptContent!.isNotEmpty)
                  TextButton.icon(
                    onPressed: () => _copyPrompt(context),
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('コピー'),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            if (promptContent == null || promptContent!.isEmpty)
              Text(
                '未設定',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md - AppSpacing.xs),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: AppRadius.chip,
                ),
                child: Text(
                  promptContent!,
                  style: theme.textTheme.bodySmall,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AiToolNameLink extends StatelessWidget {
  const _AiToolNameLink({
    required this.aiToolId,
    required this.aiToolName,
  });

  final String? aiToolId;
  final String? aiToolName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayName = aiToolName ?? '未設定';
    final canNavigate = aiToolId != null;

    if (!canNavigate) {
      return Text(
        displayName,
        style: theme.textTheme.bodyMedium,
      );
    }

    return InkWell(
      onTap: () => context.push('/ai-tools/$aiToolId'),
      borderRadius: AppRadius.chip,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs / 2),
        child: Text(
          displayName,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
            decorationColor: theme.colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
