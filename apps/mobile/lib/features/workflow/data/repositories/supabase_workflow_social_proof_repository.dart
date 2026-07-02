import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ai_pilot/features/workflow/data/dto/workflow_recent_creation_dto.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_recent_creation.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_social_proof_counts.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/workflow_social_proof_repository.dart';

/// [WorkflowSocialProofRepository] の Supabase 実装。
class SupabaseWorkflowSocialProofRepository
    implements WorkflowSocialProofRepository {
  SupabaseWorkflowSocialProofRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<WorkflowSocialProofCounts> fetchStats(String workflowId) async {
    final response = await _client.rpc(
      'get_workflow_social_proof_counts',
      params: {'p_workflow_id': workflowId},
    );

    if (response == null) {
      return WorkflowSocialProofCounts.empty;
    }

    final row = _firstRow(response);
    if (row == null) {
      return WorkflowSocialProofCounts.empty;
    }

    return WorkflowSocialProofCounts(
      favoriteCount: _asInt(row['favorite_count']),
      startedUserCount: _asInt(row['started_user_count']),
      completedUserCount: _asInt(row['completed_user_count']),
    );
  }

  @override
  Future<List<WorkflowRecentCreation>> fetchRecentCreations(
    String workflowId, {
    int limit = 5,
  }) async {
    final response = await _client.rpc(
      'get_workflow_recent_creations',
      params: {
        'p_workflow_id': workflowId,
        'p_limit': limit,
      },
    );

    if (response == null) {
      return const [];
    }

    return (response as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(WorkflowRecentCreationDto.fromJson)
        .map((dto) => dto.toEntity())
        .toList();
  }

  Map<String, dynamic>? _firstRow(Object response) {
    if (response is Map<String, dynamic>) {
      return response;
    }
    if (response is List && response.isNotEmpty) {
      final first = response.first;
      if (first is Map<String, dynamic>) {
        return first;
      }
    }
    return null;
  }

  int _asInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return 0;
  }
}
