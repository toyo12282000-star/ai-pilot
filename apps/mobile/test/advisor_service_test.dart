import 'package:flutter_test/flutter_test.dart';

import 'package:ai_pilot/features/advisor/data/repositories/mock_advisor_api_repository.dart';
import 'package:ai_pilot/features/advisor/domain/services/advisor_service.dart';
import 'package:ai_pilot/features/recommendation/data/repositories/mock_recommendation_seed_data.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';

void main() {
  late AdvisorService service;

  setUp(() {
    service = AdvisorService(
      apiRepository: MockAdvisorApiRepository(
        recommendations: mockRecommendations,
        categories: mockCategories,
      ),
    );
  });

  test('YouTube query suggests youtube short workflow first', () async {
    final suggestions = await service.suggest(
      query: 'YouTubeを始めたい',
      workflows: mockWorkflows,
      categories: mockCategories,
    );

    expect(suggestions, isNotEmpty);
    expect(suggestions.first.workflow.id, 'wf_youtube_short');
    expect(suggestions.first.reason, contains('YouTube'));
  });

  test('Instagram query suggests SNS workflow', () async {
    final suggestions = await service.suggest(
      query: 'Instagram運用したい',
      workflows: mockWorkflows,
      categories: mockCategories,
    );

    expect(suggestions, isNotEmpty);
    expect(suggestions.first.workflow.id, 'wf_sns');
  });

  test('Document query suggests research workflow', () async {
    final suggestions = await service.suggest(
      query: '営業資料を作りたい',
      workflows: mockWorkflows,
      categories: mockCategories,
    );

    expect(suggestions, isNotEmpty);
    expect(
      suggestions.map((item) => item.workflow.id),
      contains('wf_research'),
    );
  });

  test('Empty query returns no suggestions', () async {
    final suggestions = await service.suggest(
      query: '   ',
      workflows: mockWorkflows,
      categories: mockCategories,
    );

    expect(suggestions, isEmpty);
  });

  test('Returns at most three suggestions', () async {
    final suggestions = await service.suggest(
      query: 'AI',
      workflows: mockWorkflows,
      categories: mockCategories,
      limit: 3,
    );

    expect(suggestions.length, lessThanOrEqualTo(3));
  });
}
