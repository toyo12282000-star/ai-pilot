import 'package:ai_pilot/features/workflow/data/dto/json_helpers.dart';
import 'package:ai_pilot/features/workflow/data/dto/showcase_asset_dto.dart';
import 'package:ai_pilot/features/workflow/data/dto/showcase_tag_dto.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_showcase.dart';

/// Supabase `workflow_showcases` 行の DTO。
class WorkflowShowcaseDto {
  WorkflowShowcaseDto({
    required this.id,
    required this.workflowId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.thumbnailUrl,
    this.previewImageUrl,
    this.previewVideoUrl,
    this.completedOutput,
    this.category,
    this.difficulty,
    this.estimatedTime,
    this.isFeatured = false,
    this.sortOrder = 0,
    this.tags = const [],
    this.assets = const [],
  });

  factory WorkflowShowcaseDto.fromJson(Map<String, dynamic> json) {
    final tagsJson = json['showcase_tags'];
    final assetsJson = json['showcase_assets'];

    return WorkflowShowcaseDto(
      id: json['id'] as String,
      workflowId: json['workflow_id'] as String,
      title: json['title'] as String,
      description: parseNullableString(json['description']),
      thumbnailUrl: parseNullableString(json['thumbnail_url']),
      previewImageUrl: parseNullableString(json['preview_image_url']),
      previewVideoUrl: parseNullableString(json['preview_video_url']),
      completedOutput: parseNullableString(json['completed_output']),
      category: parseNullableString(json['category']),
      difficulty: parseNullableString(json['difficulty']),
      estimatedTime: json['estimated_time'] as int?,
      isFeatured: json['is_featured'] as bool? ?? false,
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: parseTimestamp(json['created_at']),
      updatedAt: parseTimestamp(json['updated_at']),
      tags: tagsJson is List
          ? tagsJson
              .cast<Map<String, dynamic>>()
              .map(ShowcaseTagDto.fromJson)
              .toList()
          : const [],
      assets: assetsJson is List
          ? assetsJson
              .cast<Map<String, dynamic>>()
              .map(ShowcaseAssetDto.fromJson)
              .toList()
          : const [],
    );
  }

  final String id;
  final String workflowId;
  final String title;
  final String? description;
  final String? thumbnailUrl;
  final String? previewImageUrl;
  final String? previewVideoUrl;
  final String? completedOutput;
  final String? category;
  final String? difficulty;
  final int? estimatedTime;
  final bool isFeatured;
  final int sortOrder;
  final List<ShowcaseTagDto> tags;
  final List<ShowcaseAssetDto> assets;
  final DateTime createdAt;
  final DateTime updatedAt;

  WorkflowShowcase toEntity() {
    return WorkflowShowcase(
      id: id,
      workflowId: workflowId,
      title: title,
      description: description,
      thumbnailUrl: thumbnailUrl,
      previewImageUrl: previewImageUrl,
      previewVideoUrl: previewVideoUrl,
      completedOutput: completedOutput,
      category: category,
      difficulty: _parseDifficulty(difficulty),
      estimatedTime: estimatedTime,
      isFeatured: isFeatured,
      sortOrder: sortOrder,
      tags: tags.map((tag) => tag.toEntity()).toList(),
      assets: assets.map((asset) => asset.toEntity()).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static ShowcaseDifficulty? _parseDifficulty(String? value) {
    switch (value) {
      case 'easy':
        return ShowcaseDifficulty.easy;
      case 'normal':
        return ShowcaseDifficulty.normal;
      case 'hard':
        return ShowcaseDifficulty.hard;
      default:
        return null;
    }
  }
}
