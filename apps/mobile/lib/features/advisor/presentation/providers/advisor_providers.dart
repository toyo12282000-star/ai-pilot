import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/features/advisor/data/repositories/mock_advisor_api_repository.dart';
import 'package:ai_pilot/features/advisor/data/repositories/supabase_advisor_api_repository.dart';
import 'package:ai_pilot/features/advisor/domain/repositories/advisor_api_repository.dart';
import 'package:ai_pilot/features/advisor/domain/services/advisor_service.dart';
import 'package:ai_pilot/features/advisor/domain/services/workflow_advisor_service.dart';
import 'package:ai_pilot/features/recommendation/presentation/providers/recommendation_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';

/// Advisor API（Edge Function）Repository。
///
/// Edge Function 未デプロイ時は Mock（ルールベース）を使用。
/// デプロイ後は [SupabaseAdvisorApiRepository] に切り替える。
final advisorApiRepositoryProvider = Provider<AdvisorApiRepository>((ref) {
  final recommendations = ref.watch(recommendationsProvider).valueOrNull ?? [];
  final categories = ref.watch(categoriesProvider).valueOrNull ?? [];

  return MockAdvisorApiRepository(
    recommendations: recommendations,
    categories: categories,
  );
  // 本番切替例:
  // return SupabaseAdvisorApiRepository();
});

/// Workflow 推薦ロジック（Repository 経由）。
final advisorServiceProvider = Provider<AdvisorService>(
  (ref) => AdvisorService(
    apiRepository: ref.watch(advisorApiRepositoryProvider),
  ),
);

/// ルールベース推薦（Mock Repository 内部 / 単体テスト用）。
final workflowAdvisorServiceProvider = Provider<WorkflowAdvisorService>(
  (ref) => WorkflowAdvisorService(),
);
