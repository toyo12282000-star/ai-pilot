import 'package:ai_pilot/features/workflow/domain/entities/showcase_asset.dart';
import 'package:ai_pilot/features/workflow/domain/entities/showcase_tag.dart';

/// 完成作品サンプルの難易度。
enum ShowcaseDifficulty {
  easy,
  normal,
  hard,
}

/// Workflow に紐づく完成作品サンプル。
class WorkflowShowcase {
  WorkflowShowcase({
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
    List<ShowcaseTag> tags = const [],
    List<ShowcaseAsset> assets = const [],
  })  : tags = List.unmodifiable(tags),
        assets = List.unmodifiable(assets);

  final String id;
  final String workflowId;
  final String title;
  final String? description;
  final String? thumbnailUrl;
  final String? previewImageUrl;
  final String? previewVideoUrl;
  final String? completedOutput;
  final String? category;
  final ShowcaseDifficulty? difficulty;
  final int? estimatedTime;
  final bool isFeatured;
  final int sortOrder;
  final List<ShowcaseTag> tags;
  final List<ShowcaseAsset> assets;
  final DateTime createdAt;
  final DateTime updatedAt;
}
