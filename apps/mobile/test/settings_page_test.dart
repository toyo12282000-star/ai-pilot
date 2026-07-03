import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/app/main_shell.dart';
import 'package:ai_pilot/features/auth/presentation/providers/auth_providers.dart';
import 'package:ai_pilot/features/favorite/data/repositories/mock_favorite_repository.dart';
import 'package:ai_pilot/features/favorite/presentation/pages/favorites_page.dart';
import 'package:ai_pilot/features/favorite/presentation/providers/favorite_providers.dart';
import 'package:ai_pilot/features/home/presentation/pages/home_page.dart';
import 'package:ai_pilot/features/profile/data/repositories/mock_user_profile_repository.dart';
import 'package:ai_pilot/features/profile/presentation/pages/about_page.dart';
import 'package:ai_pilot/features/profile/presentation/pages/beta_feedback_page.dart';
import 'package:ai_pilot/features/profile/presentation/pages/privacy_policy_page.dart';
import 'package:ai_pilot/features/profile/presentation/pages/settings_page.dart';
import 'package:ai_pilot/features/profile/presentation/pages/terms_page.dart';
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
      GoRoute(
        path: '/beta-feedback',
        builder: (context, state) => const BetaFeedbackPage(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        path: '/terms',
        builder: (context, state) => const TermsPage(),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PrivacyPolicyPage(),
      ),
    ],
  );
}

Future<void> _tapSettingsLink(WidgetTester tester, String label) async {
  final target = find.text(label);
  final settingsScrollable = find.descendant(
    of: find.byType(SettingsPage),
    matching: find.byType(Scrollable),
  );
  await tester.scrollUntilVisible(
    target,
    500,
    scrollable: settingsScrollable,
  );
  await tester.tap(target);
  await tester.pumpAndSettle();
}

Future<void> _openSettings(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(420, 920));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final router = _buildShellRouter();
  await tester.pumpWidget(_buildGuestApp(router));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  testWidgets('Settings shows app info links', (tester) async {
    await _openSettings(tester);

    expect(find.text('AI Pilotについて'), findsOneWidget);
    expect(find.text('フィードバックを送る'), findsOneWidget);
    expect(find.text('利用規約'), findsOneWidget);
    expect(find.text('プライバシーポリシー'), findsOneWidget);
  });

  testWidgets('About page shows title and content', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: AboutPage()),
    );
    await tester.pumpAndSettle();

    expect(find.text('AI Pilotについて'), findsOneWidget);
    expect(find.text('AI Pilotとは'), findsOneWidget);
    expect(
      find.textContaining('やりたいことを選ぶだけで'),
      findsOneWidget,
    );
  });

  testWidgets('Terms page shows title', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: TermsPage()),
    );
    await tester.pumpAndSettle();

    expect(find.text('利用規約'), findsOneWidget);
    expect(find.text('禁止事項'), findsOneWidget);
  });

  testWidgets('Privacy page shows title', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: PrivacyPolicyPage()),
    );
    await tester.pumpAndSettle();

    expect(find.text('プライバシーポリシー'), findsOneWidget);
    expect(find.textContaining('Supabase'), findsOneWidget);
    expect(find.text('第三者への提供'), findsOneWidget);
  });

  testWidgets('Settings navigates to beta feedback page', (tester) async {
    await _openSettings(tester);

    await _tapSettingsLink(tester, 'フィードバックを送る');

    expect(find.text('不具合・改善要望を送る'), findsOneWidget);
  });

  testWidgets('Settings navigates to about page', (tester) async {
    await _openSettings(tester);

    await _tapSettingsLink(tester, 'AI Pilotについて');

    expect(find.text('AI Pilotとは'), findsOneWidget);
  });

  testWidgets('Settings navigates to terms page', (tester) async {
    await _openSettings(tester);

    await _tapSettingsLink(tester, '利用規約');

    expect(find.text('免責事項'), findsOneWidget);
  });

  testWidgets('Settings navigates to privacy page', (tester) async {
    await _openSettings(tester);

    await _tapSettingsLink(tester, 'プライバシーポリシー');

    expect(find.textContaining('お問い合わせ'), findsWidgets);
  });

  testWidgets('Guest settings shows guest status and login button', (tester) async {
    await _openSettings(tester);

    expect(find.text('ゲスト利用中'), findsOneWidget);
    expect(find.text('ログインする'), findsOneWidget);
  });

  testWidgets('Settings tab exists in bottom navigation', (tester) async {
    final router = _buildShellRouter(initialLocation: '/');
    await tester.pumpWidget(_buildGuestApp(router));
    await tester.pumpAndSettle();

    expect(find.text('設定'), findsOneWidget);
  });
}
