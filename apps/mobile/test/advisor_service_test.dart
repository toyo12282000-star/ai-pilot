import 'package:flutter_test/flutter_test.dart';

import 'package:ai_pilot/features/advisor/domain/services/workflow_advisor_service.dart';
import 'package:ai_pilot/features/recommendation/data/repositories/mock_recommendation_seed_data.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';

void main() {
  late WorkflowAdvisorService service;

  setUp(() {
    service = WorkflowAdvisorService();
  });

  test('YouTube query suggests youtube short workflow first', () {
    final suggestions = service.suggest(
      query: 'YouTubeを始めたい',
      workflows: mockWorkflows,
      recommendations: mockRecommendations,
      categories: mockCategories,
    );

    expect(suggestions, isNotEmpty);
    expect(suggestions.first.workflow.id, 'wf_youtube_short');
    expect(suggestions.first.reason, contains('YouTube'));
  });

  test('Instagram query suggests SNS workflow', () {
    final suggestions = service.suggest(
      query: 'Instagram運用したい',
      workflows: mockWorkflows,
      recommendations: mockRecommendations,
      categories: mockCategories,
    );

    expect(suggestions, isNotEmpty);
    expect(suggestions.first.workflow.id, 'wf_sns');
  });

  test('Document query suggests research workflow', () {
    final suggestions = service.suggest(
      query: '営業資料を作りたい',
      workflows: mockWorkflows,
      recommendations: mockRecommendations,
      categories: mockCategories,
    );

    expect(suggestions, isNotEmpty);
    expect(
      suggestions.map((item) => item.workflow.id),
      contains('wf_research'),
    );
  });

  test('Empty query returns no suggestions', () {
    final suggestions = service.suggest(
      query: '   ',
      workflows: mockWorkflows,
      recommendations: mockRecommendations,
      categories: mockCategories,
    );

    expect(suggestions, isEmpty);
  });

  test('Returns at most three suggestions', () {
    final suggestions = service.suggest(
      query: 'AI',
      workflows: mockWorkflows,
      recommendations: mockRecommendations,
      categories: mockCategories,
      limit: 3,
    );

    expect(suggestions.length, lessThanOrEqualTo(3));
  });
}
