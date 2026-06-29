import 'package:ai_pilot/features/workflow/data/dto/json_helpers.dart';
import 'package:ai_pilot/features/workflow/domain/entities/showcase_asset.dart';

/// Supabase `showcase_assets` 行の DTO。
class ShowcaseAssetDto {
  ShowcaseAssetDto({
    required this.id,
    required this.showcaseId,
    required this.assetType,
    this.url,
    this.title,
    this.sortOrder = 0,
  });

  factory ShowcaseAssetDto.fromJson(Map<String, dynamic> json) {
    return ShowcaseAssetDto(
      id: json['id'] as String,
      showcaseId: json['showcase_id'] as String,
      assetType: json['asset_type'] as String,
      url: parseNullableString(json['url']),
      title: parseNullableString(json['title']),
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  final String id;
  final String showcaseId;
  final String assetType;
  final String? url;
  final String? title;
  final int sortOrder;

  ShowcaseAsset toEntity() {
    return ShowcaseAsset(
      id: id,
      showcaseId: showcaseId,
      assetType: _parseAssetType(assetType),
      url: url,
      title: title,
      sortOrder: sortOrder,
    );
  }

  static ShowcaseAssetType _parseAssetType(String value) {
    switch (value) {
      case 'image':
        return ShowcaseAssetType.image;
      case 'video':
        return ShowcaseAssetType.video;
      case 'article':
        return ShowcaseAssetType.article;
      case 'slide':
        return ShowcaseAssetType.slide;
      case 'prompt':
        return ShowcaseAssetType.prompt;
      default:
        return ShowcaseAssetType.image;
    }
  }
}
