import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/features/favorite/presentation/providers/favorite_providers.dart';
import 'package:ai_pilot/features/favorite/presentation/widgets/favorite_workflow_list.dart';
import 'package:ai_pilot/shared/widgets/empty_view.dart';
import 'package:ai_pilot/shared/widgets/error_view.dart';
import 'package:ai_pilot/shared/widgets/loading_view.dart';

/// お気に入りワークフロー一覧画面。
class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  void _retry(WidgetRef ref) {
    ref.invalidate(favoritesProvider(mockCurrentUserId));
    ref.invalidate(favoriteWorkflowsProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(favoritesProvider(mockCurrentUserId));
    final favoriteWorkflowsAsync = ref.watch(favoriteWorkflowsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('お気に入り'),
      ),
      body: favoriteWorkflowsAsync.when(
        loading: () => const LoadingView(),
        error: (_, _) => ErrorView(
          message: 'お気に入りの読み込みに失敗しました',
          onRetry: () => _retry(ref),
        ),
        data: (workflows) {
          if (workflows.isEmpty) {
            return EmptyView(
              message: 'お気に入りはまだありません',
              actionLabel: '再読み込み',
              onAction: () => _retry(ref),
            );
          }
          return FavoriteWorkflowList(workflows: workflows);
        },
      ),
    );
  }
}
