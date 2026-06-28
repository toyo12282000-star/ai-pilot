import 'package:ai_pilot/features/recommendation/domain/entities/recommendation.dart';

/// Supabase `recommendations` 行の DTO。
class RecommendationDto {
  RecommendationDto({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.priority,
  });

  factory RecommendationDto.fromJson(Map<String, dynamic> json) {
    return RecommendationDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      color: json['color'] as String? ?? '',
      priority: json['priority'] as int? ?? 0,
    );
  }

  final String id;
  final String title;
  final String description;
  final String icon;
  final String color;
  final int priority;

  Recommendation toEntity({required List<String> recommendedWorkflowIds}) {
    return Recommendation(
      id: id,
      title: title,
      description: description,
      recommendedWorkflowIds: recommendedWorkflowIds,
      icon: icon,
      color: color,
      priority: priority,
    );
  }
}

/// Supabase `recommendation_workflows` 行の DTO。
class RecommendationWorkflowDto {
  RecommendationWorkflowDto({
    required this.recommendationId,
    required this.workflowId,
    required this.sortOrder,
  });

  factory RecommendationWorkflowDto.fromJson(Map<String, dynamic> json) {
    return RecommendationWorkflowDto(
      recommendationId: json['recommendation_id'] as String,
      workflowId: json['workflow_id'] as String,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  final String recommendationId;
  final String workflowId;
  final int sortOrder;
}

/// [RecommendationDto] と [RecommendationWorkflowDto] から Entity を組み立てる。
class RecommendationMapper {
  const RecommendationMapper._();

  static List<Recommendation> assembleMany(
    List<RecommendationDto> recommendations,
    List<RecommendationWorkflowDto> links,
  ) {
    final workflowIdsByRecommendationId = <String, List<String>>{};
    for (final link in links) {
      workflowIdsByRecommendationId
          .putIfAbsent(link.recommendationId, () => [])
          .add(link.workflowId);
    }

    return recommendations
        .map(
          (recommendation) => recommendation.toEntity(
            recommendedWorkflowIds:
                workflowIdsByRecommendationId[recommendation.id] ?? const [],
          ),
        )
        .toList();
  }
}
