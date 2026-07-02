import 'package:ai_pilot/features/favorite/domain/entities/favorite.dart';
import 'package:ai_pilot/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_social_proof_data_store.dart';

/// [FavoriteRepository] の Mock 実装。
///
/// メモリ上でお気に入りの追加・削除が可能。UI 開発用。
class MockFavoriteRepository implements FavoriteRepository {
  MockFavoriteRepository([MockSocialProofDataStore? store])
      : _store = store ?? MockSocialProofDataStore();

  final MockSocialProofDataStore _store;

  @override
  Future<List<Favorite>> fetchFavorites(String userId) async {
    await Future<void>.delayed(mockNetworkDelay);
    return _store.favorites.where((f) => f.userId == userId).toList();
  }

  @override
  Future<bool> isFavorite(String userId, String workflowId) async {
    await Future<void>.delayed(mockNetworkDelay);
    return _store.favorites.any(
      (f) => f.userId == userId && f.workflowId == workflowId,
    );
  }

  @override
  Future<void> addFavorite(String userId, String workflowId) async {
    await Future<void>.delayed(mockNetworkDelay);

    final alreadyExists = _store.favorites.any(
      (f) => f.userId == userId && f.workflowId == workflowId,
    );
    if (alreadyExists) {
      return;
    }

    _store.favorites.add(
      Favorite(
        id: 'fav-${_store.nextFavoriteId}',
        userId: userId,
        workflowId: workflowId,
        createdAt: DateTime.now(),
      ),
    );
    _store.nextFavoriteId++;
  }

  @override
  Future<void> removeFavorite(String userId, String workflowId) async {
    await Future<void>.delayed(mockNetworkDelay);
    _store.favorites.removeWhere(
      (f) => f.userId == userId && f.workflowId == workflowId,
    );
  }
}
