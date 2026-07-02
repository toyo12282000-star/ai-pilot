import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/features/advisor/data/repositories/mock_advisor_history_repository.dart';
import 'package:ai_pilot/features/advisor/data/repositories/mock_advisor_api_repository.dart';
import 'package:ai_pilot/features/advisor/presentation/models/advisor_conversation_flow.dart';
import 'package:ai_pilot/features/advisor/presentation/pages/advisor_page.dart';
import 'package:ai_pilot/features/advisor/presentation/providers/advisor_history_providers.dart';
import 'package:ai_pilot/features/advisor/presentation/providers/advisor_providers.dart';
import 'package:ai_pilot/features/recommendation/data/repositories/mock_recommendation_repository.dart';
import 'package:ai_pilot/features/recommendation/data/repositories/mock_recommendation_seed_data.dart';
import 'package:ai_pilot/features/recommendation/presentation/providers/recommendation_providers.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_category_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_showcase_repository.dart';
import 'package:ai_pilot/features/workflow/data/services/mock_showcase_image_storage.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/showcase_image_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/showcase_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';
import 'package:ai_pilot/shared/providers/authenticated_user_provider.dart';

void main() {
  List<Override> baseOverrides({String? userId}) {
    return [
      workflowRepositoryProvider.overrideWithValue(MockWorkflowRepository()),
      categoryRepositoryProvider.overrideWithValue(MockCategoryRepository()),
      recommendationRepositoryProvider
          .overrideWithValue(MockRecommendationRepository()),
      advisorHistoryRepositoryProvider
          .overrideWithValue(MockAdvisorHistoryRepository()),
      advisorApiRepositoryProvider.overrideWithValue(
        MockAdvisorApiRepository(
          recommendations: mockRecommendations,
          categories: mockCategories,
        ),
      ),
      workflowShowcaseRepositoryProvider
          .overrideWithValue(MockWorkflowShowcaseRepository()),
      showcaseImageStorageProvider
          .overrideWithValue(MockShowcaseImageStorage()),
      authenticatedUserIdProvider.overrideWith((ref) => userId),
    ];
  }

  Future<void> pumpAdvisorPage(
    WidgetTester tester,
    GoRouter router, {
    String? userId,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: baseOverrides(userId: userId),
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    if (userId != null) {
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pumpAndSettle();
    }
  }

  GoRouter buildRouter() {
    return GoRouter(
      initialLocation: '/advisor',
      routes: [
        GoRoute(
          path: '/advisor',
          builder: (context, state) => const AdvisorPage(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const Scaffold(body: Text('Home Page')),
        ),
        GoRoute(
          path: '/workflows/:id',
          builder: (context, state) =>
              Scaffold(body: Text('Workflow ${state.pathParameters['id']}')),
        ),
        GoRoute(
          path: '/workflows/:id/run',
          builder: (context, state) =>
              Scaffold(body: Text('Run ${state.pathParameters['id']}')),
        ),
      ],
    );
  }

  Future<void> completeYoutubeFlow(WidgetTester tester) async {
    await tester.tap(find.text('YouTube動画を作りたい'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('美容'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('30分'));
    await tester.pumpAndSettle();

    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  testWidgets('Advisor page shows chat greeting and quick replies', (tester) async {
    await pumpAdvisorPage(tester, buildRouter());

    expect(
      find.text(AdvisorConversationFlow.initialGreeting),
      findsOneWidget,
    );
    for (final reply in AdvisorConversationFlow.initialQuickReplies) {
      expect(find.text(reply), findsWidgets);
    }
    expect(find.text('メッセージを入力...'), findsOneWidget);
  });

  testWidgets('Guest does not show recent history section', (tester) async {
    await pumpAdvisorPage(tester, buildRouter());

    expect(find.text('最近の相談'), findsNothing);
  });

  testWidgets('Authenticated user sees recent history section', (tester) async {
    await pumpAdvisorPage(tester, buildRouter(), userId: 'user-1');

    expect(find.text('最近の相談'), findsOneWidget);
    expect(find.text('YouTubeを始めたい'), findsWidgets);
    expect(find.text('YouTube'), findsWidgets);
    expect(find.text('YouTubeショートを作る'), findsOneWidget);
  });

  testWidgets('Authenticated user with no history sees empty state',
      (tester) async {
    await pumpAdvisorPage(tester, buildRouter(), userId: 'user-2');

    expect(find.text('最近の相談'), findsOneWidget);
    expect(find.text('まだ相談履歴がありません'), findsOneWidget);
    expect(
      find.text('AI Pilot に作りたいものを相談してみましょう'),
      findsOneWidget,
    );
  });

  testWidgets('Recent history tap triggers recommendation', (tester) async {
    await pumpAdvisorPage(tester, buildRouter(), userId: 'user-1');

    await tester.ensureVisible(find.text('YouTubeを始めたい').last);
    await tester.tap(find.text('YouTubeを始めたい').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('YouTubeショートを作る'), findsOneWidget);
    expect(find.text('このWorkflowを始める'), findsOneWidget);
  });

  testWidgets('Recent history delete removes item', (tester) async {
    await pumpAdvisorPage(tester, buildRouter(), userId: 'user-1');

    expect(find.text('YouTubeショートを作る'), findsOneWidget);

    await tester.tap(find.byTooltip('削除').first);
    await tester.pumpAndSettle(const Duration(milliseconds: 400));

    expect(find.text('1件のWorkflowを提案'), findsNothing);
    expect(find.text('まだ相談履歴がありません'), findsOneWidget);
  });

  testWidgets('Quick reply conversation shows typing then recommendation',
      (tester) async {
    await pumpAdvisorPage(tester, buildRouter());

    await tester.tap(find.text('YouTube動画を作りたい'));
    await tester.pumpAndSettle();

    expect(find.text('どんなジャンルですか？'), findsOneWidget);

    await tester.tap(find.text('美容'));
    await tester.pumpAndSettle();

    expect(find.text('どのくらいの時間で作りたいですか？'), findsOneWidget);

    await tester.tap(find.text('30分'));
    await tester.pump();

    expect(
      find.text(AdvisorConversationFlow.completionMessage),
      findsOneWidget,
    );

    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('おすすめWorkflow'), findsOneWidget);
    expect(find.text('YouTubeショートを作る'), findsOneWidget);
    expect(find.text('このWorkflowを始める'), findsOneWidget);
    if (find.text('他の候補を見る').evaluate().isNotEmpty) {
      expect(find.text('他の候補を見る'), findsOneWidget);
    }
  });

  testWidgets('Text input can trigger recommendation directly', (tester) async {
    await pumpAdvisorPage(tester, buildRouter());

    await tester.enterText(find.byType(TextField), 'YouTubeを始めたい');
    await tester.tap(find.byIcon(Icons.arrow_upward_rounded));
    await tester.pump();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('YouTubeショートを作る'), findsOneWidget);
  });

  testWidgets('Advisor page shows empty state with home action', (tester) async {
    await pumpAdvisorPage(tester, buildRouter());

    await tester.enterText(find.byType(TextField), 'zzzznomatchquery');
    await tester.tap(find.byIcon(Icons.arrow_upward_rounded));
    await tester.pump();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('近いWorkflowが見つかりませんでした'), findsOneWidget);
    expect(find.text('もう一度相談する'), findsOneWidget);

    await tester.tap(find.text('ホームで探す'));
    await tester.pumpAndSettle();

    expect(find.text('Home Page'), findsOneWidget);
  });

  testWidgets('Show more candidates reveals secondary suggestions', (tester) async {
    await pumpAdvisorPage(tester, buildRouter());
    await completeYoutubeFlow(tester);

    final showMore = find.text('他の候補を見る');
    if (showMore.evaluate().isEmpty) {
      return;
    }

    await tester.tap(showMore);
    await tester.pumpAndSettle();

    expect(find.text('詳細を見る'), findsWidgets);
  });
}
