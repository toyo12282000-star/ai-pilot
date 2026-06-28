import 'package:ai_pilot/features/advisor/domain/entities/advisor_api_response.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';

/// Advisor 推薦 API（Supabase Edge Function）へのアクセス抽象。
///
/// 将来 OpenAI Responses API を Edge Function 経由で呼び出す。
/// Flutter 側に API Key を置かない。
abstract class AdvisorApiRepository {
  /// [query] と公開 [workflows] 一覧を送信し、推薦 ID と理由を取得する。
  Future<AdvisorApiResponse> suggest({
    required String query,
    required List<Workflow> workflows,
  });
}
