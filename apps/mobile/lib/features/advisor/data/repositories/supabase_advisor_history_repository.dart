import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ai_pilot/features/advisor/data/dto/advisor_history_dto.dart';
import 'package:ai_pilot/features/advisor/domain/entities/advisor_history.dart';
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
        .select()
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
  Future<void> addHistory(
    String userId,
    String query,
    List<String> workflowIds,
  ) async {
    await _client.from('advisor_histories').insert({
      'user_id': userId,
      'query': query,
      'suggested_workflow_ids': workflowIds,
    });
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
