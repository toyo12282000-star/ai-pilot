import 'package:ai_pilot/features/favorite/domain/entities/favorite.dart';
import 'package:ai_pilot/features/workflow/data/dto/json_helpers.dart';

/// Supabase `favorites` 行の DTO。
class FavoriteDto {
  FavoriteDto({
    required this.id,
    required this.userId,
    required this.workflowId,
    required this.createdAt,
  });

  factory FavoriteDto.fromJson(Map<String, dynamic> json) {
    return FavoriteDto(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      workflowId: json['workflow_id'] as String,
      createdAt: parseTimestamp(json['created_at']),
    );
  }

  final String id;
  final String userId;
  final String workflowId;
  final DateTime createdAt;

  Favorite toEntity() {
    return Favorite(
      id: id,
      userId: userId,
      workflowId: workflowId,
      createdAt: createdAt,
    );
  }
}
