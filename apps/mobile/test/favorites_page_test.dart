import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/features/favorite/presentation/pages/favorites_page.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_favorite_button.dart';
import 'package:ai_pilot/shared/providers/authenticated_user_provider.dart';
import 'package:ai_pilot/shared/widgets/error_view.dart';
import 'package:ai_pilot/shared/widgets/login_required_view.dart';

void main() {
  testWidgets('Guest favorites page shows login required view', (tester) async {
    final router = GoRouter(
      initialLocation: '/favorites',
      routes: [
        GoRoute(
          path: '/favorites',
          builder: (context, state) => const FavoritesPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) =>
              const Scaffold(body: Text('Login Page')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authenticatedUserIdProvider.overrideWith((ref) => null),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(LoginRequiredView), findsOneWidget);
    expect(find.text('ログインが必要です'), findsOneWidget);
    expect(
      find.text('お気に入りや実行履歴を保存するにはログインしてください'),
      findsOneWidget,
    );
    expect(find.text('ワークフローの読み込みに失敗しました'), findsNothing);
    expect(find.text('お気に入りの読み込みに失敗しました'), findsNothing);
  });

  testWidgets('Guest favorites login button navigates to login', (tester) async {
    final router = GoRouter(
      initialLocation: '/favorites',
      routes: [
        GoRoute(
          path: '/favorites',
          builder: (context, state) => const FavoritesPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) =>
              const Scaffold(body: Text('Login Page')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authenticatedUserIdProvider.overrideWith((ref) => null),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('ログインする'));
    await tester.pumpAndSettle();

    expect(find.text('Login Page'), findsOneWidget);
  });

  testWidgets('Guest favorite button shows login prompt sheet', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authenticatedUserIdProvider.overrideWith((ref) => null),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: Center(
              child: WorkflowFavoriteButton(workflowId: 'wf-1'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('ログインしてお気に入りに追加'));
    await tester.pumpAndSettle();

    expect(find.text('保存するにはログインが必要です'), findsOneWidget);
    expect(
      find.text('ログインすると、お気に入りや実行履歴を複数端末で同期できます'),
      findsOneWidget,
    );
    expect(find.text('あとで'), findsOneWidget);
  });

  testWidgets('ErrorView shows title and description', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorView(
            title: '読み込みに失敗しました',
            description: '通信状況を確認して、もう一度お試しください',
            onRetry: () {},
          ),
        ),
      ),
    );

    expect(find.text('読み込みに失敗しました'), findsOneWidget);
    expect(find.text('通信状況を確認して、もう一度お試しください'), findsOneWidget);
    expect(find.text('再試行'), findsOneWidget);
  });
}
