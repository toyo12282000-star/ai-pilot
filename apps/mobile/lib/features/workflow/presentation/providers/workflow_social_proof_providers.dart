import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/features/workflow/data/repositories/supabase_workflow_social_proof_repository.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_product_stats.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_recent_creation.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_social_proof_counts.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/workflow_social_proof_repository.dart';
import 'package:ai_pilot/features/workflow/domain/services/workflow_product_stats_assembler.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';

/// [WorkflowSocialProofRepository] を提供する（Supabase 実装）。
final workflowSocialProofRepositoryProvider =
    Provider<WorkflowSocialProofRepository>((ref) {
  return SupabaseWorkflowSocialProofRepository();
});

/// Workflow の保存数 / 使用者数などを取得する。
final workflowSocialProofCountsProvider =
    FutureProvider.family<WorkflowSocialProofCounts, String>((ref, workflowId) {
  return ref.watch(workflowSocialProofRepositoryProvider).fetchStats(workflowId);
});

/// Workflow の最近作られた作品一覧を取得する。
final workflowRecentCreationsProvider =
    FutureProvider.family<List<WorkflowRecentCreation>, String>(
  (ref, workflowId) {
    return ref
        .watch(workflowSocialProofRepositoryProvider)
        .fetchRecentCreations(workflowId);
  },
);

/// Workflow 詳細の人気・メタ情報（Social Proof + Workflow メタ）。
final workflowProductStatsProvider =
    FutureProvider.family<WorkflowProductStats?, String>((ref, workflowId) async {
  final workflow = await ref.watch(workflowByIdProvider(workflowId).future);
  if (workflow == null) {
    return null;
  }

  final counts =
      await ref.watch(workflowSocialProofCountsProvider(workflowId).future);
  final categories = await ref.watch(categoriesProvider.future);
  final matchingCategories =
      categories.where((category) => category.id == workflow.categoryId);
  final category = matchingCategories.isEmpty ? null : matchingCategories.first;

  return WorkflowProductStatsAssembler.assemble(
    workflow: workflow,
    counts: counts,
    category: category,
  );
});

/// Social Proof 関連 Provider を再取得する。
void invalidateWorkflowSocialProof(WidgetRef ref, String workflowId) {
  ref.invalidate(workflowSocialProofCountsProvider(workflowId));
  ref.invalidate(workflowRecentCreationsProvider(workflowId));
  ref.invalidate(workflowProductStatsProvider(workflowId));
}
