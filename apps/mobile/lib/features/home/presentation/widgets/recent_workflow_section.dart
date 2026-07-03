import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/features/home/presentation/providers/home_providers.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_workflow_carousel_section.dart';
import 'package:ai_pilot/shared/providers/authenticated_user_provider.dart';

/// 最近使った Workflow 横スクロールセクション（ログイン時のみ）。
class RecentWorkflowSection extends ConsumerWidget {
  const RecentWorkflowSection({super.key});

  Future<void> _openPopularWorkflow(BuildContext context, WidgetRef ref) async {
    final popular = await ref.read(popularHomeWorkflowsProvider.future);
    if (!context.mounted || popular.isEmpty) {
      return;
    }
    context.push('/workflows/${popular.first.id}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(isAuthenticatedProvider)) {
      return const SizedBox.shrink();
    }

    final workflowsAsync = ref.watch(recentHomeWorkflowsProvider);

    return workflowsAsync.when(
      loading: () => HomeWorkflowCarouselSection(
        title: '最近使った',
        workflows: const [],
        isLoading: true,
        emptyTitle: '',
        emptySubtitle: '',
        onWorkflowTap: (_) {},
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (workflows) => HomeWorkflowCarouselSection(
        title: '最近使った',
        workflows: workflows,
        emptyTitle: 'まだWorkflowを使っていません',
        emptySubtitle: '人気の Workflow から、最初の1作品を試してみましょう',
        emptyActionLabel: '人気のWorkflowを見る',
        onEmptyAction: () => _openPopularWorkflow(context, ref),
        onWorkflowTap: (workflow) => context.push('/workflows/${workflow.id}'),
      ),
    );
  }
}
