import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/features/favorite/data/repositories/mock_favorite_repository.dart';
import 'package:ai_pilot/features/favorite/domain/entities/favorite.dart';
import 'package:ai_pilot/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';

/// Mock 開発用の現在ユーザー ID。
const String mockCurrentUserId = 'user-1';

// ---------------------------------------------------------------------------
// Repository Provider
// ---------------------------------------------------------------------------

/// [FavoriteRepository] を提供する（Mock 実装）。
///
/// セッション中は同一インスタンスを保持し、お気に入りの追加・削除状態を維持する。
final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  return MockFavoriteRepository();
});

// ---------------------------------------------------------------------------
// AsyncValue Providers（UI 向け）
// ---------------------------------------------------------------------------

/// 指定ユーザーのお気に入り一覧。
final favoritesProvider = FutureProvider.family<List<Favorite>, String>(
  (ref, userId) {
    return ref.watch(favoriteRepositoryProvider).fetchFavorites(userId);
  },
);

/// お気に入り判定用のパラメータ。
typedef IsFavoriteParams = ({String userId, String workflowId});

/// 指定ワークフローがお気に入り登録済みか判定する。
final isFavoriteProvider = FutureProvider.family<bool, IsFavoriteParams>(
  (ref, params) {
    return ref
        .watch(favoriteRepositoryProvider)
        .isFavorite(params.userId, params.workflowId);
  },
);

/// お気に入り登録済み [Workflow] 一覧。
///
/// [favoritesProvider] で取得した workflowId から [Workflow] を解決する。
final favoriteWorkflowsProvider = FutureProvider<List<Workflow>>((ref) async {
  final favorites =
      await ref.watch(favoritesProvider(mockCurrentUserId).future);
  if (favorites.isEmpty) {
    return [];
  }

  final workflowRepository = ref.watch(workflowRepositoryProvider);
  final workflows = await Future.wait(
    favorites.map(
      (favorite) => workflowRepository.fetchWorkflowById(favorite.workflowId),
    ),
  );

  return workflows.whereType<Workflow>().toList();
});
