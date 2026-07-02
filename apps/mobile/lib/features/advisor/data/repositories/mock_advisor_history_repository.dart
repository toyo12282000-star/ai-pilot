import 'package:ai_pilot/features/advisor/domain/entities/advisor_history.dart';
import 'package:ai_pilot/features/advisor/domain/entities/advisor_session_save_input.dart';
import 'package:ai_pilot/features/advisor/domain/entities/advisor_session_suggestion.dart';
import 'package:ai_pilot/features/advisor/domain/repositories/advisor_history_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';

/// [AdvisorHistoryRepository] の Mock 実装（メモリ保持）。
class MockAdvisorHistoryRepository implements AdvisorHistoryRepository {
  MockAdvisorHistoryRepository()
      : _histories = List<AdvisorHistory>.from(_initialHistories);

  static final List<AdvisorHistory> _initialHistories = [
    AdvisorHistory(
      id: 'adv_hist_1',
      userId: 'user-1',
      query: 'YouTubeを始めたい',
      path: 'youtube',
      selectedAnswers: const [
        'YouTube動画を作りたい',
        '美容',
        '30分',
      ],
      primaryWorkflowId: 'wf_youtube_short',
      suggestedWorkflowIds: const ['wf_youtube_short'],
      createdAt: mockBaseDate,
    ),
  ];

  final List<AdvisorHistory> _histories;
  int _nextId = 100;

  static const _fetchLimit = 10;

  @override
  Future<List<AdvisorHistory>> fetchRecentHistories(String userId) async {
    await Future<void>.delayed(mockNetworkDelay);
    final results = _histories
        .where((history) => history.userId == userId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (results.length > _fetchLimit) {
      return results.sublist(0, _fetchLimit);
    }
    return results;
  }

  @override
  Future<void> saveSession(AdvisorSessionSaveInput input) async {
    await Future<void>.delayed(mockNetworkDelay);
    final id = 'adv_hist_$_nextId';
    _nextId++;
    final suggestions = [
      for (var i = 0; i < input.suggestedWorkflowIds.length; i++)
        AdvisorSessionSuggestion(
          sessionId: id,
          workflowId: input.suggestedWorkflowIds[i],
          rank: i + 1,
        ),
    ];
    _histories.insert(
      0,
      AdvisorHistory(
        id: id,
        userId: input.userId,
        query: input.query,
        path: input.path,
        selectedAnswers: List<String>.from(input.selectedAnswers),
        primaryWorkflowId: input.primaryWorkflowId,
        suggestions: suggestions,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> addHistory(
    String userId,
    String query,
    List<String> workflowIds,
  ) {
    return saveSession(
      AdvisorSessionSaveInput(
        userId: userId,
        query: query,
        selectedAnswers: const [],
        suggestedWorkflowIds: workflowIds,
      ),
    );
  }

  @override
  Future<void> deleteHistory(String userId, String historyId) async {
    await Future<void>.delayed(mockNetworkDelay);
    _histories.removeWhere(
      (history) => history.userId == userId && history.id == historyId,
    );
  }
}
