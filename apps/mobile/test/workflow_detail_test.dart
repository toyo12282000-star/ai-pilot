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
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_detail_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_run_history_providers.dart';
import 'package:ai_pilot/features/workflow/domain/entities/prompt_variant.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_collapsible_step_card.dart';
import 'fakes/fake_auth_repository.dart';
import 'helpers/workflow_detail_overrides.dart';

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  List<Override> workflowDetailOverrides() {
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

  Future<void> pumpWorkflowDetail(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 4200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: workflowDetailOverrides(),
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
  }

  testWidgets('Workflow detail shows showcase-first sections', (tester) async {
    await pumpWorkflowDetail(tester);

    expect(find.text('完成作品ギャラリー'), findsOneWidget);
    expect(find.text('このWorkflowで使うAI'), findsOneWidget);
    expect(find.text('この作品を作る'), findsWidgets);
    expect(find.text('世界一危険な島3選'), findsWidgets);

    final scrollable = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      find.text('完了後に得られる成果'),
      400,
      scrollable: scrollable,
    );
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
    expect(find.text('完了後に得られる成果'), findsOneWidget);
  });

  testWidgets('Workflow detail step expands with prompt tabs', (tester) async {
    await pumpWorkflowDetail(tester);

    await tester.ensureVisible(find.text('企画を考える').first);
    await tester.tap(find.text('企画を考える').first);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('Output Example'), findsOneWidget);
    expect(find.text('Completion Criteria'), findsOneWidget);
    expect(find.text('Tips'), findsOneWidget);
    expect(find.text('Common Mistakes'), findsOneWidget);
    expect(find.text('初心者'), findsOneWidget);
    expect(find.text('高品質'), findsOneWidget);
    expect(find.text('時短'), findsOneWidget);
  });

  group('workflow detail providers', () {
    test('workflowPrimaryShowcaseProvider returns featured showcase', () async {
      final container = ProviderContainer(
        overrides: workflowDetailOverrides(),
      );
      addTearDown(container.dispose);

      final showcase = await container.read(
        workflowPrimaryShowcaseProvider('wf_youtube_short').future,
      );

      expect(showcase, isNotNull);
      expect(showcase!.isFeatured, isTrue);
    });

    test('workflowAiToolsProvider aggregates unique tools', () async {
      final container = ProviderContainer(
        overrides: workflowDetailOverrides(),
      );
      addTearDown(container.dispose);

      final tools = await container.read(
        workflowAiToolsProvider('wf_youtube_short').future,
      );

      expect(tools, isNotEmpty);
      expect(
        tools.where((entry) => entry.isRecommended),
        isNotEmpty,
      );
    });
  });

  test('prompt tab variants include beginner highQuality shortTime', () {
    expect(
      WorkflowCollapsibleStepCard.tabVariants,
      contains(PromptVariantType.beginner),
    );
    expect(
      WorkflowCollapsibleStepCard.tabVariants,
      contains(PromptVariantType.highQuality),
    );
    expect(
      WorkflowCollapsibleStepCard.tabVariants,
      contains(PromptVariantType.shortTime),
    );
  });
}
