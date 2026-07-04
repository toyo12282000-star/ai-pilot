import 'package:ai_pilot/features/profile/domain/entities/user_profile.dart';

/// ユーザープロフィールの取得を担当する Repository インターフェース。
///
/// ## 責務
/// - 現在ログイン中ユーザーのプロフィール取得
/// - ID 指定によるプロフィール参照
abstract class UserProfileRepository {
  /// 現在ログイン中のユーザープロフィールを取得する。
  ///
  /// 未ログインまたは取得不可の場合は `null` を返す。
  Future<UserProfile?> fetchCurrentUserProfile();

  /// ID を指定してユーザープロフィールを 1 件取得する。
  ///
  /// 該当がない場合は `null` を返す。
  Future<UserProfile?> fetchUserProfileById(String userId);

  /// 表示名を更新する。
  ///
  /// 未ログイン時は [StateError] を投げる。
  Future<UserProfile> updateDisplayName(String displayName);
}
