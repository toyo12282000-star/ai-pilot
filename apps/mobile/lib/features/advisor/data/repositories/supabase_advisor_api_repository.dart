import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ai_pilot/features/advisor/data/dto/advisor_api_response_dto.dart';
import 'package:ai_pilot/features/advisor/domain/entities/advisor_api_response.dart';
import 'package:ai_pilot/features/advisor/domain/repositories/advisor_api_repository.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';

/// [AdvisorApiRepository] の Supabase Edge Function 実装。
///
/// `supabase/functions/advisor` を呼び出す。
/// 将来 Edge Function 内で OpenAI Responses API に差し替える。
class SupabaseAdvisorApiRepository implements AdvisorApiRepository {
  SupabaseAdvisorApiRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const _functionName = 'advisor';

  @override
  Future<AdvisorApiResponse> suggest({
    required String query,
    required List<Workflow> workflows,
  }) async {
    final response = await _client.functions.invoke(
      _functionName,
      body: {
        'query': query,
        'workflows': workflows.map(_workflowToJson).toList(),
      },
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Advisor function returned invalid payload');
    }

    return AdvisorApiResponseDto.fromJson(data).toEntity();
  }

  Map<String, dynamic> _workflowToJson(Workflow workflow) {
    return {
      'id': workflow.id,
      'title': workflow.title,
      'description': workflow.description,
      'tags': workflow.tags,
      'categoryId': workflow.categoryId,
    };
  }
}
