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

  testWidgets('Home shows showcase-first hero copy and section', (tester) async {
    await pumpHome(tester);

    expect(find.text('何を作りたいですか？'), findsAtLeastNWidgets(1));
    expect(
      find.text('完成イメージからAIワークフローを選べます'),
      findsOneWidget,
    );
    expect(find.text('完成作品から選ぶ'), findsOneWidget);
    expect(find.text('世界一危険な島3選'), findsOneWidget);
    expect(find.text('この作品を作る'), findsWidgets);
  });

  testWidgets('Showcase section appears before recommended workflows',
      (tester) async {
    await pumpHome(tester);

    await tester.ensureVisible(find.text('完成作品から選ぶ'));
    final showcaseOffset = tester.getTopLeft(find.text('完成作品から選ぶ'));

    await tester.scrollUntilVisible(
      find.text('おすすめWorkflow'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    final recommendedOffset = tester.getTopLeft(find.text('おすすめWorkflow'));

    expect(showcaseOffset.dy, lessThan(recommendedOffset.dy));
  });

  testWidgets('Tapping showcase card navigates to workflow detail', (tester) async {
    await pumpHome(tester);

    final card = find.byType(ShowcaseCard).first;
    await tester.scrollUntilVisible(
      card,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(card);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('世界一危険な島3選'), findsWidgets);
    expect(find.text('完成作品ギャラリー'), findsOneWidget);
  });

  testWidgets('Search hides showcase browse section', (tester) async {
    await pumpHome(tester);

    await tester.enterText(find.byType(SearchBar), 'zz');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('完成作品から選ぶ'), findsNothing);
  });
}
