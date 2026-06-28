import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/features/favorite/data/repositories/supabase_favorite_repository.dart';
import 'package:ai_pilot/features/favorite/domain/entities/favorite.dart';
import 'package:ai_pilot/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';
import 'package:ai_pilot/shared/providers/authenticated_user_provider.dart';

// ---------------------------------------------------------------------------
// Repository Provider
// ---------------------------------------------------------------------------

/// [FavoriteRepository] を提供する（Supabase 実装）。
final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  return SupabaseFavoriteRepository();
});

// ---------------------------------------------------------------------------
// AsyncValue Providers（UI 向け）
// ---------------------------------------------------------------------------

/// 認証済みユーザーのお気に入り一覧。ゲストは Supabase を呼ばず空リスト。
final favoritesProvider = FutureProvider<List<Favorite>>((ref) {
  if (!ref.watch(isAuthenticatedProvider)) {
    return Future.value(const []);
  }

  final userId = ref.watch(authenticatedUserIdProvider)!;
  return ref.watch(favoriteRepositoryProvider).fetchFavorites(userId);
});

/// 指定ワークフローがお気に入り登録済みか判定する。ゲストは Supabase を呼ばず false。
final isFavoriteProvider = FutureProvider.family<bool, String>(
  (ref, workflowId) {
    if (!ref.watch(isAuthenticatedProvider)) {
      return Future.value(false);
    }

    final userId = ref.watch(authenticatedUserIdProvider)!;
    return ref.watch(favoriteRepositoryProvider).isFavorite(userId, workflowId);
  },
);

/// お気に入り登録済み [Workflow] 一覧。ゲストは Supabase / Workflow を呼ばず空リスト。
final favoriteWorkflowsProvider = FutureProvider<List<Workflow>>((ref) async {
  if (!ref.watch(isAuthenticatedProvider)) {
    return const [];
  }

  final favorites = await ref.watch(favoritesProvider.future);
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

/// お気に入り関連 Provider を再取得する。
void invalidateFavorites(WidgetRef ref) {
  if (!ref.read(isAuthenticatedProvider)) {
    return;
  }

  ref.invalidate(favoritesProvider);
  ref.invalidate(favoriteWorkflowsProvider);
}

/// 指定 Workflow のお気に入り状態 Provider を再取得する。
void invalidateFavoriteForWorkflow(WidgetRef ref, String workflowId) {
  if (!ref.read(isAuthenticatedProvider)) {
    return;
  }

  invalidateFavorites(ref);
  ref.invalidate(isFavoriteProvider(workflowId));
}
