import 'package:ai_pilot/features/favorite/domain/entities/favorite.dart';

/// お気に入りの取得・登録・解除を担当する Repository インターフェース。
///
/// ## 責務
/// - ユーザーごとのお気に入りワークフロー一覧の管理
/// - お気に入り状態の確認・追加・削除
abstract class FavoriteRepository {
  /// 指定ユーザーのお気に入り一覧を取得する。
  ///
  /// [userId] に紐づく [Favorite] を返す。
  Future<List<Favorite>> fetchFavorites(String userId);

  /// 指定ワークフローがお気に入り登録済みか判定する。
  Future<bool> isFavorite(String userId, String workflowId);

  /// ワークフローをお気に入りに追加する。
  ///
  /// 既に登録済みの場合の挙動は実装側で定義する。
  Future<void> addFavorite(String userId, String workflowId);

  /// ワークフローのお気に入りを解除する。
  ///
  /// 未登録の場合の挙動は実装側で定義する。
  Future<void> removeFavorite(String userId, String workflowId);
}
