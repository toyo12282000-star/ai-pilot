import 'package:ai_pilot/features/advisor/domain/entities/advisor_api_response.dart';
import 'package:ai_pilot/features/workflow/data/dto/json_helpers.dart';

/// Advisor Edge Function レスポンス DTO。
class AdvisorApiResponseDto {
  AdvisorApiResponseDto({
    required this.recommendationIds,
    required this.reason,
  });

  factory AdvisorApiResponseDto.fromJson(Map<String, dynamic> json) {
    return AdvisorApiResponseDto(
      recommendationIds: parseStringList(json['recommendationIds']),
      reason: json['reason'] as String? ?? '',
    );
  }

  final List<String> recommendationIds;
  final String reason;

  AdvisorApiResponse toEntity() {
    return AdvisorApiResponse(
      recommendationIds: recommendationIds,
      reason: reason,
    );
  }
}
