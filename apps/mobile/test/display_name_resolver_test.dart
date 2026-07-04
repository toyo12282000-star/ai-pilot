import 'package:flutter_test/flutter_test.dart';

import 'package:ai_pilot/features/profile/domain/services/user_display_name_resolver.dart';

void main() {
  group('UserDisplayNameResolver.resolve', () {
    test('uses profile display name when set', () {
      expect(
        UserDisplayNameResolver.resolve(
          profileDisplayName: '  山田太郎  ',
          email: 'test@example.com',
        ),
        '山田太郎',
      );
    });

    test('falls back to auth metadata name', () {
      expect(
        UserDisplayNameResolver.resolve(
          userMetadata: const {'name': 'Taro'},
          email: 'test@example.com',
        ),
        'Taro',
      );
    });

    test('falls back to email local-part', () {
      expect(
        UserDisplayNameResolver.resolve(email: 'toyo12282000@gmail.com'),
        'toyo12282000',
      );
    });

    test('falls back to default label', () {
      expect(UserDisplayNameResolver.resolve(), 'ユーザー');
    });
  });

  group('UserDisplayNameResolver.validateForSave', () {
    test('rejects empty input', () {
      expect(UserDisplayNameResolver.validateForSave('   '), isNotNull);
    });

    test('rejects too long input', () {
      expect(
        UserDisplayNameResolver.validateForSave('a' * 31),
        isNotNull,
      );
    });

    test('accepts valid input', () {
      expect(UserDisplayNameResolver.validateForSave('  とよ  '), isNull);
    });
  });
}
