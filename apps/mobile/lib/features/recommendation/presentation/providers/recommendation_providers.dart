import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/features/recommendation/data/repositories/mock_recommendation_repository.dart';
import 'package:ai_pilot/features/recommendation/domain/entities/recommendation.dart';
import 'package:ai_pilot/features/recommendation/domain/repositories/recommendation_repository.dart';

/// [RecommendationRepository] を提供する（Mock 実装）。
final recommendationRepositoryProvider = Provider<RecommendationRepository>((ref) {
  return MockRecommendationRepository();
});

/// AI おすすめ目的一覧。
final recommendationsProvider = FutureProvider<List<Recommendation>>((ref) {
  return ref.watch(recommendationRepositoryProvider).fetchRecommendations();
});
