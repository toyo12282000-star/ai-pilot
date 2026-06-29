import 'package:ai_pilot/features/workflow/domain/entities/showcase_tag.dart';

/// Supabase `showcase_tags` 行の DTO。
class ShowcaseTagDto {
  ShowcaseTagDto({
    required this.id,
    required this.showcaseId,
    required this.tag,
  });

  factory ShowcaseTagDto.fromJson(Map<String, dynamic> json) {
    return ShowcaseTagDto(
      id: json['id'] as String,
      showcaseId: json['showcase_id'] as String,
      tag: json['tag'] as String,
    );
  }

  final String id;
  final String showcaseId;
  final String tag;

  ShowcaseTag toEntity() {
    return ShowcaseTag(
      id: id,
      showcaseId: showcaseId,
      tag: tag,
    );
  }
}
