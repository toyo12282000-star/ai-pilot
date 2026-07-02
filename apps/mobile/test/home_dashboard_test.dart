import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_pilot/app/app.dart';
import 'package:ai_pilot/features/auth/presentation/providers/auth_providers.dart';
import 'package:ai_pilot/features/favorite/presentation/providers/favorite_providers.dart';
import 'package:ai_pilot/features/home/presentation/providers/home_providers.dart';
import 'package:ai_pilot/features/profile/data/repositories/mock_user_profile_repository.dart';
import 'package:ai_pilot/features/profile/presentation/providers/profile_providers.dart';
import 'package:ai_pilot/features/recommendation/data/repositories/mock_recommendation_repository.dart';
import 'package:ai_pilot/features/recommendation/presentation/providers/recommendation_providers.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_ai_tool_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_category_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_prompt_template_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_showcase_repository.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/showcase_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';
import 'package:ai_pilot/shared/providers/authenticated_user_provider.dart';
import 'fakes/fake_auth_repository.dart';
import 'helpers/workflow_detail_overrides.dart';

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  late MockWorkflowTestFixtures fixtures;

  setUp(() {
    fixtures = MockWorkflowTestFixtures();
  });

  List<Override> homeDashboardOverrides() {
    return [
      authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
      canAccessAppProvider.overrideWith((ref) => true),
      authenticatedUserIdProvider.overrideWith((ref) => 'user-1'),
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
      ...workflowDetailProviderOverrides(fixtures: fixtures),
    ];
  }

  Future<void> pumpHome(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: homeDashboardOverrides(),
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
  }

  testWidgets('Home shows recent and favorite sections for logged-in user',
      (tester) async {
    await pumpHome(tester);

    expect(find.text('最近使った'), findsOneWidget);
    expect(find.text('調査レポートを作る'), findsWidgets);
  });

  testWidgets('Home shows empty states for user without activity', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ...homeDashboardOverrides(),
          authenticatedUserIdProvider.overrideWith((ref) => 'user-empty'),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('まだWorkflowを使っていません'), findsOneWidget);
    expect(find.text('まだ保存したWorkflowがありません'), findsOneWidget);
  });

  test('popularHomeWorkflowsProvider sorts by social proof score', () async {
    final container = ProviderContainer(
      overrides: homeDashboardOverrides(),
    );
    addTearDown(container.dispose);

    final workflows =
        await container.read(popularHomeWorkflowsProvider.future);

    expect(workflows, isNotEmpty);
    expect(workflows.first.id, 'wf_youtube_short');
  });

  test('favorite add updates home favorite workflows provider', () async {
    const workflowId = 'wf_sns';
    final container = ProviderContainer(
      overrides: homeDashboardOverrides(),
    );
    addTearDown(container.dispose);

    final before =
        await container.read(favoriteHomeWorkflowsProvider.future);
    expect(before.any((workflow) => workflow.id == workflowId), isFalse);

    await fixtures.favoriteRepository.addFavorite('user-1', workflowId);
    container.invalidate(favoritesProvider);
    container.invalidate(favoriteHomeWorkflowsProvider);

    final after = await container.read(favoriteHomeWorkflowsProvider.future);
    expect(after.any((workflow) => workflow.id == workflowId), isTrue);
  });
}
