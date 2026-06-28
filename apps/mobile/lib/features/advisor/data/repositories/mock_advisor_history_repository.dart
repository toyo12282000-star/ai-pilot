import 'package:ai_pilot/features/advisor/domain/entities/advisor_history.dart';
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
      suggestedWorkflowIds: ['wf_youtube_short'],
      createdAt: mockBaseDate,
    ),
  ];

  final List<AdvisorHistory> _histories;
  int _nextId = 100;

  @override
  Future<List<AdvisorHistory>> fetchRecentHistories(String userId) async {
    await Future<void>.delayed(mockNetworkDelay);
    return _histories
        .where((history) => history.userId == userId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<void> addHistory(
    String userId,
    String query,
    List<String> workflowIds,
  ) async {
    await Future<void>.delayed(mockNetworkDelay);
    _histories.insert(
      0,
      AdvisorHistory(
        id: 'adv_hist_$_nextId',
        userId: userId,
        query: query,
        suggestedWorkflowIds: List<String>.from(workflowIds),
        createdAt: DateTime.now(),
      ),
    );
    _nextId++;
  }

  @override
  Future<void> deleteHistory(String userId, String historyId) async {
    await Future<void>.delayed(mockNetworkDelay);
    _histories.removeWhere(
      (history) => history.userId == userId && history.id == historyId,
    );
  }
}
