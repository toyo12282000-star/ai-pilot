import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/app/main_shell.dart';
import 'package:ai_pilot/features/auth/presentation/providers/auth_providers.dart';
import 'package:ai_pilot/features/favorite/presentation/pages/favorites_page.dart';
import 'package:ai_pilot/features/favorite/data/repositories/mock_favorite_repository.dart';
import 'package:ai_pilot/features/favorite/presentation/providers/favorite_providers.dart';
import 'package:ai_pilot/features/home/presentation/pages/home_page.dart';
import 'package:ai_pilot/features/profile/data/repositories/mock_user_profile_repository.dart';
import 'package:ai_pilot/features/profile/presentation/pages/settings_page.dart';
import 'package:ai_pilot/features/profile/presentation/providers/profile_providers.dart';
import 'package:ai_pilot/features/recommendation/data/repositories/mock_recommendation_repository.dart';
import 'package:ai_pilot/features/recommendation/presentation/providers/recommendation_providers.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_ai_tool_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_category_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_prompt_template_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_run_history_repository.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_run_history_providers.dart';
import 'package:ai_pilot/shared/providers/authenticated_user_provider.dart';
import 'package:ai_pilot/shared/providers/guest_mode_provider.dart';
import 'fakes/fake_auth_repository.dart';

Widget _buildGuestApp(GoRouter router) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
      guestModeProvider.overrideWith((ref) => true),
      authenticatedUserIdProvider.overrideWith((ref) => null),
      canAccessAppProvider.overrideWith((ref) => true),
      userProfileRepositoryProvider
          .overrideWithValue(MockUserProfileRepository()),
      workflowRepositoryProvider.overrideWithValue(MockWorkflowRepository()),
      categoryRepositoryProvider.overrideWithValue(MockCategoryRepository()),
      aiToolRepositoryProvider.overrideWithValue(MockAIToolRepository()),
      promptTemplateRepositoryProvider
          .overrideWithValue(MockPromptTemplateRepository()),
      recommendationRepositoryProvider
          .overrideWithValue(MockRecommendationRepository()),
      favoriteRepositoryProvider
          .overrideWithValue(MockFavoriteRepository()),
      workflowRunHistoryRepositoryProvider
          .overrideWithValue(MockWorkflowRunHistoryRepository()),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

GoRouter _buildShellRouter({String initialLocation = '/settings'}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/favorites',
                builder: (context, state) => const FavoritesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) =>
            const Scaffold(body: Text('Login Page')),
      ),
    ],
  );
}

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  testWidgets('Guest settings shows guest status and login button', (tester) async {
    final router = _buildShellRouter();

    await tester.pumpWidget(_buildGuestApp(router));
    await tester.pumpAndSettle();

    expect(find.text('ゲスト利用中'), findsOneWidget);
    expect(find.text('ログインする'), findsOneWidget);
    expect(find.text('ログアウト'), findsNothing);
    expect(find.text('MVP Preview'), findsOneWidget);
    expect(find.text('0.1.0'), findsOneWidget);
  });

  testWidgets('Settings tab exists in bottom navigation', (tester) async {
    final router = _buildShellRouter(initialLocation: '/');

    await tester.pumpWidget(_buildGuestApp(router));
    await tester.pumpAndSettle();

    expect(find.text('設定'), findsOneWidget);
    expect(find.text('ホーム'), findsOneWidget);
    expect(find.text('お気に入り'), findsOneWidget);
  });

  testWidgets('Tapping settings tab opens settings page', (tester) async {
    final router = _buildShellRouter(initialLocation: '/');

    await tester.pumpWidget(_buildGuestApp(router));
    await tester.pumpAndSettle();

    await tester.tap(find.text('設定'));
    await tester.pumpAndSettle();

    expect(find.text('ゲスト利用中'), findsOneWidget);
    expect(find.text('アプリ情報'), findsOneWidget);
  });

  testWidgets('Guest login button navigates to login page', (tester) async {
    final router = _buildShellRouter();

    await tester.pumpWidget(_buildGuestApp(router));
    await tester.pumpAndSettle();

    await tester.tap(find.text('ログインする'));
    await tester.pumpAndSettle();

    expect(find.text('Login Page'), findsOneWidget);
  });
}
