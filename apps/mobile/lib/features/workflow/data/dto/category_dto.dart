import 'package:ai_pilot/features/workflow/data/dto/json_helpers.dart';
import 'package:ai_pilot/features/workflow/domain/entities/category.dart';

/// Supabase `categories` 行の DTO。
class CategoryDto {
  CategoryDto({
    required this.id,
    required this.name,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.iconName,
  });

  factory CategoryDto.fromJson(Map<String, dynamic> json) {
    return CategoryDto(
      id: json['id'] as String,
      name: json['name'] as String,
      description: parseNullableString(json['description']),
      iconName: parseNullableString(json['icon_name']),
      sortOrder: json['sort_order'] as int,
      createdAt: parseTimestamp(json['created_at']),
      updatedAt: parseTimestamp(json['updated_at']),
    );
  }

  final String id;
  final String name;
  final String? description;
  final String? iconName;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category toEntity() {
    return Category(
      id: id,
      name: name,
      description: description,
      iconName: iconName,
      sortOrder: sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
