import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_pilot/app/app.dart';
import 'package:ai_pilot/features/auth/presentation/providers/auth_providers.dart';
import 'package:ai_pilot/features/favorite/data/repositories/mock_favorite_repository.dart';
import 'package:ai_pilot/features/favorite/presentation/providers/favorite_providers.dart';
import 'package:ai_pilot/features/home/presentation/widgets/showcase_card.dart';
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
import 'fakes/fake_auth_repository.dart';
import 'helpers/workflow_detail_overrides.dart';

const _mobileWidth = 390.0;
const _mobileHeight = 844.0;

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  List<Override> mobileOverrides() {
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

  Future<void> pumpMobileApp(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(_mobileWidth, _mobileHeight));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: mobileOverrides(),
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
  }

  Future<void> openWorkflowDetail(WidgetTester tester) async {
    final card = find.widgetWithText(ShowcaseCard, '世界一危険な島3選');
    await tester.scrollUntilVisible(
      card,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(card);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  testWidgets('Home at 390px has no overflow', (tester) async {
    await pumpMobileApp(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('今日は何を作りますか？'), findsOneWidget);
  });

  testWidgets('Workflow detail at 390px has no overflow', (tester) async {
    await pumpMobileApp(tester);
    await openWorkflowDetail(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('人気作品'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Before → After'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Before → After'), findsOneWidget);
  });

  testWidgets('Run page at 390px has no overflow', (tester) async {
    await pumpMobileApp(tester);
    await openWorkflowDetail(tester);

    final cta = find.text('無料でこの作品を作る');
    await tester.scrollUntilVisible(
      cta.first,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(cta.first);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('完成まで'), findsOneWidget);
    expect(find.text('AI Pilot'), findsOneWidget);
  });
}
