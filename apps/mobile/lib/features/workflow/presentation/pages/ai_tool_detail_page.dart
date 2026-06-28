import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/icons.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/features/workflow/domain/entities/ai_tool.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/ai_tool_detail_hero.dart';
import 'package:ai_pilot/shared/widgets/bottom_action_bar.dart';
import 'package:ai_pilot/shared/widgets/empty_view.dart';
import 'package:ai_pilot/shared/widgets/error_view.dart';
import 'package:ai_pilot/shared/widgets/fade_slide_in.dart';
import 'package:ai_pilot/shared/widgets/skeleton_card.dart';

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

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: aiToolAsync.when(
        loading: () => ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s16,
            kToolbarHeight + AppSpacing.s8,
            AppSpacing.s16,
            AppSpacing.s16,
          ),
          children: const [
            SkeletonHeroCard(compact: true),
          ],
        ),
        error: (error, _) => ErrorView(
          title: 'AIツールの読み込みに失敗しました',
          description: '通信状況を確認して、もう一度お試しください',
          onRetry: () => ref.invalidate(aiToolByIdProvider(aiToolId)),
          debugDetails: error,
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

  bool get _hasUrl => tool.url != null && tool.url!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s16,
              kToolbarHeight + AppSpacing.s8,
              AppSpacing.s16,
              AppSpacing.s16,
            ),
            children: [
              FadeSlideIn(
                index: 0,
                child: AIToolDetailHero(tool: tool),
              ),
            ],
          ),
        ),
        if (_hasUrl)
          BottomActionBar(
            label: '公式サイトを開く',
            icon: AppIcons.externalLink,
            onPressed: () => onOpenOfficialSite(tool.url!),
          ),
      ],
    );
  }
}
