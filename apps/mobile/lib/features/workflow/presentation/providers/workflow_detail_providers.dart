import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/features/workflow/domain/entities/ai_tool.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_showcase.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/outcome_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/showcase_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';

/// Workflow 詳細で表示する AI ツールの集約情報。
class WorkflowAiToolEntry {
  const WorkflowAiToolEntry({
    required this.tool,
    this.pricingNote,
    this.recommendationReason,
    this.isRecommended = false,
    this.usedInStepOrders = const {},
  });

  final AITool tool;
  final String? pricingNote;
  final String? recommendationReason;
  final bool isRecommended;
  final Set<int> usedInStepOrders;

  WorkflowAiToolEntry merge(WorkflowAiToolEntry other) {
    return WorkflowAiToolEntry(
      tool: tool,
      pricingNote: pricingNote ?? other.pricingNote,
      recommendationReason: isRecommended
          ? recommendationReason
          : (other.isRecommended
              ? other.recommendationReason
              : recommendationReason ?? other.recommendationReason),
      isRecommended: isRecommended || other.isRecommended,
      usedInStepOrders: {...usedInStepOrders, ...other.usedInStepOrders},
    );
  }
}

/// Hero 表示用の代表 Showcase（featured 優先）。
final workflowPrimaryShowcaseProvider =
    FutureProvider.family<WorkflowShowcase?, String>((ref, workflowId) async {
  final showcases =
      await ref.watch(workflowShowcasesProvider(workflowId).future);
  if (showcases.isEmpty) {
    return null;
  }

  final featured = showcases.where((showcase) => showcase.isFeatured).toList()
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  if (featured.isNotEmpty) {
    return featured.first;
  }

  final sorted = List<WorkflowShowcase>.from(showcases)
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  return sorted.first;
});

/// Workflow 全体で使う AI ツール一覧（Step ツール候補から集約）。
final workflowAiToolsProvider =
    FutureProvider.family<List<WorkflowAiToolEntry>, String>(
  (ref, workflowId) async {
    final workflow = await ref.watch(workflowByIdProvider(workflowId).future);
    if (workflow == null) {
      return const [];
    }

    final aiTools = await ref.watch(aiToolsProvider.future);
    final toolsById = {for (final tool in aiTools) tool.id: tool};
    final entries = <String, WorkflowAiToolEntry>{};

    for (final step in workflow.steps) {
      final options =
          await ref.watch(workflowStepToolOptionsProvider(step.id).future);

      for (final option in options) {
        final tool = toolsById[option.aiToolId];
        if (tool == null) {
          continue;
        }

        final candidate = WorkflowAiToolEntry(
          tool: tool,
          pricingNote: option.pricingNote,
          recommendationReason: option.recommendationReason,
          isRecommended: option.isRecommended,
          usedInStepOrders: {step.order},
        );

        final existing = entries[option.aiToolId];
        entries[option.aiToolId] =
            existing == null ? candidate : existing.merge(candidate);
      }
    }

    final list = entries.values.toList()
      ..sort((a, b) {
        if (a.isRecommended != b.isRecommended) {
          return a.isRecommended ? -1 : 1;
        }
        return a.tool.name.compareTo(b.tool.name);
      });
    return list;
  },
);
