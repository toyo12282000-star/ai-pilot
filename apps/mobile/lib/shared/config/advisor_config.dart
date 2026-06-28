import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Advisor Edge Function 利用設定。
class AdvisorConfig {
  AdvisorConfig._();

  /// `.env` の `USE_ADVISOR_EDGE_FUNCTION` が `true` / `1` のとき Edge Function を使う。
  ///
  /// 未設定またはそれ以外は [MockAdvisorApiRepository]（ルールベース）を使う。
  static bool get useEdgeFunction {
    if (!dotenv.isInitialized) {
      return false;
    }
    final value = dotenv.env['USE_ADVISOR_EDGE_FUNCTION']?.trim().toLowerCase();
    return value == 'true' || value == '1';
  }
}
