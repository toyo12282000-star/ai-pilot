import 'package:flutter_test/flutter_test.dart';

import 'package:ai_pilot/features/advisor/data/repositories/mock_advisor_api_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';

void main() {
  late MockAdvisorApiRepository repository;

  setUp(() {
    repository = MockAdvisorApiRepository();
  });

  test('returns recommendationIds and reason for matching query', () async {
    final response = await repository.suggest(
      query: 'YouTubeを始めたい',
      workflows: mockWorkflows,
    );

    expect(response.recommendationIds, isNotEmpty);
    expect(response.recommendationIds.first, 'wf_youtube_short');
    expect(response.reason, isNotEmpty);
  });

  test('returns empty recommendationIds for blank query', () async {
    final response = await repository.suggest(
      query: '   ',
      workflows: mockWorkflows,
    );

    expect(response.recommendationIds, isEmpty);
    expect(response.reason, contains('見つかりません'));
  });
}
