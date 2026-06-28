import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/features/workflow/data/repositories/mock_ai_tool_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_category_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_prompt_template_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_repository.dart';
import 'package:ai_pilot/features/workflow/domain/entities/ai_tool.dart';
import 'package:ai_pilot/features/workflow/domain/entities/category.dart';
import 'package:ai_pilot/features/workflow/domain/entities/prompt_template.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/ai_tool_repository.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/category_repository.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/prompt_template_repository.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/workflow_repository.dart';

// ---------------------------------------------------------------------------
// Repository Providers
// ---------------------------------------------------------------------------

/// [WorkflowRepository] を提供する（Mock 実装）。
final workflowRepositoryProvider = Provider<WorkflowRepository>((ref) {
  return MockWorkflowRepository();
});

/// [CategoryRepository] を提供する（Mock 実装）。
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return MockCategoryRepository();
});

/// [AIToolRepository] を提供する（Mock 実装）。
final aiToolRepositoryProvider = Provider<AIToolRepository>((ref) {
  return MockAIToolRepository();
});

/// [PromptTemplateRepository] を提供する（Mock 実装）。
final promptTemplateRepositoryProvider = Provider<PromptTemplateRepository>((ref) {
  return MockPromptTemplateRepository();
});

// ---------------------------------------------------------------------------
// AsyncValue Providers（UI 向け）
// ---------------------------------------------------------------------------

/// 全ワークフロー一覧。
final workflowsProvider = FutureProvider<List<Workflow>>((ref) {
  return ref.watch(workflowRepositoryProvider).fetchWorkflows();
});

/// 全カテゴリ一覧。
final categoriesProvider = FutureProvider<List<Category>>((ref) {
  return ref.watch(categoryRepositoryProvider).fetchCategories();
});

/// 全 AI ツール一覧。
final aiToolsProvider = FutureProvider<List<AITool>>((ref) {
  return ref.watch(aiToolRepositoryProvider).fetchAITools();
});

/// ID 指定で AI ツールを 1 件取得する。
final aiToolByIdProvider = FutureProvider.family<AITool?, String>(
  (ref, id) {
    return ref.watch(aiToolRepositoryProvider).fetchAIToolById(id);
  },
);

/// 全プロンプトテンプレート一覧。
final promptTemplatesProvider = FutureProvider<List<PromptTemplate>>((ref) {
  return ref.watch(promptTemplateRepositoryProvider).fetchPromptTemplates();
});

/// ID 指定でプロンプトテンプレートを 1 件取得する。
final promptTemplateByIdProvider = FutureProvider.family<PromptTemplate?, String>(
  (ref, id) {
    return ref.watch(promptTemplateRepositoryProvider).fetchPromptTemplateById(id);
  },
);

/// ID 指定でワークフローを 1 件取得する。
final workflowByIdProvider = FutureProvider.family<Workflow?, String>(
  (ref, id) {
    return ref.watch(workflowRepositoryProvider).fetchWorkflowById(id);
  },
);

/// カテゴリ ID でワークフロー一覧を取得する。
final workflowsByCategoryProvider = FutureProvider.family<List<Workflow>, String>(
  (ref, categoryId) {
    return ref
        .watch(workflowRepositoryProvider)
        .fetchWorkflowsByCategory(categoryId);
  },
);

/// キーワードでワークフローを検索する。
final searchWorkflowsProvider = FutureProvider.family<List<Workflow>, String>(
  (ref, query) {
    return ref.watch(workflowRepositoryProvider).searchWorkflows(query);
  },
);
