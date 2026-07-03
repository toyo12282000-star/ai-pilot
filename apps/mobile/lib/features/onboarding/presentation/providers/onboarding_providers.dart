import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/features/advisor/presentation/providers/advisor_history_providers.dart';
import 'package:ai_pilot/features/home/presentation/providers/home_providers.dart';
import 'package:ai_pilot/shared/providers/app_preferences_provider.dart';
import 'package:ai_pilot/shared/providers/authenticated_user_provider.dart';

/// Home Welcome カードを dismiss 済みか。
final homeWelcomeDismissedProvider =
    AsyncNotifierProvider<HomeWelcomeDismissedNotifier, bool>(
  HomeWelcomeDismissedNotifier.new,
);

class HomeWelcomeDismissedNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final prefs = await ref.watch(appPreferencesProvider.future);
    return prefs.isHomeWelcomeDismissed;
  }

  Future<void> dismiss() async {
    final prefs = await ref.read(appPreferencesProvider.future);
    await prefs.setHomeWelcomeDismissed(true);
    state = const AsyncData(true);
  }
}

/// run / favorite / advisor 履歴がすべて空のユーザー。
final isNewAppUserProvider = FutureProvider<bool>((ref) async {
  if (!ref.watch(isAuthenticatedProvider)) {
    return true;
  }

  final userId = ref.watch(authenticatedUserIdProvider);
  if (userId == null) {
    return true;
  }

  final recentActivities =
      await ref.watch(recentHomeWorkflowActivitiesProvider.future);
  if (recentActivities.isNotEmpty) {
    return false;
  }

  final favorites = await ref.watch(favoriteHomeWorkflowsProvider.future);
  if (favorites.isNotEmpty) {
    return false;
  }

  final advisorHistories =
      await ref.watch(advisorHistoriesProvider(userId).future);
  if (advisorHistories.isNotEmpty) {
    return false;
  }

  return true;
});

/// Home Welcome カードを表示するか（初回条件 + 未 dismiss）。
final showHomeWelcomeProvider = Provider<AsyncValue<bool>>((ref) {
  final dismissedAsync = ref.watch(homeWelcomeDismissedProvider);
  final isNewUserAsync = ref.watch(isNewAppUserProvider);

  if (dismissedAsync.isLoading || isNewUserAsync.isLoading) {
    return const AsyncLoading();
  }
  if (dismissedAsync.hasError) {
    return AsyncError(dismissedAsync.error!, dismissedAsync.stackTrace!);
  }
  if (isNewUserAsync.hasError) {
    return AsyncError(isNewUserAsync.error!, isNewUserAsync.stackTrace!);
  }

  final dismissed = dismissedAsync.requireValue;
  final isNewUser = isNewUserAsync.requireValue;
  return AsyncData(!dismissed && isNewUser);
});
