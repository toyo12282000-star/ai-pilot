import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ai_pilot/features/advisor/data/dto/advisor_history_dto.dart';
import 'package:ai_pilot/features/advisor/domain/entities/advisor_history.dart';
import 'package:ai_pilot/features/advisor/domain/entities/advisor_session_save_input.dart';
import 'package:ai_pilot/features/advisor/domain/repositories/advisor_history_repository.dart';

/// [AdvisorHistoryRepository] の Supabase 実装。
class SupabaseAdvisorHistoryRepository implements AdvisorHistoryRepository {
  SupabaseAdvisorHistoryRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const _fetchLimit = 10;

  @override
  Future<List<AdvisorHistory>> fetchRecentHistories(String userId) async {
    final response = await _client
        .from('advisor_histories')
        .select(
          '*, advisor_session_suggestions(session_id, workflow_id, rank)',
        )
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(_fetchLimit);

    return (response as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(AdvisorHistoryDto.fromJson)
        .map((dto) => dto.toEntity())
        .toList();
  }

  @override
  Future<void> saveSession(AdvisorSessionSaveInput input) async {
    final inserted = await _client
        .from('advisor_histories')
        .insert({
          'user_id': input.userId,
          'query': input.query,
          'path': input.path,
          'selected_answers_json': input.selectedAnswers,
          'primary_workflow_id': input.primaryWorkflowId,
          'suggested_workflow_ids': input.suggestedWorkflowIds,
        })
        .select('id')
        .single();

    final sessionId = inserted['id'] as String;
    if (input.suggestedWorkflowIds.isEmpty) {
      return;
    }

    await _client.from('advisor_session_suggestions').insert([
      for (var i = 0; i < input.suggestedWorkflowIds.length; i++)
        {
          'session_id': sessionId,
          'workflow_id': input.suggestedWorkflowIds[i],
          'rank': i + 1,
        },
    ]);
  }

  @override
  Future<void> addHistory(
    String userId,
    String query,
    List<String> workflowIds,
  ) {
    return saveSession(
      AdvisorSessionSaveInput(
        userId: userId,
        query: query,
        selectedAnswers: const [],
        suggestedWorkflowIds: workflowIds,
      ),
    );
  }

  @override
  Future<void> deleteHistory(String userId, String historyId) async {
    await _client
        .from('advisor_histories')
        .delete()
        .eq('user_id', userId)
        .eq('id', historyId);
  }
}
