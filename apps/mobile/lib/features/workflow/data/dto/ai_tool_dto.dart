import 'package:ai_pilot/features/workflow/data/dto/json_helpers.dart';
import 'package:ai_pilot/features/workflow/domain/entities/ai_tool.dart';

/// Supabase `ai_tools` 行の DTO。
class AIToolDto {
  AIToolDto({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    this.url,
    this.iconName,
  });

  factory AIToolDto.fromJson(Map<String, dynamic> json) {
    return AIToolDto(
      id: json['id'] as String,
      name: json['name'] as String,
      description: parseNullableString(json['description']),
      url: parseNullableString(json['url']),
      type: parseNullableString(json['type']),
      iconName: parseNullableString(json['icon_name']),
    );
  }

  final String id;
  final String name;
  final String? description;
  final String? url;
  final String? type;
  final String? iconName;

  AITool toEntity() {
    return AITool(
      id: id,
      name: name,
      description: description,
      url: url,
      type: _parseType(type),
      iconName: iconName,
    );
  }

  static AIToolType _parseType(String? value) {
    if (value == null) {
      return AIToolType.other;
    }
    for (final type in AIToolType.values) {
      if (type.name == value) {
        return type;
      }
    }
    return AIToolType.other;
  }
}
