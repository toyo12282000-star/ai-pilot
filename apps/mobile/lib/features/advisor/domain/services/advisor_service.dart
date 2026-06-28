import 'package:flutter/foundation.dart' show debugPrint;

import 'package:ai_pilot/features/advisor/domain/entities/advisor_api_response.dart';
import 'package:ai_pilot/features/advisor/domain/entities/advisor_suggestion.dart';
import 'package:ai_pilot/features/advisor/domain/exceptions/advisor_api_exception.dart';
import 'package:ai_pilot/features/advisor/domain/repositories/advisor_api_repository.dart';
import 'package:ai_pilot/features/advisor/domain/services/advisor_example_query_resolver.dart';
import 'package:ai_pilot/features/workflow/domain/entities/category.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';

/// Advisor 推薦のオーケストレーション。
///
/// [AdvisorApiRepository] 経由で Edge Function（将来 OpenAI Responses API）を呼び出し、
/// 返却された Workflow ID を [AdvisorSuggestion] に変換する。
class AdvisorService {
  AdvisorService({
    required this._apiRepository,
    this._fallbackApiRepository,
  });

  final AdvisorApiRepository _apiRepository;
  final AdvisorApiRepository? _fallbackApiRepository;

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

    if (workflows.isEmpty) {
      debugPrint('[AdvisorService] workflows list is empty; cannot suggest.');
      return const [];
    }

    // TODO(Sprint 12+): Edge Function が OpenAI Responses API を呼ぶようになったら、
    // このメソッドの呼び出し先は SupabaseAdvisorApiRepository のまま。
    // Flutter 側の変更は DTO / 理由文のパース拡張のみで済む想定。
    final AdvisorApiResponse apiResponse = await _requestSuggestions(
      query: trimmedQuery,
      workflows: workflows,
    );

    var suggestions = _buildSuggestionsFromApiResponse(
      apiResponse: apiResponse,
      workflows: workflows,
      limit: limit,
    );

    if (suggestions.isEmpty && _shouldTryFallbackRepository) {
      debugPrint(
        '[AdvisorService] API returned no resolvable workflow IDs '
        '(ids=${apiResponse.recommendationIds}). '
        'Falling back to local rule-based advisor.',
      );
      final fallbackResponse = await _fallbackApiRepository!.suggest(
        query: trimmedQuery,
        workflows: workflows,
      );
      suggestions = _buildSuggestionsFromApiResponse(
        apiResponse: fallbackResponse,
        workflows: workflows,
        limit: limit,
      );
    }

    if (suggestions.isEmpty &&
        AdvisorExampleQueryResolver.isExampleQuery(trimmedQuery)) {
      debugPrint(
        '[AdvisorService] Applying example-query resolver for "$trimmedQuery".',
      );
      suggestions = AdvisorExampleQueryResolver.buildSuggestions(
        query: trimmedQuery,
        workflows: workflows,
        difficultyLabel: _difficultyLabel,
        limit: limit,
      );
    }

    return suggestions;
  }

  bool get _shouldTryFallbackRepository {
    final fallback = _fallbackApiRepository;
    return fallback != null && !identical(fallback, _apiRepository);
  }

  List<AdvisorSuggestion> _buildSuggestionsFromApiResponse({
    required AdvisorApiResponse apiResponse,
    required List<Workflow> workflows,
    required int limit,
  }) {
    if (apiResponse.recommendationIds.isEmpty) {
      return const [];
    }

    final workflowById = {for (final workflow in workflows) workflow.id: workflow};
    final suggestions = <AdvisorSuggestion>[];
    var score = apiResponse.recommendationIds.length;

    for (final workflowId in apiResponse.recommendationIds.take(limit)) {
      final workflow = workflowById[workflowId];
      if (workflow == null) {
        debugPrint(
          '[AdvisorService] Skipping unknown workflow id from API: $workflowId',
        );
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

  Future<AdvisorApiResponse> _requestSuggestions({
    required String query,
    required List<Workflow> workflows,
  }) async {
    try {
      return await _apiRepository.suggest(query: query, workflows: workflows);
    } on AdvisorApiException catch (error) {
      final fallback = _fallbackApiRepository;
      if (fallback == null) {
        rethrow;
      }

      // Edge Function 失敗時はルールベース Mock へフォールバック（UI は継続）。
      debugPrint(
        '[AdvisorService] Edge Function failed '
        '(${error.code.name}): ${error.message}. '
        'Falling back to local rule-based advisor.',
      );

      return fallback.suggest(query: query, workflows: workflows);
    }
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
