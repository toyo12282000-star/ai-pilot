import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/features/workflow/data/repositories/mock_ai_tool_alternative_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_prompt_variant_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_outcome_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_step_tool_option_repository.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/outcome_providers.dart';

/// Workflow 詳細画面の Provider を Mock で上書きする。
List<Override> workflowDetailProviderOverrides() {
  return [
    workflowOutcomeRepositoryProvider
        .overrideWithValue(MockWorkflowOutcomeRepository()),
    workflowStepToolOptionRepositoryProvider
        .overrideWithValue(MockWorkflowStepToolOptionRepository()),
    promptVariantRepositoryProvider
        .overrideWithValue(MockPromptVariantRepository()),
    aiToolAlternativeRepositoryProvider
        .overrideWithValue(MockAIToolAlternativeRepository()),
  ];
}
