import 'package:flutter_test/flutter_test.dart';

import 'package:ai_pilot/features/advisor/data/repositories/mock_advisor_history_repository.dart';

void main() {
  late MockAdvisorHistoryRepository repository;

  setUp(() {
    repository = MockAdvisorHistoryRepository();
  });

  test('fetchRecentHistories returns histories for user', () async {
    final histories = await repository.fetchRecentHistories('user-1');

    expect(histories, isNotEmpty);
    expect(histories.first.query, 'YouTubeを始めたい');
  });

  test('addHistory inserts at top of user histories', () async {
    await repository.addHistory('user-1', 'ブログを書きたい', ['wf_blog']);

    final histories = await repository.fetchRecentHistories('user-1');

    expect(histories.first.query, 'ブログを書きたい');
    expect(histories.first.suggestedWorkflowIds, ['wf_blog']);
  });

  test('deleteHistory removes item for user', () async {
    final before = await repository.fetchRecentHistories('user-1');
    final targetId = before.first.id;

    await repository.deleteHistory('user-1', targetId);

    final after = await repository.fetchRecentHistories('user-1');
    expect(after.any((history) => history.id == targetId), isFalse);
  });
}
