import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/features/advisor/presentation/pages/advisor_page.dart';
import 'package:ai_pilot/features/recommendation/data/repositories/mock_recommendation_repository.dart';
import 'package:ai_pilot/features/recommendation/presentation/providers/recommendation_providers.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_category_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_repository.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';

void main() {
  testWidgets('Advisor page shows input and suggests workflows', (tester) async {
    final router = GoRouter(
      initialLocation: '/advisor',
      routes: [
        GoRoute(
          path: '/advisor',
          builder: (context, state) => const AdvisorPage(),
        ),
        GoRoute(
          path: '/workflows/:id',
          builder: (context, state) =>
              Scaffold(body: Text('Workflow ${state.pathParameters['id']}')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          workflowRepositoryProvider.overrideWithValue(MockWorkflowRepository()),
          categoryRepositoryProvider.overrideWithValue(MockCategoryRepository()),
          recommendationRepositoryProvider
              .overrideWithValue(MockRecommendationRepository()),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('AIに相談する'), findsWidgets);
    expect(find.text('提案する'), findsOneWidget);
    expect(find.text('YouTubeを始めたい'), findsOneWidget);

    await tester.tap(find.text('YouTubeを始めたい'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('提案する'));
    await tester.pump();
    await tester.pumpAndSettle(const Duration(milliseconds: 400));

    expect(find.text('おすすめWorkflow'), findsOneWidget);
    expect(find.text('YouTubeショートを作る'), findsOneWidget);
    expect(find.text('開始する'), findsWidgets);
    expect(find.text('詳細を見る'), findsWidgets);
  });
}
