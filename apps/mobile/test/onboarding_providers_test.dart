import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ai_pilot/features/advisor/data/repositories/mock_advisor_history_repository.dart';
import 'package:ai_pilot/features/advisor/presentation/providers/advisor_history_providers.dart';
import 'package:ai_pilot/features/favorite/data/repositories/mock_favorite_repository.dart';
import 'package:ai_pilot/features/favorite/presentation/providers/favorite_providers.dart';
import 'package:ai_pilot/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_run_history_repository.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_run_history_providers.dart';
import 'package:ai_pilot/shared/data/local/app_preferences.dart';
import 'package:ai_pilot/shared/providers/app_preferences_provider.dart';
import 'package:ai_pilot/shared/providers/authenticated_user_provider.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('isNewAppUserProvider is true for user without activity', () async {
    final container = ProviderContainer(
      overrides: [
        authenticatedUserIdProvider.overrideWith((ref) => 'user-empty'),
        advisorHistoryRepositoryProvider
            .overrideWithValue(MockAdvisorHistoryRepository()),
        favoriteRepositoryProvider.overrideWithValue(MockFavoriteRepository()),
        workflowRunHistoryRepositoryProvider
            .overrideWithValue(MockWorkflowRunHistoryRepository()),
      ],
    );
    addTearDown(container.dispose);

    expect(await container.read(isNewAppUserProvider.future), isTrue);
  });

  test('isNewAppUserProvider is false when advisor history exists', () async {
    final container = ProviderContainer(
      overrides: [
        authenticatedUserIdProvider.overrideWith((ref) => 'user-1'),
        advisorHistoryRepositoryProvider
            .overrideWithValue(MockAdvisorHistoryRepository()),
        favoriteRepositoryProvider.overrideWithValue(MockFavoriteRepository()),
        workflowRunHistoryRepositoryProvider
            .overrideWithValue(MockWorkflowRunHistoryRepository()),
      ],
    );
    addTearDown(container.dispose);

    expect(await container.read(isNewAppUserProvider.future), isFalse);
  });

  test('showHomeWelcomeProvider hides after dismiss', () async {
    SharedPreferences.setMockInitialValues({
      AppPreferences.homeWelcomeDismissedKey: false,
    });

    final container = ProviderContainer(
      overrides: [
        authenticatedUserIdProvider.overrideWith((ref) => 'user-empty'),
        advisorHistoryRepositoryProvider
            .overrideWithValue(MockAdvisorHistoryRepository()),
        favoriteRepositoryProvider.overrideWithValue(MockFavoriteRepository()),
        workflowRunHistoryRepositoryProvider
            .overrideWithValue(MockWorkflowRunHistoryRepository()),
      ],
    );
    addTearDown(container.dispose);

    await container.read(appPreferencesProvider.future);
    await container.read(isNewAppUserProvider.future);
    await container.read(homeWelcomeDismissedProvider.future);
    expect(container.read(showHomeWelcomeProvider).requireValue, isTrue);

    await container.read(homeWelcomeDismissedProvider.notifier).dismiss();
    expect(container.read(showHomeWelcomeProvider).requireValue, isFalse);
  });
}
