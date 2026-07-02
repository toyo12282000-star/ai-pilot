import 'package:flutter_test/flutter_test.dart';

import 'package:ai_pilot/features/advisor/data/repositories/mock_advisor_history_repository.dart';
import 'package:ai_pilot/features/advisor/domain/entities/advisor_session_save_input.dart';

void main() {
  late MockAdvisorHistoryRepository repository;

  setUp(() {
    repository = MockAdvisorHistoryRepository();
  });

  test('fetchRecentHistories returns histories for user', () async {
    final histories = await repository.fetchRecentHistories('user-1');

    expect(histories, isNotEmpty);
    expect(histories.first.query, 'YouTubeを始めたい');
    expect(histories.first.path, 'youtube');
    expect(histories.first.primaryWorkflowId, 'wf_youtube_short');
  });

  test('saveSession inserts at top of user histories', () async {
    await repository.saveSession(
      const AdvisorSessionSaveInput(
        userId: 'user-1',
        query: 'ブログを書きたい',
        path: 'blog',
        selectedAnswers: ['ブログ記事を書きたい', 'SEO'],
        suggestedWorkflowIds: ['wf_blog'],
      ),
    );

    final histories = await repository.fetchRecentHistories('user-1');

    expect(histories.first.query, 'ブログを書きたい');
    expect(histories.first.path, 'blog');
    expect(histories.first.selectedAnswers, ['ブログ記事を書きたい', 'SEO']);
    expect(histories.first.suggestedWorkflowIds, ['wf_blog']);
    expect(histories.first.suggestions.first.rank, 1);
  });

  test('addHistory delegates to saveSession', () async {
    await repository.addHistory('user-1', '副業を始めたい', ['wf_side']);

    final histories = await repository.fetchRecentHistories('user-1');

    expect(histories.first.query, '副業を始めたい');
    expect(histories.first.suggestedWorkflowIds, ['wf_side']);
  });

  test('deleteHistory removes item for user', () async {
    final before = await repository.fetchRecentHistories('user-1');
    final targetId = before.first.id;

    await repository.deleteHistory('user-1', targetId);

    final after = await repository.fetchRecentHistories('user-1');
    expect(after.any((history) => history.id == targetId), isFalse);
  });
}
