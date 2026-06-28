import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ai_pilot/features/workflow/data/dto/prompt_template_dto.dart';
import 'package:ai_pilot/features/workflow/domain/entities/prompt_template.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/prompt_template_repository.dart';

/// [PromptTemplateRepository] の Supabase 実装。
class SupabasePromptTemplateRepository implements PromptTemplateRepository {
  SupabasePromptTemplateRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<List<PromptTemplate>> fetchPromptTemplates() async {
    final response = await _client.from('prompt_templates').select();

    return (response as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(PromptTemplateDto.fromJson)
        .map((dto) => dto.toEntity())
        .toList();
  }

  @override
  Future<PromptTemplate?> fetchPromptTemplateById(String id) async {
    final response = await _client
        .from('prompt_templates')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return PromptTemplateDto.fromJson(response).toEntity();
  }
}
