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
import 'package:ai_pilot/features/home/presentation/widgets/home_hero_section.dart';
import 'package:ai_pilot/features/home/presentation/widgets/showcase_card.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_run_history_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_showcase_repository.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/showcase_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_run_history_providers.dart';
import 'helpers/workflow_detail_overrides.dart';
import 'fakes/fake_auth_repository.dart';

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  Future<void> pumpHome(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
          canAccessAppProvider.overrideWith((ref) => true),
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
          userProfileRepositoryProvider
              .overrideWithValue(MockUserProfileRepository()),
          workflowShowcaseRepositoryProvider
              .overrideWithValue(MockWorkflowShowcaseRepository()),
          ...workflowDetailProviderOverrides(),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Home shows outcome-first hero copy and featured showcase',
      (tester) async {
    await pumpHome(tester);

    expect(find.text('今日は何を作りますか？'), findsOneWidget);
    expect(
      find.text(HomeHeroSection.subtitle),
      findsOneWidget,
    );
    expect(find.text('人気の完成作品'), findsOneWidget);
    expect(find.text('世界一危険な島3選'), findsOneWidget);
    expect(find.text('3ステップで作る'), findsWidgets);
  });

  testWidgets('Featured showcase appears before recommendation section',
      (tester) async {
    await pumpHome(tester);

    await tester.ensureVisible(find.text('人気の完成作品'));
    final showcaseOffset = tester.getTopLeft(find.text('人気の完成作品'));

    await tester.scrollUntilVisible(
      find.text('こんな人におすすめ'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    final recommendationOffset =
        tester.getTopLeft(find.text('こんな人におすすめ'));

    expect(showcaseOffset.dy, lessThan(recommendationOffset.dy));
  });

  testWidgets('Tapping showcase card navigates to workflow detail', (tester) async {
    await pumpHome(tester);

    final card = find.widgetWithText(ShowcaseCard, '世界一危険な島3選');
    await tester.scrollUntilVisible(
      card,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(card);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('世界一危険な島3選'), findsWidgets);
    expect(find.text('人気作品'), findsOneWidget);
    expect(find.text('無料でこの作品を作る'), findsWidgets);
  });

  testWidgets('Search hides discovery sections', (tester) async {
    await pumpHome(tester);

    await tester.enterText(find.byType(SearchBar), 'zz');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('人気の完成作品'), findsNothing);
    expect(find.text('何を作ればいいか迷っていますか？'), findsNothing);
  });
}
