import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ai_pilot/features/workflow/data/dto/ai_tool_alternative_dto.dart';
import 'package:ai_pilot/features/workflow/domain/entities/ai_tool_alternative.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/ai_tool_alternative_repository.dart';

/// [AIToolAlternativeRepository] の Supabase 実装（読み取り専用）。
class SupabaseAIToolAlternativeRepository implements AIToolAlternativeRepository {
  SupabaseAIToolAlternativeRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<List<AIToolAlternative>> fetchAlternativesByToolId(
    String aiToolId,
  ) async {
    final response = await _client
        .from('ai_tool_alternatives')
        .select()
        .eq('ai_tool_id', aiToolId)
        .order('sort_order', ascending: true);

    return (response as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(AIToolAlternativeDto.fromJson)
        .map((dto) => dto.toEntity())
        .toList();
  }
}
