import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ai_pilot/features/workflow/data/dto/prompt_variant_dto.dart';
import 'package:ai_pilot/features/workflow/domain/entities/prompt_variant.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/prompt_variant_repository.dart';

/// [PromptVariantRepository] の Supabase 実装（読み取り専用）。
class SupabasePromptVariantRepository implements PromptVariantRepository {
  SupabasePromptVariantRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<List<PromptVariant>> fetchPromptVariantsByStepId(
    String workflowStepId,
  ) async {
    final response = await _client
        .from('prompt_variants')
        .select()
        .eq('workflow_step_id', workflowStepId)
        .order('sort_order', ascending: true);

    return (response as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(PromptVariantDto.fromJson)
        .map((dto) => dto.toEntity())
        .toList();
  }
}
