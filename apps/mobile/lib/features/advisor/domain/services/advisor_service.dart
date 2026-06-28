import 'package:ai_pilot/features/advisor/domain/entities/advisor_api_response.dart';
import 'package:ai_pilot/features/advisor/domain/entities/advisor_suggestion.dart';
import 'package:ai_pilot/features/advisor/domain/repositories/advisor_api_repository.dart';
import 'package:ai_pilot/features/workflow/domain/entities/category.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';

/// Advisor 推薦のオーケストレーション。
///
/// [AdvisorApiRepository] 経由で Edge Function（将来 OpenAI Responses API）を呼び出し、
/// 返却された Workflow ID を [AdvisorSuggestion] に変換する。
class AdvisorService {
  AdvisorService({required this._apiRepository});

  final AdvisorApiRepository _apiRepository;

  /// 入力 [query] に近い Workflow を最大 [limit] 件返す。
  Future<List<AdvisorSuggestion>> suggest({
    required String query,
    required List<Workflow> workflows,
    required List<Category> categories,
    int limit = 3,
  }) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      return const [];
    }

    // TODO(Sprint 12+): Edge Function が OpenAI Responses API を呼ぶようになったら、
    // このメソッドの呼び出し先は SupabaseAdvisorApiRepository のまま。
    // Flutter 側の変更は DTO / 理由文のパース拡張のみで済む想定。
    final AdvisorApiResponse apiResponse = await _apiRepository.suggest(
      query: trimmedQuery,
      workflows: workflows,
    );

    if (apiResponse.recommendationIds.isEmpty) {
      return const [];
    }

    final workflowById = {for (final workflow in workflows) workflow.id: workflow};
    final suggestions = <AdvisorSuggestion>[];
    var score = apiResponse.recommendationIds.length;

    for (final workflowId in apiResponse.recommendationIds.take(limit)) {
      final workflow = workflowById[workflowId];
      if (workflow == null) {
        continue;
      }

      suggestions.add(
        AdvisorSuggestion(
          workflow: workflow,
          reason: apiResponse.reason,
          difficulty: _difficultyLabel(workflow),
          score: score,
        ),
      );
      score--;
    }

    return suggestions;
  }

  String _difficultyLabel(Workflow workflow) {
    final stepCount = workflow.steps.length;
    final minutes = workflow.estimatedMinutes ?? 0;

    if (stepCount <= 2 && minutes <= 40) {
      return 'かんたん';
    }
    if (stepCount <= 3 && minutes <= 60) {
      return 'ふつう';
    }
    return 'ステップ多め';
  }
}
