import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ai_pilot/features/home/domain/entities/recent_workflow_activity.dart';
import 'package:ai_pilot/features/workflow/data/dto/workflow_run_history_dto.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_run_history.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/workflow_run_history_repository.dart';

/// [WorkflowRunHistoryRepository] の Supabase 実装。
class SupabaseWorkflowRunHistoryRepository
    implements WorkflowRunHistoryRepository {
  SupabaseWorkflowRunHistoryRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const _recentHistoryLimit = 10;
  static const _recentActivitiesLimit = 20;

  @override
  Future<List<RecentWorkflowActivity>> fetchRecentActivities(
    String userId, {
    int limit = 6,
  }) async {
    final response = await _client
        .from('workflow_run_histories')
        .select()
        .eq('user_id', userId)
        .order('updated_at', ascending: false)
        .limit(_recentActivitiesLimit);

    final histories = (response as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(WorkflowRunHistoryDto.fromJson)
        .map((dto) => dto.toEntity())
        .toList();

    return RecentWorkflowActivity.dedupeAndSort(histories, limit: limit);
  }

  @override
  Future<List<WorkflowRunHistory>> fetchRecentHistories(String userId) async {
    final response = await _client
        .from('workflow_run_histories')
        .select()
        .eq('user_id', userId)
        .order('updated_at', ascending: false)
        .limit(_recentHistoryLimit);

    return (response as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(WorkflowRunHistoryDto.fromJson)
        .map((dto) => dto.toEntity())
        .toList();
  }

  @override
  Future<WorkflowRunHistory?> fetchHistoryByWorkflow(
    String userId,
    String workflowId,
  ) async {
    final response = await _client
        .from('workflow_run_histories')
        .select()
        .eq('user_id', userId)
        .eq('workflow_id', workflowId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return WorkflowRunHistoryDto.fromJson(response).toEntity();
  }

  @override
  Future<WorkflowRunHistory> startWorkflow(
    String userId,
    String workflowId,
  ) async {
    final now = DateTime.now().toUtc().toIso8601String();
    final response = await _client
        .from('workflow_run_histories')
        .upsert(
          {
            'user_id': userId,
            'workflow_id': workflowId,
            'last_step_index': 0,
            'is_completed': false,
            'started_at': now,
            'completed_at': null,
          },
          onConflict: 'user_id,workflow_id',
        )
        .select()
        .single();

    return WorkflowRunHistoryDto.fromJson(response).toEntity();
  }

  @override
  Future<void> updateProgress(
    String userId,
    String workflowId,
    int stepIndex,
  ) async {
    await _client
        .from('workflow_run_histories')
        .update({'last_step_index': stepIndex})
        .eq('user_id', userId)
        .eq('workflow_id', workflowId);
  }

  @override
  Future<void> completeWorkflow(String userId, String workflowId) async {
    final now = DateTime.now().toUtc().toIso8601String();
    await _client
        .from('workflow_run_histories')
        .update({
          'is_completed': true,
          'completed_at': now,
        })
        .eq('user_id', userId)
        .eq('workflow_id', workflowId);
  }
}
