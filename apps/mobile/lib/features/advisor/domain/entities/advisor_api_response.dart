/// Advisor Edge Function / API が返す推薦結果。
class AdvisorApiResponse {
  AdvisorApiResponse({
    required this.recommendationIds,
    required this.reason,
  });

  /// 推薦 Workflow ID 一覧（Edge Function 返却順）。
  final List<String> recommendationIds;

  /// ユーザー向け推薦理由（API 全体で 1 件）。
  final String reason;
}
