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
import 'fakes/fake_auth_repository.dart';

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  Future<void> pumpHome(WidgetTester tester) async {
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
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> scrollToSearchBar(WidgetTester tester) async {
    await tester.ensureVisible(find.byType(SearchBar));
  }

  testWidgets('Single character keeps browse sections without full-page loading',
      (tester) async {
    await pumpHome(tester);

    expect(find.text('🔥 人気の完成作品'), findsOneWidget);

    await scrollToSearchBar(tester);
    await tester.enterText(find.byType(SearchBar), 'a');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('🔥 人気の完成作品'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Search runs after debounce with two or more characters',
      (tester) async {
    await pumpHome(tester);

    await scrollToSearchBar(tester);
    await tester.enterText(find.byType(SearchBar), 'zz');
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('🔥 人気の完成作品'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 250));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('🔥 人気の完成作品'), findsNothing);
    expect(find.text('条件に合うワークフローがありません'), findsOneWidget);
  });

  testWidgets('Clear button resets search query', (tester) async {
    await pumpHome(tester);

    await scrollToSearchBar(tester);
    await tester.enterText(find.byType(SearchBar), 'zz');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('クリア'));
    await tester.pumpAndSettle();

    expect(find.text('🔥 人気の完成作品'), findsOneWidget);
    expect(find.text('条件に合うワークフローがありません'), findsNothing);
  });
}
