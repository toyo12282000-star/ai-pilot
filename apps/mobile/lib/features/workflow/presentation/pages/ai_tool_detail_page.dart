import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ai_pilot/app/app_text_styles.dart';
import 'package:ai_pilot/core/constants/app_spacing.dart';
import 'package:ai_pilot/features/workflow/domain/entities/ai_tool.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/ai_tool_type_label.dart';
import 'package:ai_pilot/shared/widgets/empty_view.dart';
import 'package:ai_pilot/shared/widgets/error_view.dart';
import 'package:ai_pilot/shared/widgets/loading_view.dart';

/// AI ツール詳細画面。
class AIToolDetailPage extends ConsumerWidget {
  const AIToolDetailPage({
    super.key,
    required this.aiToolId,
  });

  final String aiToolId;

  Future<void> _openOfficialSite(BuildContext context, String url) async {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final aiToolAsync = ref.watch(aiToolByIdProvider(aiToolId));

    final appBarTitle = aiToolAsync.maybeWhen(
      data: (tool) => tool?.name ?? 'AIツール詳細',
      orElse: () => 'AIツール詳細',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: aiToolAsync.when(
        loading: () => const LoadingView(),
        error: (_, _) => ErrorView(
          message: 'AIツールの読み込みに失敗しました',
          onRetry: () => ref.invalidate(aiToolByIdProvider(aiToolId)),
        ),
        data: (tool) {
          if (tool == null) {
            return const EmptyView(
              message: 'AIツールが見つかりません',
            );
          }
          return _AIToolDetailBody(
            tool: tool,
            onOpenOfficialSite: (url) => _openOfficialSite(context, url),
          );
        },
      ),
    );
  }
}

class _AIToolDetailBody extends StatelessWidget {
  const _AIToolDetailBody({
    required this.tool,
    required this.onOpenOfficialSite,
  });

  final AITool tool;
  final ValueChanged<String> onOpenOfficialSite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: AppSpacing.page,
      children: [
        Text(
          tool.name,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _DetailRow(
          label: '説明',
          value: tool.description ?? '未設定',
        ),
        const SizedBox(height: AppSpacing.md),
        _DetailRow(
          label: '種別',
          value: tool.type.label,
        ),
        const SizedBox(height: AppSpacing.md),
        _DetailRow(
          label: 'URL',
          value: tool.url ?? '未設定',
        ),
        const SizedBox(height: AppSpacing.md),
        _DetailRow(
          label: 'アイコン',
          value: tool.iconName ?? '未設定',
        ),
        if (tool.url != null && tool.url!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => onOpenOfficialSite(tool.url!),
              icon: const Icon(Icons.open_in_new),
              label: const Text('公式サイトを開く'),
            ),
          ),
        ],
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.appText.captionLabel,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: theme.textTheme.bodyLarge,
        ),
      ],
    );
  }
}
