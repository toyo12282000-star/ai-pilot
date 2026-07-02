import 'package:flutter_test/flutter_test.dart';

import 'package:ai_pilot/features/workflow/domain/services/workflow_activity_time_formatter.dart';
import 'helpers/workflow_detail_overrides.dart';

void main() {
  late MockWorkflowTestFixtures fixtures;
  final seedNow = DateTime(2026, 6, 28, 12);

  setUp(() {
    fixtures = MockWorkflowTestFixtures(seedNow: seedNow);
  });

  test('fetchStats returns favorite and started user counts', () async {
    final repository = fixtures.socialProofRepository;
    final stats = await repository.fetchStats('wf_youtube_short');

    expect(stats.favoriteCount, 9);
    expect(stats.startedUserCount, 4);
    expect(stats.completedUserCount, 3);
  });

  test('fetchStats returns empty counts for unknown workflow', () async {
    final stats = await fixtures.socialProofRepository.fetchStats('wf_unknown');

    expect(stats.favoriteCount, 0);
    expect(stats.startedUserCount, 0);
    expect(stats.completedUserCount, 0);
  });

  test('fetchRecentCreations returns newest activities first', () async {
    final creations = await fixtures.socialProofRepository.fetchRecentCreations(
      'wf_youtube_short',
      limit: 3,
    );

    expect(creations, hasLength(3));
    expect(creations.first.displayName, 'ゆうき');
    expect(
      WorkflowActivityTimeFormatter.format(
        creations.first.activityAt,
        now: seedNow,
      ),
      '今日作成',
    );
    expect(creations[1].displayName, 'みさき');
  });

  test('fetchRecentCreations returns empty list for unknown workflow', () async {
    final creations =
        await fixtures.socialProofRepository.fetchRecentCreations('wf_unknown');

    expect(creations, isEmpty);
  });

  test('fetchStats works for sns and blog workflows', () async {
    final snsStats = await fixtures.socialProofRepository.fetchStats('wf_sns');
    final blogStats =
        await fixtures.socialProofRepository.fetchStats('wf_blog');

    expect(snsStats.favoriteCount, 6);
    expect(snsStats.startedUserCount, 3);
    expect(blogStats.favoriteCount, 5);
    expect(blogStats.startedUserCount, 3);
  });
}
