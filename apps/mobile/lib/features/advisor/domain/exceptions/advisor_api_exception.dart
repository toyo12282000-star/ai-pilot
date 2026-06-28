/// Advisor Edge Function 呼び出し失敗の種別。
enum AdvisorApiFailureCode {
  /// Edge Function 未デプロイ / 404 等。
  notDeployed,

  /// ネットワーク不通・タイムアウト等。
  network,

  /// レスポンス JSON 不正・必須フィールド欠落。
  invalidResponse,

  /// 上記以外。
  unknown,
}

/// [SupabaseAdvisorApiRepository] が投げる Advisor API エラー。
class AdvisorApiException implements Exception {
  const AdvisorApiException({
    required this.code,
    required this.message,
    this.cause,
  });

  final AdvisorApiFailureCode code;
  final String message;
  final Object? cause;

  @override
  String toString() => 'AdvisorApiException($code): $message';
}
