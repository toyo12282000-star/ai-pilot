import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ai_pilot/features/workflow/data/dto/workflow_outcome_dto.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_outcome.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/workflow_outcome_repository.dart';

/// [WorkflowOutcomeRepository] の Supabase 実装（読み取り専用）。
class SupabaseWorkflowOutcomeRepository implements WorkflowOutcomeRepository {
  SupabaseWorkflowOutcomeRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<List<WorkflowOutcome>> fetchOutcomesByWorkflowId(
    String workflowId,
  ) async {
    final response = await _client
        .from('workflow_outcomes')
        .select()
        .eq('workflow_id', workflowId)
        .order('sort_order', ascending: true);

    return (response as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(WorkflowOutcomeDto.fromJson)
        .map((dto) => dto.toEntity())
        .toList();
  }
}
