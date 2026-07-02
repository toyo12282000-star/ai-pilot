import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/features/favorite/data/repositories/mock_favorite_repository.dart';
import 'package:ai_pilot/features/favorite/presentation/providers/favorite_providers.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_ai_tool_alternative_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_prompt_variant_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_social_proof_data_store.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_outcome_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_run_history_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_social_proof_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_step_tool_option_repository.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/outcome_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_run_history_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_social_proof_providers.dart';

/// Mock favorites / run histories / social proof を同一ストアで共有する。
class MockWorkflowTestFixtures {
  factory MockWorkflowTestFixtures({DateTime? seedNow}) {
    final store = MockSocialProofDataStore(seedNow: seedNow);
    return MockWorkflowTestFixtures._(
      store: store,
      favoriteRepository: MockFavoriteRepository(store),
      runHistoryRepository: MockWorkflowRunHistoryRepository(store),
      socialProofRepository: MockWorkflowSocialProofRepository(store),
    );
  }

  MockWorkflowTestFixtures._({
    required this.store,
    required this.favoriteRepository,
    required this.runHistoryRepository,
    required this.socialProofRepository,
  });

  final MockSocialProofDataStore store;
  final MockFavoriteRepository favoriteRepository;
  final MockWorkflowRunHistoryRepository runHistoryRepository;
  final MockWorkflowSocialProofRepository socialProofRepository;

  List<Override> get repositoryOverrides => [
        favoriteRepositoryProvider.overrideWithValue(favoriteRepository),
        workflowRunHistoryRepositoryProvider
            .overrideWithValue(runHistoryRepository),
        workflowSocialProofRepositoryProvider
            .overrideWithValue(socialProofRepository),
      ];
}

/// Workflow 詳細画面の Provider を Mock で上書きする。
List<Override> workflowDetailProviderOverrides({
  MockWorkflowTestFixtures? fixtures,
}) {
  final shared = fixtures ?? MockWorkflowTestFixtures();

  return [
    workflowOutcomeRepositoryProvider
        .overrideWithValue(MockWorkflowOutcomeRepository()),
    workflowStepToolOptionRepositoryProvider
        .overrideWithValue(MockWorkflowStepToolOptionRepository()),
    promptVariantRepositoryProvider
        .overrideWithValue(MockPromptVariantRepository()),
    aiToolAlternativeRepositoryProvider
        .overrideWithValue(MockAIToolAlternativeRepository()),
    ...shared.repositoryOverrides,
  ];
}
