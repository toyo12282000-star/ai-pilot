import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ai_pilot/features/workflow/data/dto/workflow_showcase_dto.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_showcase.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/workflow_showcase_repository.dart';

/// [WorkflowShowcaseRepository] の Supabase 実装（読み取り専用）。
class SupabaseWorkflowShowcaseRepository implements WorkflowShowcaseRepository {
  SupabaseWorkflowShowcaseRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const _selectWithRelations =
      '*, showcase_tags(*), showcase_assets(*)';

  @override
  Future<List<WorkflowShowcase>> fetchShowcases() async {
    final response = await _client
        .from('workflow_showcases')
        .select(_selectWithRelations)
        .order('sort_order', ascending: true);

    return _mapResponse(response);
  }

  @override
  Future<List<WorkflowShowcase>> fetchFeaturedShowcases() async {
    final response = await _client
        .from('workflow_showcases')
        .select(_selectWithRelations)
        .eq('is_featured', true)
        .order('sort_order', ascending: true);

    return _mapResponse(response);
  }

  @override
  Future<List<WorkflowShowcase>> fetchByWorkflow(String workflowId) async {
    final response = await _client
        .from('workflow_showcases')
        .select(_selectWithRelations)
        .eq('workflow_id', workflowId)
        .order('sort_order', ascending: true);

    return _mapResponse(response);
  }

  List<WorkflowShowcase> _mapResponse(Object? response) {
    return (response as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(WorkflowShowcaseDto.fromJson)
        .map((dto) => dto.toEntity())
        .toList();
  }
}
