import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ai_pilot/features/workflow/data/dto/ai_tool_dto.dart';
import 'package:ai_pilot/features/workflow/domain/entities/ai_tool.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/ai_tool_repository.dart';

/// [AIToolRepository] の Supabase 実装。
class SupabaseAIToolRepository implements AIToolRepository {
  SupabaseAIToolRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<List<AITool>> fetchAITools() async {
    final response =
        await _client.from('ai_tools').select().order('name', ascending: true);

    return (response as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(AIToolDto.fromJson)
        .map((dto) => dto.toEntity())
        .toList();
  }

  @override
  Future<AITool?> fetchAIToolById(String id) async {
    final response =
        await _client.from('ai_tools').select().eq('id', id).maybeSingle();

    if (response == null) {
      return null;
    }

    return AIToolDto.fromJson(response).toEntity();
  }
}
