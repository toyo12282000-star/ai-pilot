import 'package:ai_pilot/features/profile/domain/entities/user_profile.dart';
import 'package:ai_pilot/features/workflow/data/dto/json_helpers.dart';

/// Supabase `profiles` 行の DTO。
class UserProfileDto {
  UserProfileDto({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.displayName,
    this.avatarUrl,
  });

  factory UserProfileDto.fromJson(Map<String, dynamic> json) {
    return UserProfileDto(
      id: json['id'] as String,
      displayName: parseNullableString(json['display_name']),
      avatarUrl: parseNullableString(json['avatar_url']),
      createdAt: parseTimestamp(json['created_at']),
      updatedAt: parseTimestamp(json['updated_at']),
    );
  }

  final String id;
  final String? displayName;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile toEntity({String? email}) {
    return UserProfile(
      id: id,
      displayName: displayName ?? 'ユーザー',
      email: email,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
