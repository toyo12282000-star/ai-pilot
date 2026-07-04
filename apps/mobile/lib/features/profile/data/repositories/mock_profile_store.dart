import 'package:ai_pilot/features/profile/domain/entities/user_profile.dart';
import 'package:ai_pilot/features/profile/domain/services/user_display_name_resolver.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';

/// Mock プロフィールの可変ストア（Settings 更新 / Social Proof 共有）。
class MockProfileStore {
  MockProfileStore._();

  static final MockProfileStore instance = MockProfileStore._();

  UserProfile _current = mockCurrentUser;

  UserProfile get current => _current;

  void reset() {
    _current = mockCurrentUser;
  }

  UserProfile updateDisplayName(String displayName) {
    final trimmed = displayName.trim();
    final error = UserDisplayNameResolver.validateForSave(trimmed);
    if (error != null) {
      throw ArgumentError(error);
    }

    _current = _current.copyWith(
      displayName: trimmed,
      updatedAt: DateTime.now(),
    );
    return _current;
  }
}
