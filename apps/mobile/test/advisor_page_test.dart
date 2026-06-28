import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/features/advisor/data/repositories/mock_advisor_history_repository.dart';
import 'package:ai_pilot/features/advisor/presentation/pages/advisor_page.dart';
import 'package:ai_pilot/features/advisor/presentation/providers/advisor_history_providers.dart';
import 'package:ai_pilot/features/advisor/presentation/widgets/advisor_example_chips.dart';
import 'package:ai_pilot/features/recommendation/data/repositories/mock_recommendation_repository.dart';
import 'package:ai_pilot/features/recommendation/presentation/providers/recommendation_providers.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_category_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_repository.dart';
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
      ],
    );
  }

  testWidgets('Advisor page shows six example chips', (tester) async {
    await pumpAdvisorPage(tester, buildRouter());

    for (final example in AdvisorExampleChips.exampleQueries) {
      expect(find.text(example), findsOneWidget);
    }
  });

  testWidgets('Guest does not show recent history section', (tester) async {
    await pumpAdvisorPage(tester, buildRouter());

    expect(find.text('最近の相談'), findsNothing);
  });

  testWidgets('Authenticated user sees recent history section', (tester) async {
    await pumpAdvisorPage(tester, buildRouter(), userId: 'user-1');

    expect(find.text('最近の相談'), findsOneWidget);
    expect(find.text('YouTubeを始めたい'), findsWidgets);
  });

  testWidgets('Recent history tap refills query', (tester) async {
    await pumpAdvisorPage(tester, buildRouter(), userId: 'user-1');

    await tester.tap(find.text('1件のWorkflowを提案'));
    await tester.pump();

    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.controller?.text, 'YouTubeを始めたい');

    await tester.pumpAndSettle(const Duration(seconds: 2));
  });

  testWidgets('Recent history delete removes item', (tester) async {
    await pumpAdvisorPage(tester, buildRouter(), userId: 'user-1');

    expect(find.text('1件のWorkflowを提案'), findsOneWidget);

    await tester.tap(find.byTooltip('削除'));
    await tester.pumpAndSettle(const Duration(milliseconds: 400));

    expect(find.text('1件のWorkflowを提案'), findsNothing);
  });

  testWidgets('Advisor page shows input helper text', (tester) async {
    await pumpAdvisorPage(tester, buildRouter());

    expect(
      find.text('やりたいことを自然な言葉で入力してください'),
      findsOneWidget,
    );
    expect(
      find.text('例：YouTubeを始めたい、資料を作りたい'),
      findsOneWidget,
    );
  });

  testWidgets('Advisor page shows loading then match badge on suggest',
      (tester) async {
    await pumpAdvisorPage(tester, buildRouter());

    await tester.tap(find.text('YouTubeを始めたい'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('提案する'));
    await tester.pump();

    expect(
      find.text('AI Pilotが最適なWorkflowを探しています...'),
      findsOneWidget,
    );

    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    expect(find.text('おすすめWorkflow'), findsOneWidget);
    expect(find.text('YouTubeショートを作る'), findsOneWidget);
    expect(find.text('おすすめ度：高'), findsOneWidget);
    expect(find.text('詳細を見る'), findsWidgets);
    expect(find.text('このWorkflowを開始する'), findsWidgets);
  });

  testWidgets('Advisor page shows empty state with home action', (tester) async {
    await pumpAdvisorPage(tester, buildRouter());

    await tester.enterText(find.byType(TextField), 'zzzznomatchquery');
    await tester.tap(find.text('提案する'));
    await tester.pump();
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    expect(find.text('近いWorkflowが見つかりませんでした'), findsOneWidget);
    expect(
      find.text('別の言葉で入力するか、カテゴリから探してみてください'),
      findsOneWidget,
    );
    expect(find.text('ホームで探す'), findsOneWidget);
    expect(find.text('例文から試す'), findsOneWidget);

    for (final example in AdvisorExampleChips.exampleQueries) {
      expect(find.text(example), findsNWidgets(2));
    }

    await tester.ensureVisible(find.text('ホームで探す'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ホームで探す'));
    await tester.pumpAndSettle();

    expect(find.text('Home Page'), findsOneWidget);
  });
}
