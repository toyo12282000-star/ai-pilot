import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ai_pilot/features/advisor/data/repositories/supabase_advisor_api_repository.dart';
import 'package:ai_pilot/features/advisor/domain/exceptions/advisor_api_exception.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';

void main() {
  test('maps 404 function exception to notDeployed', () async {
    final repository = SupabaseAdvisorApiRepository(
      invokeAdvisor: (_) async {
        throw const FunctionException(
          status: 404,
          details: 'Requested function was not found',
        );
      },
    );

    expect(
      () => repository.suggest(query: 'YouTube', workflows: mockWorkflows),
      throwsA(
        isA<AdvisorApiException>().having(
          (error) => error.code,
          'code',
          AdvisorApiFailureCode.notDeployed,
        ),
      ),
    );
  });

  test('maps invalid payload to invalidResponse', () async {
    final repository = SupabaseAdvisorApiRepository(
      invokeAdvisor: (_) async => FunctionResponse(
        status: 200,
        data: {'error': 'invalid payload'},
      ),
    );

    expect(
      () => repository.suggest(query: 'YouTube', workflows: mockWorkflows),
      throwsA(
        isA<AdvisorApiException>().having(
          (error) => error.code,
          'code',
          AdvisorApiFailureCode.invalidResponse,
        ),
      ),
    );
  });

  test('returns parsed response on success', () async {
    final repository = SupabaseAdvisorApiRepository(
      invokeAdvisor: (_) async => FunctionResponse(
        status: 200,
        data: {
          'recommendationIds': ['wf_youtube_short'],
          'reason': '入力内容に近いWorkflowとして選びました',
        },
      ),
    );

    final response = await repository.suggest(
      query: 'YouTube',
      workflows: mockWorkflows,
    );

    expect(response.recommendationIds, ['wf_youtube_short']);
    expect(response.reason, contains('Workflow'));
  });
}
