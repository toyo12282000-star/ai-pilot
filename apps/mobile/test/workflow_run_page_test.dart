import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_pilot/app/app.dart';
import 'package:ai_pilot/features/auth/presentation/providers/auth_providers.dart';
import 'package:ai_pilot/features/profile/data/repositories/mock_user_profile_repository.dart';
import 'package:ai_pilot/features/profile/presentation/providers/profile_providers.dart';
import 'package:ai_pilot/features/recommendation/data/repositories/mock_recommendation_repository.dart';
import 'package:ai_pilot/features/recommendation/presentation/providers/recommendation_providers.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_ai_tool_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_category_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_prompt_template_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_showcase_repository.dart';
import 'package:ai_pilot/features/workflow/data/services/mock_showcase_image_storage.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/showcase_image_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/showcase_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_run_mini_showcase.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_run_sticky_progress.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_run_step_checklist.dart';
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
      userProfileRepositoryProvider
          .overrideWithValue(MockUserProfileRepository()),
      workflowShowcaseRepositoryProvider
          .overrideWithValue(MockWorkflowShowcaseRepository()),
      showcaseImageStorageProvider
          .overrideWithValue(MockShowcaseImageStorage()),
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

  testWidgets('Run page shows AI production assistant layout', (tester) async {
    await pumpRunPage(tester);

    expect(find.text('完成まで'), findsOneWidget);
    expect(find.textContaining('残り約'), findsOneWidget);
    expect(find.byType(WorkflowRunStickyProgress), findsOneWidget);
    expect(find.byType(WorkflowRunMiniShowcase), findsOneWidget);
    expect(find.text('完成イメージ'), findsOneWidget);
    expect(find.text('AI Pilot'), findsOneWidget);
    expect(find.text('Goal'), findsOneWidget);
    expect(find.text('やること'), findsOneWidget);
    expect(find.byType(WorkflowRunStepChecklist), findsOneWidget);
    expect(find.text('Prompt'), findsOneWidget);
    expect(find.textContaining('おすすめ度'), findsOneWidget);
    expect(find.text('ChatGPTを開く'), findsWidgets);
    expect(find.text('AI Pilotのコツ'), findsOneWidget);
  });

  testWidgets('Run page shows achievement when advancing step', (tester) async {
    await pumpRunPage(tester);

    await tester.tap(find.text('次へ'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Step1 完了！'), findsOneWidget);
    expect(find.textContaining('いい感じです'), findsOneWidget);
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

    expect(find.text('完成おめでとう！'), findsOneWidget);
    expect(find.text('共有'), findsOneWidget);
    expect(find.text('お気に入りに追加'), findsOneWidget);
    expect(find.text('完成作品を見る'), findsOneWidget);
    expect(find.text('ホームへ戻る'), findsOneWidget);
    expect(find.text('制作時間'), findsOneWidget);
    expect(find.text('使用AI'), findsOneWidget);
  });
}
