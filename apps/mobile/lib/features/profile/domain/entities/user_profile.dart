/// アプリ利用者のプロフィール。
///
/// ## 責務
/// - ユーザーの基本情報を保持する
/// - お気に入り等、ユーザーに紐づくデータの所有者として機能する
///
/// ## 保持する値
/// - [id]: 一意識別子
/// - [displayName]: 表示名
/// - [email]: メールアドレス
/// - [avatarUrl]: アバター画像 URL
/// - [createdAt]: 作成日時
/// - [updatedAt]: 更新日時
///
/// ## 他 Entity との関係
/// - 複数の [Favorite] の所有者となる（1:N）
class UserProfile {
  /// [id] をキーに [UserProfile] を生成する。
  UserProfile({
    required this.id,
    required this.displayName,
    required this.createdAt,
    required this.updatedAt,
    this.email,
    this.avatarUrl,
  });

  /// 一意識別子。
  final String id;

  /// 表示名。
  final String displayName;

  /// メールアドレス。
  final String? email;

  /// アバター画像 URL。
  final String? avatarUrl;

  /// 作成日時。
  final DateTime createdAt;

  /// 更新日時。
  final DateTime updatedAt;

  /// 指定フィールドのみ差し替えた新しいインスタンスを返す。
  UserProfile copyWith({
    String? id,
    String? displayName,
    String? email,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
