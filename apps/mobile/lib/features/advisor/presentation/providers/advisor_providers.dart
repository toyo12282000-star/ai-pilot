import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/features/advisor/data/repositories/mock_advisor_api_repository.dart';
import 'package:ai_pilot/features/advisor/data/repositories/supabase_advisor_api_repository.dart';
import 'package:ai_pilot/features/advisor/domain/repositories/advisor_api_repository.dart';
import 'package:ai_pilot/features/advisor/domain/services/advisor_service.dart';
import 'package:ai_pilot/features/advisor/domain/services/workflow_advisor_service.dart';
import 'package:ai_pilot/features/recommendation/presentation/providers/recommendation_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';
import 'package:ai_pilot/shared/config/advisor_config.dart';

/// ルールベース Mock Repository（Edge 未使用時 / フォールバック用）。
final mockAdvisorApiRepositoryProvider = Provider<MockAdvisorApiRepository>((ref) {
  final recommendations = ref.watch(recommendationsProvider).valueOrNull ?? [];
  final categories = ref.watch(categoriesProvider).valueOrNull ?? [];

  return MockAdvisorApiRepository(
    recommendations: recommendations,
    categories: categories,
  );
});

/// Advisor API（Edge Function）Repository。
///
/// `.env` の `USE_ADVISOR_EDGE_FUNCTION=true` で [SupabaseAdvisorApiRepository]。
/// デフォルトは [MockAdvisorApiRepository]。
final advisorApiRepositoryProvider = Provider<AdvisorApiRepository>((ref) {
  if (AdvisorConfig.useEdgeFunction) {
    return SupabaseAdvisorApiRepository();
  }
  return ref.watch(mockAdvisorApiRepositoryProvider);
});

/// Workflow 推薦ロジック（Repository 経由）。
final advisorServiceProvider = Provider<AdvisorService>((ref) {
  final mockRepository = ref.watch(mockAdvisorApiRepositoryProvider);

  if (AdvisorConfig.useEdgeFunction) {
    return AdvisorService(
      apiRepository: ref.watch(advisorApiRepositoryProvider),
      // Edge Function 失敗時はルールベース Mock へフォールバック。
      fallbackApiRepository: mockRepository,
    );
  }

  return AdvisorService(apiRepository: mockRepository);
});

/// ルールベース推薦（Mock Repository 内部 / 単体テスト用）。
final workflowAdvisorServiceProvider = Provider<WorkflowAdvisorService>(
  (ref) => WorkflowAdvisorService(),
);
