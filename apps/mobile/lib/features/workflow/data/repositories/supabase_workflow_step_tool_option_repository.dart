import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ai_pilot/features/workflow/data/dto/workflow_step_tool_option_dto.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_step_tool_option.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/workflow_step_tool_option_repository.dart';

/// [WorkflowStepToolOptionRepository] の Supabase 実装（読み取り専用）。
class SupabaseWorkflowStepToolOptionRepository
    implements WorkflowStepToolOptionRepository {
  SupabaseWorkflowStepToolOptionRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<List<WorkflowStepToolOption>> fetchToolOptionsByStepId(
    String workflowStepId,
  ) async {
    final response = await _client
        .from('workflow_step_tool_options')
        .select()
        .eq('workflow_step_id', workflowStepId)
        .order('sort_order', ascending: true);

    return (response as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(WorkflowStepToolOptionDto.fromJson)
        .map((dto) => dto.toEntity())
        .toList();
  }
}
