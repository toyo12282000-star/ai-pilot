import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ai_pilot/features/recommendation/data/dto/recommendation_dto.dart';
import 'package:ai_pilot/features/recommendation/domain/entities/recommendation.dart';
import 'package:ai_pilot/features/recommendation/domain/repositories/recommendation_repository.dart';

/// [RecommendationRepository] の Supabase 実装。
class SupabaseRecommendationRepository implements RecommendationRepository {
  SupabaseRecommendationRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<List<Recommendation>> fetchRecommendations() async {
    final recommendationsResponse = await _client
        .from('recommendations')
        .select()
        .order('priority', ascending: true);

    final recommendations = (recommendationsResponse as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(RecommendationDto.fromJson)
        .toList();

    if (recommendations.isEmpty) {
      return [];
    }

    final recommendationIds =
        recommendations.map((recommendation) => recommendation.id).toList();

    final linksResponse = await _client
        .from('recommendation_workflows')
        .select()
        .inFilter('recommendation_id', recommendationIds)
        .order('sort_order', ascending: true);

    final links = (linksResponse as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(RecommendationWorkflowDto.fromJson)
        .toList();

    return RecommendationMapper.assembleMany(recommendations, links);
  }
}
