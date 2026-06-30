import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_pilot/app/app.dart';
import 'package:ai_pilot/features/auth/presentation/providers/auth_providers.dart';
import 'package:ai_pilot/features/favorite/data/repositories/mock_favorite_repository.dart';
import 'package:ai_pilot/features/favorite/presentation/providers/favorite_providers.dart';
import 'package:ai_pilot/features/profile/data/repositories/mock_user_profile_repository.dart';
import 'package:ai_pilot/features/profile/presentation/providers/profile_providers.dart';
import 'package:ai_pilot/features/recommendation/data/repositories/mock_recommendation_repository.dart';
import 'package:ai_pilot/features/recommendation/presentation/providers/recommendation_providers.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_ai_tool_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_category_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_prompt_template_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_run_history_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_showcase_repository.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/showcase_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_run_history_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_run_sticky_progress.dart';
import 'helpers/workflow_detail_overrides.dart';
import 'fakes/fake_auth_repository.dart';

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  List<Override> runPageOverrides() {
    return [
      authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
      canAccessAppProvider.overrideWith((ref) => true),
      workflowRepositoryProvider.overrideWithValue(MockWorkflowRepository()),
      categoryRepositoryProvider.overrideWithValue(MockCategoryRepository()),
      aiToolRepositoryProvider.overrideWithValue(MockAIToolRepository()),
      promptTemplateRepositoryProvider
          .overrideWithValue(MockPromptTemplateRepository()),
      recommendationRepositoryProvider
          .overrideWithValue(MockRecommendationRepository()),
      favoriteRepositoryProvider.overrideWithValue(MockFavoriteRepository()),
      workflowRunHistoryRepositoryProvider
          .overrideWithValue(MockWorkflowRunHistoryRepository()),
      userProfileRepositoryProvider
          .overrideWithValue(MockUserProfileRepository()),
      workflowShowcaseRepositoryProvider
          .overrideWithValue(MockWorkflowShowcaseRepository()),
      ...workflowDetailProviderOverrides(),
    ];
  }

  Future<void> pumpRunPage(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: runPageOverrides(),
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    await tester.tap(find.text('YouTubeショートを作る').first);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    await tester.tap(find.text('無料でこの作品を作る').first);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
  }

  testWidgets('Run page shows AI companion layout', (tester) async {
    await pumpRunPage(tester);

    expect(find.text('完成まで'), findsOneWidget);
    expect(find.text('AI Pilot'), findsOneWidget);
    expect(find.text('Goal'), findsOneWidget);
    expect(find.text('完成条件'), findsOneWidget);
    expect(find.text('Tips'), findsOneWidget);
    expect(find.text('ChatGPTを開く'), findsOneWidget);
    expect(find.text('Prompt'), findsOneWidget);
    expect(find.text('初心者'), findsOneWidget);
    expect(find.text('高品質'), findsOneWidget);
    expect(find.text('時短'), findsOneWidget);
    expect(find.byType(WorkflowRunStickyProgress), findsOneWidget);
  });

  testWidgets('Run page shows completion screen after finish', (tester) async {
    await pumpRunPage(tester);

    final nextButton = find.text('次へ');
    while (nextButton.evaluate().isNotEmpty) {
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 300));
    }

    await tester.tap(find.text('完了'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('完成しました！'), findsOneWidget);
    expect(find.text('保存'), findsOneWidget);
    expect(find.text('完成作品を見る'), findsOneWidget);
    expect(find.text('もう一作品作る'), findsOneWidget);
    expect(find.text('Homeへ戻る'), findsOneWidget);
  });
}
