import 'package:flutter_test/flutter_test.dart';

import 'package:ai_pilot/features/profile/data/repositories/mock_profile_store.dart';
import 'package:ai_pilot/features/profile/data/repositories/mock_user_profile_repository.dart';

void main() {
  late MockUserProfileRepository repository;

  setUp(() {
    MockProfileStore.instance.reset();
    repository = MockUserProfileRepository();
  });

  test('fetchCurrentUserProfile returns mock profile', () async {
    final profile = await repository.fetchCurrentUserProfile();

    expect(profile, isNotNull);
    expect(profile!.displayName, 'AI Pilot ユーザー');
  });

  test('updateDisplayName updates stored profile', () async {
    final updated = await repository.updateDisplayName('新しい表示名');

    expect(updated.displayName, '新しい表示名');

    final fetched = await repository.fetchCurrentUserProfile();
    expect(fetched?.displayName, '新しい表示名');
  });

  test('updateDisplayName rejects invalid value', () async {
    expect(
      () => repository.updateDisplayName(''),
      throwsA(isA<ArgumentError>()),
    );
  });
}
