import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/features/workflow/data/repositories/supabase_workflow_showcase_repository.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_showcase.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/workflow_showcase_repository.dart';

// ---------------------------------------------------------------------------
// Repository Provider (Sprint 12.4)
// ---------------------------------------------------------------------------

final workflowShowcaseRepositoryProvider = Provider<WorkflowShowcaseRepository>(
  (ref) => SupabaseWorkflowShowcaseRepository(),
);

// ---------------------------------------------------------------------------
// AsyncValue Providers（UI 向け・次 Sprint で Home 表示に利用）
// ---------------------------------------------------------------------------

final featuredShowcasesProvider = FutureProvider<List<WorkflowShowcase>>((ref) {
  return ref.watch(workflowShowcaseRepositoryProvider).fetchFeaturedShowcases();
});

final workflowShowcasesProvider =
    FutureProvider.family<List<WorkflowShowcase>, String>((ref, workflowId) {
  return ref
      .watch(workflowShowcaseRepositoryProvider)
      .fetchByWorkflow(workflowId);
});
