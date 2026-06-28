import 'package:ai_pilot/features/workflow/domain/entities/ai_tool.dart';

/// AI ツールの取得を担当する Repository インターフェース。
///
/// ## 責務
/// - アプリで利用可能な AI ツール一覧の提供
/// - ワークフローステップやプロンプトテンプレートから参照されるツール詳細の取得
abstract class AIToolRepository {
  /// 全 AI ツールを取得する。
  Future<List<AITool>> fetchAITools();

  /// ID を指定して AI ツールを 1 件取得する。
  ///
  /// 該当がない場合は `null` を返す。
  Future<AITool?> fetchAIToolById(String id);
}
