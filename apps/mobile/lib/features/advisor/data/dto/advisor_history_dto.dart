import 'package:ai_pilot/features/advisor/domain/entities/advisor_session_suggestion.dart';
import 'package:ai_pilot/features/advisor/domain/entities/advisor_history.dart';
import 'package:ai_pilot/features/workflow/data/dto/json_helpers.dart';

/// Supabase `advisor_session_suggestions` 行の DTO。
class AdvisorSessionSuggestionDto {
  AdvisorSessionSuggestionDto({
    required this.sessionId,
    required this.workflowId,
    required this.rank,
  });

  factory AdvisorSessionSuggestionDto.fromJson(Map<String, dynamic> json) {
    return AdvisorSessionSuggestionDto(
      sessionId: json['session_id'] as String,
      workflowId: json['workflow_id'] as String,
      rank: json['rank'] as int,
    );
  }

  final String sessionId;
  final String workflowId;
  final int rank;

  AdvisorSessionSuggestion toEntity() {
    return AdvisorSessionSuggestion(
      sessionId: sessionId,
      workflowId: workflowId,
      rank: rank,
    );
  }
}

/// Supabase `advisor_histories` 行の DTO。
class AdvisorHistoryDto {
  AdvisorHistoryDto({
    required this.id,
    required this.userId,
    required this.query,
    required this.createdAt,
    this.path,
    this.selectedAnswers = const [],
    this.primaryWorkflowId,
    this.suggestedWorkflowIds = const [],
    this.suggestions = const [],
  });

  factory AdvisorHistoryDto.fromJson(Map<String, dynamic> json) {
    final nested = json['advisor_session_suggestions'];
    final suggestions = nested is List
        ? nested
            .cast<Map<String, dynamic>>()
            .map(AdvisorSessionSuggestionDto.fromJson)
            .toList()
        : <AdvisorSessionSuggestionDto>[];

    return AdvisorHistoryDto(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      query: json['query'] as String,
      path: json['path'] as String?,
      selectedAnswers: parseStringList(json['selected_answers_json']),
      primaryWorkflowId: json['primary_workflow_id'] as String?,
      suggestedWorkflowIds: parseStringList(json['suggested_workflow_ids']),
      suggestions: suggestions,
      createdAt: parseTimestamp(json['created_at']),
    );
  }

  final String id;
  final String userId;
  final String query;
  final String? path;
  final List<String> selectedAnswers;
  final String? primaryWorkflowId;
  final List<String> suggestedWorkflowIds;
  final List<AdvisorSessionSuggestionDto> suggestions;
  final DateTime createdAt;

  AdvisorHistory toEntity() {
    final resolvedSuggestions = suggestions.isNotEmpty
        ? suggestions.map((dto) => dto.toEntity()).toList()
        : null;

    return AdvisorHistory(
      id: id,
      userId: userId,
      query: query,
      path: path,
      selectedAnswers: selectedAnswers,
      primaryWorkflowId: primaryWorkflowId,
      suggestions: resolvedSuggestions ?? const [],
      suggestedWorkflowIds: resolvedSuggestions == null
          ? suggestedWorkflowIds
          : null,
      createdAt: createdAt,
    );
  }
}
