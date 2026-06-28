import 'package:ai_pilot/features/advisor/domain/entities/advisor_api_response.dart';
import 'package:ai_pilot/features/advisor/domain/repositories/advisor_api_repository.dart';
import 'package:ai_pilot/features/advisor/domain/services/workflow_advisor_service.dart';
import 'package:ai_pilot/features/recommendation/domain/entities/recommendation.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';
import 'package:ai_pilot/features/workflow/domain/entities/category.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';

/// [AdvisorApiRepository] の Mock 実装（Edge Function 代替）。
///
/// MVP では [WorkflowAdvisorService] のルールベース結果を
/// Edge Function と同じ `{ recommendationIds, reason }` 形式に変換する。
class MockAdvisorApiRepository implements AdvisorApiRepository {
  MockAdvisorApiRepository({
    WorkflowAdvisorService? advisorService,
    List<Recommendation>? recommendations,
    List<Category>? categories,
  })  : _advisorService = advisorService ?? WorkflowAdvisorService(),
        _recommendations = recommendations ?? const [],
        _categories = categories ?? const [];

  final WorkflowAdvisorService _advisorService;
  final List<Recommendation> _recommendations;
  final List<Category> _categories;

  @override
  Future<AdvisorApiResponse> suggest({
    required String query,
    required List<Workflow> workflows,
  }) async {
    await Future<void>.delayed(mockNetworkDelay);

    final suggestions = _advisorService.suggest(
      query: query,
      workflows: workflows,
      recommendations: _recommendations,
      categories: _categories,
    );

    if (suggestions.isEmpty) {
      return AdvisorApiResponse(
        recommendationIds: const [],
        reason: '近いWorkflowが見つかりませんでした',
      );
    }

    return AdvisorApiResponse(
      recommendationIds: suggestions.map((item) => item.workflow.id).toList(),
      reason: suggestions.first.reason,
    );
  }
}
