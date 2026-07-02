import 'dart:math' as math;

import 'package:ai_pilot/features/workflow/domain/entities/category.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_product_stats.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_social_proof_counts.dart';

/// Social Proof 集計値と Workflow メタを UI 向け stats に合成する。
abstract final class WorkflowProductStatsAssembler {
  static WorkflowProductStats assemble({
    required Workflow workflow,
    required WorkflowSocialProofCounts counts,
    Category? category,
  }) {
    return WorkflowProductStats(
      popularityScore: _derivePopularityScore(counts),
      saveCount: counts.favoriteCount,
      userCount: counts.startedUserCount,
      estimatedMinutes: workflow.estimatedMinutes ?? 45,
      difficultyLabel: _difficultyLabel(workflow),
      pricingLabel: '無料',
      category: category?.name ?? '完成作品',
    );
  }

  static double _derivePopularityScore(WorkflowSocialProofCounts counts) {
    if (counts.favoriteCount == 0 && counts.startedUserCount == 0) {
      return 4.0;
    }

    final signal = counts.favoriteCount + counts.startedUserCount;
    final normalized = math.log(signal + 1) / math.log(10000);
    return (3.5 + normalized.clamp(0.0, 1.0) * 1.5).clamp(3.5, 5.0);
  }

  static String _difficultyLabel(Workflow workflow) {
    final stepCount = workflow.steps.length;
    final minutes = workflow.estimatedMinutes ?? 0;

    if (stepCount <= 2 && minutes <= 40) {
      return '初心者';
    }
    if (stepCount <= 3 && minutes <= 60) {
      return '初級';
    }
    return '中級';
  }
}
