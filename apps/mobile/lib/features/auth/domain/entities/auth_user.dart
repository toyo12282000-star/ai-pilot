/// 認証済みユーザー。
class AuthUser {
  const AuthUser({
    required this.id,
    this.email,
    this.userMetadata,
  });

  /// ユーザー ID。
  final String id;

  /// メールアドレス。
  final String? email;

  /// Supabase Auth の user metadata（表示名フォールバック用）。
  final Map<String, dynamic>? userMetadata;
}

/// 認証状態の変更イベント。
class AuthStateChange {
  const AuthStateChange({
    required this.user,
  });

  /// 現在のユーザー。未ログインの場合は null。
  final AuthUser? user;
}
