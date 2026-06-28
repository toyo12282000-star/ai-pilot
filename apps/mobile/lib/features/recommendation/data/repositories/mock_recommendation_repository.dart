import 'package:ai_pilot/features/recommendation/data/repositories/mock_recommendation_seed_data.dart';
import 'package:ai_pilot/features/recommendation/domain/entities/recommendation.dart';
import 'package:ai_pilot/features/recommendation/domain/repositories/recommendation_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';

/// [RecommendationRepository] の Mock 実装。
class MockRecommendationRepository implements RecommendationRepository {
  @override
  Future<List<Recommendation>> fetchRecommendations() async {
    await Future<void>.delayed(mockNetworkDelay);
    final results = List<Recommendation>.from(mockRecommendations)
      ..sort((a, b) => a.priority.compareTo(b.priority));
    return results;
  }
}
