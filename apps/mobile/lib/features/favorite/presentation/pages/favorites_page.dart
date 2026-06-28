import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/features/favorite/presentation/providers/favorite_providers.dart';
import 'package:ai_pilot/features/favorite/presentation/widgets/favorite_workflow_list.dart';
import 'package:ai_pilot/features/favorite/presentation/widgets/favorites_hero_section.dart';
import 'package:ai_pilot/shared/providers/authenticated_user_provider.dart';
import 'package:ai_pilot/shared/widgets/error_view.dart';
import 'package:ai_pilot/shared/widgets/fade_slide_in.dart';
import 'package:ai_pilot/shared/widgets/loading_view.dart';
import 'package:ai_pilot/shared/widgets/rich_empty_view.dart';

/// お気に入りワークフロー一覧画面。
class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  void _retry(WidgetRef ref) {
    invalidateFavorites(ref);
  }

  Widget _buildGuestPrompt(BuildContext context) {
    return RichEmptyView(
      icon: Icons.login,
      title: 'ログインが必要です',
      subtitle: 'お気に入りを保存するにはログインしてください',
      actionLabel: 'ログインする',
      onAction: () => context.go('/login'),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    if (!isAuthenticated) {
      return SafeArea(child: _buildGuestPrompt(context));
    }

    final favoriteWorkflowsAsync = ref.watch(favoriteWorkflowsProvider);

    return SafeArea(
      child: favoriteWorkflowsAsync.when(
        loading: () => const LoadingView(),
        error: (_, _) => ErrorView(
          message: 'お気に入りの読み込みに失敗しました',
          onRetry: () => _retry(ref),
        ),
        data: (workflows) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeSlideIn(
              index: 0,
              child: FavoritesHeroSection(count: workflows.length),
            ),
            Expanded(
              child: workflows.isEmpty
                  ? const RichEmptyView(
                      icon: Icons.favorite_border,
                      title: 'お気に入りはまだありません',
                      subtitle: '気になるWorkflowを保存すると、ここからすぐに開けます',
                    )
                  : FadeSlideIn(
                      index: 1,
                      child: FavoriteWorkflowList(workflows: workflows),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
