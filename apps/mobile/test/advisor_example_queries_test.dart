import 'package:flutter_test/flutter_test.dart';

import 'package:ai_pilot/features/advisor/data/repositories/mock_advisor_api_repository.dart';
import 'package:ai_pilot/features/advisor/domain/entities/advisor_api_response.dart';
import 'package:ai_pilot/features/advisor/domain/repositories/advisor_api_repository.dart';
import 'package:ai_pilot/features/advisor/domain/services/advisor_example_query_resolver.dart';
import 'package:ai_pilot/features/advisor/domain/services/advisor_service.dart';
import 'package:ai_pilot/features/advisor/domain/services/workflow_advisor_service.dart';
import 'package:ai_pilot/features/recommendation/data/repositories/mock_recommendation_seed_data.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';

/// Supabase seed の UUID 対応表（002_seed_initial_data.sql）。
const supabaseWorkflowUuidByMockId = {
  'wf_youtube_short': '40000000-0000-4000-8000-000000000001',
  'wf_blog': '40000000-0000-4000-8000-000000000002',
  'wf_sns': '40000000-0000-4000-8000-000000000003',
  'wf_research': '40000000-0000-4000-8000-000000000004',
  'wf_flutter_app': '40000000-0000-4000-8000-000000000005',
};

List<Workflow> toSupabaseUuidWorkflows(List<Workflow> workflows) {
  return workflows
      .map(
        (workflow) => workflow.copyWith(
          id: supabaseWorkflowUuidByMockId[workflow.id] ?? workflow.id,
        ),
      )
      .toList();
}

class _FixedEdgeAdvisorApiRepository implements AdvisorApiRepository {
  _FixedEdgeAdvisorApiRepository(this._response);

  final AdvisorApiResponse _response;

  @override
  Future<AdvisorApiResponse> suggest({
    required String query,
    required List<Workflow> workflows,
  }) async {
    return _response;
  }
}

void main() {
  group('AdvisorExampleQueryResolver', () {
    test('all six example queries resolve at least one workflow', () {
      for (final query in AdvisorExampleQueryResolver.exampleQueries) {
        final resolved = AdvisorExampleQueryResolver.resolveWorkflows(
          query: query,
          workflows: mockWorkflows,
        );

        expect(
          resolved,
          isNotEmpty,
          reason: 'Example query "$query" should match a workflow',
        );
      }
    });

    test('資料を作りたい resolves 調査レポートを作る', () {
      final resolved = AdvisorExampleQueryResolver.resolveWorkflows(
        query: '資料を作りたい',
        workflows: mockWorkflows,
      );

      expect(resolved, isNotEmpty);
      expect(resolved.first.title, '調査レポートを作る');
    });

    test('works with Supabase UUID workflow ids', () {
      final uuidWorkflows = toSupabaseUuidWorkflows(mockWorkflows);

      final resolved = AdvisorExampleQueryResolver.resolveWorkflows(
        query: '資料を作りたい',
        workflows: uuidWorkflows,
      );

      expect(resolved, isNotEmpty);
      expect(resolved.first.id, '40000000-0000-4000-8000-000000000004');
      expect(resolved.first.title, '調査レポートを作る');
    });
  });

  group('Mock advisor path (USE_ADVISOR_EDGE_FUNCTION=false equivalent)', () {
    late AdvisorService service;

    setUp(() {
      service = AdvisorService(
        apiRepository: MockAdvisorApiRepository(
          recommendations: mockRecommendations,
          categories: mockCategories,
        ),
      );
    });

    test('all six example queries return suggestions', () async {
      for (final query in AdvisorExampleQueryResolver.exampleQueries) {
        final suggestions = await service.suggest(
          query: query,
          workflows: mockWorkflows,
          categories: mockCategories,
        );

        expect(
          suggestions,
          isNotEmpty,
          reason: 'Mock path should suggest for "$query"',
        );
      }
    });

    test('資料を作りたい includes 調査レポートを作る', () async {
      final suggestions = await service.suggest(
        query: '資料を作りたい',
        workflows: mockWorkflows,
        categories: mockCategories,
      );

      expect(
        suggestions.map((item) => item.workflow.title),
        contains('調査レポートを作る'),
      );
    });
  });

  group('Edge advisor path (USE_ADVISOR_EDGE_FUNCTION=true equivalent)', () {
    test('UUID ids from edge response hydrate correctly', () async {
      final uuidWorkflows = toSupabaseUuidWorkflows(mockWorkflows);
      final service = AdvisorService(
        apiRepository: _FixedEdgeAdvisorApiRepository(
          AdvisorApiResponse(
            recommendationIds: const [
              '40000000-0000-4000-8000-000000000004',
            ],
            reason: 'Edge mock',
          ),
        ),
      );

      final suggestions = await service.suggest(
        query: '資料を作りたい',
        workflows: uuidWorkflows,
        categories: mockCategories,
      );

      expect(suggestions, isNotEmpty);
      expect(suggestions.first.workflow.title, '調査レポートを作る');
    });

    test('legacy mock ids from edge fall back to local advisor', () async {
      final uuidWorkflows = toSupabaseUuidWorkflows(mockWorkflows);
      final service = AdvisorService(
        apiRepository: _FixedEdgeAdvisorApiRepository(
          AdvisorApiResponse(
            recommendationIds: const ['wf_research'],
            reason: 'legacy edge ids',
          ),
        ),
        fallbackApiRepository: MockAdvisorApiRepository(
          recommendations: const [],
          categories: mockCategories,
        ),
      );

      final suggestions = await service.suggest(
        query: '資料を作りたい',
        workflows: uuidWorkflows,
        categories: mockCategories,
      );

      expect(suggestions, isNotEmpty);
      expect(suggestions.first.workflow.title, '調査レポートを作る');
    });

    test('empty edge response falls back for example queries', () async {
      final uuidWorkflows = toSupabaseUuidWorkflows(mockWorkflows);
      final service = AdvisorService(
        apiRepository: _FixedEdgeAdvisorApiRepository(
          AdvisorApiResponse(
            recommendationIds: const [],
            reason: 'no match',
          ),
        ),
        fallbackApiRepository: MockAdvisorApiRepository(
          recommendations: const [],
          categories: mockCategories,
        ),
      );

      final suggestions = await service.suggest(
        query: '資料を作りたい',
        workflows: uuidWorkflows,
        categories: mockCategories,
      );

      expect(suggestions, isNotEmpty);
      expect(suggestions.first.workflow.title, '調査レポートを作る');
    });
  });

  group('Non-example queries', () {
    test('random query returns empty when nothing matches', () {
      final suggestions = WorkflowAdvisorService().suggest(
        query: 'zzzznomatchquery',
        workflows: mockWorkflows,
        recommendations: const [],
        categories: mockCategories,
      );

      expect(suggestions, isEmpty);
    });
  });
}
