/// 表示名の解決ルールを 1 箇所に集約する。
class UserDisplayNameResolver {
  UserDisplayNameResolver._();

  static const defaultName = 'ユーザー';
  static const maxLength = 30;

  /// プロフィール・Auth metadata・email から表示名を解決する。
  static String resolve({
    String? profileDisplayName,
    Map<String, dynamic>? userMetadata,
    String? email,
  }) {
    final trimmedProfile = profileDisplayName?.trim();
    if (trimmedProfile != null && trimmedProfile.isNotEmpty) {
      return trimmedProfile;
    }

    for (final key in ['display_name', 'full_name', 'name']) {
      final value = userMetadata?[key];
      if (value is String) {
        final trimmed = value.trim();
        if (trimmed.isNotEmpty) {
          return trimmed;
        }
      }
    }

    final localPart = _emailLocalPart(email);
    if (localPart != null && localPart.isNotEmpty) {
      return localPart;
    }

    return defaultName;
  }

  /// 保存前バリデーション。問題があれば日本語メッセージを返す。
  static String? validateForSave(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return '表示名を入力してください';
    }
    if (trimmed.length > maxLength) {
      return '表示名は$maxLength文字以内で入力してください';
    }
    return null;
  }

  static String? _emailLocalPart(String? email) {
    if (email == null || email.isEmpty) {
      return null;
    }
    final atIndex = email.indexOf('@');
    if (atIndex <= 0) {
      return null;
    }
    return email.substring(0, atIndex);
  }
}
