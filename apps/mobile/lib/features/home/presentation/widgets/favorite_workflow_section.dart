import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/features/home/presentation/providers/home_providers.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_workflow_carousel_section.dart';
import 'package:ai_pilot/shared/providers/authenticated_user_provider.dart';

/// お気に入り Workflow 横スクロールセクション（ログイン時のみ）。
class FavoriteWorkflowSection extends ConsumerWidget {
  const FavoriteWorkflowSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(isAuthenticatedProvider)) {
      return const SizedBox.shrink();
    }

    final favoritesAsync = ref.watch(favoriteHomeWorkflowsProvider);

    return favoritesAsync.when(
      loading: () => HomeWorkflowCarouselSection(
        title: 'お気に入り',
        workflows: const [],
        isLoading: true,
        emptyTitle: '',
        emptySubtitle: '',
        onWorkflowTap: (_) {},
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (workflows) => HomeWorkflowCarouselSection(
        title: 'お気に入り',
        workflows: workflows,
        emptyTitle: 'まだ保存したWorkflowがありません',
        emptySubtitle: '気になる作品を保存しておくと、ここに並びます',
        onWorkflowTap: (workflow) => context.push('/workflows/${workflow.id}'),
      ),
    );
  }
}
