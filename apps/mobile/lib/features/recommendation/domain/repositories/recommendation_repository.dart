import 'package:ai_pilot/features/recommendation/domain/entities/recommendation.dart';

/// AI おすすめ Workflow 目的の取得を担当する Repository インターフェース。
abstract class RecommendationRepository {
  /// おすすめ目的一覧を取得する。
  Future<List<Recommendation>> fetchRecommendations();
}
