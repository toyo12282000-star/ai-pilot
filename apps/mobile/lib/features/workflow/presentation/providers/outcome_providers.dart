import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/features/workflow/data/repositories/supabase_ai_tool_alternative_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/supabase_prompt_variant_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/supabase_workflow_outcome_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/supabase_workflow_step_tool_option_repository.dart';
import 'package:ai_pilot/features/workflow/domain/entities/ai_tool_alternative.dart';
import 'package:ai_pilot/features/workflow/domain/entities/prompt_variant.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_outcome.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_step_tool_option.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/ai_tool_alternative_repository.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/prompt_variant_repository.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/workflow_outcome_repository.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/workflow_step_tool_option_repository.dart';

// ---------------------------------------------------------------------------
// Repository Providers (Sprint 12.2)
// ---------------------------------------------------------------------------

final workflowOutcomeRepositoryProvider = Provider<WorkflowOutcomeRepository>(
  (ref) => SupabaseWorkflowOutcomeRepository(),
);

final workflowStepToolOptionRepositoryProvider =
    Provider<WorkflowStepToolOptionRepository>(
  (ref) => SupabaseWorkflowStepToolOptionRepository(),
);

final promptVariantRepositoryProvider = Provider<PromptVariantRepository>(
  (ref) => SupabasePromptVariantRepository(),
);

final aiToolAlternativeRepositoryProvider = Provider<AIToolAlternativeRepository>(
  (ref) => SupabaseAIToolAlternativeRepository(),
);

// ---------------------------------------------------------------------------
// AsyncValue Providers（UI 向け・Sprint 12.4 以降で利用）
// ---------------------------------------------------------------------------

final workflowOutcomesProvider =
    FutureProvider.family<List<WorkflowOutcome>, String>((ref, workflowId) {
  return ref
      .watch(workflowOutcomeRepositoryProvider)
      .fetchOutcomesByWorkflowId(workflowId);
});

final workflowStepToolOptionsProvider =
    FutureProvider.family<List<WorkflowStepToolOption>, String>(
  (ref, stepId) {
    return ref
        .watch(workflowStepToolOptionRepositoryProvider)
        .fetchToolOptionsByStepId(stepId);
  },
);

final promptVariantsProvider =
    FutureProvider.family<List<PromptVariant>, String>((ref, stepId) {
  return ref
      .watch(promptVariantRepositoryProvider)
      .fetchPromptVariantsByStepId(stepId);
});

final aiToolAlternativesProvider =
    FutureProvider.family<List<AIToolAlternative>, String>((ref, toolId) {
  return ref
      .watch(aiToolAlternativeRepositoryProvider)
      .fetchAlternativesByToolId(toolId);
});
